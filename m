Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8960CC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E52A61C7A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhGFTV7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231794AbhGFTV7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1251F61C91;
        Tue,  6 Jul 2021 19:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599160;
        bh=OiHbj5NhzTKZZ3BAhzY9vGbMol6P9sW3r14vYQ2caF0=;
        h=Date:From:To:Subject:From;
        b=U4hHG57TdeGn9WtMSUbNWeLLjljfT5HloAc+XMwwmsV7EB78Vv3ZOMoEkEZ6k3SaP
         rrFbwpHJsYqsEqggYULvB1/tPBctPKEW/rv4yYxAaI0Bwi6W7OHho1P8EL6pTKGNqY
         s0wIZ1rx0FPqkzKemiapcQqDTe6mjHf6xZyg5H04=
Date:   Tue, 06 Jul 2021 12:19:19 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, ardb@kernel.org,
        catalin.marinas@arm.com, david@redhat.com, mark.rutland@arm.com,
        maz@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        wangkefeng.wang@huawei.com, will@kernel.org
Subject:  [merged]
 arm64-drop-pfn_valid_within-and-simplify-pfn_valid.patch removed from -mm
 tree
Message-ID: <20210706191919.002eyRzL7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: drop pfn_valid_within() and simplify pfn_valid()
has been removed from the -mm tree.  Its filename was
     arm64-drop-pfn_valid_within-and-simplify-pfn_valid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arm64: drop pfn_valid_within() and simplify pfn_valid()

The arm64's version of pfn_valid() differs from the generic because of two
reasons:

* Parts of the memory map are freed during boot. This makes it necessary to
  verify that there is actual physical memory that corresponds to a pfn
  which is done by querying memblock.

* There are NOMAP memory regions. These regions are not mapped in the
  linear map and until the previous commit the struct pages representing
  these areas had default values.

As the consequence of absence of the special treatment of NOMAP regions in
the memory map it was necessary to use memblock_is_map_memory() in
pfn_valid() and to have pfn_valid_within() aliased to pfn_valid() so that
generic mm functionality would not treat a NOMAP page as a normal page.

Since the NOMAP regions are now marked as PageReserved(), pfn walkers and
the rest of core mm will treat them as unusable memory and thus
pfn_valid_within() is no longer required at all and can be disabled on
arm64.

pfn_valid() can be slightly simplified by replacing
memblock_is_map_memory() with memblock_is_memory().

[rppt@kernel.org: fix merge fix]
  Link: https://lkml.kernel.org/r/YJtoQhidtIJOhYsV@kernel.org
Link: https://lkml.kernel.org/r/20210511100550.28178-5-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig   |    1 -
 arch/arm64/mm/init.c |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/arch/arm64/Kconfig~arm64-drop-pfn_valid_within-and-simplify-pfn_valid
+++ a/arch/arm64/Kconfig
@@ -201,7 +201,6 @@ config ARM64
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_GENERIC_VDSO
-	select HOLES_IN_ZONE
 	select IOMMU_DMA if IOMMU_SUPPORT
 	select IRQ_DOMAIN
 	select IRQ_FORCED_THREADING
--- a/arch/arm64/mm/init.c~arm64-drop-pfn_valid_within-and-simplify-pfn_valid
+++ a/arch/arm64/mm/init.c
@@ -252,7 +252,7 @@ int pfn_valid(unsigned long pfn)
 	if (!early_section(ms))
 		return pfn_section_valid(ms, pfn);
 
-	return memblock_is_map_memory(addr);
+	return memblock_is_memory(addr);
 }
 EXPORT_SYMBOL(pfn_valid);
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

