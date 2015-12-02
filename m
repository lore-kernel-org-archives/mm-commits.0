From: akpm@linux-foundation.org
Subject: [to-be-updated] zram-zcomp-use-gfp_noio-to-allocate-streams.patch removed from -mm tree
Date: Tue, 01 Dec 2015 16:37:56 -0800
Message-ID: <565e3d64.p6dU3G3ydFmyBtic%akpm__24497.4234876738$1449016694$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbbLBAh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2015 19:37:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, kyeongdon.kim@lge.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram/zcomp: use GFP_NOIO to allocate streams
has been removed from the -mm tree.  Its filename was
     zram-zcomp-use-gfp_noio-to-allocate-streams.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: zram/zcomp: use GFP_NOIO to allocate streams

We can end up allocating a new compression stream with GFP_KERNEL from
within the IO path, which may result is nested (recursive) IO operations. 
That can introduce problems if the IO path in question is a reclaimer,
holding some locks that will deadlock nested IOs.

Allocate streams and working memory using GFP_NOIO flag, forbidding
recursive IO and FS operations.

An example:

[  747.233722] inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
[  747.233724] git/20158 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  747.233725]  (jbd2_handle){+.+.?.}, at: [<ffffffff811e31db>] start_this_handle+0x4ca/0x555
[  747.233733] {IN-RECLAIM_FS-W} state was registered at:
[  747.233735]   [<ffffffff8107b8e9>] __lock_acquire+0x8da/0x117b
[  747.233738]   [<ffffffff8107c950>] lock_acquire+0x10c/0x1a7
[  747.233740]   [<ffffffff811e323e>] start_this_handle+0x52d/0x555
[  747.233742]   [<ffffffff811e331a>] jbd2__journal_start+0xb4/0x237
[  747.233744]   [<ffffffff811cc6c7>] __ext4_journal_start_sb+0x108/0x17e
[  747.233748]   [<ffffffff811a90bf>] ext4_dirty_inode+0x32/0x61
[  747.233750]   [<ffffffff8115f37e>] __mark_inode_dirty+0x16b/0x60c
[  747.233754]   [<ffffffff81150ad6>] iput+0x11e/0x274
[  747.233757]   [<ffffffff8114bfbd>] __dentry_kill+0x148/0x1b8
[  747.233759]   [<ffffffff8114c9d9>] shrink_dentry_list+0x274/0x44a
[  747.233761]   [<ffffffff8114d38a>] prune_dcache_sb+0x4a/0x55
[  747.233763]   [<ffffffff8113b1ad>] super_cache_scan+0xfc/0x176
[  747.233767]   [<ffffffff810fa089>] shrink_slab.part.14.constprop.25+0x2a2/0x4d3
[  747.233770]   [<ffffffff810fcccb>] shrink_zone+0x74/0x140
[  747.233772]   [<ffffffff810fd924>] kswapd+0x6b7/0x930
[  747.233774]   [<ffffffff81058887>] kthread+0x107/0x10f
[  747.233778]   [<ffffffff814fadff>] ret_from_fork+0x3f/0x70
[  747.233783] irq event stamp: 138297
[  747.233784] hardirqs last  enabled at (138297): [<ffffffff8107aff3>] debug_check_no_locks_freed+0x113/0x12f
[  747.233786] hardirqs last disabled at (138296): [<ffffffff8107af13>] debug_check_no_locks_freed+0x33/0x12f
[  747.233788] softirqs last  enabled at (137818): [<ffffffff81040f89>] __do_softirq+0x2d3/0x3e9
[  747.233792] softirqs last disabled at (137813): [<ffffffff81041292>] irq_exit+0x41/0x95
[  747.233794]
               other info that might help us debug this:
[  747.233796]  Possible unsafe locking scenario:
[  747.233797]        CPU0
[  747.233798]        ----
[  747.233799]   lock(jbd2_handle);
[  747.233801]   <Interrupt>
[  747.233801]     lock(jbd2_handle);
[  747.233803]
                *** DEADLOCK ***
[  747.233805] 5 locks held by git/20158:
[  747.233806]  #0:  (sb_writers#7){.+.+.+}, at: [<ffffffff81155411>] mnt_want_write+0x24/0x4b
[  747.233811]  #1:  (&type->i_mutex_dir_key#2/1){+.+.+.}, at: [<ffffffff81145087>] lock_rename+0xd9/0xe3
[  747.233817]  #2:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff8114f8e2>] lock_two_nondirectories+0x3f/0x6b
[  747.233822]  #3:  (&sb->s_type->i_mutex_key#11/4){+.+.+.}, at: [<ffffffff8114f909>] lock_two_nondirectories+0x66/0x6b
[  747.233827]  #4:  (jbd2_handle){+.+.?.}, at: [<ffffffff811e31db>] start_this_handle+0x4ca/0x555
[  747.233831]
               stack backtrace:
[  747.233834] CPU: 2 PID: 20158 Comm: git Not tainted 4.1.0-rc7-next-20150615-dbg-00016-g8bdf555-dirty #211
[  747.233837]  ffff8800a56cea40 ffff88010d0a75f8 ffffffff814f446d ffffffff81077036
[  747.233840]  ffffffff823a84b0 ffff88010d0a7638 ffffffff814f3849 0000000000000001
[  747.233843]  000000000000000a ffff8800a56cf6f8 ffff8800a56cea40 ffffffff810795dd
[  747.233846] Call Trace:
[  747.233849]  [<ffffffff814f446d>] dump_stack+0x4c/0x6e
[  747.233852]  [<ffffffff81077036>] ? up+0x39/0x3e
[  747.233854]  [<ffffffff814f3849>] print_usage_bug.part.23+0x25b/0x26a
[  747.233857]  [<ffffffff810795dd>] ? print_shortest_lock_dependencies+0x182/0x182
[  747.233859]  [<ffffffff8107a9c9>] mark_lock+0x384/0x56d
[  747.233862]  [<ffffffff8107ac11>] mark_held_locks+0x5f/0x76
[  747.233865]  [<ffffffffa023d2f3>] ? zcomp_strm_alloc+0x25/0x73 [zram]
[  747.233867]  [<ffffffff8107d13b>] lockdep_trace_alloc+0xb2/0xb5
[  747.233870]  [<ffffffff8112bac7>] kmem_cache_alloc_trace+0x32/0x1e2
[  747.233873]  [<ffffffffa023d2f3>] zcomp_strm_alloc+0x25/0x73 [zram]
[  747.233876]  [<ffffffffa023d428>] zcomp_strm_multi_find+0xe7/0x173 [zram]
[  747.233879]  [<ffffffffa023d58b>] zcomp_strm_find+0xc/0xe [zram]
[  747.233881]  [<ffffffffa023f292>] zram_bvec_rw+0x2ca/0x7e0 [zram]
[  747.233885]  [<ffffffffa023fa8c>] zram_make_request+0x1fa/0x301 [zram]
[  747.233889]  [<ffffffff812142f8>] generic_make_request+0x9c/0xdb
[  747.233891]  [<ffffffff8121442e>] submit_bio+0xf7/0x120
[  747.233895]  [<ffffffff810f1c0c>] ? __test_set_page_writeback+0x1a0/0x1b8
[  747.233897]  [<ffffffff811a9d00>] ext4_io_submit+0x2e/0x43
[  747.233899]  [<ffffffff811a9efa>] ext4_bio_write_page+0x1b7/0x300
[  747.233902]  [<ffffffff811a2106>] mpage_submit_page+0x60/0x77
[  747.233905]  [<ffffffff811a25b0>] mpage_map_and_submit_buffers+0x10f/0x21d
[  747.233907]  [<ffffffff811a6814>] ext4_writepages+0xc8c/0xe1b
[  747.233910]  [<ffffffff810f3f77>] do_writepages+0x23/0x2c
[  747.233913]  [<ffffffff810ea5d1>] __filemap_fdatawrite_range+0x84/0x8b
[  747.233915]  [<ffffffff810ea657>] filemap_flush+0x1c/0x1e
[  747.233917]  [<ffffffff811a3851>] ext4_alloc_da_blocks+0xb8/0x117
[  747.233919]  [<ffffffff811af52a>] ext4_rename+0x132/0x6dc
[  747.233921]  [<ffffffff8107ac11>] ? mark_held_locks+0x5f/0x76
[  747.233924]  [<ffffffff811afafd>] ext4_rename2+0x29/0x2b
[  747.233926]  [<ffffffff811427ea>] vfs_rename+0x540/0x636
[  747.233928]  [<ffffffff81146a01>] SyS_renameat2+0x359/0x44d
[  747.233931]  [<ffffffff81146b26>] SyS_rename+0x1e/0x20
[  747.233933]  [<ffffffff814faa17>] entry_SYSCALL_64_fastpath+0x12/0x6f

[minchan@kernel.org: add stable mark]
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Kyeongdon Kim <kyeongdon.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c     |    4 ++--
 drivers/block/zram/zcomp_lz4.c |    2 +-
 drivers/block/zram/zcomp_lzo.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-zcomp-use-gfp_noio-to-allocate-streams drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-zcomp-use-gfp_noio-to-allocate-streams
+++ a/drivers/block/zram/zcomp.c
@@ -76,7 +76,7 @@ static void zcomp_strm_free(struct zcomp
  */
 static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
 {
-	struct zcomp_strm *zstrm = kmalloc(sizeof(*zstrm), GFP_KERNEL);
+	struct zcomp_strm *zstrm = kmalloc(sizeof(*zstrm), GFP_NOIO);
 	if (!zstrm)
 		return NULL;
 
@@ -85,7 +85,7 @@ static struct zcomp_strm *zcomp_strm_all
 	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
 	 * case when compressed size is larger than the original one
 	 */
-	zstrm->buffer = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
+	zstrm->buffer = (void *)__get_free_pages(GFP_NOIO | __GFP_ZERO, 1);
 	if (!zstrm->private || !zstrm->buffer) {
 		zcomp_strm_free(comp, zstrm);
 		zstrm = NULL;
diff -puN drivers/block/zram/zcomp_lz4.c~zram-zcomp-use-gfp_noio-to-allocate-streams drivers/block/zram/zcomp_lz4.c
--- a/drivers/block/zram/zcomp_lz4.c~zram-zcomp-use-gfp_noio-to-allocate-streams
+++ a/drivers/block/zram/zcomp_lz4.c
@@ -15,7 +15,7 @@
 
 static void *zcomp_lz4_create(void)
 {
-	return kzalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
+	return kzalloc(LZ4_MEM_COMPRESS, GFP_NOIO);
 }
 
 static void zcomp_lz4_destroy(void *private)
diff -puN drivers/block/zram/zcomp_lzo.c~zram-zcomp-use-gfp_noio-to-allocate-streams drivers/block/zram/zcomp_lzo.c
--- a/drivers/block/zram/zcomp_lzo.c~zram-zcomp-use-gfp_noio-to-allocate-streams
+++ a/drivers/block/zram/zcomp_lzo.c
@@ -15,7 +15,7 @@
 
 static void *lzo_create(void)
 {
-	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+	return kzalloc(LZO1X_MEM_COMPRESS, GFP_NOIO);
 }
 
 static void lzo_destroy(void *private)
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

zram-zcomp-do-not-zero-out-zcomp-private-pages.patch

