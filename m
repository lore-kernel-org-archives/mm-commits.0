Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F09FC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D683A20774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266414;
	bh=NwEDKj1ysZ6H/r6yAKUO31ABetLxAubDDFy+6xyBdkM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=uoLa1iDQMTpQPJZmsMy9YZnst6gk75iqMpFJ9jF7WPIdE0JvB5vBBhbKnEAuBCc4w
	 eCaT2eWgpSD3SuX3+JUXXUCG5oCYcuV8B63TGTg19G+OdjvhylCvyXVlLtDEhpl7Ew
	 b1nlKsZ87DXWtRZCKR1f22DyrUPtEmFe4b2O4n8s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgHLVGy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVGy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:54 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 989A620838;
        Wed, 12 Aug 2020 21:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266413;
        bh=NwEDKj1ysZ6H/r6yAKUO31ABetLxAubDDFy+6xyBdkM=;
        h=Date:From:To:Subject:From;
        b=W1v5bpgkE8Eg2+47pCEEJXW2jm4cVp1aG392tSFt1ohAvVzWeYIg87WCV+uJIacJ2
         hTX2yjU7Jlhtdry2de4Njs826ZWd2oUhao1d5ZBDPnT2o1VZDUy/Bosh5mcTWdgng7
         t+r7nBtyPpnVFFFcBXDeiyVpu8Bk5RJAofl/+9tM=
Date:   Wed, 12 Aug 2020 14:06:53 -0700
From:   akpm@linux-foundation.org
To:     agordeev@linux.ibm.com, borntraeger@de.ibm.com,
        gerald.schaefer@de.ibm.com, gor@linux.ibm.com,
        heiko.carstens@de.ibm.com, mm-commits@vger.kernel.org,
        peterx@redhat.com
Subject:  [merged] mm-s390-use-general-page-fault-accounting.patch
 removed from -mm tree
Message-ID: <20200812210653.dlA6himA-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/s390: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-s390-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/s390: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Link: http://lkml.kernel.org/r/20200707225021.200906-19-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/fault.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/arch/s390/mm/fault.c~mm-s390-use-general-page-fault-accounting
+++ a/arch/s390/mm/fault.c
@@ -476,7 +476,7 @@ retry:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 	if (fault_signal_pending(fault, regs)) {
 		fault = VM_FAULT_SIGNAL;
 		if (flags & FAULT_FLAG_RETRY_NOWAIT)
@@ -486,21 +486,7 @@ retry:
 	if (unlikely(fault & VM_FAULT_ERROR))
 		goto out_up;
 
-	/*
-	 * Major/minor page fault accounting is only done on the
-	 * initial attempt. If we go through a retry, it is extremely
-	 * likely that the page will be found in page cache at that point.
-	 */
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_MAJOR) {
-			tsk->maj_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
-				      regs, address);
-		} else {
-			tsk->min_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
-				      regs, address);
-		}
 		if (fault & VM_FAULT_RETRY) {
 			if (IS_ENABLED(CONFIG_PGSTE) && gmap &&
 			    (flags & FAULT_FLAG_RETRY_NOWAIT)) {
_

Patches currently in -mm which might be from peterx@redhat.com are


