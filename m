Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1161C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FAB620838
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266408;
	bh=Y450DvhFQxLBMPMIwQeoTVK0a2Pbw6lc3l28SVwR8PQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BCUgAGPfxCA9suTKRGwfCh1de3H9FePNqyFdXX+VqIvZEg5HYJX5LPFs5NNFfHhJD
	 KftaqnwbVWH6naHwRb8qgAZp4lrHfdW6gXmkYIv8i8kl+5uLvS0lOqYQR6jAbmslrb
	 UyaXUp9RhU8UJUa4gs0d7TS75/0rbbNu9dHNnAk0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgHLVGs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVGr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7883C20774;
        Wed, 12 Aug 2020 21:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266406;
        bh=Y450DvhFQxLBMPMIwQeoTVK0a2Pbw6lc3l28SVwR8PQ=;
        h=Date:From:To:Subject:From;
        b=rvHt3HDf5dOEl1tZYNtdfWLxKDG1alTJirpdMRlp4qIbZmx5lx6qwvJFokdOcT/lR
         ybQnS0Eqxhdh4xuzu+fmvTgaQqzz5uEtBY83qdpGrMO2dtXUq7phy4Qjw79i8Zjr8t
         OkgDMSNelN9EbEc/1tpa23tjII0PdDhqHqtEgXZo=
Date:   Wed, 12 Aug 2020 14:06:46 -0700
From:   akpm@linux-foundation.org
To:     deller@gmx.de, James.Bottomley@HansenPartnership.com,
        mm-commits@vger.kernel.org, peterx@redhat.com
Subject:  [merged]
 mm-parisc-use-general-page-fault-accounting.patch removed from -mm tree
Message-ID: <20200812210646.xJyQw_e_Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/parisc: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-parisc-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/parisc: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Add the missing PERF_COUNT_SW_PAGE_FAULTS perf events too.  Note, the
other two perf events (PERF_COUNT_SW_PAGE_FAULTS_[MAJ|MIN]) were done in
handle_mm_fault().

Link: http://lkml.kernel.org/r/20200707225021.200906-16-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/mm/fault.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/parisc/mm/fault.c~mm-parisc-use-general-page-fault-accounting
+++ a/arch/parisc/mm/fault.c
@@ -18,6 +18,7 @@
 #include <linux/extable.h>
 #include <linux/uaccess.h>
 #include <linux/hugetlb.h>
+#include <linux/perf_event.h>
 
 #include <asm/traps.h>
 
@@ -281,6 +282,7 @@ void do_page_fault(struct pt_regs *regs,
 	acc_type = parisc_acctyp(code, regs->iir);
 	if (acc_type & VM_WRITE)
 		flags |= FAULT_FLAG_WRITE;
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 retry:
 	mmap_read_lock(mm);
 	vma = find_vma_prev(mm, address, &prev_vma);
@@ -302,7 +304,7 @@ good_area:
 	 * fault.
 	 */
 
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	if (fault_signal_pending(fault, regs))
 		return;
@@ -323,10 +325,6 @@ good_area:
 		BUG();
 	}
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_MAJOR)
-			current->maj_flt++;
-		else
-			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
 			/*
 			 * No need to mmap_read_unlock(mm) as we would
_

Patches currently in -mm which might be from peterx@redhat.com are


