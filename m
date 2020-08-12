Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C07C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7045520658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196335;
	bh=/rC2no0OvRvuo63FVB7V9xOUjNpMfVzBxQ3Ygg6J7No=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=KMllm0+2y6AlEyJk2H0uFzXIrzEBaa7uwnbtZ7dcuac/p4oBuNFUPgGu4WfmK9m10
	 GlCt+FU0S6rDF44NSZCE7hfccLaQGZu0HYXOpVuLJ2OWC6mYoTncDk1rj7eHWlEeMF
	 Mw0/L/QrN8Xpl742JOlFLKuzD2lST4pixAIiB1HI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgHLBiz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBiy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:38:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF17220855;
        Wed, 12 Aug 2020 01:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196334;
        bh=/rC2no0OvRvuo63FVB7V9xOUjNpMfVzBxQ3Ygg6J7No=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=smLVRHSRzEl36JdFKSvx1CmZAArI+du4Q/16qQ5YwOGyXjnBC8NtzP8pf67q7ijOr
         1LGlhJGCPqoMZpJKHWS92vQyjJX5r8GyOIPC3WYDnzLL8mKzvTfarFl8DaHQt9QOlY
         v4B4ypCZ/KtKDpsLqEKwM4Psm9knHyWr7wtnVlYI=
Date:   Tue, 11 Aug 2020 18:38:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@zankel.net, jcmvbkbc@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 163/165] mm/xtensa: use general page fault
 accounting
Message-ID: <20200812013853.qqUeoa0Kr%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/xtensa: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Remove the PERF_COUNT_SW_PAGE_FAULTS_[MAJ|MIN] perf events because it's
now also done in handle_mm_fault().

Move the PERF_COUNT_SW_PAGE_FAULTS event higher before taking mmap_sem for
the fault, then it'll match with the rest of the archs.

Link: http://lkml.kernel.org/r/20200707225021.200906-24-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/mm/fault.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/arch/xtensa/mm/fault.c~mm-xtensa-use-general-page-fault-accounting
+++ a/arch/xtensa/mm/fault.c
@@ -72,6 +72,9 @@ void do_page_fault(struct pt_regs *regs)
 
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
+
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
+
 retry:
 	mmap_read_lock(mm);
 	vma = find_vma(mm, address);
@@ -107,7 +110,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	if (fault_signal_pending(fault, regs))
 		return;
@@ -122,10 +125,6 @@ good_area:
 		BUG();
 	}
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_MAJOR)
-			current->maj_flt++;
-		else
-			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
@@ -139,12 +138,6 @@ good_area:
 	}
 
 	mmap_read_unlock(mm);
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
-	if (flags & VM_FAULT_MAJOR)
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, address);
-	else
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, address);
-
 	return;
 
 	/* Something tried to access memory that isn't in our memory map..
_
