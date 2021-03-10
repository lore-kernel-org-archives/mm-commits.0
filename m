Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50DAC433E9
	for <mm-commits@archiver.kernel.org>; Wed, 10 Mar 2021 22:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE76064FC9
	for <mm-commits@archiver.kernel.org>; Wed, 10 Mar 2021 22:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbhCJWyW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Mar 2021 17:54:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234003AbhCJWyI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Mar 2021 17:54:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7F6D64FAD;
        Wed, 10 Mar 2021 22:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615416848;
        bh=sTDPdBQJ7MjL/QDOEe1jz94U+z/pI1EbFyX5lnaoiuA=;
        h=Date:From:To:Subject:From;
        b=nH3xVM1Gg+0l40BCQSJrbGvYDmkuH4a97+OsZyYi9FDWoGIhAKkJGRpsBoWO1CX6o
         zNqu0PISPH5YM2cb3Ii3WR8jHg4CSje1R+9WO3oST4vk/PZvge3SFZGOgUiB+BsrZV
         MdhU/S4vjO7sXgGnxP2ogGES06E+HUjBYgtaZo0s=
Date:   Wed, 10 Mar 2021 14:54:07 -0800
From:   akpm@linux-foundation.org
To:     bp@alien8.de, dave.hansen@linux.intel.com, david@redhat.com,
        hpa@zytor.com, luto@kernel.org, mhocko@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        peterz@infradead.org, tglx@linutronix.de
Subject:  [to-be-updated]
 x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch removed from -mm tree
Message-ID: <20210310225407.FOJiQb0iF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/vmemmap: handle unpopulated sub-pmd ranges
has been removed from the -mm tree.  Its filename was
     x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: x86/vmemmap: handle unpopulated sub-pmd ranges

When the size of a struct page is not multiple of 2MB, sections do not
span a PMD anymore and so when populating them some parts of the PMD will
remain unused.  Because of this, PMDs will be left behind when
depopulating sections since remove_pmd_table() thinks that those unused
parts are still in use.

Fix this by marking the unused parts with PAGE_UNUSED, so memchr_inv()
will do the right thing and will let us free the PMD when the last user of
it is gone.

This patch is based on a similar patch by David Hildenbrand:

https://lore.kernel.org/linux-mm/20200722094558.9828-9-david@redhat.com/
https://lore.kernel.org/linux-mm/20200722094558.9828-10-david@redhat.com/

Link: https://lkml.kernel.org/r/20210301083230.30924-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |  106 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 98 insertions(+), 8 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-vmemmap-handle-unpopulated-sub-pmd-ranges
+++ a/arch/x86/mm/init_64.c
@@ -871,7 +871,93 @@ int arch_add_memory(int nid, u64 start,
 	return add_pages(nid, start_pfn, nr_pages, params);
 }
 
-#define PAGE_INUSE 0xFD
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+#define PAGE_UNUSED 0xFD
+
+/*
+ * The unused vmemmap range, which was not yet memset(PAGE_UNUSED) ranges
+ * from unused_pmd_start to next PMD_SIZE boundary.
+ */
+static unsigned long unused_pmd_start __meminitdata;
+
+static void __meminit vmemmap_flush_unused_pmd(void)
+{
+	if (!unused_pmd_start)
+		return;
+	/*
+	 * Clears (unused_pmd_start, PMD_END]
+	 */
+	memset((void *)unused_pmd_start, PAGE_UNUSED,
+	       ALIGN(unused_pmd_start, PMD_SIZE) - unused_pmd_start);
+	unused_pmd_start = 0;
+}
+
+/* Returns true if the PMD is completely unused and thus it can be freed */
+static bool __meminit vmemmap_unuse_sub_pmd(unsigned long addr, unsigned long end)
+{
+	unsigned long start = ALIGN_DOWN(addr, PMD_SIZE);
+
+	vmemmap_flush_unused_pmd();
+	memset((void *)addr, PAGE_UNUSED, end - addr);
+
+	return !memchr_inv((void *)start, PAGE_UNUSED, PMD_SIZE);
+}
+
+static void __meminit __vmemmap_use_sub_pmd(unsigned long start)
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
+static void __meminit vmemmap_use_sub_pmd(unsigned long start, unsigned long end)
+{
+	/*
+	 * We only optimize if the new used range directly follows the
+	 * previously unused range (esp., when populating consecutive sections).
+	 */
+	if (unused_pmd_start == start) {
+		if (likely(IS_ALIGNED(end, PMD_SIZE)))
+			unused_pmd_start = 0;
+		else
+			unused_pmd_start = end;
+		return;
+	}
+
+	vmemmap_flush_unused_pmd();
+	__vmemmap_use_sub_pmd(start);
+}
+
+static void __meminit vmemmap_use_new_sub_pmd(unsigned long start, unsigned long end)
+{
+	vmemmap_flush_unused_pmd();
+
+	/*
+	 * Could be our memmap page is filled with PAGE_UNUSED already from a
+	 * previous remove.
+	 */
+	__vmemmap_use_sub_pmd(start);
+
+	/*
+	 * Mark the unused parts of the new memmap range
+	 */
+	if (!IS_ALIGNED(start, PMD_SIZE))
+		memset((void *)start, PAGE_UNUSED,
+		       start - ALIGN_DOWN(start, PMD_SIZE));
+	/*
+	 * We want to avoid memset(PAGE_UNUSED) when populating the vmemmap of
+	 * consecutive sections. Remember for the last added PMD the last
+	 * unused range in the populated PMD.
+	 */
+	if (!IS_ALIGNED(end, PMD_SIZE))
+		unused_pmd_start = end;
+}
+#endif
 
 static void __meminit free_pagetable(struct page *page, int order)
 {
@@ -1006,7 +1092,6 @@ remove_pmd_table(pmd_t *pmd_start, unsig
 	unsigned long next, pages = 0;
 	pte_t *pte_base;
 	pmd_t *pmd;
-	void *page_addr;
 
 	pmd = pmd_start + pmd_index(addr);
 	for (; addr < end; addr = next, pmd++) {
@@ -1027,12 +1112,11 @@ remove_pmd_table(pmd_t *pmd_start, unsig
 				spin_unlock(&init_mm.page_table_lock);
 				pages++;
 			} else {
-				/* If here, we are freeing vmemmap pages. */
-				memset((void *)addr, PAGE_INUSE, next - addr);
-
-				page_addr = page_address(pmd_page(*pmd));
-				if (!memchr_inv(page_addr, PAGE_INUSE,
-						PMD_SIZE)) {
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+				/*
+				 * Free the PMD if the whole range is unused.
+				 */
+				if (vmemmap_unuse_sub_pmd(addr, next)) {
 					free_hugepage_table(pmd_page(*pmd),
 							    altmap);
 
@@ -1040,6 +1124,7 @@ remove_pmd_table(pmd_t *pmd_start, unsig
 					pmd_clear(pmd);
 					spin_unlock(&init_mm.page_table_lock);
 				}
+#endif
 			}
 
 			continue;
@@ -1492,11 +1577,16 @@ static int __meminit vmemmap_populate_hu
 
 				addr_end = addr + PMD_SIZE;
 				p_end = p + PMD_SIZE;
+
+				if (!IS_ALIGNED(addr, PMD_SIZE) ||
+				    !IS_ALIGNED(next, PMD_SIZE))
+					vmemmap_use_new_sub_pmd(addr, next);
 				continue;
 			} else if (altmap)
 				return -ENOMEM; /* no fallback */
 		} else if (pmd_large(*pmd)) {
 			vmemmap_verify((pte_t *)pmd, node, addr, next);
+			vmemmap_use_sub_pmd(addr, next);
 			continue;
 		}
 		if (vmemmap_populate_basepages(addr, next, node, NULL))
_

Patches currently in -mm which might be from osalvador@suse.de are


