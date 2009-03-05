From: akpm@linux-foundation.org
Subject: + nilfs2-simplify-handling-of-active-state-of-segments.patch added to -mm tree
Date: Thu, 05 Mar 2009 14:34:24 -0800
Message-ID: <200903052234.n25MYPiu009190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754269AbZCEWfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 17:35:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp


The patch titled
     nilfs2: simplify handling of active state of segments
has been added to the -mm tree.  Its filename is
     nilfs2-simplify-handling-of-active-state-of-segments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: simplify handling of active state of segments
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

will reduce some lines of segment constructor.  Previously, the state was
complexly controlled through a list of segments in order to keep
consistency in meta data of usage state of segments.  Instead, this
presents ``calculated'' active flags to userland cleaner program and stop
maintaining its real flag on disk.

Only by this fake flag, the cleaner cannot exactly know if each segment is
reclaimable or not.  However, the recent extension of nilfs_sustat ioctl
struct (nilfs2-extend-nilfs_sustat-ioctl-struct.patch) can prevent the
cleaner from reclaiming in-use segment wrongly.

So, now I can apply this for simplification.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/recovery.c  |   12 --
 fs/nilfs2/segbuf.c    |   24 -----
 fs/nilfs2/segbuf.h    |    6 -
 fs/nilfs2/segment.c   |  173 ++--------------------------------------
 fs/nilfs2/segment.h   |    5 -
 fs/nilfs2/sufile.c    |    8 +
 fs/nilfs2/super.c     |    4 
 fs/nilfs2/the_nilfs.h |    5 +
 8 files changed, 29 insertions(+), 208 deletions(-)

diff -puN fs/nilfs2/recovery.c~nilfs2-simplify-handling-of-active-state-of-segments fs/nilfs2/recovery.c
--- a/fs/nilfs2/recovery.c~nilfs2-simplify-handling-of-active-state-of-segments
+++ a/fs/nilfs2/recovery.c
@@ -463,16 +463,6 @@ static int nilfs_prepare_segment_for_rec
 		nilfs_free_segment_entry(ent);
 	}
 
-	/*
-	 * The segment having the latest super root is active, and
-	 * should be deactivated on the next construction for recovery.
-	 */
-	err = -ENOMEM;
-	ent = nilfs_alloc_segment_entry(segnum[0]);
-	if (unlikely(!ent))
-		goto failed;
-	list_add_tail(&ent->list, &ri->ri_used_segments);
-
 	/* Allocate new segments for recovery */
 	err = nilfs_sufile_alloc(sufile, &segnum[0]);
 	if (unlikely(err))
@@ -757,7 +747,7 @@ int nilfs_recover_logical_segments(struc
 			goto failed;
 		}
 
-		err = nilfs_attach_segment_constructor(sbi, ri);
+		err = nilfs_attach_segment_constructor(sbi);
 		if (unlikely(err))
 			goto failed;
 
diff -puN fs/nilfs2/segbuf.c~nilfs2-simplify-handling-of-active-state-of-segments fs/nilfs2/segbuf.c
--- a/fs/nilfs2/segbuf.c~nilfs2-simplify-handling-of-active-state-of-segments
+++ a/fs/nilfs2/segbuf.c
@@ -64,27 +64,17 @@ struct nilfs_segment_buffer *nilfs_segbu
 	INIT_LIST_HEAD(&segbuf->sb_list);
 	INIT_LIST_HEAD(&segbuf->sb_segsum_buffers);
 	INIT_LIST_HEAD(&segbuf->sb_payload_buffers);
-	segbuf->sb_segent = NULL;
 	return segbuf;
 }
 
 void nilfs_segbuf_free(struct nilfs_segment_buffer *segbuf)
 {
-	struct nilfs_segment_entry *ent = segbuf->sb_segent;
-
-	if (ent != NULL && list_empty(&ent->list)) {
-		/* free isolated segment list head */
-		nilfs_free_segment_entry(segbuf->sb_segent);
-		segbuf->sb_segent = NULL;
-	}
 	kmem_cache_free(nilfs_segbuf_cachep, segbuf);
 }
 
-int nilfs_segbuf_map(struct nilfs_segment_buffer *segbuf, __u64 segnum,
+void nilfs_segbuf_map(struct nilfs_segment_buffer *segbuf, __u64 segnum,
 		     unsigned long offset, struct the_nilfs *nilfs)
 {
-	struct nilfs_segment_entry *ent;
-
 	segbuf->sb_segnum = segnum;
 	nilfs_get_segment_range(nilfs, segnum, &segbuf->sb_fseg_start,
 				&segbuf->sb_fseg_end);
@@ -92,18 +82,6 @@ int nilfs_segbuf_map(struct nilfs_segmen
 	segbuf->sb_pseg_start = segbuf->sb_fseg_start + offset;
 	segbuf->sb_rest_blocks =
 		segbuf->sb_fseg_end - segbuf->sb_pseg_start + 1;
-
-	/* Attach a segment list head */
-	ent = segbuf->sb_segent;
-	if (ent == NULL) {
-		segbuf->sb_segent = nilfs_alloc_segment_entry(segnum);
-		if (unlikely(!segbuf->sb_segent))
-			return -ENOMEM;
-	} else {
-		BUG_ON(ent->bh_su || !list_empty(&ent->list));
-		ent->segnum = segnum;
-	}
-	return 0;
 }
 
 void nilfs_segbuf_set_next_segnum(struct nilfs_segment_buffer *segbuf,
diff -puN fs/nilfs2/segbuf.h~nilfs2-simplify-handling-of-active-state-of-segments fs/nilfs2/segbuf.h
--- a/fs/nilfs2/segbuf.h~nilfs2-simplify-handling-of-active-state-of-segments
+++ a/fs/nilfs2/segbuf.h
@@ -68,7 +68,6 @@ struct nilfs_segsum_info {
  * struct nilfs_segment_buffer - Segment buffer
  * @sb_super: back pointer to a superblock struct
  * @sb_list: List head to chain this structure
- * @sb_segent: Pointer for attaching a segment entry
  * @sb_sum: On-memory segment summary
  * @sb_segnum: Index number of the full segment
  * @sb_nextnum: Index number of the next full segment
@@ -83,7 +82,6 @@ struct nilfs_segsum_info {
 struct nilfs_segment_buffer {
 	struct super_block     *sb_super;
 	struct list_head	sb_list;
-	struct nilfs_segment_entry *sb_segent;
 
 	/* Segment information */
 	struct nilfs_segsum_info sb_sum;
@@ -125,8 +123,8 @@ int __init nilfs_init_segbuf_cache(void)
 void nilfs_destroy_segbuf_cache(void);
 struct nilfs_segment_buffer *nilfs_segbuf_new(struct super_block *);
 void nilfs_segbuf_free(struct nilfs_segment_buffer *);
-int nilfs_segbuf_map(struct nilfs_segment_buffer *, __u64, unsigned long,
-		     struct the_nilfs *);
+void nilfs_segbuf_map(struct nilfs_segment_buffer *, __u64, unsigned long,
+		      struct the_nilfs *);
 void nilfs_segbuf_set_next_segnum(struct nilfs_segment_buffer *, __u64,
 				  struct the_nilfs *);
 int nilfs_segbuf_reset(struct nilfs_segment_buffer *, unsigned, time_t);
diff -puN fs/nilfs2/segment.c~nilfs2-simplify-handling-of-active-state-of-segments fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-simplify-handling-of-active-state-of-segments
+++ a/fs/nilfs2/segment.c
@@ -1304,25 +1304,6 @@ static int nilfs_segctor_collect_blocks(
 	return err;
 }
 
-static int nilfs_segctor_terminate_segment(struct nilfs_sc_info *sci,
-					   struct nilfs_segment_buffer *segbuf,
-					   struct inode *sufile)
-{
-	struct nilfs_segment_entry *ent = segbuf->sb_segent;
-	int err;
-
-	err = nilfs_open_segment_entry(ent, sufile);
-	if (unlikely(err))
-		return err;
-	nilfs_mdt_mark_buffer_dirty(ent->bh_su);
-	nilfs_mdt_mark_dirty(sufile);
-	nilfs_close_segment_entry(ent, sufile);
-
-	list_add_tail(&ent->list, &sci->sc_active_segments);
-	segbuf->sb_segent = NULL;
-	return 0;
-}
-
 static int nilfs_touch_segusage(struct inode *sufile, __u64 segnum)
 {
 	struct buffer_head *bh_su;
@@ -1342,7 +1323,6 @@ static int nilfs_segctor_begin_construct
 					    struct the_nilfs *nilfs)
 {
 	struct nilfs_segment_buffer *segbuf, *n;
-	struct inode *sufile = nilfs->ns_sufile;
 	__u64 nextnum;
 	int err;
 
@@ -1354,28 +1334,22 @@ static int nilfs_segctor_begin_construct
 	} else
 		segbuf = NILFS_FIRST_SEGBUF(&sci->sc_segbufs);
 
-	err = nilfs_segbuf_map(segbuf, nilfs->ns_segnum,
-			       nilfs->ns_pseg_offset, nilfs);
-	if (unlikely(err))
-		return err;
+	nilfs_segbuf_map(segbuf, nilfs->ns_segnum, nilfs->ns_pseg_offset,
+			 nilfs);
 
 	if (segbuf->sb_rest_blocks < NILFS_PSEG_MIN_BLOCKS) {
-		err = nilfs_segctor_terminate_segment(sci, segbuf, sufile);
-		if (unlikely(err))
-			return err;
-
 		nilfs_shift_to_next_segment(nilfs);
-		err = nilfs_segbuf_map(segbuf, nilfs->ns_segnum, 0, nilfs);
+		nilfs_segbuf_map(segbuf, nilfs->ns_segnum, 0, nilfs);
 	}
 	sci->sc_segbuf_nblocks = segbuf->sb_rest_blocks;
 
-	err = nilfs_touch_segusage(sufile, segbuf->sb_segnum);
+	err = nilfs_touch_segusage(nilfs->ns_sufile, segbuf->sb_segnum);
 	if (unlikely(err))
 		return err;
 
 	if (nilfs->ns_segnum == nilfs->ns_nextnum) {
 		/* Start from the head of a new full segment */
-		err = nilfs_sufile_alloc(sufile, &nextnum);
+		err = nilfs_sufile_alloc(nilfs->ns_sufile, &nextnum);
 		if (unlikely(err))
 			return err;
 	} else
@@ -1390,7 +1364,7 @@ static int nilfs_segctor_begin_construct
 		list_del_init(&segbuf->sb_list);
 		nilfs_segbuf_free(segbuf);
 	}
-	return err;
+	return 0;
 }
 
 static int nilfs_segctor_extend_segments(struct nilfs_sc_info *sci,
@@ -1421,10 +1395,7 @@ static int nilfs_segctor_extend_segments
 			goto failed;
 
 		/* map this buffer to region of segment on-disk */
-		err = nilfs_segbuf_map(segbuf, prev->sb_nextnum, 0, nilfs);
-		if (unlikely(err))
-			goto failed_segbuf;
-
+		nilfs_segbuf_map(segbuf, prev->sb_nextnum, 0, nilfs);
 		sci->sc_segbuf_nblocks += segbuf->sb_rest_blocks;
 
 		/* allocate the next next full segment */
@@ -2178,102 +2149,6 @@ static void nilfs_segctor_check_out_file
 }
 
 /*
- * Nasty routines to manipulate active flags on sufile.
- * These would be removed in a future release.
- */
-static void nilfs_segctor_reactivate_segments(struct nilfs_sc_info *sci,
-					      struct the_nilfs *nilfs)
-{
-	struct nilfs_segment_buffer *segbuf, *last;
-	struct nilfs_segment_entry *ent, *n;
-	struct inode *sufile = nilfs->ns_sufile;
-	struct list_head *head;
-
-	last = NILFS_LAST_SEGBUF(&sci->sc_segbufs);
-	nilfs_for_each_segbuf_before(segbuf, last, &sci->sc_segbufs) {
-		ent = segbuf->sb_segent;
-		if (!ent)
-			break; /* ignore unmapped segments (should check it?)*/
-		nilfs_segment_usage_set_active(ent->raw_su);
-		nilfs_close_segment_entry(ent, sufile);
-	}
-
-	head = &sci->sc_active_segments;
-	list_for_each_entry_safe(ent, n, head, list) {
-		nilfs_segment_usage_set_active(ent->raw_su);
-		nilfs_close_segment_entry(ent, sufile);
-	}
-}
-
-static int nilfs_segctor_deactivate_segments(struct nilfs_sc_info *sci,
-					     struct the_nilfs *nilfs)
-{
-	struct nilfs_segment_buffer *segbuf, *last;
-	struct nilfs_segment_entry *ent;
-	struct inode *sufile = nilfs->ns_sufile;
-	int err;
-
-	last = NILFS_LAST_SEGBUF(&sci->sc_segbufs);
-	nilfs_for_each_segbuf_before(segbuf, last, &sci->sc_segbufs) {
-		/*
-		 * Deactivate ongoing full segments.  The last segment is kept
-		 * active because it is a start point of recovery, and is not
-		 * relocatable until the super block points to a newer
-		 * checkpoint.
-		 */
-		ent = segbuf->sb_segent;
-		if (!ent)
-			break; /* ignore unmapped segments (should check it?)*/
-		err = nilfs_open_segment_entry(ent, sufile);
-		if (unlikely(err))
-			goto failed;
-		nilfs_segment_usage_clear_active(ent->raw_su);
-		BUG_ON(!buffer_dirty(ent->bh_su));
-	}
-
-	list_for_each_entry(ent, &sci->sc_active_segments, list) {
-		err = nilfs_open_segment_entry(ent, sufile);
-		if (unlikely(err))
-			goto failed;
-		nilfs_segment_usage_clear_active(ent->raw_su);
-		WARN_ON(!buffer_dirty(ent->bh_su));
-	}
-	return 0;
-
- failed:
-	nilfs_segctor_reactivate_segments(sci, nilfs);
-	return err;
-}
-
-static void nilfs_segctor_bead_completed_segments(struct nilfs_sc_info *sci)
-{
-	struct nilfs_segment_buffer *segbuf, *last;
-	struct nilfs_segment_entry *ent;
-
-	/* move each segbuf->sb_segent to the list of used active segments */
-	last = NILFS_LAST_SEGBUF(&sci->sc_segbufs);
-	nilfs_for_each_segbuf_before(segbuf, last, &sci->sc_segbufs) {
-		ent = segbuf->sb_segent;
-		if (!ent)
-			break; /* ignore unmapped segments (should check it?)*/
-		list_add_tail(&ent->list, &sci->sc_active_segments);
-		segbuf->sb_segent = NULL;
-	}
-}
-
-static void nilfs_segctor_commit_deactivate_segments(struct nilfs_sc_info *sci,
-						     struct the_nilfs *nilfs)
-{
-	struct nilfs_segment_entry *ent, *n;
-
-	list_for_each_entry_safe(ent, n, &sci->sc_active_segments, list) {
-		list_del(&ent->list);
-		nilfs_close_segment_entry(ent, nilfs->ns_sufile);
-		nilfs_free_segment_entry(ent);
-	}
-}
-
-/*
  * Main procedure of segment constructor
  */
 static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
@@ -2322,11 +2197,6 @@ static int nilfs_segctor_do_construct(st
 		if (unlikely(err))
 			goto failed;
 
-		if (has_sr) {
-			err = nilfs_segctor_deactivate_segments(sci, nilfs);
-			if (unlikely(err))
-				goto failed;
-		}
 		if (sci->sc_stage.flags & NILFS_CF_IFILE_STARTED)
 			nilfs_segctor_fill_in_file_bmap(sci, sbi->s_ifile);
 
@@ -2353,12 +2223,10 @@ static int nilfs_segctor_do_construct(st
 		nilfs_segctor_complete_write(sci);
 
 		/* Commit segments */
-		nilfs_segctor_bead_completed_segments(sci);
 		if (has_sr) {
 			down_write(&nilfs->ns_sem);
 			nilfs_update_last_segment(sbi, 1);
 			up_write(&nilfs->ns_sem);
-			nilfs_segctor_commit_deactivate_segments(sci, nilfs);
 			nilfs_segctor_commit_free_segments(sci);
 			nilfs_segctor_clear_metadata_dirty(sci);
 		}
@@ -2379,8 +2247,6 @@ static int nilfs_segctor_do_construct(st
  failed_to_make_up:
 	if (sci->sc_stage.flags & NILFS_CF_IFILE_STARTED)
 		nilfs_redirty_inodes(&sci->sc_dirty_files);
-	if (has_sr)
-		nilfs_segctor_reactivate_segments(sci, nilfs);
 
  failed:
 	if (nilfs_doing_gc())
@@ -2942,23 +2808,11 @@ static void nilfs_segctor_kill_thread(st
 	}
 }
 
-static int nilfs_segctor_init(struct nilfs_sc_info *sci,
-			      struct nilfs_recovery_info *ri)
+static int nilfs_segctor_init(struct nilfs_sc_info *sci)
 {
-	int err;
-
 	sci->sc_seq_done = sci->sc_seq_request;
-	if (ri)
-		list_splice_init(&ri->ri_used_segments,
-				 sci->sc_active_segments.prev);
 
-	err = nilfs_segctor_start_thread(sci);
-	if (err) {
-		if (ri)
-			list_splice_init(&sci->sc_active_segments,
-					 ri->ri_used_segments.prev);
-	}
-	return err;
+	return nilfs_segctor_start_thread(sci);
 }
 
 /*
@@ -2982,7 +2836,6 @@ static struct nilfs_sc_info *nilfs_segct
 	INIT_LIST_HEAD(&sci->sc_dirty_files);
 	INIT_LIST_HEAD(&sci->sc_segbufs);
 	INIT_LIST_HEAD(&sci->sc_gc_inodes);
-	INIT_LIST_HEAD(&sci->sc_active_segments);
 	INIT_LIST_HEAD(&sci->sc_cleaning_segments);
 	INIT_LIST_HEAD(&sci->sc_copied_buffers);
 
@@ -3048,8 +2901,6 @@ static void nilfs_segctor_destroy(struct
 			      "dirty file(s) after the final construction\n");
 		nilfs_dispose_list(sbi, &sci->sc_dirty_files, 1);
 	}
-	if (!list_empty(&sci->sc_active_segments))
-		nilfs_dispose_segment_list(&sci->sc_active_segments);
 
 	if (!list_empty(&sci->sc_cleaning_segments))
 		nilfs_dispose_segment_list(&sci->sc_cleaning_segments);
@@ -3064,7 +2915,6 @@ static void nilfs_segctor_destroy(struct
 /**
  * nilfs_attach_segment_constructor - attach a segment constructor
  * @sbi: nilfs_sb_info
- * @ri: nilfs_recovery_info
  *
  * nilfs_attach_segment_constructor() allocates a struct nilfs_sc_info,
  * initilizes it, and starts the segment constructor.
@@ -3074,8 +2924,7 @@ static void nilfs_segctor_destroy(struct
  *
  * %-ENOMEM - Insufficient memory available.
  */
-int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi,
-				     struct nilfs_recovery_info *ri)
+int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	int err;
@@ -3087,7 +2936,7 @@ int nilfs_attach_segment_constructor(str
 		return -ENOMEM;
 
 	nilfs_attach_writer(nilfs, sbi);
-	err = nilfs_segctor_init(NILFS_SC(sbi), ri);
+	err = nilfs_segctor_init(NILFS_SC(sbi));
 	if (err) {
 		nilfs_detach_writer(nilfs, sbi);
 		kfree(sbi->s_sc_info);
diff -puN fs/nilfs2/segment.h~nilfs2-simplify-handling-of-active-state-of-segments fs/nilfs2/segment.h
--- a/fs/nilfs2/segment.h~nilfs2-simplify-handling-of-active-state-of-segments
+++ a/fs/nilfs2/segment.h
@@ -90,7 +90,6 @@ struct nilfs_segsum_pointer {
  * @sc_nblk_inc: Block count of current generation
  * @sc_dirty_files: List of files to be written
  * @sc_gc_inodes: List of GC inodes having blocks to be written
- * @sc_active_segments: List of active segments that were already written out
  * @sc_cleaning_segments: List of segments to be freed through construction
  * @sc_copied_buffers: List of copied buffers (buffer heads) to freeze data
  * @sc_dsync_inode: inode whose data pages are written for a sync operation
@@ -132,7 +131,6 @@ struct nilfs_sc_info {
 
 	struct list_head	sc_dirty_files;
 	struct list_head	sc_gc_inodes;
-	struct list_head	sc_active_segments;
 	struct list_head	sc_cleaning_segments;
 	struct list_head	sc_copied_buffers;
 
@@ -232,8 +230,7 @@ extern int nilfs_segctor_add_segments_to
 						  __u64 *, size_t);
 extern void nilfs_segctor_clear_segments_to_be_freed(struct nilfs_sc_info *);
 
-extern int nilfs_attach_segment_constructor(struct nilfs_sb_info *,
-					    struct nilfs_recovery_info *);
+extern int nilfs_attach_segment_constructor(struct nilfs_sb_info *);
 extern void nilfs_detach_segment_constructor(struct nilfs_sb_info *);
 
 /* recovery.c */
diff -puN fs/nilfs2/sufile.c~nilfs2-simplify-handling-of-active-state-of-segments fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-simplify-handling-of-active-state-of-segments
+++ a/fs/nilfs2/sufile.c
@@ -158,7 +158,6 @@ int nilfs_sufile_alloc(struct inode *suf
 			if (!nilfs_segment_usage_clean(su))
 				continue;
 			/* found a clean segment */
-			nilfs_segment_usage_set_active(su);
 			nilfs_segment_usage_set_dirty(su);
 			kunmap_atomic(kaddr, KM_USER0);
 
@@ -591,6 +590,7 @@ ssize_t nilfs_sufile_get_suinfo(struct i
 	struct buffer_head *su_bh;
 	struct nilfs_segment_usage *su;
 	size_t susz = NILFS_MDT(sufile)->mi_entry_size;
+	struct the_nilfs *nilfs = NILFS_MDT(sufile)->mi_nilfs;
 	void *kaddr;
 	unsigned long nsegs, segusages_per_block;
 	ssize_t n;
@@ -623,7 +623,11 @@ ssize_t nilfs_sufile_get_suinfo(struct i
 		for (j = 0; j < n; j++, su = (void *)su + susz) {
 			si[i + j].sui_lastmod = le64_to_cpu(su->su_lastmod);
 			si[i + j].sui_nblocks = le32_to_cpu(su->su_nblocks);
-			si[i + j].sui_flags = le32_to_cpu(su->su_flags);
+			si[i + j].sui_flags = le32_to_cpu(su->su_flags) &
+				~(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
+			if (nilfs_segment_is_active(nilfs, segnum + i + j))
+				si[i + j].sui_flags |=
+					(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
 		}
 		kunmap_atomic(kaddr, KM_USER0);
 		brelse(su_bh);
diff -puN fs/nilfs2/super.c~nilfs2-simplify-handling-of-active-state-of-segments fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-simplify-handling-of-active-state-of-segments
+++ a/fs/nilfs2/super.c
@@ -868,7 +868,7 @@ nilfs_fill_super(struct super_block *sb,
 	}
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		err = nilfs_attach_segment_constructor(sbi, NULL);
+		err = nilfs_attach_segment_constructor(sbi);
 		if (err)
 			goto failed_checkpoint;
 	}
@@ -1001,7 +1001,7 @@ static int nilfs_remount(struct super_bl
 		nilfs_clear_opt(sbi, SNAPSHOT);
 		sbi->s_snapshot_cno = 0;
 
-		err = nilfs_attach_segment_constructor(sbi, NULL);
+		err = nilfs_attach_segment_constructor(sbi);
 		if (err)
 			goto rw_remount_failed;
 
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-simplify-handling-of-active-state-of-segments fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-simplify-handling-of-active-state-of-segments
+++ a/fs/nilfs2/the_nilfs.h
@@ -280,4 +280,9 @@ static inline __u64 nilfs_last_cno(struc
 	return cno;
 }
 
+static inline int nilfs_segment_is_active(struct the_nilfs *nilfs, __u64 n)
+{
+	return n == nilfs->ns_segnum || n == nilfs->ns_nextnum;
+}
+
 #endif /* _THE_NILFS_H */
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-add-document.patch
nilfs2-disk-format-and-userland-interface.patch
nilfs2-add-inode-and-other-major-structures.patch
nilfs2-integrated-block-mapping.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-b-tree-based-block-mapping.patch
nilfs2-direct-block-mapping.patch
nilfs2-b-tree-node-cache.patch
nilfs2-buffer-and-page-operations.patch
nilfs2-meta-data-file.patch
nilfs2-persistent-object-allocator.patch
nilfs2-disk-address-translator.patch
nilfs2-inode-map-file.patch
nilfs2-checkpoint-file.patch
nilfs2-segment-usage-file.patch
nilfs2-segment-usage-file-fix-wrong-counting-of-checkpoints-and-dirty-segments.patch
nilfs2-inode-operations.patch
nilfs2-inode-operations-fix.patch
nilfs2-file-operations.patch
nilfs2-directory-entry-operations.patch
nilfs2-pathname-operations.patch
nilfs2-pathname-operations-fix.patch
nilfs2-operations-for-the_nilfs-core-object.patch
nilfs2-super-block-operations.patch
nilfs2-super-block-operations-fix.patch
nilfs2-segment-buffer.patch
nilfs2-segment-buffer-fix.patch
nilfs2-segment-constructor.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite.patch
nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range.patch
nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range-fix.patch
nilfs2-recovery-functions.patch
nilfs2-another-dat-for-garbage-collection.patch
nilfs2-block-cache-for-garbage-collection.patch
nilfs2-ioctl-operations.patch
nilfs2-update-makefile-and-kconfig.patch
nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch
nilfs2-cleanup-nilfs_clear_inode.patch
nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch
nilfs2-insert-explanations-in-gcinode-file.patch
nilfs2-add-maintainer.patch
nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots.patch
nilfs2-clean-up-indirect-function-calling-conventions.patch
nilfs2-fix-buggy-behavior-seen-in-enumerating-checkpoints.patch
nilfs2-remove-timedwait-ioctl-command.patch
nilfs2-use-fixed-sized-types-for-ioctl-structures.patch
nilfs2-remove-compat-ioctl-code.patch
nilfs2-use-unlocked_ioctl.patch
nilfs2-extend-nilfs_sustat-ioctl-struct.patch
nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl.patch
nilfs2-super-block-operations-fix-endian-bug.patch
nilfs2-clean-up-sketch-file.patch
nilfs2-mark-minor-flag-for-checkpoint-created-by-internal-operation.patch
nilfs2-simplify-handling-of-active-state-of-segments.patch
nilfs2-introduce-secondary-super-block.patch

