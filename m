From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Fri, 29 Oct 2010 12:01:15 -0700
Message-ID: <201010291902.o9TJ1xLe011473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761666Ab0J2TCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Oct 2010 15:02:32 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o9TJ20fS012731
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 29 Oct 2010 12:02:00 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/ext4.h              |   12 ------
 fs/ext4/extents.c           |    4 --
 fs/ext4/ialloc.c            |    3 -
 fs/ext4/inode.c             |    3 -
 fs/ext4/page-io.c           |    8 ----
 fs/ext4/super.c             |   63 ----------------------------------
 include/trace/events/ext4.h |   26 --------------
 7 files changed, 119 deletions(-)

diff -puN fs/ext4/ext4.h~linux-next-git-rejects fs/ext4/ext4.h
--- a/fs/ext4/ext4.h~linux-next-git-rejects
+++ a/fs/ext4/ext4.h
@@ -1701,15 +1701,11 @@ extern struct inode * ext4_orphan_get(st
 extern unsigned long ext4_count_free_inodes(struct super_block *);
 extern unsigned long ext4_count_dirs(struct super_block *);
 extern void ext4_check_inodes_bitmap(struct super_block *);
-<<<<<<< HEAD
 extern void ext4_mark_bitmap_end(int start_bit, int end_bit, char *bitmap);
-=======
 extern unsigned ext4_init_inode_bitmap(struct super_block *sb,
 				       struct buffer_head *bh,
 				       ext4_group_t group,
 				       struct ext4_group_desc *desc);
-extern void mark_bitmap_end(int start_bit, int end_bit, char *bitmap);
->>>>>>> FETCH_HEAD
 extern int ext4_init_inode_table(struct super_block *sb,
 				 ext4_group_t group, int barrier);
 
@@ -1729,12 +1725,9 @@ extern void ext4_free_blocks(handle_t *h
 			     unsigned long count, int flags);
 extern int ext4_mb_add_groupinfo(struct super_block *sb,
 		ext4_group_t i, struct ext4_group_desc *desc);
-<<<<<<< HEAD
-=======
 extern int ext4_mb_get_buddy_cache_lock(struct super_block *, ext4_group_t);
 extern void ext4_mb_put_buddy_cache_lock(struct super_block *,
 						ext4_group_t, int);
->>>>>>> FETCH_HEAD
 extern int ext4_trim_fs(struct super_block *, struct fstrim_range *);
 
 /* inode.c */
@@ -2109,13 +2102,8 @@ extern int ext4_move_extents(struct file
 			     __u64 len, __u64 *moved_len);
 
 /* page-io.c */
-<<<<<<< HEAD
 extern int __init ext4_init_pageio(void);
 extern void ext4_exit_pageio(void);
-=======
-extern int __init init_ext4_pageio(void);
-extern void exit_ext4_pageio(void);
->>>>>>> FETCH_HEAD
 extern void ext4_free_io_end(ext4_io_end_t *io);
 extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
 extern int ext4_end_io_nolock(ext4_io_end_t *io);
diff -puN fs/ext4/extents.c~linux-next-git-rejects fs/ext4/extents.c
--- a/fs/ext4/extents.c~linux-next-git-rejects
+++ a/fs/ext4/extents.c
@@ -2496,11 +2496,7 @@ static int ext4_ext_zeroout(struct inode
 	int ret;
 
 	ee_len    = ext4_ext_get_actual_len(ex);
-<<<<<<< HEAD
 	ee_pblock = ext4_ext_pblock(ex);
-=======
-	ee_pblock = ext_pblock(ex);
->>>>>>> FETCH_HEAD
 
 	ret = sb_issue_zeroout(inode->i_sb, ee_pblock, ee_len, GFP_NOFS);
 	if (ret > 0)
diff -puN fs/ext4/ialloc.c~linux-next-git-rejects fs/ext4/ialloc.c
--- a/fs/ext4/ialloc.c~linux-next-git-rejects
+++ a/fs/ext4/ialloc.c
@@ -1306,11 +1306,8 @@ extern int ext4_init_inode_table(struct 
 	ret = sb_issue_zeroout(sb, blk, num, GFP_NOFS);
 	if (ret < 0)
 		goto err_out;
-<<<<<<< HEAD
 	if (barrier)
 		blkdev_issue_flush(sb->s_bdev, GFP_NOFS, NULL);
-=======
->>>>>>> FETCH_HEAD
 
 skip_zeroout:
 	ext4_lock_group(sb, group);
diff -puN fs/ext4/inode.c~linux-next-git-rejects fs/ext4/inode.c
--- a/fs/ext4/inode.c~linux-next-git-rejects
+++ a/fs/ext4/inode.c
@@ -3625,8 +3625,6 @@ static int ext4_get_block_write(struct i
 			       EXT4_GET_BLOCKS_IO_CREATE_EXT);
 }
 
-<<<<<<< HEAD
-=======
 static void dump_completed_IO(struct inode * inode)
 {
 #ifdef	EXT4_DEBUG
@@ -3710,7 +3708,6 @@ int flush_completed_IO(struct inode *ino
 	return (ret2 < 0) ? ret2 : 0;
 }
 
->>>>>>> FETCH_HEAD
 static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 			    ssize_t size, void *private, int ret,
 			    bool is_async)
diff -puN fs/ext4/page-io.c~linux-next-git-rejects fs/ext4/page-io.c
--- a/fs/ext4/page-io.c~linux-next-git-rejects
+++ a/fs/ext4/page-io.c
@@ -32,11 +32,7 @@
 
 static struct kmem_cache *io_page_cachep, *io_end_cachep;
 
-<<<<<<< HEAD
 int __init ext4_init_pageio(void)
-=======
-int __init init_ext4_pageio(void)
->>>>>>> FETCH_HEAD
 {
 	io_page_cachep = KMEM_CACHE(ext4_io_page, SLAB_RECLAIM_ACCOUNT);
 	if (io_page_cachep == NULL)
@@ -50,11 +46,7 @@ int __init init_ext4_pageio(void)
 	return 0;
 }
 
-<<<<<<< HEAD
 void ext4_exit_pageio(void)
-=======
-void exit_ext4_pageio(void)
->>>>>>> FETCH_HEAD
 {
 	kmem_cache_destroy(io_end_cachep);
 	kmem_cache_destroy(io_page_cachep);
diff -puN fs/ext4/super.c~linux-next-git-rejects fs/ext4/super.c
--- a/fs/ext4/super.c~linux-next-git-rejects
+++ a/fs/ext4/super.c
@@ -2456,17 +2456,11 @@ static struct attribute *ext4_attrs[] = 
 
 /* Features this copy of ext4 supports */
 EXT4_INFO_ATTR(lazy_itable_init);
-<<<<<<< HEAD
 EXT4_INFO_ATTR(batched_discard);
 
 static struct attribute *ext4_feat_attrs[] = {
 	ATTR_LIST(lazy_itable_init),
 	ATTR_LIST(batched_discard),
-=======
-
-static struct attribute *ext4_feat_attrs[] = {
-	ATTR_LIST(lazy_itable_init),
->>>>>>> FETCH_HEAD
 	NULL,
 };
 
@@ -2907,39 +2901,20 @@ static int ext4_register_li_request(stru
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_li_request *elr;
 	ext4_group_t ngroups = EXT4_SB(sb)->s_groups_count;
-<<<<<<< HEAD
-	int ret;
-
-	if (sbi->s_li_request != NULL)
-		return 0;
-=======
 	int ret = 0;
 
 	if (sbi->s_li_request != NULL)
 		goto out;
->>>>>>> FETCH_HEAD
 
 	if (first_not_zeroed == ngroups ||
 	    (sb->s_flags & MS_RDONLY) ||
 	    !test_opt(sb, INIT_INODE_TABLE)) {
 		sbi->s_li_request = NULL;
-<<<<<<< HEAD
-		return 0;
-=======
 		goto out;
->>>>>>> FETCH_HEAD
 	}
 
 	if (first_not_zeroed == ngroups) {
 		sbi->s_li_request = NULL;
-<<<<<<< HEAD
-		return 0;
-	}
-
-	elr = ext4_li_request_new(sb, first_not_zeroed);
-	if (!elr)
-		return -ENOMEM;
-=======
 		goto out;
 	}
 
@@ -2948,7 +2923,6 @@ static int ext4_register_li_request(stru
 		ret = -ENOMEM;
 		goto out;
 	}
->>>>>>> FETCH_HEAD
 
 	mutex_lock(&ext4_li_mtx);
 
@@ -2969,12 +2943,6 @@ static int ext4_register_li_request(stru
 		if (ret)
 			goto out;
 	}
-<<<<<<< HEAD
-out:
-	mutex_unlock(&ext4_li_mtx);
-	if (ret)
-		kfree(elr);
-=======
 
 	mutex_unlock(&ext4_li_mtx);
 
@@ -2983,7 +2951,6 @@ out:
 		mutex_unlock(&ext4_li_mtx);
 		kfree(elr);
 	}
->>>>>>> FETCH_HEAD
 	return ret;
 }
 
@@ -3994,11 +3961,7 @@ static int ext4_commit_super(struct supe
 		ext4_free_blocks_count_set(es, percpu_counter_sum_positive(
 					&EXT4_SB(sb)->s_freeblocks_counter));
 	if (percpu_counter_initialized(&EXT4_SB(sb)->s_freeinodes_counter))
-<<<<<<< HEAD
-		es->s_free_inodes_count =
-=======
 		es->s_free_inodes_count = 
->>>>>>> FETCH_HEAD
 			cpu_to_le32(percpu_counter_sum_positive(
 					&EXT4_SB(sb)->s_freeinodes_counter));
 	sb->s_dirt = 0;
@@ -4796,26 +4759,15 @@ out:
 	return ret;
 }
 
-<<<<<<< HEAD
 static int __init ext4_init_fs(void)
-=======
-static int __init init_ext4_fs(void)
->>>>>>> FETCH_HEAD
 {
 	int err;
 
 	ext4_check_flag_values();
-<<<<<<< HEAD
 	err = ext4_init_pageio();
 	if (err)
 		return err;
 	err = ext4_init_system_zone();
-=======
-	err = init_ext4_pageio();
-	if (err)
-		return err;
-	err = init_ext4_system_zone();
->>>>>>> FETCH_HEAD
 	if (err)
 		goto out5;
 	ext4_kset = kset_create_and_add("ext4", NULL, fs_kobj);
@@ -4825,11 +4777,7 @@ static int __init init_ext4_fs(void)
 
 	err = ext4_init_feat_adverts();
 
-<<<<<<< HEAD
 	err = ext4_init_mballoc();
-=======
-	err = init_ext4_mballoc();
->>>>>>> FETCH_HEAD
 	if (err)
 		goto out3;
 
@@ -4861,15 +4809,9 @@ out3:
 	remove_proc_entry("fs/ext4", NULL);
 	kset_unregister(ext4_kset);
 out4:
-<<<<<<< HEAD
 	ext4_exit_system_zone();
 out5:
 	ext4_exit_pageio();
-=======
-	exit_ext4_system_zone();
-out5:
-	exit_ext4_pageio();
->>>>>>> FETCH_HEAD
 	return err;
 }
 
@@ -4884,13 +4826,8 @@ static void __exit ext4_exit_fs(void)
 	ext4_exit_mballoc();
 	remove_proc_entry("fs/ext4", NULL);
 	kset_unregister(ext4_kset);
-<<<<<<< HEAD
 	ext4_exit_system_zone();
 	ext4_exit_pageio();
-=======
-	exit_ext4_system_zone();
-	exit_ext4_pageio();
->>>>>>> FETCH_HEAD
 }
 
 MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others");
diff -puN include/trace/events/ext4.h~linux-next-git-rejects include/trace/events/ext4.h
--- a/include/trace/events/ext4.h~linux-next-git-rejects
+++ a/include/trace/events/ext4.h
@@ -442,12 +442,7 @@ TRACE_EVENT(ext4_mb_release_inode_pa,
 	),
 
 	TP_fast_assign(
-<<<<<<< HEAD
-		__entry->dev_major	= MAJOR(sb->s_dev);
-		__entry->dev_minor	= MINOR(sb->s_dev);
-=======
 		__entry->dev		= sb->s_dev;
->>>>>>> FETCH_HEAD
 		__entry->ino		= inode->i_ino;
 		__entry->block		= block;
 		__entry->count		= count;
@@ -465,24 +460,14 @@ TRACE_EVENT(ext4_mb_release_group_pa,
 	TP_ARGS(sb, pa),
 
 	TP_STRUCT__entry(
-<<<<<<< HEAD
-		__field(	int,   dev_major                )
-		__field(	int,   dev_minor                )
-=======
 		__field(	dev_t,	dev			)
->>>>>>> FETCH_HEAD
 		__field(	__u64,	pa_pstart		)
 		__field(	__u32,	pa_len			)
 
 	),
 
 	TP_fast_assign(
-<<<<<<< HEAD
-		__entry->dev_major	= MAJOR(sb->s_dev);
-		__entry->dev_minor	= MINOR(sb->s_dev);
-=======
 		__entry->dev		= sb->s_dev;
->>>>>>> FETCH_HEAD
 		__entry->pa_pstart	= pa->pa_pstart;
 		__entry->pa_len		= pa->pa_len;
 	),
@@ -870,26 +855,15 @@ DECLARE_EVENT_CLASS(ext4__mballoc,
 	),
 
 	TP_fast_assign(
-<<<<<<< HEAD
-		__entry->dev_major	= MAJOR(sb->s_dev);
-		__entry->dev_minor	= MINOR(sb->s_dev);
-=======
 		__entry->dev		= sb->s_dev;
->>>>>>> FETCH_HEAD
 		__entry->ino		= inode ? inode->i_ino : 0;
 		__entry->result_start	= start;
 		__entry->result_group	= group;
 		__entry->result_len	= len;
 	),
 
-<<<<<<< HEAD
-	TP_printk("dev %d,%d inode %lu extent %u/%d/%u ",
-		  __entry->dev_major, __entry->dev_minor,
-		  (unsigned long) __entry->ino,
-=======
 	TP_printk("dev %s inode %lu extent %u/%d/%u ",
 		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino,
->>>>>>> FETCH_HEAD
 		  __entry->result_group, __entry->result_start,
 		  __entry->result_len)
 );
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hpet-factor-timer-allocate-from-open.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-add-led-trigger-for-input-subsystem-led-events.patch
backlight-add-low-threshold-to-pwm-backlight.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
percpu_counter-rename-__percpu_counter_add-to-percpu_counter_add_batch.patch
percpu_counters-inline-the-percpu_counter_add_batch-fastpath.patch
percpu_counters-inline-the-percpu_counter_add_batch-fastpath-fix.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

