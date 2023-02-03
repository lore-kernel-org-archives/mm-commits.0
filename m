Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6264FC64EC5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjBCGii (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjBCGhI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:37:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77198DAFF
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6235661DA8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF340C433EF;
        Fri,  3 Feb 2023 06:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406193;
        bh=ykc/LF5PgGioQUPveXt8l/ezYjj6p7rbyhv/ZPVgzwg=;
        h=Date:To:From:Subject:From;
        b=VTWKaAIdMNtFA0podrVVgLoUmC9qsnxMzm6FQT1AkqHn8HNfRvsNzUmvUyg4+QmQQ
         OQDP9kWyFp0xXgJhiVYH2KxBjrqHINhFqoCIwoPiGulEKgap/W0miiQMEaPBQFeMTl
         9SIX0m7slT6WD4Zb1uloHeqiFwnKYmJupNSoiFTU=
Date:   Thu, 02 Feb 2023 22:36:33 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ia64-mm-support-__have_arch_pte_swp_exclusive.patch removed from -mm tree
Message-Id: <20230203063633.BF340C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been removed from the -mm tree.  Its filename was
     ia64-mm-support-__have_arch_pte_swp_exclusive.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: ia64/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
Date: Fri, 13 Jan 2023 18:10:07 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE by stealing one bit from the
type.  Generic MM currently only uses 5 bits for the type
(MAX_SWAPFILES_SHIFT), so the stolen bit is effectively unused.

While at it, also mask the type in __swp_entry().

Link: https://lkml.kernel.org/r/20230113171026.582290-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/ia64/include/asm/pgtable.h~ia64-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/ia64/include/asm/pgtable.h
@@ -58,6 +58,9 @@
 #define _PAGE_ED		(__IA64_UL(1) << 52)	/* exception deferral */
 #define _PAGE_PROTNONE		(__IA64_UL(1) << 63)
 
+/* We borrow bit 7 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	(1 << 7)
+
 #define _PFN_MASK		_PAGE_PPN_MASK
 /* Mask of bits which may be changed by pte_modify(); the odd bits are there for _PAGE_PROTNONE */
 #define _PAGE_CHG_MASK	(_PAGE_P | _PAGE_PROTNONE | _PAGE_PL_MASK | _PAGE_AR_MASK | _PAGE_ED)
@@ -399,6 +402,9 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD
 extern void paging_init (void);
 
 /*
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
  * Note: The macros below rely on the fact that MAX_SWAPFILES_SHIFT <= number of
  *	 bits in the swap-type field of the swap pte.  It would be nice to
  *	 enforce that, but we can't easily include <linux/swap.h> here.
@@ -406,16 +412,36 @@ extern void paging_init (void);
  *
  * Format of swap pte:
  *	bit   0   : present bit (must be zero)
- *	bits  1- 7: swap-type
+ *	bits  1- 6: swap type
+ *	bit   7   : exclusive marker
  *	bits  8-62: swap offset
  *	bit  63   : _PAGE_PROTNONE bit
  */
-#define __swp_type(entry)		(((entry).val >> 1) & 0x7f)
+#define __swp_type(entry)		(((entry).val >> 1) & 0x3f)
 #define __swp_offset(entry)		(((entry).val << 1) >> 9)
-#define __swp_entry(type,offset)	((swp_entry_t) { ((type) << 1) | ((long) (offset) << 8) })
+#define __swp_entry(type, offset)	((swp_entry_t) { ((type & 0x3f) << 1) | \
+							 ((long) (offset) << 8) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
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
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
_

Patches currently in -mm which might be from david@redhat.com are


