Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220A9C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF7FD6140E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhEHWmv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:42:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhEHWmu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:42:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE409613C5;
        Sat,  8 May 2021 22:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513708;
        bh=1R62Fm4YoBQ9Z1w6nWn1CX7j5ypq8MmtcTvRDl9SM3c=;
        h=Date:From:To:Subject:From;
        b=Zzh4MHd6LgY/gLD4LsqB+R3fBAeX/wOsZ27aCpvNaGzKKvjMwW3tC6xugm9LTTmhB
         pKxZXKETX0/gh1W+r4yzEqIvNgDMCOZDRchZdAhcoT0Mgu7YZF1+drnDT1w+NxctIa
         dZqbZqi/JyHHEPWRigFJ2CI2oSJGbs9c3ETdzKn8=
Date:   Sat, 08 May 2021 15:41:47 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, dave.hansen@linux.intel.com, david@redhat.com,
        hpa@zytor.com, luto@kernel.org, mhocko@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        peterz@infradead.org, tglx@linutronix.de, ziy@nvidia.com
Subject:  [merged]
 x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch removed from
 -mm tree
Message-ID: <20210508224147.A4FfoMsKE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/vmemmap: drop handling of 4K unaligned vmemmap range
has been removed from the -mm tree.  Its filename was
     x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: x86/vmemmap: drop handling of 4K unaligned vmemmap range

Patch series "Cleanup and fixups for vmemmap handling", v6.

This series contains cleanups to remove dead code that handles unaligned
cases for 4K and 1GB pages (patch#1 and patch#2) when removing the vemmmap
range, and a fix (patch#3) to handle the case when two vmemmap ranges
intersect the same PMD.


This patch (of 4):

remove_pte_table() is prepared to handle the case where either the start
or the end of the range is not PAGE aligned.  This cannot actually happen:

__populate_section_memmap enforces the range to be PMD aligned, so as long
as the size of the struct page remains multiple of 8, the vmemmap range
will be aligned to PAGE_SIZE.

Drop the dead code and place a VM_BUG_ON in vmemmap_{populate,free} to
catch nasty cases.  Note that the VM_BUG_ON is placed in there because
vmemmap_{populate,free= } is the gate of all removing and freeing page
tables logic.

Link: https://lkml.kernel.org/r/20210309214050.4674-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20210309214050.4674-2-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   50 +++++++++++-----------------------------
 1 file changed, 14 insertions(+), 36 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range
+++ a/arch/x86/mm/init_64.c
@@ -962,7 +962,6 @@ remove_pte_table(pte_t *pte_start, unsig
 {
 	unsigned long next, pages = 0;
 	pte_t *pte;
-	void *page_addr;
 	phys_addr_t phys_addr;
 
 	pte = pte_start + pte_index(addr);
@@ -983,42 +982,15 @@ remove_pte_table(pte_t *pte_start, unsig
 		if (phys_addr < (phys_addr_t)0x40000000)
 			return;
 
-		if (PAGE_ALIGNED(addr) && PAGE_ALIGNED(next)) {
-			/*
-			 * Do not free direct mapping pages since they were
-			 * freed when offlining, or simply not in use.
-			 */
-			if (!direct)
-				free_pagetable(pte_page(*pte), 0);
-
-			spin_lock(&init_mm.page_table_lock);
-			pte_clear(&init_mm, addr, pte);
-			spin_unlock(&init_mm.page_table_lock);
-
-			/* For non-direct mapping, pages means nothing. */
-			pages++;
-		} else {
-			/*
-			 * If we are here, we are freeing vmemmap pages since
-			 * direct mapped memory ranges to be freed are aligned.
-			 *
-			 * If we are not removing the whole page, it means
-			 * other page structs in this page are being used and
-			 * we cannot remove them. So fill the unused page_structs
-			 * with 0xFD, and remove the page when it is wholly
-			 * filled with 0xFD.
-			 */
-			memset((void *)addr, PAGE_INUSE, next - addr);
-
-			page_addr = page_address(pte_page(*pte));
-			if (!memchr_inv(page_addr, PAGE_INUSE, PAGE_SIZE)) {
-				free_pagetable(pte_page(*pte), 0);
+		if (!direct)
+			free_pagetable(pte_page(*pte), 0);
 
-				spin_lock(&init_mm.page_table_lock);
-				pte_clear(&init_mm, addr, pte);
-				spin_unlock(&init_mm.page_table_lock);
-			}
-		}
+		spin_lock(&init_mm.page_table_lock);
+		pte_clear(&init_mm, addr, pte);
+		spin_unlock(&init_mm.page_table_lock);
+
+		/* For non-direct mapping, pages means nothing. */
+		pages++;
 	}
 
 	/* Call free_pte_table() in remove_pmd_table(). */
@@ -1197,6 +1169,9 @@ remove_pagetable(unsigned long start, un
 void __ref vmemmap_free(unsigned long start, unsigned long end,
 		struct vmem_altmap *altmap)
 {
+	VM_BUG_ON(!IS_ALIGNED(start, PAGE_SIZE));
+	VM_BUG_ON(!IS_ALIGNED(end, PAGE_SIZE));
+
 	remove_pagetable(start, end, false, altmap);
 }
 
@@ -1556,6 +1531,9 @@ int __meminit vmemmap_populate(unsigned
 {
 	int err;
 
+	VM_BUG_ON(!IS_ALIGNED(start, PAGE_SIZE));
+	VM_BUG_ON(!IS_ALIGNED(end, PAGE_SIZE));
+
 	if (end - start < PAGES_PER_SECTION * sizeof(struct page))
 		err = vmemmap_populate_basepages(start, end, node, NULL);
 	else if (boot_cpu_has(X86_FEATURE_PSE))
_

Patches currently in -mm which might be from osalvador@suse.de are


