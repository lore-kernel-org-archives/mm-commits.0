From: akpm@linux-foundation.org
Subject: + ocfs2-clean-up-redundant-null-check-before-iput.patch added to
 -mm tree
Date: Wed, 16 Dec 2015 14:04:06 -0800
Message-ID: <5671dfd6.0k0yT6xWQ6V/d68g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967060AbbLPWEH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Dec 2015 17:04:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clean up redundant NULL check before iput
has been added to the -mm tree.  Its filename is
     ocfs2-clean-up-redundant-null-check-before-iput.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-clean-up-redundant-null-check-before-iput.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-clean-up-redundant-null-check-before-iput.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: clean up redundant NULL check before iput

Since iput will take care the NULL check itself, NULL check before
calling it is redundant. So clean them up.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c      |    3 +--
 fs/ocfs2/ioctl.c      |    4 +---
 fs/ocfs2/journal.c    |   10 +++-------
 fs/ocfs2/localalloc.c |   10 +++-------
 fs/ocfs2/namei.c      |    3 +--
 fs/ocfs2/slot_map.c   |    3 +--
 fs/ocfs2/super.c      |    3 +--
 7 files changed, 11 insertions(+), 25 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-clean-up-redundant-null-check-before-iput fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-clean-up-redundant-null-check-before-iput
+++ a/fs/ocfs2/alloc.c
@@ -6174,8 +6174,7 @@ int ocfs2_begin_truncate_log_recovery(st
 	}
 
 bail:
-	if (tl_inode)
-		iput(tl_inode);
+	iput(tl_inode);
 	brelse(tl_bh);
 
 	if (status < 0) {
diff -puN fs/ocfs2/ioctl.c~ocfs2-clean-up-redundant-null-check-before-iput fs/ocfs2/ioctl.c
--- a/fs/ocfs2/ioctl.c~ocfs2-clean-up-redundant-null-check-before-iput
+++ a/fs/ocfs2/ioctl.c
@@ -606,9 +606,7 @@ bail:
 	if (gb_inode)
 		mutex_unlock(&gb_inode->i_mutex);
 
-	if (gb_inode)
-		iput(gb_inode);
-
+	iput(gb_inode);
 	brelse(bh);
 
 	return status;
diff -puN fs/ocfs2/journal.c~ocfs2-clean-up-redundant-null-check-before-iput fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-clean-up-redundant-null-check-before-iput
+++ a/fs/ocfs2/journal.c
@@ -1042,8 +1042,7 @@ void ocfs2_journal_shutdown(struct ocfs2
 
 //	up_write(&journal->j_trans_barrier);
 done:
-	if (inode)
-		iput(inode);
+	iput(inode);
 }
 
 static void ocfs2_clear_journal_error(struct super_block *sb,
@@ -1687,9 +1686,7 @@ done:
 	if (got_lock)
 		ocfs2_inode_unlock(inode, 1);
 
-	if (inode)
-		iput(inode);
-
+	iput(inode);
 	brelse(bh);
 
 	return status;
@@ -1796,8 +1793,7 @@ static int ocfs2_trylock_journal(struct
 
 	ocfs2_inode_unlock(inode, 1);
 bail:
-	if (inode)
-		iput(inode);
+	iput(inode);
 
 	return status;
 }
diff -puN fs/ocfs2/localalloc.c~ocfs2-clean-up-redundant-null-check-before-iput fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c~ocfs2-clean-up-redundant-null-check-before-iput
+++ a/fs/ocfs2/localalloc.c
@@ -358,8 +358,7 @@ int ocfs2_load_local_alloc(struct ocfs2_
 bail:
 	if (status < 0)
 		brelse(alloc_bh);
-	if (inode)
-		iput(inode);
+	iput(inode);
 
 	trace_ocfs2_load_local_alloc(osb->local_alloc_bits);
 
@@ -473,8 +472,7 @@ out_mutex:
 	iput(main_bm_inode);
 
 out:
-	if (local_alloc_inode)
-		iput(local_alloc_inode);
+	iput(local_alloc_inode);
 
 	kfree(alloc_copy);
 }
@@ -1327,9 +1325,7 @@ bail:
 
 	brelse(main_bm_bh);
 
-	if (main_bm_inode)
-		iput(main_bm_inode);
-
+	iput(main_bm_inode);
 	kfree(alloc_copy);
 
 	if (ac)
diff -puN fs/ocfs2/namei.c~ocfs2-clean-up-redundant-null-check-before-iput fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-clean-up-redundant-null-check-before-iput
+++ a/fs/ocfs2/namei.c
@@ -1683,8 +1683,7 @@ bail:
 	if (new_inode)
 		sync_mapping_buffers(old_inode->i_mapping);
 
-	if (new_inode)
-		iput(new_inode);
+	iput(new_inode);
 
 	ocfs2_free_dir_lookup_result(&target_lookup_res);
 	ocfs2_free_dir_lookup_result(&old_entry_lookup);
diff -puN fs/ocfs2/slot_map.c~ocfs2-clean-up-redundant-null-check-before-iput fs/ocfs2/slot_map.c
--- a/fs/ocfs2/slot_map.c~ocfs2-clean-up-redundant-null-check-before-iput
+++ a/fs/ocfs2/slot_map.c
@@ -322,8 +322,7 @@ static void __ocfs2_free_slot_info(struc
 	if (si == NULL)
 		return;
 
-	if (si->si_inode)
-		iput(si->si_inode);
+	iput(si->si_inode);
 	if (si->si_bh) {
 		for (i = 0; i < si->si_blocks; i++) {
 			if (si->si_bh[i]) {
diff -puN fs/ocfs2/super.c~ocfs2-clean-up-redundant-null-check-before-iput fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-clean-up-redundant-null-check-before-iput
+++ a/fs/ocfs2/super.c
@@ -1722,8 +1722,7 @@ static int ocfs2_statfs(struct dentry *d
 	ocfs2_inode_unlock(inode, 0);
 	status = 0;
 bail:
-	if (inode)
-		iput(inode);
+	iput(inode);
 
 	if (status)
 		mlog_errno(status);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-clean-up-redundant-null-check-before-iput.patch
ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v3.patch
ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

