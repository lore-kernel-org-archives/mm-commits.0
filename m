Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F70AC43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 252466148E
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhD3F6L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:58:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhD3F6K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:58:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEB1761476;
        Fri, 30 Apr 2021 05:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762243;
        bh=6bHw5J75yMDQoAv8OuK/cX59bf4PBfw/Q9msFYmaP+0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mKGIKI9DDljTEpAVNTHleOmp4ODghf2TWf2b3+K+XWtdNfSbRI6ubbBigu0iOW8I+
         ee75+n5WLRShboAa15k19vFv6FIFjDNq7Zts7pENSg1OKq+IEBXM68dx6a22efDJe+
         xvX6m0jjHCSaHMYrLjxb1Gr1JUuDJ6DQGRMwSP/I=
Date:   Thu, 29 Apr 2021 22:57:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, linux-mm@kvack.org,
        luto@kernel.org, mhocko@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        peterz@infradead.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 082/178] x86/vmemmap: optimize for consecutive
 sections in partial populated PMDs
Message-ID: <20210430055722.AValK3kxA%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: x86/vmemmap: optimize for consecutive sections in partial populated PMDs

We can optimize in the case we are adding consecutive sections, so no
memset(PAGE_UNUSED) is needed.

In that case, let us keep track where the unused range of the previous
memory range begins, so we can compare it with start of the range to be
added.  If they are equal, we know sections are added consecutively.

For that purpose, let us introduce 'unused_pmd_start', which always holds
the beginning of the unused memory range.

In the case a section does not contiguously follow the previous one, we
know we can memset [unused_pmd_start, PMD_BOUNDARY) with PAGE_UNUSE.

This patch is based on a similar patch by David Hildenbrand:

https://lore.kernel.org/linux-mm/20200722094558.9828-10-david@redhat.com/

Link: https://lkml.kernel.org/r/20210309214050.4674-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
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

 arch/x86/mm/init_64.c |   67 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 61 insertions(+), 6 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds
+++ a/arch/x86/mm/init_64.c
@@ -829,17 +829,42 @@ void __init paging_init(void)
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 #define PAGE_UNUSED 0xFD
 
+/*
+ * The unused vmemmap range, which was not yet memset(PAGE_UNUSED), ranges
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
+#ifdef CONFIG_MEMORY_HOTPLUG
 /* Returns true if the PMD is completely unused and thus it can be freed */
 static bool __meminit vmemmap_pmd_is_unused(unsigned long addr, unsigned long end)
 {
 	unsigned long start = ALIGN_DOWN(addr, PMD_SIZE);
 
+	/*
+	 * Flush the unused range cache to ensure that memchr_inv() will work
+	 * for the whole range.
+	 */
+	vmemmap_flush_unused_pmd();
 	memset((void *)addr, PAGE_UNUSED, end - addr);
 
 	return !memchr_inv((void *)start, PAGE_UNUSED, PMD_SIZE);
 }
+#endif
 
-static void __meminit vmemmap_use_sub_pmd(unsigned long start)
+static void __meminit __vmemmap_use_sub_pmd(unsigned long start)
 {
 	/*
 	 * As we expect to add in the same granularity as we remove, it's
@@ -851,23 +876,53 @@ static void __meminit vmemmap_use_sub_pm
 	memset((void *)start, 0, sizeof(struct page));
 }
 
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
+	/*
+	 * If the range does not contiguously follows previous one, make sure
+	 * to mark the unused range of the previous one so it can be removed.
+	 */
+	vmemmap_flush_unused_pmd();
+	__vmemmap_use_sub_pmd(start);
+}
+
+
 static void __meminit vmemmap_use_new_sub_pmd(unsigned long start, unsigned long end)
 {
+	vmemmap_flush_unused_pmd();
+
 	/*
 	 * Could be our memmap page is filled with PAGE_UNUSED already from a
 	 * previous remove. Make sure to reset it.
 	 */
-	vmemmap_use_sub_pmd(start);
+	__vmemmap_use_sub_pmd(start);
 
 	/*
 	 * Mark with PAGE_UNUSED the unused parts of the new memmap range
 	 */
 	if (!IS_ALIGNED(start, PMD_SIZE))
 		memset((void *)start, PAGE_UNUSED,
-		        start - ALIGN_DOWN(start, PMD_SIZE));
+			start - ALIGN_DOWN(start, PMD_SIZE));
+
+	/*
+	 * We want to avoid memset(PAGE_UNUSED) when populating the vmemmap of
+	 * consecutive sections. Remember for the last added PMD where the
+	 * unused range begins.
+	 */
 	if (!IS_ALIGNED(end, PMD_SIZE))
-		memset((void *)end, PAGE_UNUSED,
-		        ALIGN(end, PMD_SIZE) - end);
+		unused_pmd_start = end;
 }
 #endif
 
@@ -1538,7 +1593,7 @@ static int __meminit vmemmap_populate_hu
 				return -ENOMEM; /* no fallback */
 		} else if (pmd_large(*pmd)) {
 			vmemmap_verify((pte_t *)pmd, node, addr, next);
-			vmemmap_use_sub_pmd(addr);
+			vmemmap_use_sub_pmd(addr, next);
 			continue;
 		}
 		if (vmemmap_populate_basepages(addr, next, node, NULL))
_
