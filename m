Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26902C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:40:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbjBCGkt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbjBCGig (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:38:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1FB8E69F
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A20261DAA
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4509C433D2;
        Fri,  3 Feb 2023 06:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406210;
        bh=OOepmRmqU0vYniWYXq0Ii/mZ4KdHZ9+6cGiMhx3qIfQ=;
        h=Date:To:From:Subject:From;
        b=IESO2dfq98XxN19NcXV0GQPrh/G947R2j69dNfCYMC5GeTVSv13rUToAqHebU7nuf
         eMlzQFIVga/O6smpc5Q7sChUq0tNKgCO1RXU8SqprB6y7xqHMObBC0V/iYnd/VEXd9
         K96nA5JxRrZIYVr9HQbjEpnfttR1uF2wLOfh8Wqg=
Date:   Thu, 02 Feb 2023 22:36:50 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, dave.hansen@linux.intel.com, bp@alien8.de,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-support-__have_arch_pte_swp_exclusive-also-on-32bit.patch removed from -mm tree
Message-Id: <20230203063650.B4509C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE also on 32bit
has been removed from the -mm tree.  Its filename was
     x86-mm-support-__have_arch_pte_swp_exclusive-also-on-32bit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: x86/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE also on 32bit
Date: Fri, 13 Jan 2023 18:10:24 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE just like we already do on
x86-64.  After deciphering the PTE layout it becomes clear that there are
still unused bits for 2-level and 3-level page tables that we should be
able to use.  Reusing a bit avoids stealing one bit from the swap offset.

While at it, mask the type in __swp_entry(); use some helper definitions
to make the macros easier to grasp.

Link: https://lkml.kernel.org/r/20230113171026.582290-25-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/x86/include/asm/pgtable-2level.h~x86-mm-support-__have_arch_pte_swp_exclusive-also-on-32bit
+++ a/arch/x86/include/asm/pgtable-2level.h
@@ -80,21 +80,37 @@ static inline unsigned long pte_bitop(un
 	return ((value >> rightshift) & mask) << leftshift;
 }
 
-/* Encode and de-code a swap entry */
+/*
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
+ * Format of swap PTEs:
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   <----------------- offset ------------------> 0 E <- type --> 0
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
+ */
 #define SWP_TYPE_BITS 5
+#define _SWP_TYPE_MASK ((1U << SWP_TYPE_BITS) - 1)
+#define _SWP_TYPE_SHIFT (_PAGE_BIT_PRESENT + 1)
 #define SWP_OFFSET_SHIFT (_PAGE_BIT_PROTNONE + 1)
 
-#define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > SWP_TYPE_BITS)
+#define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > 5)
 
-#define __swp_type(x)			(((x).val >> (_PAGE_BIT_PRESENT + 1)) \
-					 & ((1U << SWP_TYPE_BITS) - 1))
+#define __swp_type(x)			(((x).val >> _SWP_TYPE_SHIFT) \
+					 & _SWP_TYPE_MASK)
 #define __swp_offset(x)			((x).val >> SWP_OFFSET_SHIFT)
 #define __swp_entry(type, offset)	((swp_entry_t) { \
-					 ((type) << (_PAGE_BIT_PRESENT + 1)) \
+					 (((type) & _SWP_TYPE_MASK) << _SWP_TYPE_SHIFT) \
 					 | ((offset) << SWP_OFFSET_SHIFT) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { (pte).pte_low })
 #define __swp_entry_to_pte(x)		((pte_t) { .pte = (x).val })
 
+/* We borrow bit 7 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	_PAGE_PSE
+
 /* No inverted PFNs on 2 level page tables */
 
 static inline u64 protnone_mask(u64 val)
--- a/arch/x86/include/asm/pgtable-3level.h~x86-mm-support-__have_arch_pte_swp_exclusive-also-on-32bit
+++ a/arch/x86/include/asm/pgtable-3level.h
@@ -145,8 +145,24 @@ static inline pmd_t pmdp_establish(struc
 }
 #endif
 
-/* Encode and de-code a swap entry */
+/*
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
+ * Format of swap PTEs:
+ *
+ *   6 6 6 6 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 3 3
+ *   3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2
+ *   < type -> <---------------------- offset ----------------------
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   --------------------------------------------> 0 E 0 0 0 0 0 0 0
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
+ */
 #define SWP_TYPE_BITS		5
+#define _SWP_TYPE_MASK ((1U << SWP_TYPE_BITS) - 1)
 
 #define SWP_OFFSET_FIRST_BIT	(_PAGE_BIT_PROTNONE + 1)
 
@@ -154,9 +170,10 @@ static inline pmd_t pmdp_establish(struc
 #define SWP_OFFSET_SHIFT	(SWP_OFFSET_FIRST_BIT + SWP_TYPE_BITS)
 
 #define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > SWP_TYPE_BITS)
-#define __swp_type(x)			(((x).val) & ((1UL << SWP_TYPE_BITS) - 1))
+#define __swp_type(x)			(((x).val) & _SWP_TYPE_MASK)
 #define __swp_offset(x)			((x).val >> SWP_TYPE_BITS)
-#define __swp_entry(type, offset)	((swp_entry_t){(type) | (offset) << SWP_TYPE_BITS})
+#define __swp_entry(type, offset)	((swp_entry_t){((type) & _SWP_TYPE_MASK) \
+					| (offset) << SWP_TYPE_BITS})
 
 /*
  * Normally, __swp_entry() converts from arch-independent swp_entry_t to
@@ -184,6 +201,9 @@ static inline pmd_t pmdp_establish(struc
 #define __pte_to_swp_entry(pte)	(__swp_entry(__pteval_swp_type(pte), \
 					     __pteval_swp_offset(pte)))
 
+/* We borrow bit 7 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	_PAGE_PSE
+
 #include <asm/pgtable-invert.h>
 
 #endif /* _ASM_X86_PGTABLE_3LEVEL_H */
--- a/arch/x86/include/asm/pgtable.h~x86-mm-support-__have_arch_pte_swp_exclusive-also-on-32bit
+++ a/arch/x86/include/asm/pgtable.h
@@ -1299,7 +1299,6 @@ static inline void update_mmu_cache_pud(
 		unsigned long addr, pud_t *pud)
 {
 }
-#ifdef _PAGE_SWP_EXCLUSIVE
 #define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
 static inline pte_t pte_swp_mkexclusive(pte_t pte)
 {
@@ -1315,7 +1314,6 @@ static inline pte_t pte_swp_clear_exclus
 {
 	return pte_clear_flags(pte, _PAGE_SWP_EXCLUSIVE);
 }
-#endif /* _PAGE_SWP_EXCLUSIVE */
 
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
_

Patches currently in -mm which might be from david@redhat.com are


