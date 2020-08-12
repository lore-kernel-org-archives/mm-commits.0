Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D12AC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A1702080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266413;
	bh=g0B5PAg5EtLcjfHR07zXrj2TDsZ+OAOpuSvSl8GEDQo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Tml26lMXeWxxIjPGC2n3WK8QAQWJeWZKoeksV4alB65dZY+LOlziN5RgWfBS73r8e
	 DMeoN0rlZk7ssGAX4o4OPwoQ9OA0hI6VRTdFftfJYHfQYHEZ1ocJasJ4obZH9yG1ov
	 N2A/R5/U2Q84qD4ojmmVwIiRRUsNInTYtJxn4ZcM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHLVGw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVGw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:52 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84C9920774;
        Wed, 12 Aug 2020 21:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266410;
        bh=g0B5PAg5EtLcjfHR07zXrj2TDsZ+OAOpuSvSl8GEDQo=;
        h=Date:From:To:Subject:From;
        b=qV44JNIRMC71MXI+wm+FubBHEJQ9q76nNOsHmzWl+DZNDMUN5Sm1CgPQNbyWmINgw
         TCtO53TtF9V4Aeq9997WGvoMIW7v/rmUEXMGEatmfaThrW/2JCnqUov9VsS/qq3ihJ
         qEVLcHNMBz3/SwwMjidN0aH9lGFkfmIUY4qutTMQ=
Date:   Wed, 12 Aug 2020 14:06:50 -0700
From:   akpm@linux-foundation.org
To:     aou@eecs.berkeley.edu, mm-commits@vger.kernel.org,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        penberg@kernel.org, peterx@redhat.com
Subject:  [merged] mm-riscv-use-general-page-fault-accounting.patch
 removed from -mm tree
Message-ID: <20200812210650.0keLpcZzq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/riscv: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-riscv-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/riscv: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Link: http://lkml.kernel.org/r/20200707225021.200906-18-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/fault.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/arch/riscv/mm/fault.c~mm-riscv-use-general-page-fault-accounting
+++ a/arch/riscv/mm/fault.c
@@ -109,7 +109,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, addr, flags, NULL);
+	fault = handle_mm_fault(vma, addr, flags, regs);
 
 	/*
 	 * If we need to retry but a fatal signal is pending, handle the
@@ -127,21 +127,7 @@ good_area:
 		BUG();
 	}
 
-	/*
-	 * Major/minor page fault accounting is only done on the
-	 * initial attempt. If we go through a retry, it is extremely
-	 * likely that the page will be found in page cache at that point.
-	 */
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_MAJOR) {
-			tsk->maj_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ,
-				      1, regs, addr);
-		} else {
-			tsk->min_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN,
-				      1, regs, addr);
-		}
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
_

Patches currently in -mm which might be from peterx@redhat.com are


