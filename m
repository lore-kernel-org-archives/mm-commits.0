Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D273FC07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF175613D6
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhGIVgn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhGIVgm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:36:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9901613D3;
        Fri,  9 Jul 2021 21:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866439;
        bh=n9eQi0BxKSZcHXPW9+c1Yid8imd/iolF0nAe0MQx1Yk=;
        h=Date:From:To:Subject:From;
        b=g0M0EySHlt324lDSK/P+5kd11vaOFdLbm6UDeOCmh6QILcDVsdEsy7r29SZDq/u9l
         oBARUEOZ1txPhRyFZ1fTM7jmfWrqnPw8AW1SR3O6ZEHavwaW7KyObVEXpScjewHVcO
         DRc4M4qY/PsLV8jGroua9be5F/+/eP9ZbS97VL0g=
Date:   Fri, 09 Jul 2021 14:33:58 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        hughd@google.com, joel@joelfernandes.org, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com, sfr@canb.auug.org.au
Subject:  [merged]
 mm-mremap-convert-huge-pud-move-to-separate-helper.patch removed from -mm
 tree
Message-ID: <20210709213358.ioSGjdgyQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: convert huge PUD move to separate helper
has been removed from the -mm tree.  Its filename was
     mm-mremap-convert-huge-pud-move-to-separate-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/mremap: convert huge PUD move to separate helper

With TRANSPARENT_HUGEPAGE_PUD enabled the kernel can find huge PUD
entries.  Add a helper to move huge PUD entries on mremap().

This will be used by a later patch to optimize mremap of PUD_SIZE aligned
level 4 PTE mapped address

This also make sure we support mremap on huge PUD entries even with
CONFIG_HAVE_MOVE_PUD disabled.

[aneesh.kumar@linux.ibm.com: fix build failure with clang-10]
  Link: https://lore.kernel.org/lkml/YMuOSnJsL9qkxweY@archlinux-ax161
  Link: https://lkml.kernel.org/r/20210619134310.89098-1-aneesh.kumar@linux.ibm.com
Link: https://lkml.kernel.org/r/20210616045239.370802-4-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   80 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 73 insertions(+), 7 deletions(-)

--- a/mm/mremap.c~mm-mremap-convert-huge-pud-move-to-separate-helper
+++ a/mm/mremap.c
@@ -324,10 +324,61 @@ static inline bool move_normal_pud(struc
 }
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static bool move_huge_pud(struct vm_area_struct *vma, unsigned long old_addr,
+			  unsigned long new_addr, pud_t *old_pud, pud_t *new_pud)
+{
+	spinlock_t *old_ptl, *new_ptl;
+	struct mm_struct *mm = vma->vm_mm;
+	pud_t pud;
+
+	/*
+	 * The destination pud shouldn't be established, free_pgtables()
+	 * should have released it.
+	 */
+	if (WARN_ON_ONCE(!pud_none(*new_pud)))
+		return false;
+
+	/*
+	 * We don't have to worry about the ordering of src and dst
+	 * ptlocks because exclusive mmap_lock prevents deadlock.
+	 */
+	old_ptl = pud_lock(vma->vm_mm, old_pud);
+	new_ptl = pud_lockptr(mm, new_pud);
+	if (new_ptl != old_ptl)
+		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
+
+	/* Clear the pud */
+	pud = *old_pud;
+	pud_clear(old_pud);
+
+	VM_BUG_ON(!pud_none(*new_pud));
+
+	/* Set the new pud */
+	/* mark soft_ditry when we add pud level soft dirty support */
+	set_pud_at(mm, new_addr, new_pud, pud);
+	flush_pud_tlb_range(vma, old_addr, old_addr + HPAGE_PUD_SIZE);
+	if (new_ptl != old_ptl)
+		spin_unlock(new_ptl);
+	spin_unlock(old_ptl);
+
+	return true;
+}
+#else
+static bool move_huge_pud(struct vm_area_struct *vma, unsigned long old_addr,
+			  unsigned long new_addr, pud_t *old_pud, pud_t *new_pud)
+{
+	WARN_ON_ONCE(1);
+	return false;
+
+}
+#endif
+
 enum pgt_entry {
 	NORMAL_PMD,
 	HPAGE_PMD,
 	NORMAL_PUD,
+	HPAGE_PUD,
 };
 
 /*
@@ -347,6 +398,7 @@ static __always_inline unsigned long get
 		mask = PMD_MASK;
 		size = PMD_SIZE;
 		break;
+	case HPAGE_PUD:
 	case NORMAL_PUD:
 		mask = PUD_MASK;
 		size = PUD_SIZE;
@@ -395,6 +447,12 @@ static bool move_pgt_entry(enum pgt_entr
 			move_huge_pmd(vma, old_addr, new_addr, old_entry,
 				      new_entry);
 		break;
+	case HPAGE_PUD:
+		moved = IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+			move_huge_pud(vma, old_addr, new_addr, old_entry,
+				      new_entry);
+		break;
+
 	default:
 		WARN_ON_ONCE(1);
 		break;
@@ -414,6 +472,7 @@ unsigned long move_page_tables(struct vm
 	unsigned long extent, old_end;
 	struct mmu_notifier_range range;
 	pmd_t *old_pmd, *new_pmd;
+	pud_t *old_pud, *new_pud;
 
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
@@ -429,15 +488,22 @@ unsigned long move_page_tables(struct vm
 		 * PUD level if possible.
 		 */
 		extent = get_extent(NORMAL_PUD, old_addr, old_end, new_addr);
-		if (IS_ENABLED(CONFIG_HAVE_MOVE_PUD) && extent == PUD_SIZE) {
-			pud_t *old_pud, *new_pud;
 
-			old_pud = get_old_pud(vma->vm_mm, old_addr);
-			if (!old_pud)
+		old_pud = get_old_pud(vma->vm_mm, old_addr);
+		if (!old_pud)
+			continue;
+		new_pud = alloc_new_pud(vma->vm_mm, vma, new_addr);
+		if (!new_pud)
+			break;
+		if (pud_trans_huge(*old_pud) || pud_devmap(*old_pud)) {
+			if (extent == HPAGE_PUD_SIZE) {
+				move_pgt_entry(HPAGE_PUD, vma, old_addr, new_addr,
+					       old_pud, new_pud, need_rmap_locks);
+				/* We ignore and continue on error? */
 				continue;
-			new_pud = alloc_new_pud(vma->vm_mm, vma, new_addr);
-			if (!new_pud)
-				break;
+			}
+		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PUD) && extent == PUD_SIZE) {
+
 			if (move_pgt_entry(NORMAL_PUD, vma, old_addr, new_addr,
 					   old_pud, new_pud, need_rmap_locks))
 				continue;
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


