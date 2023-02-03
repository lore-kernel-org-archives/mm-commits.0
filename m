Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15F6C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjBCGju (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjBCGiP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:38:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE20C4C0F1
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B76861D99
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01BEC433EF;
        Fri,  3 Feb 2023 06:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406205;
        bh=CPJjHVRlbot+5xqbOcRroQETzy/zYLoJiTW9ly7BpUk=;
        h=Date:To:From:Subject:From;
        b=KD9hPTCvd/cZr3vgZzLvt78admkOhg+Kptou8BSn08aSHoiKo7JM2unjr779sbSRM
         MnBY+onw9YYYlGnkTo/d57fKDnJRChcocklgMVFkKcWtW+gdh0WjgszDhT+fK/eK3d
         u8bXFU7fqQe8X5y1NlJoBqZ/M4S/Cqx/ag5OOCmo=
Date:   Thu, 02 Feb 2023 22:36:45 -0800
To:     mm-commits@vger.kernel.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-mm-support-__have_arch_pte_swp_exclusive.patch removed from -mm tree
Message-Id: <20230203063645.B01BEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: riscv/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been removed from the -mm tree.  Its filename was
     riscv-mm-support-__have_arch_pte_swp_exclusive.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: riscv/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
Date: Fri, 13 Jan 2023 18:10:19 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE by stealing one bit from the
offset.  This reduces the maximum swap space per file: on 32bit to 16 GiB
(was 32 GiB).

Note that this bit does not conflict with swap PMDs and could also be used
in swap PMD context later.

While at it, mask the type in __swp_entry().

Link: https://lkml.kernel.org/r/20230113171026.582290-20-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/riscv/include/asm/pgtable-bits.h~riscv-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/riscv/include/asm/pgtable-bits.h
@@ -27,6 +27,9 @@
  */
 #define _PAGE_PROT_NONE _PAGE_GLOBAL
 
+/* Used for swap PTEs only. */
+#define _PAGE_SWP_EXCLUSIVE _PAGE_ACCESSED
+
 #define _PAGE_PFN_SHIFT 10
 
 /*
--- a/arch/riscv/include/asm/pgtable.h~riscv-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/riscv/include/asm/pgtable.h
@@ -724,16 +724,18 @@ static inline pmd_t pmdp_establish(struc
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /*
- * Encode and decode a swap entry
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
  *
  * Format of swap PTE:
  *	bit            0:	_PAGE_PRESENT (zero)
  *	bit       1 to 3:       _PAGE_LEAF (zero)
  *	bit            5:	_PAGE_PROT_NONE (zero)
- *	bits      6 to 10:	swap type
- *	bits 10 to XLEN-1:	swap offset
+ *	bit            6:	exclusive marker
+ *	bits      7 to 11:	swap type
+ *	bits 11 to XLEN-1:	swap offset
  */
-#define __SWP_TYPE_SHIFT	6
+#define __SWP_TYPE_SHIFT	7
 #define __SWP_TYPE_BITS		5
 #define __SWP_TYPE_MASK		((1UL << __SWP_TYPE_BITS) - 1)
 #define __SWP_OFFSET_SHIFT	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT)
@@ -744,11 +746,28 @@ static inline pmd_t pmdp_establish(struc
 #define __swp_type(x)	(((x).val >> __SWP_TYPE_SHIFT) & __SWP_TYPE_MASK)
 #define __swp_offset(x)	((x).val >> __SWP_OFFSET_SHIFT)
 #define __swp_entry(type, offset) ((swp_entry_t) \
-	{ ((type) << __SWP_TYPE_SHIFT) | ((offset) << __SWP_OFFSET_SHIFT) })
+	{ (((type) & __SWP_TYPE_MASK) << __SWP_TYPE_SHIFT) | \
+	  ((offset) << __SWP_OFFSET_SHIFT) })
 
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
+	return __pte(pte_val(pte) | _PAGE_SWP_EXCLUSIVE);
+}
+
+static inline pte_t pte_swp_clear_exclusive(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~_PAGE_SWP_EXCLUSIVE);
+}
+
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 #define __pmd_to_swp_entry(pmd) ((swp_entry_t) { pmd_val(pmd) })
 #define __swp_entry_to_pmd(swp) __pmd((swp).val)
_

Patches currently in -mm which might be from david@redhat.com are


