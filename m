Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B88EB64DD
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jul 2023 19:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjGYTb0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jul 2023 15:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbjGYTbS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2023 15:31:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0F12102
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 12:31:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CCA3618A0
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 19:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03B6C433C9;
        Tue, 25 Jul 2023 19:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690313477;
        bh=JZ9zyEocDgokV6sT2UbC8TVAxVYYIOBQsZroL2KSLm8=;
        h=Date:To:From:Subject:From;
        b=2kS6LAcLOzrd9ShRH+6Sg76xjQHBr7XPTEHtHtPHB1bQgaV62KWYOM5zU6wXKs8Rb
         A/6ivnu9yrCm+nFXCCx5u/MJKUUbVcmx7LDNNaJZbPg+FfgPmEd83Z+II1CXITv7fB
         vK/9SAc8UN+R0uLNM1czIixw1QyL63K1LYNRCDKs=
Date:   Tue, 25 Jul 2023 12:31:16 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-pud_same-similar-to-__have_arch_p4d_same.patch added to mm-unstable branch
Message-Id: <20230725193116.F03B6C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add pud_same similar to __HAVE_ARCH_P4D_SAME
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-pud_same-similar-to-__have_arch_p4d_same.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-pud_same-similar-to-__have_arch_p4d_same.patch

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
Subject: mm: add pud_same similar to __HAVE_ARCH_P4D_SAME
Date: Tue, 25 Jul 2023 00:37:51 +0530

This helps architectures to override pmd_same and pud_same independently.

Link: https://lkml.kernel.org/r/20230724190759.483013-6-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/pgtable.h~mm-add-pud_same-similar-to-__have_arch_p4d_same
+++ a/include/linux/pgtable.h
@@ -699,11 +699,14 @@ static inline int pmd_same(pmd_t pmd_a,
 {
 	return pmd_val(pmd_a) == pmd_val(pmd_b);
 }
+#endif
 
+#ifndef pud_same
 static inline int pud_same(pud_t pud_a, pud_t pud_b)
 {
 	return pud_val(pud_a) == pud_val(pud_b);
 }
+#define pud_same pud_same
 #endif
 
 #ifndef __HAVE_ARCH_P4D_SAME
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
powerpc-book3s64-radix-remove-mmu_vmemmap_psize.patch
powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch

