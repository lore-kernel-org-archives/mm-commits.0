Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90564C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbjBCGjb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbjBCGh3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:37:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7198E498
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFBDAB82988
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D65C4339B;
        Fri,  3 Feb 2023 06:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406201;
        bh=s5Q4j06toAN/Mrbyt3j670aKDN2Hhrmj5YT5TahgEKY=;
        h=Date:To:From:Subject:From;
        b=sppUYWVsIXDSQ47EQ10gplvuQjsSHTmcEpqVdjECtpm7w0Gf08jc1+t3kUr94GMHh
         1Z37GoXB5NibNsKzfr0wv5Tr3aZE45vOFo8Wk22Tc3Lxa0kHL9v9awCkGh84sQsHC4
         tnGvMRej4iMYpDn7ZczelQ2t8M9w60DcRb1E5+s8=
Date:   Thu, 02 Feb 2023 22:36:41 -0800
To:     mm-commits@vger.kernel.org, stefan.kristiansson@saunalahti.fi,
        shorne@gmail.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] openrisc-mm-support-__have_arch_pte_swp_exclusive.patch removed from -mm tree
Message-Id: <20230203063641.98D65C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: openrisc/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been removed from the -mm tree.  Its filename was
     openrisc-mm-support-__have_arch_pte_swp_exclusive.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: openrisc/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
Date: Fri, 13 Jan 2023 18:10:15 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE by stealing one bit from the
type.  Generic MM currently only uses 5 bits for the type
(MAX_SWAPFILES_SHIFT), so the stolen bit is effectively unused.

While at it, mask the type in __swp_entry().

Link: https://lkml.kernel.org/r/20230113171026.582290-16-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/openrisc/include/asm/pgtable.h~openrisc-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/openrisc/include/asm/pgtable.h
@@ -154,6 +154,9 @@ extern void paging_init(void);
 #define _KERNPG_TABLE \
 	(_PAGE_BASE | _PAGE_SRE | _PAGE_SWE | _PAGE_ACCESSED | _PAGE_DIRTY)
 
+/* We borrow bit 11 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	_PAGE_U_SHARED
+
 #define PAGE_NONE       __pgprot(_PAGE_ALL)
 #define PAGE_READONLY   __pgprot(_PAGE_ALL | _PAGE_URE | _PAGE_SRE)
 #define PAGE_READONLY_X __pgprot(_PAGE_ALL | _PAGE_URE | _PAGE_SRE | _PAGE_EXEC)
@@ -385,16 +388,44 @@ static inline void update_mmu_cache(stru
 
 /* __PHX__ FIXME, SWAP, this probably doesn't work */
 
-/* Encode and de-code a swap entry (must be !pte_none(e) && !pte_present(e)) */
-/* Since the PAGE_PRESENT bit is bit 4, we can use the bits above */
-
-#define __swp_type(x)			(((x).val >> 5) & 0x7f)
+/*
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
+ * Format of swap PTEs:
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   <-------------- offset ---------------> E <- type --> 0 0 0 0 0
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
+ *   The zero'ed bits include _PAGE_PRESENT.
+ */
+#define __swp_type(x)			(((x).val >> 5) & 0x3f)
 #define __swp_offset(x)			((x).val >> 12)
 #define __swp_entry(type, offset) \
-	((swp_entry_t) { ((type) << 5) | ((offset) << 12) })
+	((swp_entry_t) { (((type) & 0x3f) << 5) | ((offset) << 12) })
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
 typedef pte_t *pte_addr_t;
 
 #endif /* __ASSEMBLY__ */
_

Patches currently in -mm which might be from david@redhat.com are


