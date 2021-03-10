Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86344C4332D
	for <mm-commits@archiver.kernel.org>; Wed, 10 Mar 2021 22:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A04E64FC6
	for <mm-commits@archiver.kernel.org>; Wed, 10 Mar 2021 22:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbhCJW7L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Mar 2021 17:59:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232087AbhCJW65 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Mar 2021 17:58:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF01364FAD;
        Wed, 10 Mar 2021 22:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615417137;
        bh=Ndt9knb4zLa5HgD7w28H6iVSDmr/h0vZfjY7Dt03w18=;
        h=Date:From:To:Subject:From;
        b=knhvrZ9MjEYFVWuris24sBpSm0owKHbhekN2moQE05F3L6MioGrcctDJu9boIX4mD
         T5z3EtaemWJnLbzwQjZ89omdT49ESbLF+plAHupjYNJ6+qBtHf99AFk7SyTc5X8CbV
         Rz7Mc3NzLVpNJJnsrPW5N8c2Dk1tHd/pQiuojFTY=
Date:   Wed, 10 Mar 2021 14:58:56 -0800
From:   akpm@linux-foundation.org
To:     bp@alien8.de, dave.hansen@linux.intel.com, david@redhat.com,
        hpa@zytor.com, luto@kernel.org, mhocko@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        peterz@infradead.org, tglx@linutronix.de, ziy@nvidia.com
Subject:  + x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
 added to -mm tree
Message-ID: <20210310225856.PQWfPyaE4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/vmemmap: handle unpopulated sub-pmd ranges
has been added to the -mm tree.  Its filename is
     x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

 arch/x86/mm/init_64.c |   65 ++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 12 deletions(-)

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
@@ -1026,20 +1068,13 @@ remove_pmd_table(pmd_t *pmd_start, unsig
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
+			} else if (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP) &&
+				   vmemmap_pmd_is_unused(addr, next)) {
 					free_hugepage_table(pmd_page(*pmd),
 							    altmap);
-
 					spin_lock(&init_mm.page_table_lock);
 					pmd_clear(pmd);
 					spin_unlock(&init_mm.page_table_lock);
-				}
 			}
 
 			continue;
@@ -1492,11 +1527,17 @@ static int __meminit vmemmap_populate_hu
 
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

Patches currently in -mm which might be from osalvador@suse.de are

x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch
x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch

