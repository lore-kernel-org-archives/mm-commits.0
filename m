Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9480AC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F3A161468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238468AbhGABxy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238466AbhGABxy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:53:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4605161469;
        Thu,  1 Jul 2021 01:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104283;
        bh=Ty1K6Dbhu2efMQRHCLoL8TCxA2XV9UNWYXZg0QHl6nY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CPYDBy9gATsYp4QOPqS660Lz05pmXr03jzr1ZW6WIx5X49V89naUtZALDnFBe4K2S
         G9TJ8HxrBDL0UyIZCNwE80+uQkreWGzsKaFNih0NrfVZxfcowSTdJ6J+1DxOaPB+ns
         H7tE2zUx88WntvB1deucjbmfajaxhoDq4KB9S2kw=
Date:   Wed, 30 Jun 2021 18:51:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        ardb@kernel.org, catalin.marinas@arm.com, david@redhat.com,
        linux-mm@kvack.org, mark.rutland@arm.com, maz@kernel.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, wangkefeng.wang@huawei.com,
        will@kernel.org
Subject:  [patch 079/192] arm64: drop pfn_valid_within() and
 simplify pfn_valid()
Message-ID: <20210701015122.VdSqIdHx4%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
