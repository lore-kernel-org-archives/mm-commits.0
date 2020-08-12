Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867AFC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 616192080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266388;
	bh=aaPs/KjAD31nfw0cjShw2yWJPhJR6kO+pwKkwRbQfk4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=u2DFpbuERoYH8I2OCWySK1kBhZWq37//FsYL0ZMXjGu9faG6ZavfYoT+s3vHUSYBZ
	 7zBsZsLrKi1/OSCnX6IuRvgKuvjbTUdjeKw5kr2MHtMLVTEl+cun9p4oG8SAA6L8M1
	 /9KiG4NzxLF1j6XHa+ezYfalqR0ToXlNn8/IrHEg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgHLVG2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVG1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:27 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 605E0207F7;
        Wed, 12 Aug 2020 21:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266387;
        bh=aaPs/KjAD31nfw0cjShw2yWJPhJR6kO+pwKkwRbQfk4=;
        h=Date:From:To:Subject:From;
        b=QtUYIKvpYLODRGbilFUWVnnVJFQm4nugpHD2feWylC+pKXbX69PabZmc/AEDHYKcB
         tX2lrqLESxpCoVQWDcnrO9VdtJSedCV8ziiZyVi05uMY5sfasoCZbPeXNdZye8xn/B
         wyBdQ+94SpS4msC47l1DnE6IMD2v2HbhDnnPeA1o=
Date:   Wed, 12 Aug 2020 14:06:27 -0700
From:   akpm@linux-foundation.org
To:     guoren@kernel.org, mm-commits@vger.kernel.org, peterx@redhat.com
Subject:  [merged] mm-csky-use-general-page-fault-accounting.patch
 removed from -mm tree
Message-ID: <20200812210627.tWYfaaVS8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/csky: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-csky-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from peterx@redhat.com are


