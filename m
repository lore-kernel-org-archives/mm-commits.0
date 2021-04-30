Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4198EC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B5D461476
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhD3F6I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhD3F6H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:58:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3EC56147D;
        Fri, 30 Apr 2021 05:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762240;
        bh=qBh1IeiMt3wS1bEIDrzYYhBcge2fw3Anb0xBVwplAMQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=s+OtfxOPpJngA1FS4YVXWAPv4Egnvcg4kIe/zA4IL5dSQynkOpX/A9AnC1RPcpuy8
         43ZgtwcyvRwFlJz5tYV8mdlBYUsqkTjIl9la+Klcr6/Nz5ZIc4QOcASeDLe0E0khXH
         Jv5mPb+c7NV2wZC5Xr9fCAT0YRcfj8wt6t4HBNMk=
Date:   Thu, 29 Apr 2021 22:57:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bp@alien8.de,
        dave.hansen@linux.intel.com, david@redhat.com, hpa@zytor.com,
        linux-mm@kvack.org, luto@kernel.org, mhocko@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        peterz@infradead.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 081/178] x86/vmemmap: handle unpopulated sub-pmd
 ranges
Message-ID: <20210430055719.GC7_cOkEn%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: x86/vmemmap: handle unpopulated sub-pmd ranges

When sizeof(struct page) is not a power of 2, sections do not span a PMD
anymore and so when populating them some parts of the PMD will remain
unused.

Because of this, PMDs will be left behind when depopulating sections since
remove_pmd_table() thinks that those unused parts are still in use.

Fix this by marking the unused parts with PAGE_UNUSED, so memchr_inv()
will do the right thing and will let us free the PMD when the last user of
it is gone.

This patch is based on a similar patch by David Hildenbrand:

https://lore.kernel.org/linux-mm/20200722094558.9828-9-david@redhat.com/

[osalvador@suse.de: go back to the ifdef version]
  Link: https://lkml.kernel.org/r/YGy++mSft7K4u+88@localhost.localdomain
Link: https://lkml.kernel.org/r/20210309214050.4674-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   68 ++++++++++++++++++++++++++++++++--------
 1 file changed, 55 insertions(+), 13 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-vmemmap-handle-unpopulated-sub-pmd-ranges
+++ a/arch/x86/mm/init_64.c
@@ -826,6 +826,51 @@ void __init paging_init(void)
 	zone_sizes_init();
 }
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+#define PAGE_UNUSED 0xFD
+
+/* Returns true if the PMD is completely unused and thus it can be freed */
+static bool __meminit vmemmap_pmd_is_unused(unsigned long addr, unsigned long end)
+{
+	unsigned long start = ALIGN_DOWN(addr, PMD_SIZE);
+
+	memset((void *)addr, PAGE_UNUSED, end - addr);
+
+	return !memchr_inv((void *)start, PAGE_UNUSED, PMD_SIZE);
+}
+
+static void __meminit vmemmap_use_sub_pmd(unsigned long start)
+{
+	/*
+	 * As we expect to add in the same granularity as we remove, it's
+	 * sufficient to mark only some piece used to block the memmap page from
+	 * getting removed when removing some other adjacent memmap (just in
+	 * case the first memmap never gets initialized e.g., because the memory
+	 * block never gets onlined).
+	 */
+	memset((void *)start, 0, sizeof(struct page));
+}
+
+static void __meminit vmemmap_use_new_sub_pmd(unsigned long start, unsigned long end)
+{
+	/*
+	 * Could be our memmap page is filled with PAGE_UNUSED already from a
+	 * previous remove. Make sure to reset it.
+	 */
+	vmemmap_use_sub_pmd(start);
+
+	/*
+	 * Mark with PAGE_UNUSED the unused parts of the new memmap range
+	 */
+	if (!IS_ALIGNED(start, PMD_SIZE))
+		memset((void *)start, PAGE_UNUSED,
+		        start - ALIGN_DOWN(start, PMD_SIZE));
+	if (!IS_ALIGNED(end, PMD_SIZE))
+		memset((void *)end, PAGE_UNUSED,
+		        ALIGN(end, PMD_SIZE) - end);
+}
+#endif
+
 /*
  * Memory hotplug specific functions
  */
@@ -871,8 +916,6 @@ int arch_add_memory(int nid, u64 start,
 	return add_pages(nid, start_pfn, nr_pages, params);
 }
 
-#define PAGE_INUSE 0xFD
-
 static void __meminit free_pagetable(struct page *page, int order)
 {
 	unsigned long magic;
@@ -1006,7 +1049,6 @@ remove_pmd_table(pmd_t *pmd_start, unsig
 	unsigned long next, pages = 0;
 	pte_t *pte_base;
 	pmd_t *pmd;
-	void *page_addr;
 
 	pmd = pmd_start + pmd_index(addr);
 	for (; addr < end; addr = next, pmd++) {
@@ -1026,22 +1068,16 @@ remove_pmd_table(pmd_t *pmd_start, unsig
 				pmd_clear(pmd);
 				spin_unlock(&init_mm.page_table_lock);
 				pages++;
-			} else {
-				/* If here, we are freeing vmemmap pages. */
-				memset((void *)addr, PAGE_INUSE, next - addr);
-
-				page_addr = page_address(pmd_page(*pmd));
-				if (!memchr_inv(page_addr, PAGE_INUSE,
-						PMD_SIZE)) {
+			}
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+			else if (vmemmap_pmd_is_unused(addr, next)) {
 					free_hugepage_table(pmd_page(*pmd),
 							    altmap);
-
 					spin_lock(&init_mm.page_table_lock);
 					pmd_clear(pmd);
 					spin_unlock(&init_mm.page_table_lock);
-				}
 			}
-
+#endif
 			continue;
 		}
 
@@ -1492,11 +1528,17 @@ static int __meminit vmemmap_populate_hu
 
 				addr_end = addr + PMD_SIZE;
 				p_end = p + PMD_SIZE;
+
+				if (!IS_ALIGNED(addr, PMD_SIZE) ||
+				    !IS_ALIGNED(next, PMD_SIZE))
+					vmemmap_use_new_sub_pmd(addr, next);
+
 				continue;
 			} else if (altmap)
 				return -ENOMEM; /* no fallback */
 		} else if (pmd_large(*pmd)) {
 			vmemmap_verify((pte_t *)pmd, node, addr, next);
+			vmemmap_use_sub_pmd(addr);
 			continue;
 		}
 		if (vmemmap_populate_basepages(addr, next, node, NULL))
_
