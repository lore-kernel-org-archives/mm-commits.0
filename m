Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD31CC433E3
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC18F20838
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266382;
	bh=culF+X89qpfMSqpR2kWEaHCnKTrqfXMfi54QI2xwXR4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Cx+w+Mo6MrJr0NxK2IDPiKH8bDeC+ogXSpcSD2Im+H3ClUGhlv9VOOVlm4u2hl1lK
	 ORnSwp4g5TmFXgqiWVM94+SSBuQByuw1Tn28jDguNXYqy57zSt6Jwijeis92xuIPWe
	 qwHfn24Y6rQ0SL2YyxEJtPKodyrqJB1AbPEjS26E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgHLVGW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgHLVGW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:22 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ED932080C;
        Wed, 12 Aug 2020 21:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266381;
        bh=culF+X89qpfMSqpR2kWEaHCnKTrqfXMfi54QI2xwXR4=;
        h=Date:From:To:Subject:From;
        b=lp24nrcJ2M0c9vNTS/faFnmt/YodCb04gjbt7juPO3zlTMK685o9bkI9F3Ee161SW
         46YlCP1GPXQVKX+1oILvXly3d7TzqrTMez9NzIHI3DxeinolK45oH9RV+0+nbTSlw7
         XY+8ipmonPF5uScDI8w3AQd9jX/prOp8NzF4OEzQ=
Date:   Wed, 12 Aug 2020 14:06:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, peterx@redhat.com, vgupta@synopsys.com
Subject:  [merged] mm-arc-use-general-page-fault-accounting.patch
 removed from -mm tree
Message-ID: <20200812210621.7X0mXU3bp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/arc: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-arc-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/arc: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Fix PERF_COUNT_SW_PAGE_FAULTS perf event manually for page fault retries,
by moving it before taking mmap_sem.

Link: http://lkml.kernel.org/r/20200707225021.200906-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/fault.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/arch/arc/mm/fault.c~mm-arc-use-general-page-fault-accounting
+++ a/arch/arc/mm/fault.c
@@ -105,6 +105,7 @@ void do_page_fault(unsigned long address
 	if (write)
 		flags |= FAULT_FLAG_WRITE;
 
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 retry:
 	mmap_read_lock(mm);
 
@@ -130,7 +131,7 @@ retry:
 		goto bad_area;
 	}
 
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	/* Quick path to respond to signals */
 	if (fault_signal_pending(fault, regs)) {
@@ -155,22 +156,9 @@ bad_area:
 	 * Major/minor page fault accounting
 	 * (in case of retry we only land here once)
 	 */
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
-
-	if (likely(!(fault & VM_FAULT_ERROR))) {
-		if (fault & VM_FAULT_MAJOR) {
-			tsk->maj_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
-				      regs, address);
-		} else {
-			tsk->min_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
-				      regs, address);
-		}
-
+	if (likely(!(fault & VM_FAULT_ERROR)))
 		/* Normal return path: fault Handled Gracefully */
 		return;
-	}
 
 	if (!user_mode(regs))
 		goto no_context;
_

Patches currently in -mm which might be from peterx@redhat.com are


