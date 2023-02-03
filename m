Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630F5C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbjBCGi3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbjBCGgq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD788DAE2
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65AAC61DA6
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88C0C4339B;
        Fri,  3 Feb 2023 06:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406189;
        bh=0eaVFyF/ofndldOB0R4YsiHLdFWo27xSLi4uWQ9YhWs=;
        h=Date:To:From:Subject:From;
        b=FUkSoTBHeetfGbkvFRzBqR7TyWbaQWl5cURtAn/qu4G3XYwr7OT61VBk13ZKl3srT
         g6oQNJm5Np6ZAvC76GEpX8fk/lp2/miYxfaMp/9LH1fk3tqVM1OylOGgiL9crKDLuF
         p4HqlW3/QTEu5Bgp2PgRn5pnlh65rB8XDyTDnvjQ=
Date:   Thu, 02 Feb 2023 22:36:29 -0800
To:     mm-commits@vger.kernel.org, vgupta@kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arc-mm-support-__have_arch_pte_swp_exclusive.patch removed from -mm tree
Message-Id: <20230203063629.B88C0C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arc/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been removed from the -mm tree.  Its filename was
     arc-mm-support-__have_arch_pte_swp_exclusive.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: arc/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
Date: Fri, 13 Jan 2023 18:10:03 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE by using bit 5, which is yet
unused.  The only important parts seems to be to not use _PAGE_PRESENT
(bit 9).

Link: https://lkml.kernel.org/r/20230113171026.582290-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/arc/include/asm/pgtable-bits-arcv2.h~arc-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/arc/include/asm/pgtable-bits-arcv2.h
@@ -26,6 +26,9 @@
 #define _PAGE_GLOBAL		(1 << 8)  /* ASID agnostic (H) */
 #define _PAGE_PRESENT		(1 << 9)  /* PTE/TLB Valid (H) */
 
+/* We borrow bit 5 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	_PAGE_DIRTY
+
 #ifdef CONFIG_ARC_MMU_V4
 #define _PAGE_HW_SZ		(1 << 10)  /* Normal/super (H) */
 #else
@@ -106,9 +109,18 @@ static inline void set_pte_at(struct mm_
 void update_mmu_cache(struct vm_area_struct *vma, unsigned long address,
 		      pte_t *ptep);
 
-/* Encode swap {type,off} tuple into PTE
- * We reserve 13 bits for 5-bit @type, keeping bits 12-5 zero, ensuring that
- * PAGE_PRESENT is zero in a PTE holding swap "identifier"
+/*
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
+ * Format of swap PTEs:
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   <-------------- offset -------------> <--- zero --> E < type ->
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
+ *   The zero'ed bits include _PAGE_PRESENT.
  */
 #define __swp_entry(type, off)		((swp_entry_t) \
 					{ ((type) & 0x1f) | ((off) << 13) })
@@ -120,6 +132,15 @@ void update_mmu_cache(struct vm_area_str
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
+#define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_SWP_EXCLUSIVE;
+}
+
+PTE_BIT_FUNC(swp_mkexclusive, |= (_PAGE_SWP_EXCLUSIVE));
+PTE_BIT_FUNC(swp_clear_exclusive, &= ~(_PAGE_SWP_EXCLUSIVE));
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #include <asm/hugepage.h>
 #endif
_

Patches currently in -mm which might be from david@redhat.com are


