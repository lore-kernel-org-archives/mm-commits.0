Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD6B8C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 836EA2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266399;
	bh=dQsk15ajCeAeAb4K4HvdTLUu0CYzT/HpkY9vQRPWTj8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CqS7XRWJO/jMa9VeFl3t6Sx6qHCpvz6pgPwsBHgFxNCVVrHddChibN/tKbKzEUXa9
	 W1LXaiaV/ZI6FRmVhqevaIjLxA05xIFbsMO58+CM/l95muGWr5tD867yhpJHybNq8F
	 d2k4vRglju/v4ufXfxaskptvnMSlxHquSwP6MwgI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgHLVGj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgHLVGj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:39 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7691C20774;
        Wed, 12 Aug 2020 21:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266398;
        bh=dQsk15ajCeAeAb4K4HvdTLUu0CYzT/HpkY9vQRPWTj8=;
        h=Date:From:To:Subject:From;
        b=fztO0rMgKLweLWj/j5eaVxf1U1QwWeNzenoXqbV2dni0DMdS8mcD8nTi4Y3bs1qaV
         YL56i97mfx+8jlTBZM9abYEgV+nhhfvqpiXiSkYbTtC08ecR8nQXIUckFPaqyHoxd9
         nTS4RAY68SG7qO7rUIN2Bk1QhWy0brojiDV6k4fc=
Date:   Wed, 12 Aug 2020 14:06:38 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        tsbogend@alpha.franken.de
Subject:  [merged] mm-mips-use-general-page-fault-accounting.patch
 removed from -mm tree
Message-ID: <20200812210638.suliM-oti%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mips: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-mips-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/mips: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Fix PERF_COUNT_SW_PAGE_FAULTS perf event manually for page fault retries,
by moving it before taking mmap_sem.

Link: http://lkml.kernel.org/r/20200707225021.200906-12-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/fault.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/arch/mips/mm/fault.c~mm-mips-use-general-page-fault-accounting
+++ a/arch/mips/mm/fault.c
@@ -96,6 +96,8 @@ static void __kprobes __do_page_fault(st
 
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
+
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 retry:
 	mmap_read_lock(mm);
 	vma = find_vma(mm, address);
@@ -152,12 +154,11 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	if (fault_signal_pending(fault, regs))
 		return;
 
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -168,15 +169,6 @@ good_area:
 		BUG();
 	}
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_MAJOR) {
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
-						  regs, address);
-			tsk->maj_flt++;
-		} else {
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
-						  regs, address);
-			tsk->min_flt++;
-		}
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
_

Patches currently in -mm which might be from peterx@redhat.com are


