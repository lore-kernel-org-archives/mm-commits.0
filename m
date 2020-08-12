Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE56FC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B966F2177B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266385;
	bh=zZgl6dinkG339ULXz/eW/hsvrppYfm/VbetjkDIrByE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=FigwiZr7J+Knm0S3aOj8S/mpE9PXgCL0kKR0uUv2f4sLg6SQnyGTCfzYuZA12V/s8
	 D/u6X5mYDgITwGWaIS3t55qkfxipgLE8VunDD5DLqIRqhWihi0x0KQ6mQ/MflNluA3
	 9JzEBepBvr3kgHDiHZzTfcM6Y7mvlsSIfTkHQbPs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgHLVGZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgHLVGZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:25 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CA3F20838;
        Wed, 12 Aug 2020 21:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266383;
        bh=zZgl6dinkG339ULXz/eW/hsvrppYfm/VbetjkDIrByE=;
        h=Date:From:To:Subject:From;
        b=gkx4s78psK3jsqCm3+U+WGcy8IYR2mpsAMTYcu4/+pZd+MQnpg4uBDkmB6WmuAly9
         Zn3ND2e7QxNZBH167Y0FqM9jilk4z64i5A22qlXrBV5HOeOTef/stf4fCixTnHzZf3
         /G2AtBpU0A3FLB/ZtRLBwqKr1uQGdDQUSsEUWX6A=
Date:   Wed, 12 Aug 2020 14:06:23 -0700
From:   akpm@linux-foundation.org
To:     linux@armlinux.org.uk, mm-commits@vger.kernel.org,
        peterx@redhat.com, will@kernel.org
Subject:  [merged] mm-arm-use-general-page-fault-accounting.patch
 removed from -mm tree
Message-ID: <20200812210623.5-dCxTlZe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/arm: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-arm-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/arm: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.  To do this, we need to pass
the pt_regs pointer into __do_page_fault().

Fix PERF_COUNT_SW_PAGE_FAULTS perf event manually for page fault retries,
by moving it before taking mmap_sem.

Link: http://lkml.kernel.org/r/20200707225021.200906-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

--- a/arch/arm/mm/fault.c~mm-arm-use-general-page-fault-accounting
+++ a/arch/arm/mm/fault.c
@@ -202,7 +202,8 @@ static inline bool access_error(unsigned
 
 static vm_fault_t __kprobes
 __do_page_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
-		unsigned int flags, struct task_struct *tsk)
+		unsigned int flags, struct task_struct *tsk,
+		struct pt_regs *regs)
 {
 	struct vm_area_struct *vma;
 	vm_fault_t fault;
@@ -224,7 +225,7 @@ good_area:
 		goto out;
 	}
 
-	return handle_mm_fault(vma, addr & PAGE_MASK, flags, NULL);
+	return handle_mm_fault(vma, addr & PAGE_MASK, flags, regs);
 
 check_stack:
 	/* Don't allow expansion below FIRST_USER_ADDRESS */
@@ -266,6 +267,8 @@ do_page_fault(unsigned long addr, unsign
 	if ((fsr & FSR_WRITE) && !(fsr & FSR_CM))
 		flags |= FAULT_FLAG_WRITE;
 
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
+
 	/*
 	 * As per x86, we may deadlock here.  However, since the kernel only
 	 * validly references user space from well defined areas of the code,
@@ -290,7 +293,7 @@ retry:
 #endif
 	}
 
-	fault = __do_page_fault(mm, addr, fsr, flags, tsk);
+	fault = __do_page_fault(mm, addr, fsr, flags, tsk, regs);
 
 	/* If we need to retry but a fatal signal is pending, handle the
 	 * signal first. We do not need to release the mmap_lock because
@@ -302,23 +305,7 @@ retry:
 		return 0;
 	}
 
-	/*
-	 * Major/minor page fault accounting is only done on the
-	 * initial attempt. If we go through a retry, it is extremely
-	 * likely that the page will be found in page cache at that point.
-	 */
-
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
 	if (!(fault & VM_FAULT_ERROR) && flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_MAJOR) {
-			tsk->maj_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
-					regs, addr);
-		} else {
-			tsk->min_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
-					regs, addr);
-		}
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 			goto retry;
_

Patches currently in -mm which might be from peterx@redhat.com are


