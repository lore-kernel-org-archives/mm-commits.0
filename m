Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DC7C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60D0A2054F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196282;
	bh=NZ8MgY+I9N4pW3668y8HsY2GRkps2RVyZLbxMMlaA1M=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=X1gWnCMuKRcOtPclxwcGItEU6gAh7xLi0uQA9ESztbT539eJPoXRvkV39HCbR+ExV
	 8f/5ihshlwOH1CY0O0UAvsgjlIDr2xisbn72w4xT9JXgiIoOTnmpz97nJkJRi8FDq7
	 NnnrXvdgdOtjvz9VDc1Q/55ZCFQeeLt7pHsmQ7Og=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgHLBiC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBiB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:38:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 621C72076C;
        Wed, 12 Aug 2020 01:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196281;
        bh=NZ8MgY+I9N4pW3668y8HsY2GRkps2RVyZLbxMMlaA1M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JiAmGWEDvYNUOL/BApVZV0pnvnCuU4d2+ZCUbWvohUGWMWFuR//mCH4QOG6ceSiCx
         7TwKzpjLBCqBTQVMqBJjmOCRMMUv2Zo0TY7/u1WQwam0W8AiUBJyC+731gawemAbBg
         TCDim2ttB1GqsYKAKUKxNU1WmGg5z+10eJmAh6qM=
Date:   Tue, 11 Aug 2020 18:38:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guoren@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 146/165] mm/csky: use general page fault
 accounting
Message-ID: <20200812013800.7Sw_gjGmg%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/csky: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Link: http://lkml.kernel.org/r/20200707225021.200906-7-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/mm/fault.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/arch/csky/mm/fault.c~mm-csky-use-general-page-fault-accounting
+++ a/arch/csky/mm/fault.c
@@ -151,7 +151,7 @@ good_area:
 	 * the fault.
 	 */
 	fault = handle_mm_fault(vma, address, write ? FAULT_FLAG_WRITE : 0,
-				NULL);
+				regs);
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -161,16 +161,6 @@ good_area:
 			goto bad_area;
 		BUG();
 	}
-	if (fault & VM_FAULT_MAJOR) {
-		tsk->maj_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs,
-			      address);
-	} else {
-		tsk->min_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs,
-			      address);
-	}
-
 	mmap_read_unlock(mm);
 	return;
 
_
