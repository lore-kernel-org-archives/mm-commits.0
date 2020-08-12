Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E55C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 264F6207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196275;
	bh=+pcbjs8f3bUXzkPLl6ROmNS+PbL4hctP0JC91+wfY5I=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=hcjpfFVePq5pQOKZKUB1634fcbIa1YapBujPGltBxAxp6bobdAcnHR0dnCqkxaimH
	 WdQE816gJxfd1dv0swQ1h7kLC00fNwNA+yDXV8bFDdCpWcTH+gELRYoBwv8BD8wbxx
	 MztanOnP/nXJcHb9t1PvXJviw43yERNkPijZPZS8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgHLBhy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBhw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:37:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62E2E2076C;
        Wed, 12 Aug 2020 01:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196272;
        bh=+pcbjs8f3bUXzkPLl6ROmNS+PbL4hctP0JC91+wfY5I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PUV+s6s1oOP9QMDCtevTcwh/4oda67xSds5ABmqqyByOCAQbSZwtZpElZHJDhG7M7
         LX36c22bWJ2VMAxvu8bs98qi7+CUfsa9V9gzLlPjIo4z+uvwg6zWnF7OFk+jDU0dui
         he0E454j2eiEUhxedF198qoZ4MrMGAhwyH8mrytM=
Date:   Tue, 11 Aug 2020 18:37:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org, vgupta@synopsys.com
Subject:  [patch 143/165] mm/arc: use general page fault accounting
Message-ID: <20200812013752.LkqQfvZHO%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
