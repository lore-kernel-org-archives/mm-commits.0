Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE5AC001DC
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 15:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbjG0P0W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 11:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbjG0P0R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 11:26:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E373A9F
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 08:26:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 972E061EBF
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 15:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C43C433C9;
        Thu, 27 Jul 2023 15:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690471559;
        bh=KNErRMutNKzf6LVMFeriuTs093PBH56zfQUDo+cB6MM=;
        h=Date:To:From:Subject:From;
        b=2lVaxtDzrqS50qW+q3DCSl2w37N1yPf0ZwdCmqugz93XcrMyZ6yLlDSLeEBGrh+uo
         92Y7F4Qmsrx682gZw8BFuvE0bCHHFoBoCzIHOoO65U+/a/IW29oJ0L4BLTR3hmPF1t
         lu8JfO8pN7gLuQcSjBQgzbpTjSct+PP5xMmtVgn0=
Date:   Thu, 27 Jul 2023 08:25:57 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix.patch added to mm-unstable branch
Message-Id: <20230727152558.E5C43C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: fix section mismatch warning
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix.patch

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
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: powerpc/mm: fix section mismatch warning
Date: Thu, 27 Jul 2023 10:16:19 +0530

remove_pte_table is only called from remove_pmd_table which is marked
__meminit.  These functions are used only during memory hotplug and they
also call functions marked __meminit.  Mark remote_pte_table also with
__meminit so that we can avoid the section mismatch warning below.

WARNING: modpost: vmlinux: section mismatch in reference: remove_pte_table+0x230 (section: .text.remove_pte_table) -> free_vmemmap_pages (section: .meminit.text)
WARNING: modpost: vmlinux: section mismatch in reference: remove_pte_table+0x43c (section: .text.remove_pte_table) -> vmemmap_populated (section: .meminit.text)
WARNING: modpost: vmlinux: section mismatch in reference: remove_pte_table+0x4a4 (section: .text.remove_pte_table) -> free_vmemmap_pages (section: .meminit.text)

Link: https://lkml.kernel.org/r/87h6pqvu5g.fsf@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
  Closes: https://lkml.kernel.org/r/20230727142844.5e00c84d@canb.auug.org.au
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/radix_pgtable.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -793,9 +793,9 @@ static void __meminit free_vmemmap_pages
 		free_pages((unsigned long)page_address(page), order);
 }
 
-static void remove_pte_table(pte_t *pte_start, unsigned long addr,
-			     unsigned long end, bool direct,
-			     struct vmem_altmap *altmap)
+static void __meminit remove_pte_table(pte_t *pte_start, unsigned long addr,
+				       unsigned long end, bool direct,
+				       struct vmem_altmap *altmap)
 {
 	unsigned long next, pages = 0;
 	pte_t *pte;
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support.patch
mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support-fix.patch
mm-change-pudp_huge_get_and_clear_full-take-vm_area_struct-as-arg.patch
mm-vmemmap-improve-vmemmap_can_optimize-and-allow-architectures-to-override.patch
mm-vmemmap-allow-architectures-to-override-how-vmemmap-optimization-works.patch
mm-add-pud_same-similar-to-__have_arch_p4d_same.patch
mm-huge-pud-use-transparent-huge-pud-helpers-only-with-config_transparent_hugepage.patch
mm-vmemmap-optimization-split-hugetlb-and-devdax-vmemmap-optimization.patch
powerpc-mm-trace-convert-trace-event-to-trace-event-class.patch
powerpc-book3s64-mm-enable-transparent-pud-hugepage.patch
powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function.patch
powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix.patch
powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix.patch
powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix.patch
powerpc-book3s64-radix-remove-mmu_vmemmap_psize.patch
powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch

