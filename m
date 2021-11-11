Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2830C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C529F61208
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhKKCha (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:37:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233120AbhKKCha (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:37:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BB64611C9;
        Thu, 11 Nov 2021 02:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598073;
        bh=j+BLM4YEGkqsRZgHofJB1ZTBBnch6kEEy5s+m59aqA8=;
        h=Date:From:To:Subject:From;
        b=en4xV58O97FZEpULOaRbRb2jsAl2f2a/vfNMS3qZZf7cE1cAJOF/SELrb7YelUB02
         AGxNOuCNc9G9gXvsc1/dYNyVA9oBnnK+r/m2JLnZl0b9pqSl2FIx1PQeqgruYOjTZW
         ZC6EbUhmVxs00VQu6gHXGR4B/LUAxNYfsrrf/eSo=
Date:   Wed, 10 Nov 2021 18:34:32 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        willy@infradead.org
Subject:  [obsolete] revert-acct_reclaim_writeback-for-next.patch
 removed from -mm tree
Message-ID: <20211111023432.0h9kYl6kS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: revert-acct_reclaim_writeback-for-next
has been removed from the -mm tree.  Its filename was
     revert-acct_reclaim_writeback-for-next.patch

This patch was dropped because it is obsolete

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
@@ -1620,7 +1620,6 @@ void end_page_writeback(struct page *pag
 
 	smp_mb__after_atomic();
 	wake_up_page(page, PG_writeback);
-	acct_reclaim_writeback(page);
 	put_page(page);
 }
 EXPORT_SYMBOL(end_page_writeback);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

