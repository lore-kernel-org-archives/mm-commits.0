Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C2AC001E0
	for <mm-commits@archiver.kernel.org>; Fri, 28 Jul 2023 18:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjG1SRG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jul 2023 14:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjG1SRF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2023 14:17:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE06212A
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 11:17:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03390621AD
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 18:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BECAC433C7;
        Fri, 28 Jul 2023 18:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690568223;
        bh=FMWSnQuoObzam38iY9qgMp7+GjrCQvI4vbq25YkDtqM=;
        h=Date:To:From:Subject:From;
        b=OiRFQE9pBmBOA85H9hEOuY24yt5UXwrMmbwNt4y82LpUyklYzy8u2u22RGBSo8t6q
         97nOzVPMmhp0fjP20OY0JX8hjNYseb3Tjr2K8aN4vBsbAXF8HyTpzYCkMBqRnNTQXo
         gpV0NCM6TogPnFciBYKCbcszzo0O1uXDIChQx7YQ=
Date:   Fri, 28 Jul 2023 11:17:02 -0700
To:     mm-commits@vger.kernel.org, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix-2.patch added to mm-unstable branch
Message-Id: <20230728181703.5BECAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: fix kernel build error
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix-2.patch

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
Subject: powerpc/mm: fix kernel build error
Date: Fri, 28 Jul 2023 15:36:53 +0530

  CC      arch/powerpc/mm/init_64.o
src/linux/arch/powerpc/mm/init_64.c:324:12: error: no previous prototype for __vmemmap_free() [-Werror=3Dmissing-prototypes]
  324 | void __ref __vmemmap_free(unsigned long start, unsigned long end,

Link: https://lkml.kernel.org/r/877cqkwd20.fsf@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/init_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/mm/init_64.c~powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix-2
+++ a/arch/powerpc/mm/init_64.c
@@ -308,8 +308,8 @@ static unsigned long vmemmap_list_free(u
 	return vmem_back->phys;
 }
 
-void __ref __vmemmap_free(unsigned long start, unsigned long end,
-			  struct vmem_altmap *altmap)
+static void __ref __vmemmap_free(unsigned long start, unsigned long end,
+				 struct vmem_altmap *altmap)
 {
 	unsigned long page_size = 1 << mmu_psize_defs[mmu_vmemmap_psize].shift;
 	unsigned long page_order = get_order(page_size);
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
powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix-2.patch
powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix.patch
powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix.patch
powerpc-book3s64-radix-remove-mmu_vmemmap_psize.patch
powerpc-book3s64-radix-remove-mmu_vmemmap_psize-fix.patch
powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch

