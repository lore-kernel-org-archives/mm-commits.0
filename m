Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33CEC6FD18
	for <mm-commits@archiver.kernel.org>; Wed, 19 Apr 2023 23:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjDSXQU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Apr 2023 19:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjDSXQT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Apr 2023 19:16:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18FFAC
        for <mm-commits@vger.kernel.org>; Wed, 19 Apr 2023 16:16:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16702643B9
        for <mm-commits@vger.kernel.org>; Wed, 19 Apr 2023 23:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C964C433D2;
        Wed, 19 Apr 2023 23:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681946175;
        bh=ROIVov7/4QTQIUszGoOFdrN+Tykbf6XvxKGzq/DYwt8=;
        h=Date:To:From:Subject:From;
        b=RbNexgODytohq58xGxgGZuKXvxmTnA7vl4LXOiVTlkjGV+f5XKgOJhtPQL1JWqpO/
         UCjIEGVs+kRQaIcoBu4m9TDaLJ9m882Xo5l/eQSBUUDzYoAUucFcye/7cpy0yPykl9
         7Or1ph4wv6vCyoTgarrQ2A+EPPQ43eDyA8EhKcAU=
Date:   Wed, 19 Apr 2023 16:16:14 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com,
        willy@infradead.org, namit@vmware.com, mgorman@techsingularity.net,
        hughd@google.com, david@redhat.com, ying.huang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmunmap-avoid-flushing-tlb-in-batch-if-pte-is-inaccessible.patch added to mm-unstable branch
Message-Id: <20230419231615.5C964C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,unmap: avoid flushing TLB in batch if PTE is inaccessible
has been added to the -mm mm-unstable branch.  Its filename is
     mmunmap-avoid-flushing-tlb-in-batch-if-pte-is-inaccessible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmunmap-avoid-flushing-tlb-in-batch-if-pte-is-inaccessible.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm,unmap: avoid flushing TLB in batch if PTE is inaccessible
Date: Mon, 10 Apr 2023 15:52:24 +0800

0Day/LKP reported a performance regression for commit 7e12beb8ca2a
("migrate_pages: batch flushing TLB").  In the commit, the TLB flushing
during page migration is batched.  So, in try_to_migrate_one(),
ptep_clear_flush() is replaced with set_tlb_ubc_flush_pending().  In
further investigation, it is found that the TLB flushing can be avoided in
ptep_clear_flush() if the PTE is inaccessible.  In fact, we can optimize
in similar way for the batched TLB flushing too to improve the
performance.

So in this patch, we check pte_accessible() before
set_tlb_ubc_flush_pending() in try_to_unmap/migrate_one().  Tests show
that the benchmark score of the anon-cow-rand-mt test case of
vm-scalability test suite can improve up to 2.1% with the patch on a Intel
server machine.  The TLB flushing IPI can reduce up to 44.3%.

Link: https://lore.kernel.org/oe-lkp/202303192325.ecbaf968-yujie.liu@intel.com
Link: https://lore.kernel.org/oe-lkp/ab92aaddf1b52ede15e2c608696c36765a2602c1.camel@intel.com/
Link: https://lkml.kernel.org/r/20230410075224.827740-1-ying.huang@intel.com
Fixes: 7e12beb8ca2a ("migrate_pages: batch flushing TLB")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reported-by: kernel test robot <yujie.liu@intel.com>
Reviewed-by: Nadav Amit <namit@vmware.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mmunmap-avoid-flushing-tlb-in-batch-if-pte-is-inaccessible
+++ a/mm/rmap.c
@@ -1580,7 +1580,8 @@ static bool try_to_unmap_one(struct foli
 				 */
 				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
 
-				set_tlb_ubc_flush_pending(mm, pte_dirty(pteval));
+				if (pte_accessible(mm, pteval))
+					set_tlb_ubc_flush_pending(mm, pte_dirty(pteval));
 			} else {
 				pteval = ptep_clear_flush(vma, address, pvmw.pte);
 			}
@@ -1961,7 +1962,8 @@ static bool try_to_migrate_one(struct fo
 				 */
 				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
 
-				set_tlb_ubc_flush_pending(mm, pte_dirty(pteval));
+				if (pte_accessible(mm, pteval))
+					set_tlb_ubc_flush_pending(mm, pte_dirty(pteval));
 			} else {
 				pteval = ptep_clear_flush(vma, address, pvmw.pte);
 			}
_

Patches currently in -mm which might be from ying.huang@intel.com are

migrate_pages_batch-fix-statistics-for-longterm-pin-retry.patch
mmunmap-avoid-flushing-tlb-in-batch-if-pte-is-inaccessible.patch

