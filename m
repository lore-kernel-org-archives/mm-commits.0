From: akpm@linux-foundation.org
Subject: [patch 068/111] nilfs2: fix misuse of a semaphore in sysfs code
Date: Tue, 02 Aug 2016 14:05:25 -0700
Message-ID: <57a10b15.tKt4gTRjDtW9FHxi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbcHBVQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:16:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: fix misuse of a semaphore in sysfs code

Variables ns_seg_seq, ns_segnum, ns_nextnum, ns_pseg_offset, ns_cno,
ns_ctime, ns_nongc_ctime, and ns_ndirtyblks, are protected by
ns_segctor_sem, but ns_sem is wrongly used by the nilfs sysfs code
when reading these variables.  This fixes the misuse and clarifies
which semaphore protects them in the comment of the_nilfs struct.

Link: http://lkml.kernel.org/r/1465825507-3407-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sysfs.c     |   44 ++++++++++++++++++++--------------------
 fs/nilfs2/the_nilfs.h |    7 +-----
 2 files changed, 24 insertions(+), 27 deletions(-)

diff -puN fs/nilfs2/sysfs.c~nilfs2-fix-misuse-of-a-semaphore-in-sysfs-code fs/nilfs2/sysfs.c
--- a/fs/nilfs2/sysfs.c~nilfs2-fix-misuse-of-a-semaphore-in-sysfs-code
+++ a/fs/nilfs2/sysfs.c
@@ -326,9 +326,9 @@ nilfs_checkpoints_next_checkpoint_show(s
 {
 	__u64 cno;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	cno = nilfs->ns_cno;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n", cno);
 }
@@ -511,9 +511,9 @@ nilfs_segctor_current_seg_sequence_show(
 {
 	u64 seg_seq;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	seg_seq = nilfs->ns_seg_seq;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n", seg_seq);
 }
@@ -525,9 +525,9 @@ nilfs_segctor_current_last_full_seg_show
 {
 	__u64 segnum;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	segnum = nilfs->ns_segnum;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n", segnum);
 }
@@ -539,9 +539,9 @@ nilfs_segctor_next_full_seg_show(struct
 {
 	__u64 nextnum;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	nextnum = nilfs->ns_nextnum;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n", nextnum);
 }
@@ -553,9 +553,9 @@ nilfs_segctor_next_pseg_offset_show(stru
 {
 	unsigned long pseg_offset;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	pseg_offset = nilfs->ns_pseg_offset;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%lu\n", pseg_offset);
 }
@@ -567,9 +567,9 @@ nilfs_segctor_next_checkpoint_show(struc
 {
 	__u64 cno;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	cno = nilfs->ns_cno;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n", cno);
 }
@@ -581,9 +581,9 @@ nilfs_segctor_last_seg_write_time_show(s
 {
 	time_t ctime;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	ctime = nilfs->ns_ctime;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return NILFS_SHOW_TIME(ctime, buf);
 }
@@ -595,9 +595,9 @@ nilfs_segctor_last_seg_write_time_secs_s
 {
 	time_t ctime;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	ctime = nilfs->ns_ctime;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n", (unsigned long long)ctime);
 }
@@ -609,9 +609,9 @@ nilfs_segctor_last_nongc_write_time_show
 {
 	time_t nongc_ctime;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	nongc_ctime = nilfs->ns_nongc_ctime;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return NILFS_SHOW_TIME(nongc_ctime, buf);
 }
@@ -623,9 +623,9 @@ nilfs_segctor_last_nongc_write_time_secs
 {
 	time_t nongc_ctime;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	nongc_ctime = nilfs->ns_nongc_ctime;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n",
 			(unsigned long long)nongc_ctime);
@@ -638,9 +638,9 @@ nilfs_segctor_dirty_data_blocks_count_sh
 {
 	u32 ndirtyblks;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	ndirtyblks = atomic_read(&nilfs->ns_ndirtyblks);
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%u\n", ndirtyblks);
 }
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-fix-misuse-of-a-semaphore-in-sysfs-code fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-fix-misuse-of-a-semaphore-in-sysfs-code
+++ a/fs/nilfs2/the_nilfs.h
@@ -122,11 +122,8 @@ struct the_nilfs {
 	unsigned int		ns_sb_update_freq;
 
 	/*
-	 * Following fields are dedicated to a writable FS-instance.
-	 * Except for the period seeking checkpoint, code outside the segment
-	 * constructor must lock a segment semaphore while accessing these
-	 * fields.
-	 * The writable FS-instance is sole during a lifetime of the_nilfs.
+	 * The following fields are updated by a writable FS-instance.
+	 * These fields are protected by ns_segctor_sem outside load_nilfs().
 	 */
 	u64			ns_seg_seq;
 	__u64			ns_segnum;
_
