From: akpm@linux-foundation.org
Subject: + nilfs2-fix-misuse-of-a-semaphore-in-sysfs-code.patch added to
 -mm tree
Date: Tue, 14 Jun 2016 15:27:00 -0700
Message-ID: <576084b4.eEtoxpXF8QjFvkc+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbcFNW1B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2016 18:27:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix misuse of a semaphore in sysfs code
has been added to the -mm tree.  Its filename is
     nilfs2-fix-misuse-of-a-semaphore-in-sysfs-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-fix-misuse-of-a-semaphore-in-sysfs-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-fix-misuse-of-a-semaphore-in-sysfs-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-hide-function-name-argument-from-nilfs_error.patch
nilfs2-add-nilfs_msg-message-interface.patch
nilfs2-embed-a-back-pointer-to-super-block-instance-in-nilfs-object.patch
nilfs2-reduce-bare-use-of-printk-with-nilfs_msg.patch
nilfs2-replace-nilfs_warning-with-nilfs_msg.patch
nilfs2-emit-error-message-when-i-o-error-is-detected.patch
nilfs2-do-not-use-yield.patch
nilfs2-refactor-parser-of-snapshot-mount-option.patch
nilfs2-fix-misuse-of-a-semaphore-in-sysfs-code.patch
nilfs2-use-bit-macro.patch
nilfs2-move-ioctl-interface-and-disk-layout-to-uapi-separately.patch

