Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E855C77B73
	for <mm-commits@archiver.kernel.org>; Thu, 27 Apr 2023 20:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344241AbjD0Umw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Apr 2023 16:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344282AbjD0Umt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Apr 2023 16:42:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55033ABC
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 13:42:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 630B263FCE
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 20:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58F3C433EF;
        Thu, 27 Apr 2023 20:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682628164;
        bh=VH9tsUtk5ovFUOX7vBfMr69bYsDLTzbXeQ/+9dzhUc0=;
        h=Date:To:From:Subject:From;
        b=Wxr5YkmxRcVojFDwdmQXepT2ad7kbRUFd2Rzq8XE/1sR0vhZp0CERNyV7kIp8OPMe
         vyl1yrvbFYiE8tbMMD0M8B8Jq80+B38F/ZJ7XEarKBrQAcIACDCHE0kkAxBZ/JbSeC
         fW5SzPpdDDnM67QO9u2Yjz5kF7jmk9sKmIs0CAas=
Date:   Thu, 27 Apr 2023 13:42:44 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com,
        xhao@linux.alibaba.com, willy@infradead.org, namit@vmware.com,
        mgorman@techsingularity.net, hughd@google.com, david@redhat.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmunmap-avoid-flushing-tlb-in-batch-if-pte-is-inaccessible.patch removed from -mm tree
Message-Id: <20230427204244.B58F3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm,unmap: avoid flushing TLB in batch if PTE is inaccessible
has been removed from the -mm tree.  Its filename was
     mmunmap-avoid-flushing-tlb-in-batch-if-pte-is-inaccessible.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm,unmap: avoid flushing TLB in batch if PTE is inaccessible
Date: Mon, 24 Apr 2023 14:54:08 +0800

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
Link: https://lkml.kernel.org/r/20230424065408.188498-1-ying.huang@intel.com
Fixes: 7e12beb8ca2a ("migrate_pages: batch flushing TLB")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reported-by: kernel test robot <yujie.liu@intel.com>
Reviewed-by: Nadav Amit <namit@vmware.com>
Reviewed-by: Xin Hao <xhao@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~mmunmap-avoid-flushing-tlb-in-batch-if-pte-is-inaccessible
+++ a/mm/rmap.c
@@ -642,10 +642,14 @@ void try_to_unmap_flush_dirty(void)
 #define TLB_FLUSH_BATCH_PENDING_LARGE			\
 	(TLB_FLUSH_BATCH_PENDING_MASK / 2)
 
-static void set_tlb_ubc_flush_pending(struct mm_struct *mm, bool writable)
+static void set_tlb_ubc_flush_pending(struct mm_struct *mm, pte_t pteval)
 {
 	struct tlbflush_unmap_batch *tlb_ubc = &current->tlb_ubc;
 	int batch;
+	bool writable = pte_dirty(pteval);
+
+	if (!pte_accessible(mm, pteval))
+		return;
 
 	arch_tlbbatch_add_mm(&tlb_ubc->arch, mm);
 	tlb_ubc->flush_required = true;
@@ -729,7 +733,7 @@ void flush_tlb_batched_pending(struct mm
 	}
 }
 #else
-static void set_tlb_ubc_flush_pending(struct mm_struct *mm, bool writable)
+static void set_tlb_ubc_flush_pending(struct mm_struct *mm, pte_t pteval)
 {
 }
 
@@ -1580,7 +1584,7 @@ static bool try_to_unmap_one(struct foli
 				 */
 				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
 
-				set_tlb_ubc_flush_pending(mm, pte_dirty(pteval));
+				set_tlb_ubc_flush_pending(mm, pteval);
 			} else {
 				pteval = ptep_clear_flush(vma, address, pvmw.pte);
 			}
@@ -1961,7 +1965,7 @@ static bool try_to_migrate_one(struct fo
 				 */
 				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
 
-				set_tlb_ubc_flush_pending(mm, pte_dirty(pteval));
+				set_tlb_ubc_flush_pending(mm, pteval);
 			} else {
 				pteval = ptep_clear_flush(vma, address, pvmw.pte);
 			}
_

Patches currently in -mm which might be from ying.huang@intel.com are


