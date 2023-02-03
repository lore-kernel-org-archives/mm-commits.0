Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D72CC64EC3
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjBCGih (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjBCGhI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:37:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558BE8DAFE
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14949B82984
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4E1C4339B;
        Fri,  3 Feb 2023 06:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406191;
        bh=L54WZlZF9YVJ+4NPo8s6txaSilcvk5pXIFVn04wf4Ao=;
        h=Date:To:From:Subject:From;
        b=lPEMM/qYirAj4VsiZUfINRqrJMburSBqshal4d2jgJX46qsrTwXLczqludiBhO0+I
         0rP2RkuBnR48IkTBzY2Mq/tSI4rY+C6aukc3xmrdVxGMycuzB1b9G0+Gh7g1gvLmik
         Z5h0Z4KtX5VEtaQfQ8mN0KPPl1vF1NnLUbYEwfko=
Date:   Thu, 02 Feb 2023 22:36:31 -0800
To:     mm-commits@vger.kernel.org, guoren@kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] csky-mm-support-__have_arch_pte_swp_exclusive.patch removed from -mm tree
Message-Id: <20230203063631.AF4E1C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: csky/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been removed from the -mm tree.  Its filename was
     csky-mm-support-__have_arch_pte_swp_exclusive.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: csky/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
Date: Fri, 13 Jan 2023 18:10:05 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE by stealing one bit from the
offset.  This reduces the maximum swap space per file to 16 GiB (was 32
GiB).

We might actually be able to reuse one of the other software bits
(_PAGE_READ / PAGE_WRITE) instead, because we only have to keep
pte_present(), pte_none() and HW happy.  For now, let's keep it simple
because there might be something non-obvious.

Link: https://lkml.kernel.org/r/20230113171026.582290-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Guo Ren <guoren@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/csky/abiv1/inc/abi/pgtable-bits.h~csky-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/csky/abiv1/inc/abi/pgtable-bits.h
@@ -10,6 +10,9 @@
 #define _PAGE_ACCESSED		(1<<3)
 #define _PAGE_MODIFIED		(1<<4)
 
+/* We borrow bit 9 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	(1<<9)
+
 /* implemented in hardware */
 #define _PAGE_GLOBAL		(1<<6)
 #define _PAGE_VALID		(1<<7)
@@ -26,7 +29,8 @@
 #define _PAGE_PROT_NONE		_PAGE_READ
 
 /*
- * Encode and decode a swap entry
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
  *
  * Format of swap PTE:
  *     bit          0:    _PAGE_PRESENT (zero)
@@ -35,15 +39,16 @@
  *     bit          6:    _PAGE_GLOBAL (zero)
  *     bit          7:    _PAGE_VALID (zero)
  *     bit          8:    swap type[4]
- *     bit     9 - 31:    swap offset
+ *     bit          9:    exclusive marker
+ *     bit    10 - 31:    swap offset
  */
 #define __swp_type(x)			((((x).val >> 2) & 0xf) | \
 					(((x).val >> 4) & 0x10))
-#define __swp_offset(x)			((x).val >> 9)
+#define __swp_offset(x)			((x).val >> 10)
 #define __swp_entry(type, offset)	((swp_entry_t) { \
 					((type & 0xf) << 2) | \
 					((type & 0x10) << 4) | \
-					((offset) << 9)})
+					((offset) << 10)})
 
 #define HAVE_ARCH_UNMAPPED_AREA
 
--- a/arch/csky/abiv2/inc/abi/pgtable-bits.h~csky-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/csky/abiv2/inc/abi/pgtable-bits.h
@@ -10,6 +10,9 @@
 #define _PAGE_PRESENT		(1<<10)
 #define _PAGE_MODIFIED		(1<<11)
 
+/* We borrow bit 7 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	(1<<7)
+
 /* implemented in hardware */
 #define _PAGE_GLOBAL		(1<<0)
 #define _PAGE_VALID		(1<<1)
@@ -26,23 +29,25 @@
 #define _PAGE_PROT_NONE		_PAGE_WRITE
 
 /*
- * Encode and decode a swap entry
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
  *
  * Format of swap PTE:
  *     bit          0:    _PAGE_GLOBAL (zero)
  *     bit          1:    _PAGE_VALID (zero)
  *     bit      2 - 6:    swap type
- *     bit      7 - 8:    swap offset[0 - 1]
+ *     bit          7:    exclusive marker
+ *     bit          8:    swap offset[0]
  *     bit          9:    _PAGE_WRITE (zero)
  *     bit         10:    _PAGE_PRESENT (zero)
- *     bit    11 - 31:    swap offset[2 - 22]
+ *     bit    11 - 31:    swap offset[1 - 21]
  */
 #define __swp_type(x)			(((x).val >> 2) & 0x1f)
-#define __swp_offset(x)			((((x).val >> 7) & 0x3) | \
-					(((x).val >> 9) & 0x7ffffc))
+#define __swp_offset(x)			((((x).val >> 8) & 0x1) | \
+					(((x).val >> 10) & 0x3ffffe))
 #define __swp_entry(type, offset)	((swp_entry_t) { \
 					((type & 0x1f) << 2) | \
-					((offset & 0x3) << 7) | \
-					((offset & 0x7ffffc) << 9)})
+					((offset & 0x1) << 8) | \
+					((offset & 0x3ffffe) << 10)})
 
 #endif /* __ASM_CSKY_PGTABLE_BITS_H */
--- a/arch/csky/include/asm/pgtable.h~csky-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/csky/include/asm/pgtable.h
@@ -200,6 +200,24 @@ static inline pte_t pte_mkyoung(pte_t pt
 	return pte;
 }
 
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
 #define __HAVE_PHYS_MEM_ACCESS_PROT
 struct file;
 extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
_

Patches currently in -mm which might be from david@redhat.com are


