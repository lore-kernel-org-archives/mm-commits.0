Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A694BC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 21 Oct 2021 01:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 815E3610C8
	for <mm-commits@archiver.kernel.org>; Thu, 21 Oct 2021 01:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhJUBK6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Oct 2021 21:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhJUBK6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 Oct 2021 21:10:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AECC610D0;
        Thu, 21 Oct 2021 01:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634778523;
        bh=vvgSGohrXJDPawE2pnkEEe0EXmPpb/BJmdkFyq7ZNFk=;
        h=Date:From:To:Subject:From;
        b=rlwriM6lWCV64+1rc30WTFgV1ZpsFTBXAAdG4sWoPF1K/elBubA8EjEW4IsuxjskJ
         6B/fOkGMWF7AH7C47ic8zwb8Ph9B96gY/6B9Iw7eZwyu5PmDcLV102jQv1S703ndj+
         H2M6P2pZFusk7vMBWi+jpKXcWYdEW7VRbAepseuQ=
Date:   Wed, 20 Oct 2021 18:08:42 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        willy@infradead.org
Subject:  + restore-acct_reclaim_writeback-for-folio.patch added to
 -mm tree
Message-ID: <20211021010842.rf7R8AF9I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: restore-acct_reclaim_writeback-for-folio
has been added to the -mm tree.  Its filename is
     restore-acct_reclaim_writeback-for-folio.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/restore-acct_reclaim_writeback-for-folio.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/restore-acct_reclaim_writeback-for-folio.patch

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
@@ -1600,6 +1600,7 @@ void folio_end_writeback(struct folio *f
 
 	smp_mb__after_atomic();
 	folio_wake(folio, PG_writeback);
+	acct_reclaim_writeback(folio_page(folio, 0));
 	folio_put(folio);
 }
 EXPORT_SYMBOL(folio_end_writeback);
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

