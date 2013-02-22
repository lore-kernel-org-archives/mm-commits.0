From: akpm@linux-foundation.org
Subject: [merged] ocfs2-remove-kfree-redundant-null-checks.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:39:04 -0800
Message-ID: <20130222203904.B214D5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:43536 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3BVUjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:39:05 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so103478vbi.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:39:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.gardner@canonical.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove kfree() redundant null checks
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-kfree-redundant-null-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tim Gardner <tim.gardner@canonical.com>
Subject: ocfs2: remove kfree() redundant null checks

smatch analysis indicates a number of redundant NULL checks before
calling kfree(), e.g.,

fs/ocfs2/alloc.c:6138 ocfs2_begin_truncate_log_recovery() info:
 redundant null check on *tl_copy calling kfree()

fs/ocfs2/alloc.c:6755 ocfs2_zero_range_for_truncate() info:
 redundant null check on pages calling kfree()

etc....

[akpm@linux-foundation.org: revert dubious change in ocfs2_begin_truncate_log_recovery()]
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c             |    3 +--
 fs/ocfs2/cluster/heartbeat.c |    6 ++----
 fs/ocfs2/cluster/tcp.c       |    6 ++----
 fs/ocfs2/dlm/dlmdomain.c     |    4 +---
 fs/ocfs2/extent_map.c        |    3 +--
 fs/ocfs2/journal.c           |   10 +++-------
 fs/ocfs2/localalloc.c        |    8 +++-----
 fs/ocfs2/stack_o2cb.c        |    2 +-
 fs/ocfs2/super.c             |    6 ++----
 fs/ocfs2/sysfile.c           |    3 +--
 10 files changed, 17 insertions(+), 34 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-remove-kfree-redundant-null-checks
+++ a/fs/ocfs2/alloc.c
@@ -6751,8 +6751,7 @@ int ocfs2_zero_range_for_truncate(struct
 		mlog_errno(ret);
 
 out:
-	if (pages)
-		kfree(pages);
+	kfree(pages);
 
 	return ret;
 }
diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-remove-kfree-redundant-null-checks
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1471,8 +1471,7 @@ static void o2hb_region_release(struct c
 
 	mlog(ML_HEARTBEAT, "hb region release (%s)\n", reg->hr_dev_name);
 
-	if (reg->hr_tmp_block)
-		kfree(reg->hr_tmp_block);
+	kfree(reg->hr_tmp_block);
 
 	if (reg->hr_slot_data) {
 		for (i = 0; i < reg->hr_num_pages; i++) {
@@ -1486,8 +1485,7 @@ static void o2hb_region_release(struct c
 	if (reg->hr_bdev)
 		blkdev_put(reg->hr_bdev, FMODE_READ|FMODE_WRITE);
 
-	if (reg->hr_slots)
-		kfree(reg->hr_slots);
+	kfree(reg->hr_slots);
 
 	kfree(reg->hr_db_regnum);
 	kfree(reg->hr_db_livenodes);
diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-remove-kfree-redundant-null-checks
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1165,10 +1165,8 @@ out:
 	o2net_debug_del_nst(&nst); /* must be before dropping sc and node */
 	if (sc)
 		sc_put(sc);
-	if (vec)
-		kfree(vec);
-	if (msg)
-		kfree(msg);
+	kfree(vec);
+	kfree(msg);
 	o2net_complete_nsw(nn, &nsw, 0, 0, 0);
 	return ret;
 }
diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-kfree-redundant-null-checks
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -319,9 +319,7 @@ static void dlm_free_ctxt_mem(struct dlm
 	if (dlm->master_hash)
 		dlm_free_pagevec((void **)dlm->master_hash, DLM_HASH_PAGES);
 
-	if (dlm->name)
-		kfree(dlm->name);
-
+	kfree(dlm->name);
 	kfree(dlm);
 }
 
diff -puN fs/ocfs2/extent_map.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/extent_map.c
--- a/fs/ocfs2/extent_map.c~ocfs2-remove-kfree-redundant-null-checks
+++ a/fs/ocfs2/extent_map.c
@@ -282,8 +282,7 @@ search:
 	spin_unlock(&oi->ip_lock);
 
 out:
-	if (new_emi)
-		kfree(new_emi);
+	kfree(new_emi);
 }
 
 static int ocfs2_last_eb_is_empty(struct inode *inode,
diff -puN fs/ocfs2/journal.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-remove-kfree-redundant-null-checks
+++ a/fs/ocfs2/journal.c
@@ -1234,11 +1234,8 @@ static void ocfs2_queue_recovery_complet
 		/* Though we wish to avoid it, we are in fact safe in
 		 * skipping local alloc cleanup as fsck.ocfs2 is more
 		 * than capable of reclaiming unused space. */
-		if (la_dinode)
-			kfree(la_dinode);
-
-		if (tl_dinode)
-			kfree(tl_dinode);
+		kfree(la_dinode);
+		kfree(tl_dinode);
 
 		if (qrec)
 			ocfs2_free_quota_recovery(qrec);
@@ -1408,8 +1405,7 @@ bail:
 
 	mutex_unlock(&osb->recovery_lock);
 
-	if (rm_quota)
-		kfree(rm_quota);
+	kfree(rm_quota);
 
 	/* no one is callint kthread_stop() for us so the kthread() api
 	 * requires that we call do_exit().  And it isn't exported, but
diff -puN fs/ocfs2/localalloc.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c~ocfs2-remove-kfree-redundant-null-checks
+++ a/fs/ocfs2/localalloc.c
@@ -476,8 +476,7 @@ out:
 	if (local_alloc_inode)
 		iput(local_alloc_inode);
 
-	if (alloc_copy)
-		kfree(alloc_copy);
+	kfree(alloc_copy);
 }
 
 /*
@@ -534,7 +533,7 @@ int ocfs2_begin_local_alloc_recovery(str
 		mlog_errno(status);
 
 bail:
-	if ((status < 0) && (*alloc_copy)) {
+	if (status < 0) {
 		kfree(*alloc_copy);
 		*alloc_copy = NULL;
 	}
@@ -1290,8 +1289,7 @@ bail:
 	if (main_bm_inode)
 		iput(main_bm_inode);
 
-	if (alloc_copy)
-		kfree(alloc_copy);
+	kfree(alloc_copy);
 
 	if (ac)
 		ocfs2_free_alloc_context(ac);
diff -puN fs/ocfs2/stack_o2cb.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/stack_o2cb.c
--- a/fs/ocfs2/stack_o2cb.c~ocfs2-remove-kfree-redundant-null-checks
+++ a/fs/ocfs2/stack_o2cb.c
@@ -376,7 +376,7 @@ static int o2cb_cluster_connect(struct o
 	dlm_register_eviction_cb(dlm, &priv->op_eviction_cb);
 
 out_free:
-	if (rc && conn->cc_private)
+	if (rc)
 		kfree(conn->cc_private);
 
 out:
diff -puN fs/ocfs2/super.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-remove-kfree-redundant-null-checks
+++ a/fs/ocfs2/super.c
@@ -2525,8 +2525,7 @@ static int ocfs2_check_volume(struct ocf
 		mlog_errno(status);
 
 finally:
-	if (local_alloc)
-		kfree(local_alloc);
+	kfree(local_alloc);
 
 	if (status)
 		mlog_errno(status);
@@ -2553,8 +2552,7 @@ static void ocfs2_delete_osb(struct ocfs
 	 * we free it here.
 	 */
 	kfree(osb->journal);
-	if (osb->local_alloc_copy)
-		kfree(osb->local_alloc_copy);
+	kfree(osb->local_alloc_copy);
 	kfree(osb->uuid_str);
 	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
 	memset(osb, 0, sizeof(struct ocfs2_super));
diff -puN fs/ocfs2/sysfile.c~ocfs2-remove-kfree-redundant-null-checks fs/ocfs2/sysfile.c
--- a/fs/ocfs2/sysfile.c~ocfs2-remove-kfree-redundant-null-checks
+++ a/fs/ocfs2/sysfile.c
@@ -91,8 +91,7 @@ static struct inode **get_local_system_i
 		} else
 			osb->local_system_inodes = local_system_inodes;
 		spin_unlock(&osb->osb_lock);
-		if (unlikely(free))
-			kfree(free);
+		kfree(free);
 	}
 
 	index = (slot * NUM_LOCAL_SYSTEM_INODES) +
_

Patches currently in -mm which might be from tim.gardner@canonical.com are

origin.patch
linux-next.patch
firewire-convert-to-idr_alloc-fix.patch

