From: akpm@linux-foundation.org
Subject: [merged]
 ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:16:15 -0800
Message-ID: <563d0a8f.tmrQidt+Ok0Y4o8D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162062AbbKFUQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: use find_mergeable_vma in try_to_merge_with_ksm_page
has been removed from the -mm tree.  Its filename was
     ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: ksm: use find_mergeable_vma in try_to_merge_with_ksm_page

Doing the VM_MERGEABLE check after the page == kpage check won't provide
any meaningful benefit.  The !vma->anon_vma check of find_mergeable_vma is
the only superfluous bit in using find_mergeable_vma because the !PageAnon
check of try_to_merge_one_page() implicitly checks for that, but it still
looks cleaner to share the same find_mergeable_vma().

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Petr Holasek <pholasek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN mm/ksm.c~ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page mm/ksm.c
--- a/mm/ksm.c~ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page
+++ a/mm/ksm.c
@@ -1021,8 +1021,6 @@ static int try_to_merge_one_page(struct
 	if (page == kpage)			/* ksm page forked */
 		return 0;
 
-	if (!(vma->vm_flags & VM_MERGEABLE))
-		goto out;
 	if (PageTransCompound(page) && page_trans_compound_anon_split(page))
 		goto out;
 	BUG_ON(PageTransCompound(page));
@@ -1087,10 +1085,8 @@ static int try_to_merge_with_ksm_page(st
 	int err = -EFAULT;
 
 	down_read(&mm->mmap_sem);
-	if (ksm_test_exit(mm))
-		goto out;
-	vma = find_vma(mm, rmap_item->address);
-	if (!vma || vma->vm_start > rmap_item->address)
+	vma = find_mergeable_vma(mm, rmap_item->address);
+	if (!vma)
 		goto out;
 
 	err = try_to_merge_one_page(vma, page, kpage);
_

Patches currently in -mm which might be from aarcange@redhat.com are


