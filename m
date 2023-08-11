Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7795FC04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbjHKXGj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbjHKXFe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:05:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D963C3B
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:03:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C10A765772
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B42C433C7;
        Fri, 11 Aug 2023 23:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691795005;
        bh=SKFOMRZemwz5fGjFrGsG/WcQMOroCIPM2dXX7KDI2mc=;
        h=Date:To:From:Subject:From;
        b=OpzCD7lhJ7T+09cO4vnqz+jDZYcGYrJqjed6nmuj5TsNAvLefXbmj3W4uvaEoN3KJ
         h5nov64UFFBZ+XsFky2GMcveZGIdDPg47Wf10kBH1JhcwOIII8OEBh64k0Ki3J/ou9
         ACUNIONu10XoWVpXQhSougTYY+KHw0UauwoVjA/Q=
Date:   Fri, 11 Aug 2023 16:03:24 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-book3s64-radix-remove-mmu_vmemmap_psize.patch removed from -mm tree
Message-Id: <20230811230325.23B42C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc/book3s64/radix: remove mmu_vmemmap_psize
has been removed from the -mm tree.  Its filename was
     powerpc-book3s64-radix-remove-mmu_vmemmap_psize.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: powerpc/book3s64/radix: remove mmu_vmemmap_psize
Date: Tue, 25 Jul 2023 00:37:58 +0530

This is not used by radix anymore.

[aneesh.kumar@linux.ibm.com: fix kernel build error]
  Link: https://lkml.kernel.org/r/874jlowd0c.fsf@linux.ibm.com
Link: https://lkml.kernel.org/r/20230724190759.483013-13-aneesh.kumar@linux.ibm.com
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

 arch/powerpc/mm/book3s64/radix_pgtable.c |   11 -----------
 arch/powerpc/mm/init_64.c                |   21 ++++++++++++++-------
 2 files changed, 14 insertions(+), 18 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-book3s64-radix-remove-mmu_vmemmap_psize
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -601,17 +601,6 @@ void __init radix__early_init_mmu(void)
 #else
 	mmu_virtual_psize = MMU_PAGE_4K;
 #endif
-
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-	/* vmemmap mapping */
-	if (mmu_psize_defs[MMU_PAGE_2M].shift) {
-		/*
-		 * map vmemmap using 2M if available
-		 */
-		mmu_vmemmap_psize = MMU_PAGE_2M;
-	} else
-		mmu_vmemmap_psize = mmu_virtual_psize;
-#endif
 #endif
 	/*
 	 * initialize page table size
--- a/arch/powerpc/mm/init_64.c~powerpc-book3s64-radix-remove-mmu_vmemmap_psize
+++ a/arch/powerpc/mm/init_64.c
@@ -198,17 +198,12 @@ bool altmap_cross_boundary(struct vmem_a
 	return false;
 }
 
-int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
-		struct vmem_altmap *altmap)
+static int __meminit __vmemmap_populate(unsigned long start, unsigned long end, int node,
+					struct vmem_altmap *altmap)
 {
 	bool altmap_alloc;
 	unsigned long page_size = 1 << mmu_psize_defs[mmu_vmemmap_psize].shift;
 
-#ifdef CONFIG_PPC_BOOK3S_64
-	if (radix_enabled())
-		return radix__vmemmap_populate(start, end, node, altmap);
-#endif
-
 	/* Align to the page size of the linear mapping. */
 	start = ALIGN_DOWN(start, page_size);
 
@@ -277,6 +272,18 @@ int __meminit vmemmap_populate(unsigned
 	return 0;
 }
 
+int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
+			       struct vmem_altmap *altmap)
+{
+
+#ifdef CONFIG_PPC_BOOK3S_64
+	if (radix_enabled())
+		return radix__vmemmap_populate(start, end, node, altmap);
+#endif
+
+	return __vmemmap_populate(start, end, node, altmap);
+}
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 static unsigned long vmemmap_list_free(unsigned long start)
 {
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig.patch
mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback.patch
mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch
mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks.patch
powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix.patch
mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block.patch

