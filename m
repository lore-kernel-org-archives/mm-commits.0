Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E9C0C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 22:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C849610A6
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 22:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhIOW7n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 18:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIOW7j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Sep 2021 18:59:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02E12610A2;
        Wed, 15 Sep 2021 22:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631746700;
        bh=f5P5Yf33FRe+f4T4uGPRbexavAYcRza1Ghr9FtFK3wM=;
        h=Date:From:To:Subject:From;
        b=iHtxG2lyoW/HKIxOahghqeI1gdLBb5Ncc40/jTTsORu4Zd7x4saMXxdGE9nC2dXli
         vs/HfqFydcBorOCbYbZtxMjDMzWD9fWb7EYqyVKhgh5m4RJ/7kNp44cHTItVy0of7R
         6YD00xKHk1QLOMZIRPJm2VbrzDyRy9aCG9fq3QCY=
Date:   Wed, 15 Sep 2021 15:58:19 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, apopple@nvidia.com, axelrasmussen@google.com,
        david@redhat.com, hughd@google.com, jglisse@redhat.com,
        kirill@shutemov.name, liam.howlett@oracle.com,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rppt@linux.vnet.ibm.com, shy828301@gmail.com,
        willy@infradead.org
Subject:  + mm-clear-vmf-pte-after-pte_unmap_same-returns.patch
 added to -mm tree
Message-ID: <20210915225819.mvrdowwbb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clear vmf->pte after pte_unmap_same() returns
has been added to the -mm tree.  Its filename is
     mm-clear-vmf-pte-after-pte_unmap_same-returns.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-clear-vmf-pte-after-pte_unmap_same-returns.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-clear-vmf-pte-after-pte_unmap_same-returns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: clear vmf->pte after pte_unmap_same() returns

pte_unmap_same() will always unmap the pte pointer.  After the unmap,
vmf->pte will not be valid any more, we should clear it.

It was safe only because no one is accessing vmf->pte after
pte_unmap_same() returns, since the only caller of pte_unmap_same() (so
far) is do_swap_page(), where vmf->pte will in most cases be overwritten
very soon.

Directly pass in vmf into pte_unmap_same() and then we can also avoid the
long parameter list too, which should be a nice cleanup.

Link: https://lkml.kernel.org/r/20210915181533.11188-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam Howlett <liam.howlett@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-clear-vmf-pte-after-pte_unmap_same-returns
+++ a/mm/memory.c
@@ -2724,19 +2724,19 @@ EXPORT_SYMBOL_GPL(apply_to_existing_page
  * proceeding (but do_wp_page is only called after already making such a check;
  * and do_anonymous_page can safely check later on).
  */
-static inline int pte_unmap_same(struct mm_struct *mm, pmd_t *pmd,
-				pte_t *page_table, pte_t orig_pte)
+static inline int pte_unmap_same(struct vm_fault *vmf)
 {
 	int same = 1;
 #if defined(CONFIG_SMP) || defined(CONFIG_PREEMPTION)
 	if (sizeof(pte_t) > sizeof(unsigned long)) {
-		spinlock_t *ptl = pte_lockptr(mm, pmd);
+		spinlock_t *ptl = pte_lockptr(vmf->vma->vm_mm, vmf->pmd);
 		spin_lock(ptl);
-		same = pte_same(*page_table, orig_pte);
+		same = pte_same(*vmf->pte, vmf->orig_pte);
 		spin_unlock(ptl);
 	}
 #endif
-	pte_unmap(page_table);
+	pte_unmap(vmf->pte);
+	vmf->pte = NULL;
 	return same;
 }
 
@@ -3487,7 +3487,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	vm_fault_t ret = 0;
 	void *shadow = NULL;
 
-	if (!pte_unmap_same(vma->vm_mm, vmf->pmd, vmf->pte, vmf->orig_pte))
+	if (!pte_unmap_same(vmf))
 		goto out;
 
 	entry = pte_to_swp_entry(vmf->orig_pte);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-shmem-unconditionally-set-pte-dirty-in-mfill_atomic_install_pte.patch
mm-clear-vmf-pte-after-pte_unmap_same-returns.patch
mm-drop-first_index-last_index-in-zap_details.patch
mm-add-zap_skip_check_mapping-helper.patch

