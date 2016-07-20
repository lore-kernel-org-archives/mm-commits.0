From: akpm@linux-foundation.org
Subject: [patch 2/5] radix-tree: fix radix_tree_iter_retry() for tagged
 iterators.
Date: Wed, 20 Jul 2016 15:45:00 -0700
Message-ID: <578ffeec.gIU9fPBQ/5xoX5xd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbcGTWpB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jul 2016 18:45:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aryabinin@virtuozzo.com, dvyukov@google.com, hughd@google.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, stable@vger.kernel.org, willy@linux.intel.com

From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: radix-tree: fix radix_tree_iter_retry() for tagged iterators.

radix_tree_iter_retry() resets slot to NULL, but it doesn't reset tags. 
Then NULL slot and non-zero iter.tags passed to radix_tree_next_slot()
leading to crash:

RIP: [<     inline     >] radix_tree_next_slot include/linux/radix-tree.h:473
  [<ffffffff816951a4>] find_get_pages_tag+0x334/0x930 mm/filemap.c:1452
....
Call Trace:
 [<ffffffff816cd91a>] pagevec_lookup_tag+0x3a/0x80 mm/swap.c:960
 [<ffffffff81ab4231>] mpage_prepare_extent_to_map+0x321/0xa90 fs/ext4/inode.c:2516
 [<ffffffff81ac883e>] ext4_writepages+0x10be/0x2b20 fs/ext4/inode.c:2736
 [<ffffffff816c99c7>] do_writepages+0x97/0x100 mm/page-writeback.c:2364
 [<ffffffff8169bee8>] __filemap_fdatawrite_range+0x248/0x2e0 mm/filemap.c:300
 [<ffffffff8169c371>] filemap_write_and_wait_range+0x121/0x1b0 mm/filemap.c:490
 [<ffffffff81aa584d>] ext4_sync_file+0x34d/0xdb0 fs/ext4/fsync.c:115
 [<ffffffff818b667a>] vfs_fsync_range+0x10a/0x250 fs/sync.c:195
 [<     inline     >] vfs_fsync fs/sync.c:209
 [<ffffffff818b6832>] do_fsync+0x42/0x70 fs/sync.c:219
 [<     inline     >] SYSC_fdatasync fs/sync.c:232
 [<ffffffff818b6f89>] SyS_fdatasync+0x19/0x20 fs/sync.c:230
 [<ffffffff86a94e00>] entry_SYSCALL_64_fastpath+0x23/0xc1 arch/x86/entry/entry_64.S:207

We must reset iterator's tags to bail out from radix_tree_next_slot() and
go to the slow-path in radix_tree_next_chunk().

Fixes: 46437f9a554f ("radix-tree: fix race in gang lookup")
Link: http://lkml.kernel.org/r/1468495196-10604-1-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/radix-tree.h~radix-tree-fix-radix_tree_iter_retry-for-tagged-iterators include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-fix-radix_tree_iter_retry-for-tagged-iterators
+++ a/include/linux/radix-tree.h
@@ -407,6 +407,7 @@ static inline __must_check
 void **radix_tree_iter_retry(struct radix_tree_iter *iter)
 {
 	iter->next_index = iter->index;
+	iter->tags = 0;
 	return NULL;
 }
 
_
