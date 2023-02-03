Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D7FC636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbjBCGig (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbjBCGg7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6236D8DAF9
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15406B82983
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA523C433EF;
        Fri,  3 Feb 2023 06:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406190;
        bh=qL28UvXFNBYth4UQ3vx1+CT3y8Wtz/0DuIMgfHI8bXE=;
        h=Date:To:From:Subject:From;
        b=mullJY6z9sJDiokwbFgtoUsYDaBHkJLLfNpNuzGYweAwH8ulXZeVDVSWzHjxBbLif
         EF8AEc9Ts2/41e72A95zKYrVFXPjzAVA0i8OoAZwy7lOZg2Kpt5mvPYgyv8OhmRvv3
         2pgpwobFVGODIUhsmdrd4UPTvTBi/sqTPbBrhq9c=
Date:   Thu, 02 Feb 2023 22:36:30 -0800
To:     mm-commits@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm-mm-support-__have_arch_pte_swp_exclusive.patch removed from -mm tree
Message-Id: <20230203063630.AA523C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been removed from the -mm tree.  Its filename was
     arm-mm-support-__have_arch_pte_swp_exclusive.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: arm/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
Date: Fri, 13 Jan 2023 18:10:04 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE by stealing one bit from the
offset.  This reduces the maximum swap space per file to 64 GiB (was 128
GiB).

While at it drop the PTE_TYPE_FAULT from __swp_entry_to_pte() which is
defined to be 0 and is rather confusing because we should be dealing with
"Linux PTEs" not "hardware PTEs".  Also, properly mask the type in
__swp_entry().

Link: https://lkml.kernel.org/r/20230113171026.582290-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/arm/include/asm/pgtable-2level.h~arm-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/arm/include/asm/pgtable-2level.h
@@ -126,6 +126,9 @@
 #define L_PTE_SHARED		(_AT(pteval_t, 1) << 10)	/* shared(v6), coherent(xsc3) */
 #define L_PTE_NONE		(_AT(pteval_t, 1) << 11)
 
+/* We borrow bit 7 to store the exclusive marker in swap PTEs. */
+#define L_PTE_SWP_EXCLUSIVE	L_PTE_RDONLY
+
 /*
  * These are the memory types, defined to be compatible with
  * pre-ARMv6 CPUs cacheable and bufferable bits: n/a,n/a,C,B
--- a/arch/arm/include/asm/pgtable-3level.h~arm-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -76,6 +76,9 @@
 #define L_PTE_NONE		(_AT(pteval_t, 1) << 57)	/* PROT_NONE */
 #define L_PTE_RDONLY		(_AT(pteval_t, 1) << 58)	/* READ ONLY */
 
+/* We borrow bit 7 to store the exclusive marker in swap PTEs. */
+#define L_PTE_SWP_EXCLUSIVE	(_AT(pteval_t, 1) << 7)
+
 #define L_PMD_SECT_VALID	(_AT(pmdval_t, 1) << 0)
 #define L_PMD_SECT_DIRTY	(_AT(pmdval_t, 1) << 55)
 #define L_PMD_SECT_NONE		(_AT(pmdval_t, 1) << 57)
--- a/arch/arm/include/asm/pgtable.h~arm-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/arm/include/asm/pgtable.h
@@ -271,27 +271,48 @@ static inline pte_t pte_modify(pte_t pte
 }
 
 /*
- * Encode and decode a swap entry.  Swap entries are stored in the Linux
- * page tables as follows:
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
+ * Format of swap PTEs:
  *
  *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
  *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
- *   <--------------- offset ------------------------> < type -> 0 0
+ *   <------------------- offset ------------------> E < type -> 0 0
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
  *
- * This gives us up to 31 swap files and 128GB per swap file.  Note that
+ * This gives us up to 31 swap files and 64GB per swap file.  Note that
  * the offset field is always non-zero.
  */
 #define __SWP_TYPE_SHIFT	2
 #define __SWP_TYPE_BITS		5
 #define __SWP_TYPE_MASK		((1 << __SWP_TYPE_BITS) - 1)
-#define __SWP_OFFSET_SHIFT	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT)
+#define __SWP_OFFSET_SHIFT	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT + 1)
 
 #define __swp_type(x)		(((x).val >> __SWP_TYPE_SHIFT) & __SWP_TYPE_MASK)
 #define __swp_offset(x)		((x).val >> __SWP_OFFSET_SHIFT)
-#define __swp_entry(type,offset) ((swp_entry_t) { ((type) << __SWP_TYPE_SHIFT) | ((offset) << __SWP_OFFSET_SHIFT) })
+#define __swp_entry(type, offset) ((swp_entry_t) { (((type) & __SWP_TYPE_BITS) << __SWP_TYPE_SHIFT) | \
+						   ((offset) << __SWP_OFFSET_SHIFT) })
 
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
-#define __swp_entry_to_pte(swp)	__pte((swp).val | PTE_TYPE_FAULT)
+#define __swp_entry_to_pte(swp)	__pte((swp).val)
+
+#define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return pte_isset(pte, L_PTE_SWP_EXCLUSIVE);
+}
+
+static inline pte_t pte_swp_mkexclusive(pte_t pte)
+{
+	return set_pte_bit(pte, __pgprot(L_PTE_SWP_EXCLUSIVE));
+}
+
+static inline pte_t pte_swp_clear_exclusive(pte_t pte)
+{
+	return clear_pte_bit(pte, __pgprot(L_PTE_SWP_EXCLUSIVE));
+}
 
 /*
  * It is an error for the kernel to have more swap files than we can
_

Patches currently in -mm which might be from david@redhat.com are


