From: akpm@linux-foundation.org
Subject: - devcgroup-fix-race-against-rmdir.patch removed from -mm tree
Date: Wed, 03 Sep 2008 09:11:29 -0700
Message-ID: <200809031611.m83GBTMp023774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895AbYICQMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 12:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devcgroup: fix race against rmdir()
has been removed from the -mm tree.  Its filename was
     devcgroup-fix-race-against-rmdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devcgroup: fix race against rmdir()
From: Li Zefan <lizf@cn.fujitsu.com>

During the use of a dev_cgroup, we should guarantee the corresponding
cgroup won't be deleted (i.e.  via rmdir).  This can be done through
css_get(&dev_cgroup->css), but here we can just get and use the dev_cgroup
under rcu_read_lock.

And also remove checking NULL dev_cgroup, it won't be NULL since a task
always belongs to a cgroup.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN security/device_cgroup.c~devcgroup-fix-race-against-rmdir security/device_cgroup.c
--- a/security/device_cgroup.c~devcgroup-fix-race-against-rmdir
+++ a/security/device_cgroup.c
@@ -508,12 +508,11 @@ int devcgroup_inode_permission(struct in
 		return 0;
 	if (!S_ISBLK(inode->i_mode) && !S_ISCHR(inode->i_mode))
 		return 0;
-	dev_cgroup = css_to_devcgroup(task_subsys_state(current,
-				devices_subsys_id));
-	if (!dev_cgroup)
-		return 0;
 
 	rcu_read_lock();
+
+	dev_cgroup = task_devcgroup(current);
+
 	list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
 		if (wh->type & DEV_ALL)
 			goto acc_check;
@@ -533,6 +532,7 @@ acc_check:
 		rcu_read_unlock();
 		return 0;
 	}
+
 	rcu_read_unlock();
 
 	return -EPERM;
@@ -543,12 +543,10 @@ int devcgroup_inode_mknod(int mode, dev_
 	struct dev_cgroup *dev_cgroup;
 	struct dev_whitelist_item *wh;
 
-	dev_cgroup = css_to_devcgroup(task_subsys_state(current,
-				devices_subsys_id));
-	if (!dev_cgroup)
-		return 0;
-
 	rcu_read_lock();
+
+	dev_cgroup = task_devcgroup(current);
+
 	list_for_each_entry(wh, &dev_cgroup->whitelist, list) {
 		if (wh->type & DEV_ALL)
 			goto acc_check;
@@ -566,6 +564,8 @@ acc_check:
 		rcu_read_unlock();
 		return 0;
 	}
+
 	rcu_read_unlock();
+
 	return -EPERM;
 }
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
res_counter-fix-off-by-one-bug-in-setting-limit.patch
linux-next.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
devcgroup-use-kmemdup.patch
devcgroup-remove-unused-variable.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

