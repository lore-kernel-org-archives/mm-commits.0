Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3FDDC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 01:48:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA779611CE
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 01:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhKDBuk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Nov 2021 21:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232912AbhKDBuj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Nov 2021 21:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7936361186;
        Thu,  4 Nov 2021 01:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635990482;
        bh=ysQTa0ol4+fSQGx2u129MLrtqEeyPkv/7Hqqe8YTGBg=;
        h=Date:From:To:Subject:From;
        b=jU/4Dbfmorocw0H+12FnV6q+2c4OF+1tgIn001OW/514Sf50dn/NMKQbhfUo0jfA5
         UbsBS6IiJtnt2qWYfHFGtmYV69uh/PoYUXGDCfNpkcj3W0esT2S04tVRjPKQteufvN
         EfkTuE+70glY5qeapKJT5t2LJhF9ak6uat8bwjsE=
Date:   Wed, 03 Nov 2021 18:48:02 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        willy@infradead.org
Subject:  [obsolete] restore-acct_reclaim_writeback-for-folio.patch
 removed from -mm tree
Message-ID: <20211104014802.Y5gsWrnc9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: restore-acct_reclaim_writeback-for-folio
has been removed from the -mm tree.  Its filename was
     restore-acct_reclaim_writeback-for-folio.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: restore-acct_reclaim_writeback-for-folio

Make Mel's "mm/vmscan: throttle reclaim and compaction when too may pages
are isolated" work for folio changes.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/filemap.c~restore-acct_reclaim_writeback-for-folio
+++ a/mm/filemap.c
@@ -1607,6 +1607,7 @@ void folio_end_writeback(struct folio *f
 
 	smp_mb__after_atomic();
 	folio_wake(folio, PG_writeback);
+	acct_reclaim_writeback(folio_page(folio, 0));
 	folio_put(folio);
 }
 EXPORT_SYMBOL(folio_end_writeback);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-move-kvmalloc-related-functions-to-slabh-fix.patch
mm-simplify-bdi-refcounting-fix-fix.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
delay-replace-kernelh-with-the-necessary-inclusions-fix.patch
generic-radix-tree-replace-kernelh-with-the-necessary-inclusions-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
revert-acct_reclaim_writeback-for-next.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

