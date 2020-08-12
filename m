Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE46C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D1AD20658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196302;
	bh=skDb6rIE1dOucJDtpd9y4VvtVMjiWtuTNK63f/moOsw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=S+GveLpqbuIZ7YKZk63YvBkDhMUFuq0UYZ8C6m7NATVGX9Lc5aAmqnknBfbM5byb2
	 t6ina56TjlfIM+pIcDE44p0JG5hg3csvWfPibBLr9VNvai9t/+QTOy7Bq7OPhS9tQN
	 nq+jhAq+asaBnG4SMp8O00agg+ldWUPU+KBNo8ic=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgHLBiU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBiU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:38:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 832AF2054F;
        Wed, 12 Aug 2020 01:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196299;
        bh=skDb6rIE1dOucJDtpd9y4VvtVMjiWtuTNK63f/moOsw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TAwaK9d1w8Mo2ZrKduCfOpg97SgjkzeF6AMF80wb4UFWyJ1e3QKxyy0g+tLzIFE6W
         Rfb5kR9wMCVjwIRBMQOsgzwAOK/gWF1/gSZ19WhEpNweE6E8OANKvMG/pDDoBTO796
         TjCkabdfV9Tnc2Ljw9Ye3QDbgqSKkz2aFQcUHf1M=
Date:   Tue, 11 Aug 2020 18:38:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, deanbo422@gmail.com, green.hu@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        nickhu@andestech.com, peterx@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 152/165] mm/nds32: use general page fault
 accounting
Message-ID: <20200812013819.iSGvKsBSJ%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/nds32: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Fix PERF_COUNT_SW_PAGE_FAULTS perf event manually for page fault retries,
by moving it before taking mmap_sem.

Link: http://lkml.kernel.org/r/20200707225021.200906-13-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Greentime Hu <green.hu@gmail.com>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nds32/mm/fault.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

--- a/arch/nds32/mm/fault.c~mm-nds32-use-general-page-fault-accounting
+++ a/arch/nds32/mm/fault.c
@@ -121,6 +121,8 @@ void do_page_fault(unsigned long entry,
 	if (unlikely(faulthandler_disabled() || !mm))
 		goto no_context;
 
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
+
 	/*
 	 * As per x86, we may deadlock here. However, since the kernel only
 	 * validly references user space from well defined areas of the code,
@@ -206,7 +208,7 @@ good_area:
 	 * the fault.
 	 */
 
-	fault = handle_mm_fault(vma, addr, flags, NULL);
+	fault = handle_mm_fault(vma, addr, flags, regs);
 
 	/*
 	 * If we need to retry but a fatal signal is pending, handle the
@@ -228,22 +230,7 @@ good_area:
 			goto bad_area;
 	}
 
-	/*
-	 * Major/minor page fault accounting is only done on the initial
-	 * attempt. If we go through a retry, it is extremely likely that the
-	 * page will be found in page cache at that point.
-	 */
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
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
