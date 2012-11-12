From: akpm@linux-foundation.org
Subject: [merged] device_cgroup-fix-unchecked-cgroup-parent-usage.patch removed from -mm tree
Date: Mon, 12 Nov 2012 13:09:09 -0800
Message-ID: <20121112210909.D90F2100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:39523 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab2KLVJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 16:09:12 -0500
Received: by mail-gh0-f202.google.com with SMTP id z15so779043ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 13:09:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aris@redhat.com, jmorris@namei.org, jslaby@suse.cz, lizefan@huawei.com, serge.hallyn@ubuntu.com, tj@kernel.org, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: device_cgroup: fix unchecked cgroup parent usage
has been removed from the -mm tree.  Its filename was
     device_cgroup-fix-unchecked-cgroup-parent-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aristeu Rozanski <aris@redhat.com>
Subject: device_cgroup: fix unchecked cgroup parent usage

In 4cef7299b478687 ("device_cgroup: add proper checking when changing
default behavior") the cgroup parent usage is unchecked.  root will not
have a parent and trying to use device.{allow,deny} will cause a null
pointer dereference.  For some reason my stressing scripts didn't test the
root directory so I didn't catch it on my regular tests.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: James Morris <jmorris@namei.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN security/device_cgroup.c~device_cgroup-fix-unchecked-cgroup-parent-usage security/device_cgroup.c
--- a/security/device_cgroup.c~device_cgroup-fix-unchecked-cgroup-parent-usage
+++ a/security/device_cgroup.c
@@ -352,6 +352,8 @@ static int parent_has_perm(struct dev_cg
  */
 static inline int may_allow_all(struct dev_cgroup *parent)
 {
+	if (!parent)
+		return 1;
 	return parent->behavior == DEVCG_DEFAULT_ALLOW;
 }
 
@@ -376,11 +378,14 @@ static int devcgroup_update_access(struc
 	int count, rc;
 	struct dev_exception_item ex;
 	struct cgroup *p = devcgroup->css.cgroup;
-	struct dev_cgroup *parent = cgroup_to_devcgroup(p->parent);
+	struct dev_cgroup *parent = NULL;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (p->parent)
+		parent = cgroup_to_devcgroup(p->parent);
+
 	memset(&ex, 0, sizeof(ex));
 	b = buffer;
 
@@ -391,11 +396,14 @@ static int devcgroup_update_access(struc
 			if (!may_allow_all(parent))
 				return -EPERM;
 			dev_exception_clean(devcgroup);
+			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
+			if (!parent)
+				break;
+
 			rc = dev_exceptions_copy(&devcgroup->exceptions,
 						 &parent->exceptions);
 			if (rc)
 				return rc;
-			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
 			break;
 		case DEVCG_DENY:
 			dev_exception_clean(devcgroup);
_

Patches currently in -mm which might be from aris@redhat.com are

linux-next.patch

