Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B51C0015E
	for <mm-commits@archiver.kernel.org>; Wed, 26 Jul 2023 18:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjGZSou (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jul 2023 14:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjGZSot (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2023 14:44:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F341BFB
        for <mm-commits@vger.kernel.org>; Wed, 26 Jul 2023 11:44:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7627261C41
        for <mm-commits@vger.kernel.org>; Wed, 26 Jul 2023 18:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CC0C433C7;
        Wed, 26 Jul 2023 18:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690397087;
        bh=8olDr7rtFZzEbsNjy/K7sboPyNCAaabH2r2K7HlT5QI=;
        h=Date:To:From:Subject:From;
        b=B53kTDrGvdUSoiQvrLHCkrOzoeh9LRtX6T+02RfEUMC8wfh66z7/lXILepOt55Hf7
         krRCJm2gUso20JBLHHvxBu3F1SdJzIVlQQT0ea6pIdeAA0wNgOiu6T0MsD7UgQaKP0
         XvRtfSO1Cf9CK9yZi682RoB6/EtrbE0rs95WE9h4=
Date:   Wed, 26 Jul 2023 11:44:47 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix.patch added to mm-unstable branch
Message-Id: <20230726184447.C1CC0C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix.patch

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
Subject: powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix
Date: Wed, 26 Jul 2023 10:52:33 +0530

We should look at ppc64 not including radix headers if
CONFIG_PPC_RADIX_MMU is disabled.

Link: https://lkml.kernel.org/r/87zg3jw8km.fsf@linux.ibm.com
Signed-off-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/radix.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/include/asm/book3s/64/radix.h~powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix
+++ a/arch/powerpc/include/asm/book3s/64/radix.h
@@ -364,8 +364,10 @@ int radix__remove_section_mapping(unsign
 
 void radix__kernel_map_pages(struct page *page, int numpages, int enable);
 
+#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 #define vmemmap_can_optimize vmemmap_can_optimize
 bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
+#endif
 
 #define vmemmap_populate_compound_pages vmemmap_populate_compound_pages
 int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support.patch
mm-change-pudp_huge_get_and_clear_full-take-vm_area_struct-as-arg.patch
mm-vmemmap-improve-vmemmap_can_optimize-and-allow-architectures-to-override.patch
mm-vmemmap-allow-architectures-to-override-how-vmemmap-optimization-works.patch
mm-add-pud_same-similar-to-__have_arch_p4d_same.patch
mm-huge-pud-use-transparent-huge-pud-helpers-only-with-config_transparent_hugepage.patch
mm-vmemmap-optimization-split-hugetlb-and-devdax-vmemmap-optimization.patch
powerpc-mm-trace-convert-trace-event-to-trace-event-class.patch
powerpc-book3s64-mm-enable-transparent-pud-hugepage.patch
powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function.patch
powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix.patch
powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix.patch
powerpc-book3s64-radix-remove-mmu_vmemmap_psize.patch
powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch

