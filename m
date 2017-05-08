From: akpm@linux-foundation.org
Subject: [folded-merged]
 treewide-convert-pf_memalloc-manipulations-to-new-helpers-fix.patch removed from -mm tree
Date: Mon, 08 May 2017 15:41:58 -0700
Message-ID: <5910f436.r0Arq39uGojK8UZG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43582 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdEHWl6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:41:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide-convert-pf_memalloc-manipulations-to-new-helpers-fix
has been removed from the -mm tree.  Its filename was
     treewide-convert-pf_memalloc-manipulations-to-new-helpers-fix.patch

This patch was dropped because it was folded into treewide-convert-pf_memalloc-manipulations-to-new-helpers.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: treewide-convert-pf_memalloc-manipulations-to-new-helpers-fix

In net/core/sock.c the hunk is missing (that didn't involve
tsk_restore_flags()).

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/sock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN net/core/sock.c~treewide-convert-pf_memalloc-manipulations-to-new-helpers-fix net/core/sock.c
--- a/net/core/sock.c~treewide-convert-pf_memalloc-manipulations-to-new-helpers-fix
+++ a/net/core/sock.c
@@ -373,14 +373,14 @@ EXPORT_SYMBOL_GPL(sk_clear_memalloc);
 int __sk_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 {
 	int ret;
-	unsigned long pflags = current->flags;
+	unsigned int noreclaim_flag;
 
 	/* these should have been dropped before queueing */
 	BUG_ON(!sock_flag(sk, SOCK_MEMALLOC));
 
-	current->flags |= PF_MEMALLOC;
+	noreclaim_flag = memalloc_noreclaim_save();
 	ret = sk->sk_backlog_rcv(sk, skb);
-	current_restore_flags(pflags, PF_MEMALLOC);
+	memalloc_noreclaim_restore(noreclaim_flag);
 
 	return ret;
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-reorder-fields-in-struct-compact_control.patch
mm-compaction-remove-redundant-watermark-check-in-compact_finished.patch
mm-page_alloc-split-smallest-stolen-page-in-fallback.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock.patch
mm-compaction-change-migrate_async_suitable-to-suitable_migration_source.patch
mm-compaction-add-migratetype-to-compact_control.patch
mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype.patch
mm-compaction-finish-whole-pageblock-to-reduce-fragmentation.patch
mm-prevent-potential-recursive-reclaim-due-to-clearing-pf_memalloc.patch
mm-introduce-memalloc_noreclaim_saverestore.patch
treewide-convert-pf_memalloc-manipulations-to-new-helpers.patch
mtd-nand-nandsim-convert-to-memalloc_noreclaim_.patch

