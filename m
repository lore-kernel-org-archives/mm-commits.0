Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBD4C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49F846191D
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhEKWSM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 18:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhEKWSM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 18:18:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE6EC6191C;
        Tue, 11 May 2021 22:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620771425;
        bh=NPqfLvTWb097NyjAjDMHaL7F64KM/PMQU09pl3PWTxY=;
        h=Date:From:To:Subject:From;
        b=VboKQh3TMkO6RLse/3m2bNX8tzkFSGVniXy+Lp3ATkjrL8mntL9tzno0FAh80WfFJ
         vdXVF2T0GPZ/5swZ5DqZ/WwTbpUG3pAOLZIrWKd2eyHoWsniNT0kNC8b5QRh1mrphT
         pRUgmbf3gNlUO5te3bdutEkBFOitYKbFTILU+mlA=
Date:   Tue, 11 May 2021 15:17:04 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        joel@joelfernandes.org, kaleshsingh@google.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject:  + mm-mremap-move-tlb-flush-outside-page-table-lock.patch
 added to -mm tree
Message-ID: <20210511221704.FqG7TQeLV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: move TLB flush outside page table lock
has been added to the -mm tree.  Its filename is
     mm-mremap-move-tlb-flush-outside-page-table-lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-move-tlb-flush-outside-page-table-lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-move-tlb-flush-outside-page-table-lock.patch

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
 	pmd_populate(mm, new_pmd, (pgtable_t)pmd_page_vaddr(pmd));
 
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

selftest-mremap_test-update-the-test-to-handle-pagesize-other-than-4k.patch
selftest-mremap_test-avoid-crash-with-static-build.patch
mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch
powerpc-mm-book3s64-fix-possible-build-error.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush.patch
mm-mremap-move-tlb-flush-outside-page-table-lock.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-mm-enable-move-pmd-pud.patch

