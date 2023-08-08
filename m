Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5961C04A6A
	for <mm-commits@archiver.kernel.org>; Tue,  8 Aug 2023 20:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjHHUJO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Aug 2023 16:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjHHUIu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Aug 2023 16:08:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7AB26304
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 11:30:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7A5F62A12
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 18:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36765C433C9;
        Tue,  8 Aug 2023 18:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691519429;
        bh=OfnjmpdwTaCKhF9qfpuA2Zq3SCHdGPKWdczKPeD6lpU=;
        h=Date:To:From:Subject:From;
        b=LfIuys9U0/4efq+eNFhlBOZsh2fuvNw6qEIBwXtzL3yllTYdbuJ+QSt8A5OWPsvIL
         g6igxc1jTw5uX3G/CxcDsJdpmhc5FCZMu1URw0noP7F3SQ+ekpD9YwqG9HB66VKwzG
         0F9WKo/yC5anVzCOK2OuDFX2NGH4HR01GPSAT6mk=
Date:   Tue, 08 Aug 2023 11:30:28 -0700
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        osalvador@suse.de, npiggin@gmail.com, mpe@ellerman.id.au,
        mhocko@suse.com, david@redhat.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch added to mm-unstable branch
Message-Id: <20230808183029.36765C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: allow architecture to override memmap on memory support check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch

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
Subject: mm/memory_hotplug: allow architecture to override memmap on memory support check
Date: Tue, 8 Aug 2023 14:44:58 +0530

Some architectures would want different restrictions. Hence add an
architecture-specific override.

The PMD_SIZE check is moved there.

Link: https://lkml.kernel.org/r/20230808091501.287660-4-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check
+++ a/mm/memory_hotplug.c
@@ -1247,10 +1247,26 @@ static int online_memory_block(struct me
 	return device_online(&mem->dev);
 }
 
+static inline unsigned long memory_block_memmap_size(void)
+{
+	return PHYS_PFN(memory_block_size_bytes()) * sizeof(struct page);
+}
+
+#ifndef arch_supports_memmap_on_memory
+static inline bool arch_supports_memmap_on_memory(unsigned long vmemmap_size)
+{
+	/*
+	 * As default, we want the vmemmap to span a complete PMD such that we
+	 * can map the vmemmap using a single PMD if supported by the
+	 * architecture.
+	 */
+	return IS_ALIGNED(vmemmap_size, PMD_SIZE);
+}
+#endif
+
 static bool mhp_supports_memmap_on_memory(unsigned long size)
 {
-	unsigned long nr_vmemmap_pages = size / PAGE_SIZE;
-	unsigned long vmemmap_size = nr_vmemmap_pages * sizeof(struct page);
+	unsigned long vmemmap_size = memory_block_memmap_size();
 	unsigned long remaining_size = size - vmemmap_size;
 
 	/*
@@ -1281,8 +1297,8 @@ static bool mhp_supports_memmap_on_memor
 	 */
 	return mhp_memmap_on_memory() &&
 	       size == memory_block_size_bytes() &&
-	       IS_ALIGNED(vmemmap_size, PMD_SIZE) &&
-	       IS_ALIGNED(remaining_size, (pageblock_nr_pages << PAGE_SHIFT));
+	       IS_ALIGNED(remaining_size, (pageblock_nr_pages << PAGE_SHIFT)) &&
+	       arch_supports_memmap_on_memory(vmemmap_size);
 }
 
 /*
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
mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig.patch
mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback.patch
mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch
mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks.patch
powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix.patch
mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block.patch

