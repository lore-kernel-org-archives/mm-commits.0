Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9A6EE49A8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjHUUmW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbjHUUl3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:41:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C12E6E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45A276069B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE6FC433C7;
        Mon, 21 Aug 2023 20:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650451;
        bh=Fg7Q0FQ5Ba/us5kPVPkmyRJ62b74twuiTr1mYqSxhH0=;
        h=Date:To:From:Subject:From;
        b=MZ48SfciFiEFKWvuxiaENqPpykxSfxi3fcs8wX+0imP6Ogxuw0sDhVzIlH9ZVZcjZ
         ApYf4FepVudFs4sW5nlsjYJ+Y/YakSHe2VuKnuBKvttQJOC0Zy/rAcZG19SEy4VyZn
         WMx4tZkiDtlkB8Olvg2SOL+j5NRY0D02YLsq7op0=
Date:   Mon, 21 Aug 2023 13:40:51 -0700
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        osalvador@suse.de, npiggin@gmail.com, mpe@ellerman.id.au,
        mhocko@suse.com, david@redhat.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix.patch removed from -mm tree
Message-Id: <20230821204051.9DE6FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc/book3s64/memhotplug: enable memmap on memory for radix
has been removed from the -mm tree.  Its filename was
     powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: powerpc/book3s64/memhotplug: enable memmap on memory for radix
Date: Tue, 8 Aug 2023 14:45:00 +0530

Radix vmemmap mapping can map things correctly at the PMD level or PTE
level based on different device boundary checks.  Hence we skip the
restrictions w.r.t vmemmap size to be multiple of PMD_SIZE.  This also
makes the feature widely useful because to use PMD_SIZE vmemmap area we
require a memory block size of 2GiB

We can also use MHP_RESERVE_PAGES_MEMMAP_ON_MEMORY to that the feature can
work with a memory block size of 256MB.  Using altmap.reserve feature to
align things correctly at pageblock granularity.  We can end up losing
some pages in memory with this.  For ex: with a 256MiB memory block size,
we require 4 pages to map vmemmap pages, In order to align things
correctly we end up adding a reserve of 28 pages.  ie, for every 4096
pages 28 pages get reserved.

Link: https://lkml.kernel.org/r/20230808091501.287660-6-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                            |    1 
 arch/powerpc/include/asm/pgtable.h              |   21 ++++++++++++++
 arch/powerpc/platforms/pseries/hotplug-memory.c |    2 -
 3 files changed, 23 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/pgtable.h~powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -161,6 +161,27 @@ static inline pgtable_t pmd_pgtable(pmd_
 int __meminit vmemmap_populated(unsigned long vmemmap_addr, int vmemmap_map_size);
 bool altmap_cross_boundary(struct vmem_altmap *altmap, unsigned long start,
 			   unsigned long page_size);
+/*
+ * mm/memory_hotplug.c:mhp_supports_memmap_on_memory goes into details
+ * some of the restrictions. We don't check for PMD_SIZE because our
+ * vmemmap allocation code can fallback correctly. The pageblock
+ * alignment requirement is met using altmap->reserve blocks.
+ */
+#define arch_supports_memmap_on_memory arch_supports_memmap_on_memory
+static inline bool arch_supports_memmap_on_memory(unsigned long vmemmap_size)
+{
+	if (!radix_enabled())
+		return false;
+	/*
+	 * With 4K page size and 2M PMD_SIZE, we can align
+	 * things better with memory block size value
+	 * starting from 128MB. Hence align things with PMD_SIZE.
+	 */
+	if (IS_ENABLED(CONFIG_PPC_4K_PAGES))
+		return IS_ALIGNED(vmemmap_size, PMD_SIZE);
+	return true;
+}
+
 #endif /* CONFIG_PPC64 */
 
 #endif /* __ASSEMBLY__ */
--- a/arch/powerpc/Kconfig~powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix
+++ a/arch/powerpc/Kconfig
@@ -157,6 +157,7 @@ config PPC
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_KEEP_MEMBLOCK
+	select ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE	if PPC_RADIX_MMU
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select ARCH_OPTIONAL_KERNEL_RWX		if ARCH_HAS_STRICT_KERNEL_RWX
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c~powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix
+++ a/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -637,7 +637,7 @@ static int dlpar_add_lmb(struct drmem_lm
 		nid = first_online_node;
 
 	/* Add the memory */
-	rc = __add_memory(nid, lmb->base_addr, block_sz, MHP_NONE);
+	rc = __add_memory(nid, lmb->base_addr, block_sz, MHP_MEMMAP_ON_MEMORY);
 	if (rc) {
 		invalidate_lmb_associativity_index(lmb);
 		return rc;
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


