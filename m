Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDE5C0015E
	for <mm-commits@archiver.kernel.org>; Fri, 28 Jul 2023 18:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbjG1SPf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jul 2023 14:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbjG1SPe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2023 14:15:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F0F212A
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 11:15:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 558B7621D1
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 18:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A395DC433C7;
        Fri, 28 Jul 2023 18:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690568132;
        bh=/HTuVaRNwPK2HEAh/vSFffZC0Ej2QPduNMmczodh5go=;
        h=Date:To:From:Subject:From;
        b=I3+XGqWS09XTBiaZhk4NClA8nsSN80Px8ONUCyObe6r5q30Wr+STfYq60/ybO0FkI
         /AO50EtWTdyVzRFIRB5RJaAbzL9eL0Ygt7xaiXXjohcOefRtDkO+bQnBkaHKqYSdUm
         7aG9eOdaPBDBQkWaJttwH610aA69Ud+DF5F2eNSM=
Date:   Fri, 28 Jul 2023 11:15:31 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-book3s64-radix-remove-mmu_vmemmap_psize-fix.patch added to mm-unstable branch
Message-Id: <20230728181532.A395DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: fix kernel build error
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-book3s64-radix-remove-mmu_vmemmap_psize-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-book3s64-radix-remove-mmu_vmemmap_psize-fix.patch

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
Date: Fri, 28 Jul 2023 14:47:46 +0530

 arch/powerpc/mm/init_64.c:201:15: error: no previous prototype for function '__vmemmap_populate' [-Werror,-Wmissing-prototypes]
   int __meminit __vmemmap_populate(unsigned long start, unsigned long end, int node,
                 ^
   arch/powerpc/mm/init_64.c:201:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int __meminit __vmemmap_populate(unsigned long start, unsigned long end, int node,

Link: https://lkml.kernel.org/r/874jlowd0c.fsf@linux.ibm.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202307281617.OxcXz84j-lkp@intel.com/
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/init_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/mm/init_64.c~powerpc-book3s64-radix-remove-mmu_vmemmap_psize-fix
+++ a/arch/powerpc/mm/init_64.c
@@ -198,8 +198,8 @@ bool altmap_cross_boundary(struct vmem_a
 	return false;
 }
 
-int __meminit __vmemmap_populate(unsigned long start, unsigned long end, int node,
-				 struct vmem_altmap *altmap)
+static int __meminit __vmemmap_populate(unsigned long start, unsigned long end, int node,
+					struct vmem_altmap *altmap)
 {
 	bool altmap_alloc;
 	unsigned long page_size = 1 << mmu_psize_defs[mmu_vmemmap_psize].shift;
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
powerpc-book3s64-radix-remove-mmu_vmemmap_psize-fix.patch
powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch

