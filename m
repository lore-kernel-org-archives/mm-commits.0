Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA504C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbiATV0U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347699AbiATV0S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:26:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A395C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:26:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37805B81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96980C340E0;
        Thu, 20 Jan 2022 21:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713976;
        bh=cDq6hwwdFTjeD9yH54hJCRrWRlMkbUn2lJI1jrIXtQ4=;
        h=Date:From:To:Subject:From;
        b=oR2ON+Rg1zkhudqUjKqoen280hWQaca7uy3qfhLg/t9nVmcvObcurpBegLhme4Dfs
         niZ+YPkGR0zyCXR224Ba0W4v8dfLmyMshK+wwo7qn8akcEogs+/i0cc4FpgmT2BpQc
         tgLFgNKWGDldvlyFohpQqosBREbeVbxG+Uzc4b2U=
Date:   Thu, 20 Jan 2022 13:26:15 -0800
From:   akpm@linux-foundation.org
To:     chao@kernel.org, chuck.lever@oracle.com, david@fromorbit.com,
        djwong@kernel.org, jaegeuk@kernel.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de, tytso@mit.edu
Subject:  [merged] mm-introduce-memalloc_retry_wait.patch removed
 from -mm tree
Message-ID: <20220120212615.7_r3zKQKW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce memalloc_retry_wait()
has been removed from the -mm tree.  Its filename was
     mm-introduce-memalloc_retry_wait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "NeilBrown" <neilb@suse.de>
Subject: mm: introduce memalloc_retry_wait()

Various places in the kernel - largely in filesystems - respond to a
memory allocation failure by looping around and re-trying.  Some of these
cannot conveniently use __GFP_NOFAIL, for reasons such as:

 - a GFP_ATOMIC allocation, which __GFP_NOFAIL doesn't work on
 - a need to check for the process being signalled between failures
 - the possibility that other recovery actions could be performed
 - the allocation is quite deep in support code, and passing down an
   extra flag to say if __GFP_NOFAIL is wanted would be clumsy.

Many of these currently use congestion_wait() which (in almost all cases)
simply waits the given timeout - congestion isn't tracked for most
devices.

It isn't clear what the best delay is for loops, but it is clear that the
various filesystems shouldn't be responsible for choosing a timeout.

This patch introduces memalloc_retry_wait() with takes on that
responsibility.  Code that wants to retry a memory allocation can call
this function passing the GFP flags that were used.  It will wait however
is appropriate.

For now, it only considers __GFP_NORETRY and whatever
gfpflags_allow_blocking() tests.  If blocking is allowed without
__GFP_NORETRY, then alloc_page either made some reclaim progress, or
waited for a while, before failing.  So there is no need for much further
waiting.  memalloc_retry_wait() will wait until the current jiffie ends. 
If this condition is not met, then alloc_page() won't have waited much if
at all.  In that case memalloc_retry_wait() waits about 200ms.  This is
the delay that most current loops uses.

linux/sched/mm.h needs to be included in some files now,
but linux/backing-dev.h does not.

Link: https://lkml.kernel.org/r/163754371968.13692.1277530886009912421@noble.neil.brown.name
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/extents.c        |    8 +++-----
 fs/ext4/inline.c         |    5 ++---
 fs/ext4/page-io.c        |    9 +++++----
 fs/f2fs/data.c           |    4 ++--
 fs/f2fs/gc.c             |    5 ++---
 fs/f2fs/inode.c          |    4 ++--
 fs/f2fs/node.c           |    4 ++--
 fs/f2fs/recovery.c       |    6 +++---
 fs/f2fs/segment.c        |    9 +++------
 fs/f2fs/super.c          |    5 ++---
 fs/xfs/kmem.c            |    3 +--
 fs/xfs/xfs_buf.c         |    2 +-
 include/linux/sched/mm.h |   26 ++++++++++++++++++++++++++
 net/sunrpc/svc_xprt.c    |    3 ++-
 14 files changed, 56 insertions(+), 37 deletions(-)

--- a/fs/ext4/extents.c~mm-introduce-memalloc_retry_wait
+++ a/fs/ext4/extents.c
@@ -27,8 +27,8 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/fiemap.h>
-#include <linux/backing-dev.h>
 #include <linux/iomap.h>
+#include <linux/sched/mm.h>
 #include "ext4_jbd2.h"
 #include "ext4_extents.h"
 #include "xattr.h"
@@ -4407,8 +4407,7 @@ retry:
 	err = ext4_es_remove_extent(inode, last_block,
 				    EXT_MAX_BLOCKS - last_block);
 	if (err == -ENOMEM) {
-		cond_resched();
-		congestion_wait(BLK_RW_ASYNC, HZ/50);
+		memalloc_retry_wait(GFP_ATOMIC);
 		goto retry;
 	}
 	if (err)
@@ -4416,8 +4415,7 @@ retry:
 retry_remove_space:
 	err = ext4_ext_remove_space(inode, last_block, EXT_MAX_BLOCKS - 1);
 	if (err == -ENOMEM) {
-		cond_resched();
-		congestion_wait(BLK_RW_ASYNC, HZ/50);
+		memalloc_retry_wait(GFP_ATOMIC);
 		goto retry_remove_space;
 	}
 	return err;
--- a/fs/ext4/inline.c~mm-introduce-memalloc_retry_wait
+++ a/fs/ext4/inline.c
@@ -7,7 +7,7 @@
 #include <linux/iomap.h>
 #include <linux/fiemap.h>
 #include <linux/iversion.h>
-#include <linux/backing-dev.h>
+#include <linux/sched/mm.h>
 
 #include "ext4_jbd2.h"
 #include "ext4.h"
@@ -1929,8 +1929,7 @@ int ext4_inline_data_truncate(struct ino
 retry:
 			err = ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
 			if (err == -ENOMEM) {
-				cond_resched();
-				congestion_wait(BLK_RW_ASYNC, HZ/50);
+				memalloc_retry_wait(GFP_ATOMIC);
 				goto retry;
 			}
 			if (err)
--- a/fs/ext4/page-io.c~mm-introduce-memalloc_retry_wait
+++ a/fs/ext4/page-io.c
@@ -24,7 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/backing-dev.h>
+#include <linux/sched/mm.h>
 
 #include "ext4_jbd2.h"
 #include "xattr.h"
@@ -523,12 +523,13 @@ int ext4_bio_write_page(struct ext4_io_s
 			ret = PTR_ERR(bounce_page);
 			if (ret == -ENOMEM &&
 			    (io->io_bio || wbc->sync_mode == WB_SYNC_ALL)) {
-				gfp_flags = GFP_NOFS;
+				gfp_t new_gfp_flags = GFP_NOFS;
 				if (io->io_bio)
 					ext4_io_submit(io);
 				else
-					gfp_flags |= __GFP_NOFAIL;
-				congestion_wait(BLK_RW_ASYNC, HZ/50);
+					new_gfp_flags |= __GFP_NOFAIL;
+				memalloc_retry_wait(gfp_flags);
+				gfp_flags = new_gfp_flags;
 				goto retry_encrypt;
 			}
 
--- a/fs/f2fs/data.c~mm-introduce-memalloc_retry_wait
+++ a/fs/f2fs/data.c
@@ -8,9 +8,9 @@
 #include <linux/fs.h>
 #include <linux/f2fs_fs.h>
 #include <linux/buffer_head.h>
+#include <linux/sched/mm.h>
 #include <linux/mpage.h>
 #include <linux/writeback.h>
-#include <linux/backing-dev.h>
 #include <linux/pagevec.h>
 #include <linux/blkdev.h>
 #include <linux/bio.h>
@@ -2542,7 +2542,7 @@ retry_encrypt:
 		/* flush pending IOs and wait for a while in the ENOMEM case */
 		if (PTR_ERR(fio->encrypted_page) == -ENOMEM) {
 			f2fs_flush_merged_writes(fio->sbi);
-			congestion_wait(BLK_RW_ASYNC, DEFAULT_IO_TIMEOUT);
+			memalloc_retry_wait(GFP_NOFS);
 			gfp_flags |= __GFP_NOFAIL;
 			goto retry_encrypt;
 		}
--- a/fs/f2fs/gc.c~mm-introduce-memalloc_retry_wait
+++ a/fs/f2fs/gc.c
@@ -7,7 +7,6 @@
  */
 #include <linux/fs.h>
 #include <linux/module.h>
-#include <linux/backing-dev.h>
 #include <linux/init.h>
 #include <linux/f2fs_fs.h>
 #include <linux/kthread.h>
@@ -15,6 +14,7 @@
 #include <linux/freezer.h>
 #include <linux/sched/signal.h>
 #include <linux/random.h>
+#include <linux/sched/mm.h>
 
 #include "f2fs.h"
 #include "node.h"
@@ -1375,8 +1375,7 @@ retry:
 		if (err) {
 			clear_page_private_gcing(page);
 			if (err == -ENOMEM) {
-				congestion_wait(BLK_RW_ASYNC,
-						DEFAULT_IO_TIMEOUT);
+				memalloc_retry_wait(GFP_NOFS);
 				goto retry;
 			}
 			if (is_dirty)
--- a/fs/f2fs/inode.c~mm-introduce-memalloc_retry_wait
+++ a/fs/f2fs/inode.c
@@ -8,8 +8,8 @@
 #include <linux/fs.h>
 #include <linux/f2fs_fs.h>
 #include <linux/buffer_head.h>
-#include <linux/backing-dev.h>
 #include <linux/writeback.h>
+#include <linux/sched/mm.h>
 
 #include "f2fs.h"
 #include "node.h"
@@ -562,7 +562,7 @@ retry:
 	inode = f2fs_iget(sb, ino);
 	if (IS_ERR(inode)) {
 		if (PTR_ERR(inode) == -ENOMEM) {
-			congestion_wait(BLK_RW_ASYNC, DEFAULT_IO_TIMEOUT);
+			memalloc_retry_wait(GFP_NOFS);
 			goto retry;
 		}
 	}
--- a/fs/f2fs/node.c~mm-introduce-memalloc_retry_wait
+++ a/fs/f2fs/node.c
@@ -8,7 +8,7 @@
 #include <linux/fs.h>
 #include <linux/f2fs_fs.h>
 #include <linux/mpage.h>
-#include <linux/backing-dev.h>
+#include <linux/sched/mm.h>
 #include <linux/blkdev.h>
 #include <linux/pagevec.h>
 #include <linux/swap.h>
@@ -2750,7 +2750,7 @@ int f2fs_recover_inode_page(struct f2fs_
 retry:
 	ipage = f2fs_grab_cache_page(NODE_MAPPING(sbi), ino, false);
 	if (!ipage) {
-		congestion_wait(BLK_RW_ASYNC, DEFAULT_IO_TIMEOUT);
+		memalloc_retry_wait(GFP_NOFS);
 		goto retry;
 	}
 
--- a/fs/f2fs/recovery.c~mm-introduce-memalloc_retry_wait
+++ a/fs/f2fs/recovery.c
@@ -8,6 +8,7 @@
 #include <asm/unaligned.h>
 #include <linux/fs.h>
 #include <linux/f2fs_fs.h>
+#include <linux/sched/mm.h>
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
@@ -587,7 +588,7 @@ retry_dn:
 	err = f2fs_get_dnode_of_data(&dn, start, ALLOC_NODE);
 	if (err) {
 		if (err == -ENOMEM) {
-			congestion_wait(BLK_RW_ASYNC, DEFAULT_IO_TIMEOUT);
+			memalloc_retry_wait(GFP_NOFS);
 			goto retry_dn;
 		}
 		goto out;
@@ -670,8 +671,7 @@ retry_prev:
 			err = check_index_in_prev_nodes(sbi, dest, &dn);
 			if (err) {
 				if (err == -ENOMEM) {
-					congestion_wait(BLK_RW_ASYNC,
-							DEFAULT_IO_TIMEOUT);
+					memalloc_retry_wait(GFP_NOFS);
 					goto retry_prev;
 				}
 				goto err;
--- a/fs/f2fs/segment.c~mm-introduce-memalloc_retry_wait
+++ a/fs/f2fs/segment.c
@@ -9,6 +9,7 @@
 #include <linux/f2fs_fs.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/sched/mm.h>
 #include <linux/prefetch.h>
 #include <linux/kthread.h>
 #include <linux/swap.h>
@@ -245,9 +246,7 @@ retry:
 								LOOKUP_NODE);
 			if (err) {
 				if (err == -ENOMEM) {
-					congestion_wait(BLK_RW_ASYNC,
-							DEFAULT_IO_TIMEOUT);
-					cond_resched();
+					memalloc_retry_wait(GFP_NOFS);
 					goto retry;
 				}
 				err = -EAGAIN;
@@ -424,9 +423,7 @@ retry:
 			err = f2fs_do_write_data_page(&fio);
 			if (err) {
 				if (err == -ENOMEM) {
-					congestion_wait(BLK_RW_ASYNC,
-							DEFAULT_IO_TIMEOUT);
-					cond_resched();
+					memalloc_retry_wait(GFP_NOFS);
 					goto retry;
 				}
 				unlock_page(page);
--- a/fs/f2fs/super.c~mm-introduce-memalloc_retry_wait
+++ a/fs/f2fs/super.c
@@ -8,9 +8,9 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <linux/sched/mm.h>
 #include <linux/statfs.h>
 #include <linux/buffer_head.h>
-#include <linux/backing-dev.h>
 #include <linux/kthread.h>
 #include <linux/parser.h>
 #include <linux/mount.h>
@@ -2415,8 +2415,7 @@ repeat:
 		page = read_cache_page_gfp(mapping, blkidx, GFP_NOFS);
 		if (IS_ERR(page)) {
 			if (PTR_ERR(page) == -ENOMEM) {
-				congestion_wait(BLK_RW_ASYNC,
-						DEFAULT_IO_TIMEOUT);
+				memalloc_retry_wait(GFP_NOFS);
 				goto repeat;
 			}
 			set_sbi_flag(F2FS_SB(sb), SBI_QUOTA_NEED_REPAIR);
--- a/fs/xfs/kmem.c~mm-introduce-memalloc_retry_wait
+++ a/fs/xfs/kmem.c
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
-#include <linux/backing-dev.h>
 #include "xfs_message.h"
 #include "xfs_trace.h"
 
@@ -26,6 +25,6 @@ kmem_alloc(size_t size, xfs_km_flags_t f
 	"%s(%u) possible memory allocation deadlock size %u in %s (mode:0x%x)",
 				current->comm, current->pid,
 				(unsigned int)size, __func__, lflags);
-		congestion_wait(BLK_RW_ASYNC, HZ/50);
+		memalloc_retry_wait(lflags);
 	} while (1);
 }
--- a/fs/xfs/xfs_buf.c~mm-introduce-memalloc_retry_wait
+++ a/fs/xfs/xfs_buf.c
@@ -394,7 +394,7 @@ xfs_buf_alloc_pages(
 		}
 
 		XFS_STATS_INC(bp->b_mount, xb_page_retries);
-		congestion_wait(BLK_RW_ASYNC, HZ / 50);
+		memalloc_retry_wait(gfp_mask);
 	}
 	return 0;
 }
--- a/include/linux/sched/mm.h~mm-introduce-memalloc_retry_wait
+++ a/include/linux/sched/mm.h
@@ -214,6 +214,32 @@ static inline void fs_reclaim_acquire(gf
 static inline void fs_reclaim_release(gfp_t gfp_mask) { }
 #endif
 
+/* Any memory-allocation retry loop should use
+ * memalloc_retry_wait(), and pass the flags for the most
+ * constrained allocation attempt that might have failed.
+ * This provides useful documentation of where loops are,
+ * and a central place to fine tune the waiting as the MM
+ * implementation changes.
+ */
+static inline void memalloc_retry_wait(gfp_t gfp_flags)
+{
+	/* We use io_schedule_timeout because waiting for memory
+	 * typically included waiting for dirty pages to be
+	 * written out, which requires IO.
+	 */
+	__set_current_state(TASK_UNINTERRUPTIBLE);
+	gfp_flags = current_gfp_context(gfp_flags);
+	if (gfpflags_allow_blocking(gfp_flags) &&
+	    !(gfp_flags & __GFP_NORETRY))
+		/* Probably waited already, no need for much more */
+		io_schedule_timeout(1);
+	else
+		/* Probably didn't wait, and has now released a lock,
+		 * so now is a good time to wait
+		 */
+		io_schedule_timeout(HZ/50);
+}
+
 /**
  * might_alloc - Mark possible allocation sites
  * @gfp_mask: gfp_t flags that would be used to allocate
--- a/net/sunrpc/svc_xprt.c~mm-introduce-memalloc_retry_wait
+++ a/net/sunrpc/svc_xprt.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/errno.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
@@ -688,7 +689,7 @@ static int svc_alloc_arg(struct svc_rqst
 			return -EINTR;
 		}
 		trace_svc_alloc_arg_err(pages);
-		schedule_timeout(msecs_to_jiffies(500));
+		memalloc_retry_wait(GFP_KERNEL);
 	}
 	rqstp->rq_page_end = &rqstp->rq_pages[pages];
 	rqstp->rq_pages[pages] = NULL; /* this might be seen in nfsd_splice_actor() */
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

