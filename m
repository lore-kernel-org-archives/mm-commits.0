From: akpm@linux-foundation.org
Subject: [merged] cgroup-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:43 -0800
Message-ID: <20130228201543.BA45D5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:49062 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305Ab3B1UPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:45 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so245248qea.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, lizefan@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     cgroup-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: cgroup: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff -puN kernel/cgroup.c~cgroup-convert-to-idr_alloc kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-convert-to-idr_alloc
+++ a/kernel/cgroup.c
@@ -5320,7 +5320,7 @@ EXPORT_SYMBOL_GPL(free_css_id);
 static struct css_id *get_new_cssid(struct cgroup_subsys *ss, int depth)
 {
 	struct css_id *newid;
-	int myid, error, size;
+	int ret, size;
 
 	BUG_ON(!ss->use_id);
 
@@ -5328,35 +5328,24 @@ static struct css_id *get_new_cssid(stru
 	newid = kzalloc(size, GFP_KERNEL);
 	if (!newid)
 		return ERR_PTR(-ENOMEM);
-	/* get id */
-	if (unlikely(!idr_pre_get(&ss->idr, GFP_KERNEL))) {
-		error = -ENOMEM;
-		goto err_out;
-	}
+
+	idr_preload(GFP_KERNEL);
 	spin_lock(&ss->id_lock);
 	/* Don't use 0. allocates an ID of 1-65535 */
-	error = idr_get_new_above(&ss->idr, newid, 1, &myid);
+	ret = idr_alloc(&ss->idr, newid, 1, CSS_ID_MAX + 1, GFP_NOWAIT);
 	spin_unlock(&ss->id_lock);
+	idr_preload_end();
 
 	/* Returns error when there are no free spaces for new ID.*/
-	if (error) {
-		error = -ENOSPC;
+	if (ret < 0)
 		goto err_out;
-	}
-	if (myid > CSS_ID_MAX)
-		goto remove_idr;
 
-	newid->id = myid;
+	newid->id = ret;
 	newid->depth = depth;
 	return newid;
-remove_idr:
-	error = -ENOSPC;
-	spin_lock(&ss->id_lock);
-	idr_remove(&ss->idr, myid);
-	spin_unlock(&ss->id_lock);
 err_out:
 	kfree(newid);
-	return ERR_PTR(error);
+	return ERR_PTR(ret);
 
 }
 
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

