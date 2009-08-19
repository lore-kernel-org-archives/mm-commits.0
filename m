From: akpm@linux-foundation.org
Subject: + fs-turn-iprune_mutex-into-rwsem.patch added to -mm tree
Date: Tue, 18 Aug 2009 17:18:10 -0700
Message-ID: <200908190018.n7J0IAHP021899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455AbZHSAS6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Aug 2009 20:18:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, hch@lst.de, jack@ucw.cz, viro@zeniv.linux.org.uk


The patch titled
     fs: turn iprune_mutex into rwsem
has been added to the -mm tree.  Its filename is
     fs-turn-iprune_mutex-into-rwsem.patch

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
Subject: fs: turn iprune_mutex into rwsem
From: Nick Piggin <npiggin@suse.de>

We have had a report of bad memory allocation latency during DVD-RAM (UDF)
writing.  This is causing the user's desktop session to become unusable.

Jan tracked the cause of this down to UDF inode reclaim blocking:

gnome-screens D ffff810006d1d598     0 20686      1
 ffff810006d1d508 0000000000000082 ffff810037db6718 0000000000000800
 ffff810006d1d488 ffffffff807e4280 ffffffff807e4280 ffff810006d1a580
 ffff8100bccbc140 ffff810006d1a8c0 0000000006d1d4e8 ffff810006d1a8c0
Call Trace:
 [<ffffffff804477f3>] io_schedule+0x63/0xa5
 [<ffffffff802c2587>] sync_buffer+0x3b/0x3f
 [<ffffffff80447d2a>] __wait_on_bit+0x47/0x79
 [<ffffffff80447dc6>] out_of_line_wait_on_bit+0x6a/0x77
 [<ffffffff802c24f6>] __wait_on_buffer+0x1f/0x21
 [<ffffffff802c442a>] __bread+0x70/0x86
 [<ffffffff88de9ec7>] :udf:udf_tread+0x38/0x3a
 [<ffffffff88de0fcf>] :udf:udf_update_inode+0x4d/0x68c
 [<ffffffff88de26e1>] :udf:udf_write_inode+0x1d/0x2b
 [<ffffffff802bcf85>] __writeback_single_inode+0x1c0/0x394
 [<ffffffff802bd205>] write_inode_now+0x7d/0xc4
 [<ffffffff88de2e76>] :udf:udf_clear_inode+0x3d/0x53
 [<ffffffff802b39ae>] clear_inode+0xc2/0x11b
 [<ffffffff802b3ab1>] dispose_list+0x5b/0x102
 [<ffffffff802b3d35>] shrink_icache_memory+0x1dd/0x213
 [<ffffffff8027ede3>] shrink_slab+0xe3/0x158
 [<ffffffff8027fbab>] try_to_free_pages+0x177/0x232
 [<ffffffff8027a578>] __alloc_pages+0x1fa/0x392
 [<ffffffff802951fa>] alloc_page_vma+0x176/0x189
 [<ffffffff802822d8>] __do_fault+0x10c/0x417
 [<ffffffff80284232>] handle_mm_fault+0x466/0x940
 [<ffffffff8044b922>] do_page_fault+0x676/0xabf

This blocks with iprune_mutex held, which then blocks other reclaimers:

X             D ffff81009d47c400     0 17285  14831
 ffff8100844f3728 0000000000000086 0000000000000000 ffff81000000e288
 ffff81000000da00 ffffffff807e4280 ffffffff807e4280 ffff81009d47c400
 ffffffff805ff890 ffff81009d47c740 00000000844f3808 ffff81009d47c740
Call Trace:
 [<ffffffff80447f8c>] __mutex_lock_slowpath+0x72/0xa9
 [<ffffffff80447e1a>] mutex_lock+0x1e/0x22
 [<ffffffff802b3ba1>] shrink_icache_memory+0x49/0x213
 [<ffffffff8027ede3>] shrink_slab+0xe3/0x158
 [<ffffffff8027fbab>] try_to_free_pages+0x177/0x232
 [<ffffffff8027a578>] __alloc_pages+0x1fa/0x392
 [<ffffffff8029507f>] alloc_pages_current+0xd1/0xd6
 [<ffffffff80279ac0>] __get_free_pages+0xe/0x4d
 [<ffffffff802ae1b7>] __pollwait+0x5e/0xdf
 [<ffffffff8860f2b4>] :nvidia:nv_kern_poll+0x2e/0x73
 [<ffffffff802ad949>] do_select+0x308/0x506
 [<ffffffff802adced>] core_sys_select+0x1a6/0x254
 [<ffffffff802ae0b7>] sys_select+0xb5/0x157

Now I think the main problem is having the filesystem block (and do IO) in
inode reclaim.  The problem is that this doesn't get accounted well and
penalizes a random allocator with a big latency spike caused by work
generated from elsewhere.

I think the best idea would be to avoid this.  By design if possible, or
by deferring the hard work to an asynchronous context.  If the latter,
then the fs would probably want to throttle creation of new work with
queue size of the deferred work, but let's not get into those details.

Anyway, the other obvious thing we looked at is the iprune_mutex which is
causing the cascading blocking.  We could turn this into an rwsem to
improve concurrency.  It is unreasonable to totally ban all potentially
slow or blocking operations in inode reclaim, so I think this is a cheap
way to get a small improvement.

This doesn't solve the whole problem of course.  The process doing inode
reclaim will still take the latency hit, and concurrent processes may end
up contending on filesystem locks.  So fs developers should keep these
problems in mind.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jan Kara <jack@ucw.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN fs/inode.c~fs-turn-iprune_mutex-into-rwsem fs/inode.c
--- a/fs/inode.c~fs-turn-iprune_mutex-into-rwsem
+++ a/fs/inode.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/backing-dev.h>
 #include <linux/wait.h>
+#include <linux/rwsem.h>
 #include <linux/hash.h>
 #include <linux/swap.h>
 #include <linux/security.h>
@@ -87,14 +88,18 @@ static struct hlist_head *inode_hashtabl
 DEFINE_SPINLOCK(inode_lock);
 
 /*
- * iprune_mutex provides exclusion between the kswapd or try_to_free_pages
+ * iprune_sem provides exclusion between the kswapd or try_to_free_pages
  * icache shrinking path, and the umount path.  Without this exclusion,
  * by the time prune_icache calls iput for the inode whose pages it has
  * been invalidating, or by the time it calls clear_inode & destroy_inode
  * from its final dispose_list, the struct super_block they refer to
  * (for inode->i_sb->s_op) may already have been freed and reused.
+ *
+ * We make this an rwsem because the fastpath is icache shrinking. In
+ * some cases a filesystem may be doing a significant amount of work in
+ * its inode reclaim code, so this should improve parallelism.
  */
-static DEFINE_MUTEX(iprune_mutex);
+static DECLARE_RWSEM(iprune_sem);
 
 /*
  * Statistics gathering..
@@ -383,7 +388,7 @@ static int invalidate_list(struct list_h
 		/*
 		 * We can reschedule here without worrying about the list's
 		 * consistency because the per-sb list of inodes must not
-		 * change during umount anymore, and because iprune_mutex keeps
+		 * change during umount anymore, and because iprune_sem keeps
 		 * shrink_icache_memory() away.
 		 */
 		cond_resched_lock(&inode_lock);
@@ -422,7 +427,7 @@ int invalidate_inodes(struct super_block
 	int busy;
 	LIST_HEAD(throw_away);
 
-	mutex_lock(&iprune_mutex);
+	down_write(&iprune_sem);
 	spin_lock(&inode_lock);
 	inotify_unmount_inodes(&sb->s_inodes);
 	fsnotify_unmount_inodes(&sb->s_inodes);
@@ -430,7 +435,7 @@ int invalidate_inodes(struct super_block
 	spin_unlock(&inode_lock);
 
 	dispose_list(&throw_away);
-	mutex_unlock(&iprune_mutex);
+	up_write(&iprune_sem);
 
 	return busy;
 }
@@ -469,7 +474,7 @@ static void prune_icache(int nr_to_scan)
 	int nr_scanned;
 	unsigned long reap = 0;
 
-	mutex_lock(&iprune_mutex);
+	down_read(&iprune_sem);
 	spin_lock(&inode_lock);
 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
 		struct inode *inode;
@@ -511,7 +516,7 @@ static void prune_icache(int nr_to_scan)
 	spin_unlock(&inode_lock);
 
 	dispose_list(&freeable);
-	mutex_unlock(&iprune_mutex);
+	up_read(&iprune_sem);
 }
 
 /*
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-revert-oom-move-oom_adj-value.patch
linux-next.patch
ksm-no-debug-in-page_dup_rmap.patch
fs-turn-iprune_mutex-into-rwsem.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

