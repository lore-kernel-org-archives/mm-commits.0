Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106B1C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C78DC2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266421;
	bh=qt4M3omuC3BpcIfs5zzi7psZc3vDT7VivurqTCPyTtc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rBM024KPYm2GxqACZJ2EL9xubLe6DVJLqoZAc/RlEkjJGNjlSw4AXv71qwbG8GyFl
	 bE+EcROjV92q5OGkTg/fhEVU1Hhk4GLPwD8ZPAO/I0GVmHYvZUIfGywvtFC0VquTOD
	 GHU2f9HOTjVZptNlUy7HnYC4NKtvDMoLTaPPG2MM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgHLVHB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVHB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:07:01 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82AF820774;
        Wed, 12 Aug 2020 21:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266420;
        bh=qt4M3omuC3BpcIfs5zzi7psZc3vDT7VivurqTCPyTtc=;
        h=Date:From:To:Subject:From;
        b=dNHFYAqkD2LTB0fbdtlXG2Y0lk8ief9gqOKX8jyEid5ruJBqTCgiKvGMGVfGgmZsF
         GWwJe7E5cLGkS358dP1U3O9zT4u2vn070QKAgd35hs714MUBP4sMPKFauu7kC+Y89V
         pcgfHDws4Kxv65aUOQ77CTfM1FqCpJASyHrmFitU=
Date:   Wed, 12 Aug 2020 14:07:00 -0700
From:   akpm@linux-foundation.org
To:     davem@davemloft.net, mm-commits@vger.kernel.org, peterx@redhat.com
Subject:  [merged]
 mm-sparc64-use-general-page-fault-accounting.patch removed from -mm tree
Message-ID: <20200812210700.Jc1l3gdfG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparc64: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-sparc64-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/sparc64: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Link: http://lkml.kernel.org/r/20200707225021.200906-22-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/fault_64.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/arch/sparc/mm/fault_64.c~mm-sparc64-use-general-page-fault-accounting
+++ a/arch/sparc/mm/fault_64.c
@@ -422,7 +422,7 @@ good_area:
 			goto bad_area;
 	}
 
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	if (fault_signal_pending(fault, regs))
 		goto exit_exception;
@@ -438,15 +438,6 @@ good_area:
 	}
 
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_MAJOR) {
-			current->maj_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ,
-				      1, regs, address);
-		} else {
-			current->min_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN,
-				      1, regs, address);
-		}
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
_

Patches currently in -mm which might be from peterx@redhat.com are


