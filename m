Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533EEC47095
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 22:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36C796109F
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 22:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFGWjE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 18:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230351AbhFGWjC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 18:39:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A52F61185;
        Mon,  7 Jun 2021 22:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623105421;
        bh=KTjHu2OcvD/chyoeLEx8VdTfQyUBxi9IXK6TDyzwyys=;
        h=Date:From:To:Subject:From;
        b=cpKYDy6icVee4pIOqOksL2MEmDaSg5mBOnaHzBhA+f6bEty4b0VB1aEkD08nJQl1t
         ncgtnCEkroCv9XFQMsV+MyGf1R2QvlsmvxbeHsbgkpILAFI4zQIJNfd08upM3EBAko
         9YG5JT+tDqNgp7wFU35ybqXIF9wH62FibaE56juQ=
Date:   Mon, 07 Jun 2021 15:37:01 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        joel@joelfernandes.org, kaleshsingh@google.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject:  [to-be-updated]
 mm-mremap-move-tlb-flush-outside-page-table-lock.patch removed from -mm
 tree
Message-ID: <20210607223701.ghklu9PM0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: move TLB flush outside page table lock
has been removed from the -mm tree.  Its filename was
     mm-mremap-move-tlb-flush-outside-page-table-lock.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/mremap: move TLB flush outside page table lock

Move TLB flush outside page table lock so that kernel does less with page
table lock held.  Releasing the ptl with old TLB contents still valid will
behave such that such access happened before the level3 or level2 entry
update.

Link: https://lkml.kernel.org/r/20210422054323.150993-8-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/mremap.c~mm-mremap-move-tlb-flush-outside-page-table-lock
+++ a/mm/mremap.c
@@ -258,7 +258,7 @@ static bool move_normal_pmd(struct vm_ar
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_lock prevents deadlock.
 	 */
-	old_ptl = pmd_lock(vma->vm_mm, old_pmd);
+	old_ptl = pmd_lock(mm, old_pmd);
 	new_ptl = pmd_lockptr(mm, new_pmd);
 	if (new_ptl != old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
@@ -270,11 +270,11 @@ static bool move_normal_pmd(struct vm_ar
 	VM_BUG_ON(!pmd_none(*new_pmd));
 	pmd_populate(mm, new_pmd, pmd_pgtable(pmd));
 
-	flush_pte_tlb_pwc_range(vma, old_addr, old_addr + PMD_SIZE);
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
 	spin_unlock(old_ptl);
 
+	flush_pte_tlb_pwc_range(vma, old_addr, old_addr + PMD_SIZE);
 	return true;
 }
 #else
@@ -305,7 +305,7 @@ static bool move_normal_pud(struct vm_ar
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_lock prevents deadlock.
 	 */
-	old_ptl = pud_lock(vma->vm_mm, old_pud);
+	old_ptl = pud_lock(mm, old_pud);
 	new_ptl = pud_lockptr(mm, new_pud);
 	if (new_ptl != old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
@@ -317,11 +317,11 @@ static bool move_normal_pud(struct vm_ar
 	VM_BUG_ON(!pud_none(*new_pud));
 
 	pud_populate(mm, new_pud, (pmd_t *)pud_page_vaddr(pud));
-	flush_pte_tlb_pwc_range(vma, old_addr, old_addr + PUD_SIZE);
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
 	spin_unlock(old_ptl);
 
+	flush_pte_tlb_pwc_range(vma, old_addr, old_addr + PUD_SIZE);
 	return true;
 }
 #else
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-mremap-allow-arch-runtime-override.patch
powerpc-mm-enable-move-pmd-pud.patch

