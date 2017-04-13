From: akpm@linux-foundation.org
Subject: +
 treewide-convert-pf_memalloc-manipulations-to-new-helpers-fix.patch added
 to -mm tree
Date: Thu, 13 Apr 2017 12:48:23 -0700
Message-ID: <58efd607.x6FoDjeJIXNnoPXk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34286 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752027AbdDMTsY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 15:48:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide-convert-pf_memalloc-manipulations-to-new-helpers-fix
has been added to the -mm tree.  Its filename is
     treewide-convert-pf_memalloc-manipulations-to-new-helpers-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/treewide-convert-pf_memalloc-manipulations-to-new-helpers-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/treewide-convert-pf_memalloc-manipulations-to-new-helpers-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-page_alloc-split-smallest-stolen-page-in-fallback-fix.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock.patch
mm-compaction-change-migrate_async_suitable-to-suitable_migration_source.patch
mm-compaction-add-migratetype-to-compact_control.patch
mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype.patch
mm-compaction-finish-whole-pageblock-to-reduce-fragmentation.patch
mm-prevent-potential-recursive-reclaim-due-to-clearing-pf_memalloc.patch
mm-introduce-memalloc_noreclaim_saverestore.patch
treewide-convert-pf_memalloc-manipulations-to-new-helpers.patch
treewide-convert-pf_memalloc-manipulations-to-new-helpers-fix.patch
mtd-nand-nandsim-convert-to-memalloc_noreclaim_.patch

