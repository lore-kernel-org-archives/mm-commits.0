From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch removed from -mm tree
Date: Wed, 10 Mar 2010 12:30:00 -0800
Message-ID: <201003102030.o2AKU0QT001941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757036Ab0CJUa2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 15:30:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, ebiederm@xmission.com, gregkh@suse.de, paulmck@us.ibm.com, rmk+lkml@arm.linux.org.uk, rusty@rustcorp.com.au, sam@ravnborg.org, mm-commits@vger.


The patch titled
     sysctl: convert hotplug helper string to proc_rcu_string()
has been removed from the -mm tree.  Its filename was
     sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: convert hotplug helper string to proc_rcu_string()
From: Andi Kleen <andi@firstfloor.org>

This avoids races with lockless sysctl.

Also saves ~220 bytes in the data segment for default kernels.

I also moved the code into a separate function because the original
was very long.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kobject.h |    2 -
 kernel/sysctl.c         |    2 -
 lib/kobject_uevent.c    |   50 ++++++++++++++++++++++++--------------
 3 files changed, 34 insertions(+), 20 deletions(-)

diff -puN include/linux/kobject.h~sysctl-convert-hotplug-helper-string-to-proc_rcu_string include/linux/kobject.h
--- a/include/linux/kobject.h~sysctl-convert-hotplug-helper-string-to-proc_rcu_string
+++ a/include/linux/kobject.h
@@ -31,7 +31,7 @@
 #define UEVENT_BUFFER_SIZE		2048	/* buffer for the variables */
 
 /* path to the userspace helper executed on an event */
-extern char uevent_helper[];
+extern char *uevent_helper;
 
 /* counter to tag the uevent, read only except for the kobject core */
 extern u64 uevent_seqnum;
diff -puN kernel/sysctl.c~sysctl-convert-hotplug-helper-string-to-proc_rcu_string kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-convert-hotplug-helper-string-to-proc_rcu_string
+++ a/kernel/sysctl.c
@@ -557,7 +557,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &uevent_helper,
 		.maxlen		= UEVENT_HELPER_PATH_LEN,
 		.mode		= 0644,
-		.proc_handler	= proc_dostring,
+		.proc_handler	= proc_rcu_string,
 	},
 #endif
 #ifdef CONFIG_CHR_DEV_SG
diff -puN lib/kobject_uevent.c~sysctl-convert-hotplug-helper-string-to-proc_rcu_string lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~sysctl-convert-hotplug-helper-string-to-proc_rcu_string
+++ a/lib/kobject_uevent.c
@@ -22,11 +22,12 @@
 #include <linux/socket.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
+#include <linux/rcustring.h>
 #include <net/sock.h>
 
 
 u64 uevent_seqnum;
-char uevent_helper[UEVENT_HELPER_PATH_LEN] = CONFIG_UEVENT_HELPER_PATH;
+char *uevent_helper = CONFIG_UEVENT_HELPER_PATH;
 static DEFINE_SPINLOCK(sequence_lock);
 #if defined(CONFIG_NET)
 static struct sock *uevent_sock;
@@ -76,6 +77,34 @@ out:
 	return ret;
 }
 
+/* Call an external helper executable. */
+static int uevent_call_helper(const char *subsystem, struct kobj_uevent_env *env)
+{
+	char *argv[3];
+	char *helper;
+	int retval;
+
+	helper = access_rcu_string(&uevent_helper, UEVENT_HELPER_PATH_LEN, GFP_KERNEL);
+	if (!helper)
+		return -ENOMEM;
+
+	retval = -E2BIG;
+	argv[0] = helper;
+	argv[1] = (char *)subsystem;
+	argv[2] = NULL;
+	retval = add_uevent_var(env, "HOME=/");
+	if (retval)
+		goto error;
+	retval = add_uevent_var(env, "PATH=/sbin:/bin:/usr/sbin:/usr/bin");
+	if (retval)
+		goto error;
+
+	retval = call_usermodehelper(argv[0], argv, env->envp, UMH_WAIT_EXEC);
+error:
+	kfree(helper);
+	return retval;
+}
+
 /**
  * kobject_uevent_env - send an uevent with environmental data
  *
@@ -243,23 +272,8 @@ int kobject_uevent_env(struct kobject *k
 #endif
 
 	/* call uevent_helper, usually only enabled during early boot */
-	if (uevent_helper[0]) {
-		char *argv [3];
-
-		argv [0] = uevent_helper;
-		argv [1] = (char *)subsystem;
-		argv [2] = NULL;
-		retval = add_uevent_var(env, "HOME=/");
-		if (retval)
-			goto exit;
-		retval = add_uevent_var(env,
-					"PATH=/sbin:/bin:/usr/sbin:/usr/bin");
-		if (retval)
-			goto exit;
-
-		retval = call_usermodehelper(argv[0], argv,
-					     env->envp, UMH_WAIT_EXEC);
-	}
+	if (uevent_helper[0])
+		retval = uevent_call_helper(subsystem, env);
 
 exit:
 	kfree(devpath);
_

Patches currently in -mm which might be from andi@firstfloor.org are

mm-introduce-dump_page-and-print-symbolic-flag-names.patch
linux-next.patch
hardware-latency-detector-remove-default-m.patch
modpost-support-objects-with-more-than-64k-sections.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch
sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper-fix.patch

