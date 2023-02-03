Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 905E6C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbjBCGiw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjBCGh0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:37:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE3D8E04E
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5A455CE2EC5
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2F8C433EF;
        Fri,  3 Feb 2023 06:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406196;
        bh=dG1ck9brJ2+XtK9mEJhDXLcIvE38GDzQGaTEdLMFOrE=;
        h=Date:To:From:Subject:From;
        b=sSbkVU77YmLbhCulMIJuo22LM1eqhMxzcDqJxL1itxX8x0ek5XJwJJfa+LuKrqdwl
         r+FGWURRpBFC/gWADGVuruOQia3pyLweU8EDjBYv2ki0PZj2GV6TFwlQEw4ozTtlXa
         90/kIDAYrCzXaL6+KqtydquFzx9fyrd+PRRK6dh8=
Date:   Thu, 02 Feb 2023 22:36:36 -0800
To:     mm-commits@vger.kernel.org, gerg@linux-m68k.org,
        geert@linux-m68k.org, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] m68k-mm-support-__have_arch_pte_swp_exclusive.patch removed from -mm tree
Message-Id: <20230203063636.AE2F8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: m68k/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been removed from the -mm tree.  Its filename was
     m68k-mm-support-__have_arch_pte_swp_exclusive.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: m68k/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
Date: Fri, 13 Jan 2023 18:10:10 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE by stealing one bit from the
type.  Generic MM currently only uses 5 bits for the type
(MAX_SWAPFILES_SHIFT), so the stolen bit is effectively unused.

While at it, make sure for sun3 that the valid bit never gets set by
properly masking it off and mask the type in __swp_entry().

Link: https://lkml.kernel.org/r/20230113171026.582290-11-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/m68k/include/asm/mcf_pgtable.h~m68k-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/m68k/include/asm/mcf_pgtable.h
@@ -46,6 +46,9 @@
 #define _CACHEMASK040		(~0x060)
 #define _PAGE_GLOBAL040		0x400   /* 68040 global bit, used for kva descs */
 
+/* We borrow bit 7 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	0x080
+
 /*
  * Externally used page protection values.
  */
@@ -254,15 +257,42 @@ static inline pte_t pte_mkcache(pte_t pt
 extern pgd_t kernel_pg_dir[PTRS_PER_PGD];
 
 /*
- * Encode and de-code a swap entry (must be !pte_none(e) && !pte_present(e))
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
+ * Format of swap PTEs:
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   <------------------ offset -------------> 0 0 0 E <-- type --->
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
  */
-#define __swp_type(x)		((x).val & 0xFF)
+#define __swp_type(x)		((x).val & 0x7f)
 #define __swp_offset(x)		((x).val >> 11)
-#define __swp_entry(typ, off)	((swp_entry_t) { (typ) | \
+#define __swp_entry(typ, off)	((swp_entry_t) { ((typ) & 0x7f) | \
 					(off << 11) })
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	(__pte((x).val))
 
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
 #define pmd_pfn(pmd)		(pmd_val(pmd) >> PAGE_SHIFT)
 #define pmd_page(pmd)		(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
 
--- a/arch/m68k/include/asm/motorola_pgtable.h~m68k-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/m68k/include/asm/motorola_pgtable.h
@@ -41,6 +41,9 @@
 
 #define _PAGE_PROTNONE	0x004
 
+/* We borrow bit 11 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	0x800
+
 #ifndef __ASSEMBLY__
 
 /* This is the cache mode to be used for pages containing page descriptors for
@@ -169,12 +172,41 @@ static inline pte_t pte_mkcache(pte_t pt
 #define swapper_pg_dir kernel_pg_dir
 extern pgd_t kernel_pg_dir[128];
 
-/* Encode and de-code a swap entry (must be !pte_none(e) && !pte_present(e)) */
-#define __swp_type(x)		(((x).val >> 4) & 0xff)
+/*
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
+ * Format of swap PTEs:
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   <----------------- offset ------------> E <-- type ---> 0 0 0 0
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
+ */
+#define __swp_type(x)		(((x).val >> 4) & 0x7f)
 #define __swp_offset(x)		((x).val >> 12)
-#define __swp_entry(type, offset) ((swp_entry_t) { ((type) << 4) | ((offset) << 12) })
+#define __swp_entry(type, offset) ((swp_entry_t) { (((type) & 0x7f) << 4) | ((offset) << 12) })
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
 
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
 #endif	/* !__ASSEMBLY__ */
 #endif /* _MOTOROLA_PGTABLE_H */
--- a/arch/m68k/include/asm/sun3_pgtable.h~m68k-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/m68k/include/asm/sun3_pgtable.h
@@ -71,6 +71,9 @@
 #define SUN3_PMD_MASK	(0x0000003F)
 #define SUN3_PMD_MAGIC	(0x0000002B)
 
+/* We borrow bit 6 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	0x040
+
 #ifndef __ASSEMBLY__
 
 /*
@@ -152,12 +155,42 @@ static inline pte_t pte_mkcache(pte_t pt
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern pgd_t kernel_pg_dir[PTRS_PER_PGD];
 
-/* Macros to (de)construct the fake PTEs representing swap pages. */
-#define __swp_type(x)		((x).val & 0x7F)
+/*
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
+ * Format of swap PTEs:
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   0 <--------------------- offset ----------------> E <- type -->
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
+ */
+#define __swp_type(x)		((x).val & 0x3f)
 #define __swp_offset(x)		(((x).val) >> 7)
-#define __swp_entry(type,offset) ((swp_entry_t) { ((type) | ((offset) << 7)) })
+#define __swp_entry(type, offset) ((swp_entry_t) { (((type) & 0x3f) | \
+						   (((offset) << 7) & ~SUN3_PAGE_VALID)) })
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
 
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
 #endif	/* !__ASSEMBLY__ */
 #endif	/* !_SUN3_PGTABLE_H */
_

Patches currently in -mm which might be from david@redhat.com are


