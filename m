Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53EDCC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2985461131
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346101AbhIHC4a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347363AbhIHC4N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:56:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91F7861104;
        Wed,  8 Sep 2021 02:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069706;
        bh=PCzlAF6gf0hyOT4qNQzP0+7SnSbXN6VRpkGBpsgZweg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eWXP//k9290IWfQ7TV0KdhVZTR+yx8Dts+5Ldo5marguImuwFXUGPGctkTPgguz0P
         pxCxZJ1B/5nYL27uy6YO8wPEhhkx5UMbdjsFUXKC0bAZuB/42oLxolztQd5I/RqG8i
         aPL0TceHmF5GHXFo+MvJwICFLVzsL9JHapdnfusA=
Date:   Tue, 07 Sep 2021 19:55:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, anton@ozlabs.org, ardb@kernel.org,
        bauerman@linux.ibm.com, benh@kernel.crashing.org, bhe@redhat.com,
        borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com,
        cheloha@linux.ibm.com, christophe.leroy@c-s.fr, dalias@libc.org,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        dave.jiang@intel.com, david@redhat.com, gor@linux.ibm.com,
        hca@linux.ibm.com, hpa@zytor.com, jasowang@redhat.com,
        joe@perches.com, justin.he@arm.com, ldufour@linux.ibm.com,
        lenb@kernel.org, linux-mm@kvack.org, luto@kernel.org,
        mhocko@kernel.org, michel@lespinasse.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, mst@redhat.com,
        nathanl@linux.ibm.com, npiggin@gmail.com, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, pankaj.gupta@ionos.com,
        pasha.tatashin@soleen.com, paulus@samba.org, peterz@infradead.org,
        pmorel@linux.ibm.com, rafael.j.wysocki@intel.com,
        richard.weiyang@linux.alibaba.com, rjw@rjwysocki.net,
        rppt@kernel.org, slyfox@gentoo.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vishal.l.verma@intel.com, vkuznets@redhat.com,
        wangkefeng.wang@huawei.com, will@kernel.org,
        ysato@users.sourceforge.jp
Subject:  [patch 039/147] mm/memory_hotplug: remove nid parameter
 from arch_remove_memory()
Message-ID: <20210908025504.TW3JgZsqZ%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: remove nid parameter from arch_remove_memory()

The parameter is unused, let's remove it.

Link: https://lkml.kernel.org/r/20210712124052.26491-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> [powerpc]
Acked-by: Heiko Carstens <hca@linux.ibm.com>	[s390]
Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: Joe Perches <joe@perches.com>
Cc: Pierre Morel <pmorel@linux.ibm.com>
Cc: Jia He <justin.he@arm.com>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c            |    3 +--
 arch/ia64/mm/init.c            |    3 +--
 arch/powerpc/mm/mem.c          |    3 +--
 arch/s390/mm/init.c            |    3 +--
 arch/sh/mm/init.c              |    3 +--
 arch/x86/mm/init_32.c          |    3 +--
 arch/x86/mm/init_64.c          |    3 +--
 include/linux/memory_hotplug.h |    3 +--
 mm/memory_hotplug.c            |    4 ++--
 mm/memremap.c                  |    5 +----
 10 files changed, 11 insertions(+), 22 deletions(-)

--- a/arch/arm64/mm/mmu.c~mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory
+++ a/arch/arm64/mm/mmu.c
@@ -1502,8 +1502,7 @@ int arch_add_memory(int nid, u64 start,
 	return ret;
 }
 
-void arch_remove_memory(int nid, u64 start, u64 size,
-			struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
--- a/arch/ia64/mm/init.c~mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory
+++ a/arch/ia64/mm/init.c
@@ -484,8 +484,7 @@ int arch_add_memory(int nid, u64 start,
 	return ret;
 }
 
-void arch_remove_memory(int nid, u64 start, u64 size,
-			struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
--- a/arch/powerpc/mm/mem.c~mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory
+++ a/arch/powerpc/mm/mem.c
@@ -119,8 +119,7 @@ int __ref arch_add_memory(int nid, u64 s
 	return rc;
 }
 
-void __ref arch_remove_memory(int nid, u64 start, u64 size,
-			      struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
--- a/arch/s390/mm/init.c~mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory
+++ a/arch/s390/mm/init.c
@@ -306,8 +306,7 @@ int arch_add_memory(int nid, u64 start,
 	return rc;
 }
 
-void arch_remove_memory(int nid, u64 start, u64 size,
-			struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
--- a/arch/sh/mm/init.c~mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory
+++ a/arch/sh/mm/init.c
@@ -414,8 +414,7 @@ int arch_add_memory(int nid, u64 start,
 	return ret;
 }
 
-void arch_remove_memory(int nid, u64 start, u64 size,
-			struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long nr_pages = size >> PAGE_SHIFT;
--- a/arch/x86/mm/init_32.c~mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory
+++ a/arch/x86/mm/init_32.c
@@ -801,8 +801,7 @@ int arch_add_memory(int nid, u64 start,
 	return __add_pages(nid, start_pfn, nr_pages, params);
 }
 
-void arch_remove_memory(int nid, u64 start, u64 size,
-			struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
--- a/arch/x86/mm/init_64.c~mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory
+++ a/arch/x86/mm/init_64.c
@@ -1255,8 +1255,7 @@ kernel_physical_mapping_remove(unsigned
 	remove_pagetable(start, end, true, NULL);
 }
 
-void __ref arch_remove_memory(int nid, u64 start, u64 size,
-			      struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory
+++ a/include/linux/memory_hotplug.h
@@ -130,8 +130,7 @@ static inline bool movable_node_is_enabl
 	return movable_node_enabled;
 }
 
-extern void arch_remove_memory(int nid, u64 start, u64 size,
-			       struct vmem_altmap *altmap);
+extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap);
 extern void __remove_pages(unsigned long start_pfn, unsigned long nr_pages,
 			   struct vmem_altmap *altmap);
 
--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory
+++ a/mm/memory_hotplug.c
@@ -1106,7 +1106,7 @@ int __ref add_memory_resource(int nid, s
 	/* create memory block devices after memory was added */
 	ret = create_memory_block_devices(start, size, mhp_altmap.alloc);
 	if (ret) {
-		arch_remove_memory(nid, start, size, NULL);
+		arch_remove_memory(start, size, NULL);
 		goto error;
 	}
 
@@ -1886,7 +1886,7 @@ static int __ref try_remove_memory(int n
 
 	mem_hotplug_begin();
 
-	arch_remove_memory(nid, start, size, altmap);
+	arch_remove_memory(start, size, altmap);
 
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
 		memblock_free(start, size);
--- a/mm/memremap.c~mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory
+++ a/mm/memremap.c
@@ -140,14 +140,11 @@ static void pageunmap_range(struct dev_p
 {
 	struct range *range = &pgmap->ranges[range_id];
 	struct page *first_page;
-	int nid;
 
 	/* make sure to access a memmap that was actually initialized */
 	first_page = pfn_to_page(pfn_first(pgmap, range_id));
 
 	/* pages are dead and unused, undo the arch mapping */
-	nid = page_to_nid(first_page);
-
 	mem_hotplug_begin();
 	remove_pfn_range_from_zone(page_zone(first_page), PHYS_PFN(range->start),
 				   PHYS_PFN(range_len(range)));
@@ -155,7 +152,7 @@ static void pageunmap_range(struct dev_p
 		__remove_pages(PHYS_PFN(range->start),
 			       PHYS_PFN(range_len(range)), NULL);
 	} else {
-		arch_remove_memory(nid, range->start, range_len(range),
+		arch_remove_memory(range->start, range_len(range),
 				pgmap_altmap(pgmap));
 		kasan_remove_zero_shadow(__va(range->start), range_len(range));
 	}
_
