Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BAABC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbjBCGiw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbjBCGhW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:37:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758AE8E048
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13EE8B82983
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72C8C433D2;
        Fri,  3 Feb 2023 06:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406197;
        bh=olS3Tu7Y2lBSzD52joNmZ7c7hUHvo92QKLvt86qy7tw=;
        h=Date:To:From:Subject:From;
        b=iyJnbrwF+iLRtdyObpqPynZ8QiwyQdBYDqhEF4gQUd250fikqH9lj5nI9BxT8To7R
         ZA0vnxz96KOJiUkjVlXlyiRtt5egzfzhBJpNgWOOqwNOsecwnquZWlHScWNsxXvas8
         yl6kcMu3M+FCmKv0fIWahPLX8XB7G6z3rQLGpkxw=
Date:   Thu, 02 Feb 2023 22:36:37 -0800
To:     mm-commits@vger.kernel.org, monstr@monstr.eu, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] microblaze-mm-support-__have_arch_pte_swp_exclusive.patch removed from -mm tree
Message-Id: <20230203063637.A72C8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: microblaze/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been removed from the -mm tree.  Its filename was
     microblaze-mm-support-__have_arch_pte_swp_exclusive.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: microblaze/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
Date: Fri, 13 Jan 2023 18:10:11 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE by stealing one bit from the
type.  Generic MM currently only uses 5 bits for the type
(MAX_SWAPFILES_SHIFT), so the stolen bit is effectively unused.

The shift by 2 when converting between PTE and arch-specific swap entry
makes the swap PTE layout a little bit harder to decipher.

While at it, drop the comment from paulus---copy-and-paste leftover from
powerpc where we actually have _PAGE_HASHPTE---and mask the type in
__swp_entry_to_pte() as well.

Link: https://lkml.kernel.org/r/20230113171026.582290-12-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/m68k/include/asm/mcf_pgtable.h~microblaze-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/m68k/include/asm/mcf_pgtable.h
@@ -46,8 +46,8 @@
 #define _CACHEMASK040		(~0x060)
 #define _PAGE_GLOBAL040		0x400   /* 68040 global bit, used for kva descs */
 
-/* We borrow bit 7 to store the exclusive marker in swap PTEs. */
-#define _PAGE_SWP_EXCLUSIVE	0x080
+/* We borrow bit 24 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	CF_PAGE_NOCACHE
 
 /*
  * Externally used page protection values.
--- a/arch/microblaze/include/asm/pgtable.h~microblaze-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/microblaze/include/asm/pgtable.h
@@ -131,10 +131,10 @@ extern pte_t *va_to_pte(unsigned long ad
  * of the 16 available.  Bit 24-26 of the TLB are cleared in the TLB
  * miss handler.  Bit 27 is PAGE_USER, thus selecting the correct
  * zone.
- * - PRESENT *must* be in the bottom two bits because swap cache
- * entries use the top 30 bits.  Because 4xx doesn't support SMP
- * anyway, M is irrelevant so we borrow it for PAGE_PRESENT.  Bit 30
- * is cleared in the TLB miss handler before the TLB entry is loaded.
+ * - PRESENT *must* be in the bottom two bits because swap PTEs use the top
+ * 30 bits.  Because 4xx doesn't support SMP anyway, M is irrelevant so we
+ * borrow it for PAGE_PRESENT.  Bit 30 is cleared in the TLB miss handler
+ * before the TLB entry is loaded.
  * - All other bits of the PTE are loaded into TLBLO without
  *  * modification, leaving us only the bits 20, 21, 24, 25, 26, 30 for
  * software PTE bits.  We actually use bits 21, 24, 25, and
@@ -155,6 +155,9 @@ extern pte_t *va_to_pte(unsigned long ad
 #define _PAGE_ACCESSED	0x400	/* software: R: page referenced */
 #define _PMD_PRESENT	PAGE_MASK
 
+/* We borrow bit 24 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	_PAGE_DIRTY
+
 /*
  * Some bits are unused...
  */
@@ -393,18 +396,40 @@ static inline unsigned long pmd_page_vad
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
 /*
- * Encode and decode a swap entry.
- * Note that the bits we use in a PTE for representing a swap entry
- * must not include the _PAGE_PRESENT bit, or the _PAGE_HASHPTE bit
- * (if used).  -- paulus
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
+ *                         1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3
+ *   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ *   <------------------ offset -------------------> E < type -> 0 0
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
  */
-#define __swp_type(entry)		((entry).val & 0x3f)
+#define __swp_type(entry)	((entry).val & 0x1f)
 #define __swp_offset(entry)	((entry).val >> 6)
 #define __swp_entry(type, offset) \
-		((swp_entry_t) { (type) | ((offset) << 6) })
+		((swp_entry_t) { ((type) & 0x1f) | ((offset) << 6) })
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) >> 2 })
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val << 2 })
 
+#define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pte_t pte_swp_mkexclusive(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_SWP_EXCLUSIVE;
+	return pte;
+}
+
+static inline pte_t pte_swp_clear_exclusive(pte_t pte)
+{
+	pte_val(pte) &= ~_PAGE_SWP_EXCLUSIVE;
+	return pte;
+}
+
 extern unsigned long iopa(unsigned long addr);
 
 /* Values for nocacheflag and cmode */
_

Patches currently in -mm which might be from david@redhat.com are


