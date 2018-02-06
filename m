From: akpm@linux-foundation.org
Subject: [patch 057/114] nilfs2: use time64_t internally
Date: Tue, 06 Feb 2018 15:39:21 -0800
Message-ID: <20180206233921.KAR4--o41%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55124 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932067AbeBFXjX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:39:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, axboe@kernel.dk, jack@suse.cz, konishi.ryusuke@lab.ntt.co.jp, mingo@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Arnd Bergmann <arnd@arndb.de>
Subject: nilfs2: use time64_t internally

The superblock and segment timestamps are used only internally in nilfs2
and can be read out using sysfs.  Since we are using the old
'get_seconds()' interface and store the data as timestamps, the behavior
differs slightly between 64-bit and 32-bit kernels, the latter will show
incorrect timestamps after 2038 in sysfs, and presumably fail completely
in 2106 as comparisons go wrong.

This changes nilfs2 to use time64_t with ktime_get_real_seconds() to
handle timestamps, making the behavior consistent and correct on both
32-bit and 64-bit machines.

The on-disk format already uses 64-bit timestamps, so nothing changes
there.

Link: http://lkml.kernel.org/r/20180122211050.1286441-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segbuf.c    |    2 +-
 fs/nilfs2/segbuf.h    |    4 ++--
 fs/nilfs2/segment.c   |    2 +-
 fs/nilfs2/segment.h   |    2 +-
 fs/nilfs2/sufile.c    |    2 +-
 fs/nilfs2/sufile.h    |    2 +-
 fs/nilfs2/super.c     |    4 ++--
 fs/nilfs2/sysfs.c     |   21 ++++++++++-----------
 fs/nilfs2/the_nilfs.h |    8 ++++----
 9 files changed, 23 insertions(+), 24 deletions(-)

diff -puN fs/nilfs2/segbuf.c~nilfs2-use-time64_t-internally fs/nilfs2/segbuf.c
--- a/fs/nilfs2/segbuf.c~nilfs2-use-time64_t-internally
+++ a/fs/nilfs2/segbuf.c
@@ -130,7 +130,7 @@ int nilfs_segbuf_extend_payload(struct n
 }
 
 int nilfs_segbuf_reset(struct nilfs_segment_buffer *segbuf, unsigned int flags,
-		       time_t ctime, __u64 cno)
+		       time64_t ctime, __u64 cno)
 {
 	int err;
 
diff -puN fs/nilfs2/segbuf.h~nilfs2-use-time64_t-internally fs/nilfs2/segbuf.h
--- a/fs/nilfs2/segbuf.h~nilfs2-use-time64_t-internally
+++ a/fs/nilfs2/segbuf.h
@@ -46,7 +46,7 @@ struct nilfs_segsum_info {
 	unsigned long		nfileblk;
 	u64			seg_seq;
 	__u64			cno;
-	time_t			ctime;
+	time64_t		ctime;
 	sector_t		next;
 };
 
@@ -120,7 +120,7 @@ void nilfs_segbuf_map_cont(struct nilfs_
 			   struct nilfs_segment_buffer *prev);
 void nilfs_segbuf_set_next_segnum(struct nilfs_segment_buffer *, __u64,
 				  struct the_nilfs *);
-int nilfs_segbuf_reset(struct nilfs_segment_buffer *, unsigned int, time_t,
+int nilfs_segbuf_reset(struct nilfs_segment_buffer *, unsigned int, time64_t,
 		       __u64);
 int nilfs_segbuf_extend_segsum(struct nilfs_segment_buffer *);
 int nilfs_segbuf_extend_payload(struct nilfs_segment_buffer *,
diff -puN fs/nilfs2/segment.c~nilfs2-use-time64_t-internally fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-use-time64_t-internally
+++ a/fs/nilfs2/segment.c
@@ -2040,7 +2040,7 @@ static int nilfs_segctor_do_construct(st
 			goto out;
 
 		/* Update time stamp */
-		sci->sc_seg_ctime = get_seconds();
+		sci->sc_seg_ctime = ktime_get_real_seconds();
 
 		err = nilfs_segctor_collect(sci, nilfs, mode);
 		if (unlikely(err))
diff -puN fs/nilfs2/segment.h~nilfs2-use-time64_t-internally fs/nilfs2/segment.h
--- a/fs/nilfs2/segment.h~nilfs2-use-time64_t-internally
+++ a/fs/nilfs2/segment.h
@@ -157,7 +157,7 @@ struct nilfs_sc_info {
 	unsigned long		sc_blk_cnt;
 	unsigned long		sc_datablk_cnt;
 	unsigned long		sc_nblk_this_inc;
-	time_t			sc_seg_ctime;
+	time64_t		sc_seg_ctime;
 	__u64			sc_cno;
 	unsigned long		sc_flags;
 
diff -puN fs/nilfs2/sufile.c~nilfs2-use-time64_t-internally fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-use-time64_t-internally
+++ a/fs/nilfs2/sufile.c
@@ -526,7 +526,7 @@ int nilfs_sufile_mark_dirty(struct inode
  * @modtime: modification time (option)
  */
 int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
-				   unsigned long nblocks, time_t modtime)
+				   unsigned long nblocks, time64_t modtime)
 {
 	struct buffer_head *bh;
 	struct nilfs_segment_usage *su;
diff -puN fs/nilfs2/sufile.h~nilfs2-use-time64_t-internally fs/nilfs2/sufile.h
--- a/fs/nilfs2/sufile.h~nilfs2-use-time64_t-internally
+++ a/fs/nilfs2/sufile.h
@@ -35,7 +35,7 @@ int nilfs_sufile_set_alloc_range(struct
 int nilfs_sufile_alloc(struct inode *, __u64 *);
 int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum);
 int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
-				   unsigned long nblocks, time_t modtime);
+				   unsigned long nblocks, time64_t modtime);
 int nilfs_sufile_get_stat(struct inode *, struct nilfs_sustat *);
 ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned int,
 				size_t);
diff -puN fs/nilfs2/super.c~nilfs2-use-time64_t-internally fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-use-time64_t-internally
+++ a/fs/nilfs2/super.c
@@ -283,10 +283,10 @@ int nilfs_commit_super(struct super_bloc
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
-	time_t t;
+	time64_t t;
 
 	/* nilfs->ns_sem must be locked by the caller. */
-	t = get_seconds();
+	t = ktime_get_real_seconds();
 	nilfs->ns_sbwtime = t;
 	sbp[0]->s_wtime = cpu_to_le64(t);
 	sbp[0]->s_sum = 0;
diff -puN fs/nilfs2/sysfs.c~nilfs2-use-time64_t-internally fs/nilfs2/sysfs.c
--- a/fs/nilfs2/sysfs.c~nilfs2-use-time64_t-internally
+++ a/fs/nilfs2/sysfs.c
@@ -31,7 +31,7 @@ static struct kset *nilfs_kset;
 #define NILFS_SHOW_TIME(time_t_val, buf) ({ \
 		struct tm res; \
 		int count = 0; \
-		time_to_tm(time_t_val, 0, &res); \
+		time64_to_tm(time_t_val, 0, &res); \
 		res.tm_year += 1900; \
 		res.tm_mon += 1; \
 		count = scnprintf(buf, PAGE_SIZE, \
@@ -579,7 +579,7 @@ nilfs_segctor_last_seg_write_time_show(s
 					struct the_nilfs *nilfs,
 					char *buf)
 {
-	time_t ctime;
+	time64_t ctime;
 
 	down_read(&nilfs->ns_segctor_sem);
 	ctime = nilfs->ns_ctime;
@@ -593,13 +593,13 @@ nilfs_segctor_last_seg_write_time_secs_s
 					    struct the_nilfs *nilfs,
 					    char *buf)
 {
-	time_t ctime;
+	time64_t ctime;
 
 	down_read(&nilfs->ns_segctor_sem);
 	ctime = nilfs->ns_ctime;
 	up_read(&nilfs->ns_segctor_sem);
 
-	return snprintf(buf, PAGE_SIZE, "%llu\n", (unsigned long long)ctime);
+	return snprintf(buf, PAGE_SIZE, "%llu\n", ctime);
 }
 
 static ssize_t
@@ -607,7 +607,7 @@ nilfs_segctor_last_nongc_write_time_show
 					 struct the_nilfs *nilfs,
 					 char *buf)
 {
-	time_t nongc_ctime;
+	time64_t nongc_ctime;
 
 	down_read(&nilfs->ns_segctor_sem);
 	nongc_ctime = nilfs->ns_nongc_ctime;
@@ -621,14 +621,13 @@ nilfs_segctor_last_nongc_write_time_secs
 						struct the_nilfs *nilfs,
 						char *buf)
 {
-	time_t nongc_ctime;
+	time64_t nongc_ctime;
 
 	down_read(&nilfs->ns_segctor_sem);
 	nongc_ctime = nilfs->ns_nongc_ctime;
 	up_read(&nilfs->ns_segctor_sem);
 
-	return snprintf(buf, PAGE_SIZE, "%llu\n",
-			(unsigned long long)nongc_ctime);
+	return snprintf(buf, PAGE_SIZE, "%llu\n", nongc_ctime);
 }
 
 static ssize_t
@@ -728,7 +727,7 @@ nilfs_superblock_sb_write_time_show(stru
 				     struct the_nilfs *nilfs,
 				     char *buf)
 {
-	time_t sbwtime;
+	time64_t sbwtime;
 
 	down_read(&nilfs->ns_sem);
 	sbwtime = nilfs->ns_sbwtime;
@@ -742,13 +741,13 @@ nilfs_superblock_sb_write_time_secs_show
 					 struct the_nilfs *nilfs,
 					 char *buf)
 {
-	time_t sbwtime;
+	time64_t sbwtime;
 
 	down_read(&nilfs->ns_sem);
 	sbwtime = nilfs->ns_sbwtime;
 	up_read(&nilfs->ns_sem);
 
-	return snprintf(buf, PAGE_SIZE, "%llu\n", (unsigned long long)sbwtime);
+	return snprintf(buf, PAGE_SIZE, "%llu\n", sbwtime);
 }
 
 static ssize_t
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-use-time64_t-internally fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-use-time64_t-internally
+++ a/fs/nilfs2/the_nilfs.h
@@ -116,7 +116,7 @@ struct the_nilfs {
 	 */
 	struct buffer_head     *ns_sbh[2];
 	struct nilfs_super_block *ns_sbp[2];
-	time_t			ns_sbwtime;
+	time64_t		ns_sbwtime;
 	unsigned int		ns_sbwcount;
 	unsigned int		ns_sbsize;
 	unsigned int		ns_mount_state;
@@ -131,8 +131,8 @@ struct the_nilfs {
 	__u64			ns_nextnum;
 	unsigned long		ns_pseg_offset;
 	__u64			ns_cno;
-	time_t			ns_ctime;
-	time_t			ns_nongc_ctime;
+	time64_t		ns_ctime;
+	time64_t		ns_nongc_ctime;
 	atomic_t		ns_ndirtyblks;
 
 	/*
@@ -267,7 +267,7 @@ struct nilfs_root {
 
 static inline int nilfs_sb_need_update(struct the_nilfs *nilfs)
 {
-	u64 t = get_seconds();
+	u64 t = ktime_get_real_seconds();
 
 	return t < nilfs->ns_sbwtime ||
 		t > nilfs->ns_sbwtime + nilfs->ns_sb_update_freq;
_
