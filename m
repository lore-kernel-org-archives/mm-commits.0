From: akpm@linux-foundation.org
Subject: [nacked]
 ocfs2-fix-bug-due-to-uncleaned-localalloc-during-mount.patch removed from
 -mm tree
Date: Wed, 02 Dec 2015 13:29:51 -0800
Message-ID: <565f62cf.AbfY85UQ50zVpzDv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984AbbLBV3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 16:29:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, tariq.x.saeed@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix BUG due to uncleaned localalloc during mount
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-bug-due-to-uncleaned-localalloc-during-mount.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix BUG due to uncleaned localalloc during mount

Tariq has reported a BUG before and posted a fix at:
https://oss.oracle.com/pipermail/ocfs2-devel/2015-April/010696.html

This is because during umount, localalloc shutdown relies on journal
shutdown.  But during journal shutdown, it just stops commit thread
without checking its result.  So it may happen that localalloc shutdown
uncleaned during I/O error and after that, journal then has been marked
clean if I/O restores.

Then during mount, localalloc won't be recovered because of clean journal
and then trigger BUG when claiming clusters from localalloc.

In Tariq's fix, we have to run fsck offline and a separate fix to fsck is
needed because it currently does not support clearing out localalloc
inode.  And my way to fix this issue is checking localalloc before
actually loading it during mount.  And this is somewhat online.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reported-by: Tariq Saeed <tariq.x.saeed@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c |   19 ++++++++++++-------
 fs/ocfs2/localalloc.h |    2 +-
 fs/ocfs2/super.c      |   17 ++++++++++++++---
 3 files changed, 27 insertions(+), 11 deletions(-)

diff -puN fs/ocfs2/localalloc.c~ocfs2-fix-bug-due-to-uncleaned-localalloc-during-mount fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c~ocfs2-fix-bug-due-to-uncleaned-localalloc-during-mount
+++ a/fs/ocfs2/localalloc.c
@@ -281,7 +281,7 @@ bail:
 	return ret;
 }
 
-int ocfs2_load_local_alloc(struct ocfs2_super *osb)
+int ocfs2_load_local_alloc(struct ocfs2_super *osb, int check, int *recovery)
 {
 	int status = 0;
 	struct ocfs2_dinode *alloc = NULL;
@@ -345,21 +345,26 @@ int ocfs2_load_local_alloc(struct ocfs2_
 	if (num_used
 	    || alloc->id1.bitmap1.i_used
 	    || alloc->id1.bitmap1.i_total
-	    || la->la_bm_off)
+	    || la->la_bm_off) {
 		mlog(ML_ERROR, "Local alloc hasn't been recovered!\n"
 		     "found = %u, set = %u, taken = %u, off = %u\n",
 		     num_used, le32_to_cpu(alloc->id1.bitmap1.i_used),
 		     le32_to_cpu(alloc->id1.bitmap1.i_total),
 		     OCFS2_LOCAL_ALLOC(alloc)->la_bm_off);
+		status = -EINVAL;
+		*recovery = 1;
+		goto bail;
+	}
 
-	osb->local_alloc_bh = alloc_bh;
-	osb->local_alloc_state = OCFS2_LA_ENABLED;
+	if (!check) {
+		osb->local_alloc_bh = alloc_bh;
+		osb->local_alloc_state = OCFS2_LA_ENABLED;
+	}
 
 bail:
-	if (status < 0)
+	if (status < 0 || check)
 		brelse(alloc_bh);
-	if (inode)
-		iput(inode);
+	iput(inode);
 
 	trace_ocfs2_load_local_alloc(osb->local_alloc_bits);
 
diff -puN fs/ocfs2/localalloc.h~ocfs2-fix-bug-due-to-uncleaned-localalloc-during-mount fs/ocfs2/localalloc.h
--- a/fs/ocfs2/localalloc.h~ocfs2-fix-bug-due-to-uncleaned-localalloc-during-mount
+++ a/fs/ocfs2/localalloc.h
@@ -26,7 +26,7 @@
 #ifndef OCFS2_LOCALALLOC_H
 #define OCFS2_LOCALALLOC_H
 
-int ocfs2_load_local_alloc(struct ocfs2_super *osb);
+int ocfs2_load_local_alloc(struct ocfs2_super *osb, int check, int *recovery);
 
 void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb);
 
diff -puN fs/ocfs2/super.c~ocfs2-fix-bug-due-to-uncleaned-localalloc-during-mount fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-fix-bug-due-to-uncleaned-localalloc-during-mount
+++ a/fs/ocfs2/super.c
@@ -2424,6 +2424,7 @@ static int ocfs2_check_volume(struct ocf
 	int status;
 	int dirty;
 	int local;
+	int la_dirty = 0, recovery = 0;
 	struct ocfs2_dinode *local_alloc = NULL; /* only used if we
 						  * recover
 						  * ourselves. */
@@ -2445,6 +2446,16 @@ static int ocfs2_check_volume(struct ocf
 	 * recover anything. Otherwise, journal_load will do that
 	 * dirty work for us :) */
 	if (!dirty) {
+		/* It may happen that local alloc is unclean shutdown, but
+		 * journal has been marked clean, so check it here and do
+		 * recovery if needed */
+		status = ocfs2_load_local_alloc(osb, 1, &recovery);
+		if (recovery) {
+			printk(KERN_NOTICE "ocfs2: local alloc needs recovery "
+					"on device (%s).\n", osb->dev_str);
+			la_dirty = 1;
+		}
+
 		status = ocfs2_journal_wipe(osb->journal, 0);
 		if (status < 0) {
 			mlog_errno(status);
@@ -2473,7 +2484,7 @@ static int ocfs2_check_volume(struct ocf
 				JBD2_FEATURE_COMPAT_CHECKSUM, 0,
 				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
 
-	if (dirty) {
+	if (dirty || la_dirty) {
 		/* recover my local alloc if we didn't unmount cleanly. */
 		status = ocfs2_begin_local_alloc_recovery(osb,
 							  osb->slot_num,
@@ -2486,13 +2497,13 @@ static int ocfs2_check_volume(struct ocf
 		 * ourselves as mounted. */
 	}
 
-	status = ocfs2_load_local_alloc(osb);
+	status = ocfs2_load_local_alloc(osb, 0, &recovery);
 	if (status < 0) {
 		mlog_errno(status);
 		goto finally;
 	}
 
-	if (dirty) {
+	if (dirty || la_dirty) {
 		/* Recovery will be completed after we've mounted the
 		 * rest of the volume. */
 		osb->dirty = 1;
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v3.patch
ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

