Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E765C38159
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 23:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjARX7z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjARX7f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 18:59:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C0B3E635
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 15:59:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5020BB81EE2
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 23:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FF3C433D2;
        Wed, 18 Jan 2023 23:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674086372;
        bh=DynjpTiUkwhXwrm8cGLV3lHUYFnv2LUjghG4oRVSgyM=;
        h=Date:To:From:Subject:From;
        b=CBup8jm0jGsi3NuiW1aFuYwFDLBvwmj25rzOMoVfKGeyJB9x7t44nSDGmn5o8EaZt
         W3DVWazj6alhJhAMw87Odxw/8lxVCZIEu3+A0o7AXym4E3YQFfOK4QrxJWgjYT6Rlj
         dNTcf5xruzEYQjN+1cYHrpk5WUruggyurk2wWouM=
Date:   Wed, 18 Jan 2023 15:59:31 -0800
To:     mm-commits@vger.kernel.org, anshuman.khandual@arm.com,
        fvdl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-debug-use-valid-physical-memory-for-pmd-pud-tests-v3.patch removed from -mm tree
Message-Id: <20230118235931.F1FF3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-debug-use-valid-physical-memory-for-pmd-pud-tests-v3
has been removed from the -mm tree.  Its filename was
     mm-debug-use-valid-physical-memory-for-pmd-pud-tests-v3.patch

This patch was dropped because it was folded into mm-debug-use-valid-physical-memory-for-pmd-pud-tests.patch

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm-debug-use-valid-physical-memory-for-pmd-pud-tests-v3
Date: Tue, 10 Jan 2023 18:12:08 +0000

Link: https://lkml.kernel.org/r/20230110181208.1633879-1-fvdl@google.com
Fixes: 399145f9eb6c ("mm/debug: add tests validating architecture page table helpers")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/debug_vm_pgtable.c~mm-debug-use-valid-physical-memory-for-pmd-pud-tests-v3
+++ a/mm/debug_vm_pgtable.c
@@ -1089,8 +1089,8 @@ debug_vm_pgtable_alloc_huge_page(struct
  * it's not used on x86.
  */
 static void  __init phys_align_check(phys_addr_t pstart,
-	phys_addr_t pend, unsigned long psize, phys_addr_t *physp,
-	unsigned long *alignp)
+				     phys_addr_t pend, unsigned long psize,
+				     phys_addr_t *physp, unsigned long *alignp)
 {
 	phys_addr_t aligned_start, aligned_end;
 
@@ -1133,20 +1133,19 @@ static void __init init_fixed_pfns(struc
 	for_each_mem_range(idx, &pstart, &pend) {
 		/* First check for a PUD-aligned area */
 		phys_align_check(pstart, pend, PUD_SIZE, &phys,
-				&args->fixed_alignment);
+				 &args->fixed_alignment);
 
 		/* If a PUD-aligned area is found, we're done */
-		if (args->fixed_alignment >= PUD_SIZE)
+		if (args->fixed_alignment == PUD_SIZE)
 			break;
 
 		/*
 		 * If no PMD-aligned area found yet, check for one,
 		 * but continue the loop to look for a PUD-aligned area.
 		 */
-		if (args->fixed_alignment < PMD_SIZE) {
+		if (args->fixed_alignment < PMD_SIZE)
 			phys_align_check(pstart, pend, PMD_SIZE, &phys,
-					&args->fixed_alignment);
-		}
+					 &args->fixed_alignment);
 	}
 
 	args->fixed_pgd_pfn = __phys_to_pfn(phys & PGDIR_MASK);
_

Patches currently in -mm which might be from fvdl@google.com are

mm-debug-use-valid-physical-memory-for-pmd-pud-tests.patch

