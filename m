From: akpm@linux-foundation.org
Subject: + kobject-dont-block-for-each-kobject_uevent.patch added to -mm
 tree
Date: Tue, 11 Feb 2014 15:00:21 -0800
Message-ID: <52faab85.Rtct059qXBFKnOsn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaBKXAW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 18:00:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, greg@kroah.com, cl@linux.com, vdavydov@parallels.com

Subject: + kobject-dont-block-for-each-kobject_uevent.patch added to -mm tree
To: vdavydov@parallels.com,cl@linux.com,greg@kroah.com,penberg@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 15:00:21 -0800


The patch titled
     Subject: kobject: don't block for each kobject_uevent
has been added to the -mm tree.  Its filename is
     kobject-dont-block-for-each-kobject_uevent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kobject-dont-block-for-each-kobject_uevent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kobject-dont-block-for-each-kobject_uevent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: kobject: don't block for each kobject_uevent

Currently kobject_uevent has somewhat unpredictable semantics.  The point
is, since it may call a usermode helper and wait for it to execute
(UMH_WAIT_EXEC), it is impossible to say for sure what lock dependencies
it will introduce for the caller - strictly speaking it depends on what fs
the binary is located on and the set of locks fork may take.  There are
quite a few kobject_uevent's users that do not take this into account and
call it with various mutexes taken, e.g.  rtnl_mutex, net_mutex, which
might potentially lead to a deadlock.

Since there is actually no reason to wait for the usermode helper to
execute there, let's make kobject_uevent start the helper asynchronously
with the aid of the UMH_NO_WAIT flag.

Personally, I'm interested in this, because I really want kobject_uevent
to be called under the slab_mutex in the slub implementation as it used to
be some time ago, because it greatly simplifies synchronization and
automatically fixes a kmemcg-related race.  However, there was a deadlock
detected on an attempt to call kobject_uevent under the slab_mutex (see
https://lkml.org/lkml/2012/1/14/45), which was reported to be fixed by
releasing the slab_mutex for kobject_uevent.  Unfortunately, there was no
information about who exactly blocked on the slab_mutex causing the
usermode helper to stall, neither have I managed to find this out or
reproduce the issue.

BTW, this is not the first attempt to make kobject_uevent use UMH_NO_WAIT.
Previous one was made by commit f520360d93c ("kobject: don't block for
each kobject_uevent"), but it was wrong (it passed arguments allocated on
stack to async thread) so it was reverted in 05f54c13cd0c ("Revert
"kobject: don't block for each kobject_uevent".").  It targeted on
speeding up the boot process though.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Greg KH <greg@kroah.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kobject.h |    1 
 lib/kobject_uevent.c    |   42 ++++++++++++++++++++++++++++++++------
 2 files changed, 37 insertions(+), 6 deletions(-)

diff -puN include/linux/kobject.h~kobject-dont-block-for-each-kobject_uevent include/linux/kobject.h
--- a/include/linux/kobject.h~kobject-dont-block-for-each-kobject_uevent
+++ a/include/linux/kobject.h
@@ -119,6 +119,7 @@ struct kobj_type {
 };
 
 struct kobj_uevent_env {
+	char *argv[3];
 	char *envp[UEVENT_NUM_ENVP];
 	int envp_idx;
 	char buf[UEVENT_BUFFER_SIZE];
diff -puN lib/kobject_uevent.c~kobject-dont-block-for-each-kobject_uevent lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~kobject-dont-block-for-each-kobject_uevent
+++ a/lib/kobject_uevent.c
@@ -124,6 +124,30 @@ static int kobj_usermode_filter(struct k
 	return 0;
 }
 
+static int init_uevent_argv(struct kobj_uevent_env *env, const char *subsystem)
+{
+	int len;
+
+	len = strlcpy(&env->buf[env->buflen], subsystem,
+		      sizeof(env->buf) - env->buflen);
+	if (len >= (sizeof(env->buf) - env->buflen)) {
+		WARN(1, KERN_ERR "init_uevent_argv: buffer size too small\n");
+		return -ENOMEM;
+	}
+
+	env->argv[0] = uevent_helper;
+	env->argv[1] = &env->buf[env->buflen];
+	env->argv[2] = NULL;
+
+	env->buflen += len + 1;
+	return 0;
+}
+
+static void cleanup_uevent_env(struct subprocess_info *info)
+{
+	kfree(info->data);
+}
+
 /**
  * kobject_uevent_env - send an uevent with environmental data
  *
@@ -301,11 +325,8 @@ int kobject_uevent_env(struct kobject *k
 
 	/* call uevent_helper, usually only enabled during early boot */
 	if (uevent_helper[0] && !kobj_usermode_filter(kobj)) {
-		char *argv [3];
+		struct subprocess_info *info;
 
-		argv [0] = uevent_helper;
-		argv [1] = (char *)subsystem;
-		argv [2] = NULL;
 		retval = add_uevent_var(env, "HOME=/");
 		if (retval)
 			goto exit;
@@ -313,9 +334,18 @@ int kobject_uevent_env(struct kobject *k
 					"PATH=/sbin:/bin:/usr/sbin:/usr/bin");
 		if (retval)
 			goto exit;
+		retval = init_uevent_argv(env, subsystem);
+		if (retval)
+			goto exit;
 
-		retval = call_usermodehelper(argv[0], argv,
-					     env->envp, UMH_WAIT_EXEC);
+		retval = -ENOMEM;
+		info = call_usermodehelper_setup(env->argv[0], env->argv,
+						 env->envp, GFP_KERNEL,
+						 NULL, cleanup_uevent_env, env);
+		if (info)
+			retval = call_usermodehelper_exec(info, UMH_NO_WAIT);
+		if (!retval)
+			env = NULL;	/* will be freed by cleanup_uevent_env */
 	}
 
 exit:
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmscan-shrink_slab-rename-max_pass-freeable.patch
kobject-dont-block-for-each-kobject_uevent.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
linux-next.patch

