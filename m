Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CF8C54EBC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 23:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbjAJXFR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 18:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbjAJXFP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 18:05:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F531167D5
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 15:05:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 332FAB81887
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 23:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCE4C433D2;
        Tue, 10 Jan 2023 23:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673391911;
        bh=PE3uXXOhT/6qazkICOE/GChl0w2q4WdNf6hlnxW3zOk=;
        h=Date:To:From:Subject:From;
        b=0fpcSU/iiVr/FokD7lAjMah4GiZ8GyLEYSvRev/x4mUDvVX9NwiJLrnpIDaBg8zhg
         6758Igq2xz0eDVEnMfKuzZ3XCMHXHbblDlLzc59H46z3boHhpPZnkEEDF84Uby2pbH
         2tFmXnIgsur6sfsCaqMiarzINiK915CM/Ma5D6QY=
Date:   Tue, 10 Jan 2023 15:05:11 -0800
To:     mm-commits@vger.kernel.org, anshuman.khandual@arm.com,
        fvdl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug-use-valid-physical-memory-for-pmd-pud-tests-v3.patch added to mm-unstable branch
Message-Id: <20230110230511.CDCE4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-debug-use-valid-physical-memory-for-pmd-pud-tests-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-debug-use-valid-physical-memory-for-pmd-pud-tests-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug-use-valid-physical-memory-for-pmd-pud-tests-v3.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

 mm/debug_vm_pgtable.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

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
mm-debug-use-valid-physical-memory-for-pmd-pud-tests-v3.patch

