Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA7BDC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB9CB207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266426;
	bh=9wff7d9STfi4wHPECBl4sgT7Wc64mT06lmypXoaKedY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=qRpoEwTH/EFsk1Q8uKmQZj02ldBiOaeio9NFkltSGjsXnMxht/OqqDYQgahmKClYP
	 ExWzxKV1jHCQTVk0gtv5qRSQDM835LJm67uGB5Z6Pe1V8ErknrD4qXz36CxlDjtgJe
	 9CMgyEoegWS7qJhv6ugsidQMpnX0Q6gtRRDDqpZ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgHLVHG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVHG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:07:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 780ED20774;
        Wed, 12 Aug 2020 21:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266425;
        bh=9wff7d9STfi4wHPECBl4sgT7Wc64mT06lmypXoaKedY=;
        h=Date:From:To:Subject:From;
        b=RdbdwfLXDW1yqnbYzEuo4aGL72nFI91bebiV9G9H2alcUQjnqWUY+9WNUts/yGve4
         gCIoiKIxxcNCeuM+TDYY6HkpY2Y+cX+nK1ORZbwqHdHxbSRfllpjwHkL1+btyiiudd
         7hmOHPPbCUQQTmAHbTmb7Mp9QsMY78m8d+vMSvSc=
Date:   Wed, 12 Aug 2020 14:07:05 -0700
From:   akpm@linux-foundation.org
To:     chris@zankel.net, jcmvbkbc@gmail.com, mm-commits@vger.kernel.org,
        peterx@redhat.com
Subject:  [merged]
 mm-xtensa-use-general-page-fault-accounting.patch removed from -mm tree
Message-ID: <20200812210705.HUcPFK01X%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/xtensa: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-xtensa-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from peterx@redhat.com are


