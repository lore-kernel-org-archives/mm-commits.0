Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ECACC2B9F4
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 04:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 263E261026
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 04:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhFQEGS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Jun 2021 00:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229565AbhFQEGP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Jun 2021 00:06:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A287B613E2;
        Thu, 17 Jun 2021 04:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623902642;
        bh=KbC7sbqbxG1pKvcsWQ6GMe3MMBATj4vaWf4RoxmpuKc=;
        h=Date:From:To:Subject:From;
        b=alEkki675qTU9IwsBQPiQTIJx5hvXlzjMkIxohaE19oxot/DkqW3FttiLisr6QopB
         dOL2Fc0j98svc+Fh6nZUUEPN81ypLDBlqjpRlFkMMpl5NdNFfObF/chkeMKa9ZBr/P
         oEldC6lLQl7X1I+cNZErKliez/AJDBzgcTg0qkFc=
Date:   Wed, 16 Jun 2021 21:04:01 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        hughd@google.com, joel@joelfernandes.org, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com, sfr@canb.auug.org.au
Subject:  +
 mm-mremap-convert-huge-pud-move-to-separate-helper.patch added to -mm tree
Message-ID: <20210617040401.6bOfV5nyf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: convert huge PUD move to separate helper
has been added to the -mm tree.  Its filename is
     mm-mremap-convert-huge-pud-move-to-separate-helper.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-convert-huge-pud-move-to-separate-helper.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-convert-huge-pud-move-to-separate-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/mremap: convert huge PUD move to separate helper

With TRANSPARENT_HUGEPAGE_PUD enabled the kernel can find huge PUD
entries.  Add a helper to move huge PUD entries on mremap().

This will be used by a later patch to optimize mremap of PUD_SIZE aligned
level 4 PTE mapped address

This also make sure we support mremap on huge PUD entries even with
CONFIG_HAVE_MOVE_PUD disabled.

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

 mm/mremap.c |   79 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 72 insertions(+), 7 deletions(-)

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
@@ -395,6 +447,11 @@ static bool move_pgt_entry(enum pgt_entr
 			move_huge_pmd(vma, old_addr, new_addr, old_entry,
 				      new_entry);
 		break;
+	case HPAGE_PUD:
+		moved = move_huge_pud(vma, old_addr, new_addr, old_entry,
+				      new_entry);
+		break;
+
 	default:
 		WARN_ON_ONCE(1);
 		break;
@@ -414,6 +471,7 @@ unsigned long move_page_tables(struct vm
 	unsigned long extent, old_end;
 	struct mmu_notifier_range range;
 	pmd_t *old_pmd, *new_pmd;
+	pud_t *old_pud, *new_pud;
 
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
@@ -429,15 +487,22 @@ unsigned long move_page_tables(struct vm
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

mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t.patch
mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch
selftest-mremap_test-update-the-test-to-handle-pagesize-other-than-4k.patch
selftest-mremap_test-avoid-crash-with-static-build.patch
mm-mremap-convert-huge-pud-move-to-separate-helper.patch
mm-mremap-dont-enable-optimized-pud-move-if-page-table-levels-is-2.patch
mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch
mm-mremap-hold-the-rmap-lock-in-write-mode-when-moving-page-table-entries.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-book3s64-mm-update-flush_tlb_range-to-flush-page-walk-cache.patch
powerpc-mm-enable-have_move_pmd-support.patch

