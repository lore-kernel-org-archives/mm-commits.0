Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7B0C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 21 Oct 2021 01:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B24F610A1
	for <mm-commits@archiver.kernel.org>; Thu, 21 Oct 2021 01:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhJUBK6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Oct 2021 21:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230268AbhJUBK5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 Oct 2021 21:10:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A56A610CF;
        Thu, 21 Oct 2021 01:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634778522;
        bh=z2Q+gGaF1RJF6BULzD0NQmCzO/p3GY17H66GVAUk5Zs=;
        h=Date:From:To:Subject:From;
        b=mK20MgqC7jS/9qajM4boZ7jEr+0dAVSwbUk4bRyOuIvOlYXiFU1IV4+FWynWZpXtS
         zvbDt48FLgnkZWCYtz6AtfVKqTODHtWLByvpvTN2yf8DtNyu/IJYVQRdHzJIEbjHzu
         EzNNUOaYsUxiqJglznKhE0EZ0i216Qcs4qXnp19U=
Date:   Wed, 20 Oct 2021 18:08:41 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        willy@infradead.org
Subject:  + revert-acct_reclaim_writeback-for-next.patch added to
 -mm tree
Message-ID: <20211021010841.FqP1uSRg4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: revert-acct_reclaim_writeback-for-next
has been added to the -mm tree.  Its filename is
     revert-acct_reclaim_writeback-for-next.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/revert-acct_reclaim_writeback-for-next.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/revert-acct_reclaim_writeback-for-next.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert-acct_reclaim_writeback-for-next

take away this change from Mel's "mm/vmscan: throttle reclaim and
compaction when too may pages are isolated" so that linux-next.patch
applies more easily.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/filemap.c~revert-acct_reclaim_writeback-for-next
+++ a/mm/filemap.c
@@ -1613,7 +1613,6 @@ void end_page_writeback(struct page *pag
 
 	smp_mb__after_atomic();
 	wake_up_page(page, PG_writeback);
-	acct_reclaim_writeback(page);
 	put_page(page);
 }
 EXPORT_SYMBOL(end_page_writeback);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
revert-acct_reclaim_writeback-for-next.patch
linux-next-rejects.patch
restore-acct_reclaim_writeback-for-folio.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
kernel-forkc-export-kernel_thread-to-modules.patch

