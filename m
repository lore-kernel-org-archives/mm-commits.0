From: akpm@linux-foundation.org
Subject: + device_cgroup-add-proper-checking-when-changing-default-behavior.patch added to -mm tree
Date: Mon, 22 Oct 2012 12:55:14 -0700
Message-ID: <20121022195515.5E1D01E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:60510 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab2JVTzR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 15:55:17 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so359005qae.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 12:55:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aris@redhat.com, jmorris@namei.org, jslaby@suse.cz, lizefan@huawei.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@openvz.org


The patch titled
     Subject: device_cgroup: add proper checking when changing default behavior
has been added to the -mm tree.  Its filename is
     device_cgroup-add-proper-checking-when-changing-default-behavior.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aristeu Rozanski <aris@redhat.com>
Subject: device_cgroup: add proper checking when changing default behavior

Before changing a group's default behavior to ALLOW, we must check if its
parent's behavior is also ALLOW.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: James Morris <jmorris@namei.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff -puN security/device_cgroup.c~device_cgroup-add-proper-checking-when-changing-default-behavior security/device_cgroup.c
--- a/security/device_cgroup.c~device_cgroup-add-proper-checking-when-changing-default-behavior
+++ a/security/device_cgroup.c
@@ -344,6 +344,17 @@ static int parent_has_perm(struct dev_cg
 	return may_access(parent, ex);
 }
 
+/**
+ * may_allow_all - checks if it's possible to change the behavior to
+ *		   allow based on parent's rules.
+ * @parent: device cgroup's parent
+ * returns: != 0 in case it's allowed, 0 otherwise
+ */
+static inline int may_allow_all(struct dev_cgroup *parent)
+{
+	return parent->behavior == DEVCG_DEFAULT_ALLOW;
+}
+
 /*
  * Modify the exception list using allow/deny rules.
  * CAP_SYS_ADMIN is needed for this.  It's at least separate from CAP_MKNOD
@@ -364,6 +375,8 @@ static int devcgroup_update_access(struc
 	char temp[12];		/* 11 + 1 characters needed for a u32 */
 	int count, rc;
 	struct dev_exception_item ex;
+	struct cgroup *p = devcgroup->css.cgroup;
+	struct dev_cgroup *parent = cgroup_to_devcgroup(p->parent);
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -375,9 +388,13 @@ static int devcgroup_update_access(struc
 	case 'a':
 		switch (filetype) {
 		case DEVCG_ALLOW:
-			if (!parent_has_perm(devcgroup, &ex))
+			if (!may_allow_all(parent))
 				return -EPERM;
 			dev_exception_clean(devcgroup);
+			rc = dev_exceptions_copy(&devcgroup->exceptions,
+						 &parent->exceptions);
+			if (rc)
+				return rc;
 			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
 			break;
 		case DEVCG_DENY:
_

Patches currently in -mm which might be from aris@redhat.com are

device_cgroup-rename-deny_all-to-behavior.patch
device_cgroup-stop-using-simple_strtoul.patch
device_cgroup-add-proper-checking-when-changing-default-behavior.patch
linux-next.patch

