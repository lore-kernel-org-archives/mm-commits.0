Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFFFC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8E48207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266386;
	bh=9Y5e6EtsYAp4luInjxwMIVSHI8b5fIFe3os46lFZznY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=NPCor9Z5tUCsSQv3COsX8eT/Sonlu5nH31aUyQSWxt8XTLqoEzFKWoCkkTcXfX80c
	 lDOV2pcsksjqor+epqiJMkG/nAiA33WvZ+AG0BQevV2nNR5B0PEViiDDY8YUxsnIx+
	 hv3TLUWMtoPncuFoKEeY5GNWzzWUlLC5IztJ7mGY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHLVG0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgHLVG0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:26 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B70E2080C;
        Wed, 12 Aug 2020 21:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266385;
        bh=9Y5e6EtsYAp4luInjxwMIVSHI8b5fIFe3os46lFZznY=;
        h=Date:From:To:Subject:From;
        b=NN/ggBYH4mXbukpVL+/VWWW5qBPGhqqK3UNIx9zaiVHPnIbFMhSNJwWgbfgg9N3JS
         uyjtBeC7/ePt7pFfhKnY8L1rD989QRv3FOnhCAfqSBRT/nnqakUE6CB+9UscYjbn37
         l6/7P3P6sAGgWFniLiArI7pHfE0SetsV+UDnltII=
Date:   Wed, 12 Aug 2020 14:06:25 -0700
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, will@kernel.org
Subject:  [merged] mm-arm64-use-general-page-fault-accounting.patch
 removed from -mm tree
Message-ID: <20200812210625.ZYX4eAzPI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/arm64: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-arm64-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/arm64: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.  To do this, we pass pt_regs
pointer into __do_page_fault().

Link: http://lkml.kernel.org/r/20200707225021.200906-6-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/fault.c |   29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

--- a/arch/arm64/mm/fault.c~mm-arm64-use-general-page-fault-accounting
+++ a/arch/arm64/mm/fault.c
@@ -404,7 +404,8 @@ static void do_bad_area(unsigned long ad
 #define VM_FAULT_BADACCESS	0x020000
 
 static vm_fault_t __do_page_fault(struct mm_struct *mm, unsigned long addr,
-			   unsigned int mm_flags, unsigned long vm_flags)
+				  unsigned int mm_flags, unsigned long vm_flags,
+				  struct pt_regs *regs)
 {
 	struct vm_area_struct *vma = find_vma(mm, addr);
 
@@ -428,7 +429,7 @@ static vm_fault_t __do_page_fault(struct
 	 */
 	if (!(vma->vm_flags & vm_flags))
 		return VM_FAULT_BADACCESS;
-	return handle_mm_fault(vma, addr & PAGE_MASK, mm_flags, NULL);
+	return handle_mm_fault(vma, addr & PAGE_MASK, mm_flags, regs);
 }
 
 static bool is_el0_instruction_abort(unsigned int esr)
@@ -450,7 +451,7 @@ static int __kprobes do_page_fault(unsig
 {
 	const struct fault_info *inf;
 	struct mm_struct *mm = current->mm;
-	vm_fault_t fault, major = 0;
+	vm_fault_t fault;
 	unsigned long vm_flags = VM_ACCESS_FLAGS;
 	unsigned int mm_flags = FAULT_FLAG_DEFAULT;
 
@@ -516,8 +517,7 @@ retry:
 #endif
 	}
 
-	fault = __do_page_fault(mm, addr, mm_flags, vm_flags);
-	major |= fault & VM_FAULT_MAJOR;
+	fault = __do_page_fault(mm, addr, mm_flags, vm_flags, regs);
 
 	/* Quick path to respond to signals */
 	if (fault_signal_pending(fault, regs)) {
@@ -538,25 +538,8 @@ retry:
 	 * Handle the "normal" (no error) case first.
 	 */
 	if (likely(!(fault & (VM_FAULT_ERROR | VM_FAULT_BADMAP |
-			      VM_FAULT_BADACCESS)))) {
-		/*
-		 * Major/minor page fault accounting is only done
-		 * once. If we go through a retry, it is extremely
-		 * likely that the page will be found in page cache at
-		 * that point.
-		 */
-		if (major) {
-			current->maj_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs,
-				      addr);
-		} else {
-			current->min_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs,
-				      addr);
-		}
-
+			      VM_FAULT_BADACCESS))))
 		return 0;
-	}
 
 	/*
 	 * If we are in kernel mode at this point, we have no context to
_

Patches currently in -mm which might be from peterx@redhat.com are


