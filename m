Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C07C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 811C26113B
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbhKKCpb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:45:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234197AbhKKCp2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:45:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9EDA60F46;
        Thu, 11 Nov 2021 02:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598560;
        bh=7Ou+OytPhRpETJnBWzQYqYwTH5SYm7vCXxoQ1v5jDoo=;
        h=Date:From:To:Subject:From;
        b=KmXuYXLVp6u/azM1vW9yt+OUV76BXl3nkBBny83ThGAENLncsyr4yn/oQuryXgXJB
         nz4slvZev6G2HYV1RgrJuueGwncIv+GwBbFJSj7X5JWFN6UaWz+07xPUhOHheVbSbf
         i2HriPLDWzDb2xh8zJMQylI7PFASMha+v8vii3vo=
Date:   Wed, 10 Nov 2021 18:42:39 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, apopple@nvidia.com, axelrasmussen@google.com,
        david@redhat.com, hughd@google.com, jglisse@redhat.com,
        kirill@shutemov.name, liam.howlett@oracle.com,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rppt@linux.vnet.ibm.com, shy828301@gmail.com,
        willy@infradead.org
Subject:  [merged]
 mm-clear-vmf-pte-after-pte_unmap_same-returns.patch removed from -mm tree
Message-ID: <20211111024239.lwamDzFsI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clear vmf->pte after pte_unmap_same() returns
has been removed from the -mm tree.  Its filename was
     mm-clear-vmf-pte-after-pte_unmap_same-returns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
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
@@ -2728,19 +2728,19 @@ EXPORT_SYMBOL_GPL(apply_to_existing_page
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
 
@@ -3492,7 +3492,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	vm_fault_t ret = 0;
 	void *shadow = NULL;
 
-	if (!pte_unmap_same(vma->vm_mm, vmf->pmd, vmf->pte, vmf->orig_pte))
+	if (!pte_unmap_same(vmf))
 		goto out;
 
 	entry = pte_to_swp_entry(vmf->orig_pte);
_

Patches currently in -mm which might be from peterx@redhat.com are


