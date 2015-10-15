From: akpm@linux-foundation.org
Subject: + ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page.patch
 added to -mm tree
Date: Thu, 15 Oct 2015 12:35:01 -0700
Message-ID: <561fffe5.eFSkF9ozuOrwYDlJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbbJOTfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Oct 2015 15:35:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: use find_mergeable_vma in try_to_merge_with_ksm_page
has been added to the -mm tree.  Its filename is
     ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: ksm: use find_mergeable_vma in try_to_merge_with_ksm_page

Doing the VM_MERGEABLE check after the page == kpage check won't provide
any meaningful benefit.  The !vma->anon_vma check of find_mergeable_vma is
the only superfluous bit in using find_mergeable_vma because the !PageAnon
check of try_to_merge_one_page() implicitly checks for that, but it still
looks cleaner to share the same find_mergeable_vma().

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Petr Holasek <pholasek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/ksm.c~ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page mm/ksm.c
--- a/mm/ksm.c~ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page
+++ a/mm/ksm.c
@@ -1057,8 +1057,6 @@ static int try_to_merge_one_page(struct
 	if (page == kpage)			/* ksm page forked */
 		return 0;
 
-	if (!(vma->vm_flags & VM_MERGEABLE))
-		goto out;
 	if (PageTransCompound(page) && page_trans_compound_anon_split(page))
 		goto out;
 	BUG_ON(PageTransCompound(page));
@@ -1135,8 +1133,8 @@ static int try_to_merge_with_ksm_page(st
 		return err;
 
 	down_read(&mm->mmap_sem);
-	vma = find_vma(mm, rmap_item->address);
-	if (!vma || vma->vm_start > rmap_item->address)
+	vma = find_mergeable_vma(mm, rmap_item->address);
+	if (!vma)
 		goto out;
 
 	err = try_to_merge_one_page(vma, page, kpage);
_

Patches currently in -mm which might be from aarcange@redhat.com are

ksm-fix-rmap_item-anon_vma-memory-corruption-and-vma-user-after-free.patch
ksm-add-cond_resched-to-the-rmap_walks.patch
ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes.patch
ksm-use-the-helper-method-to-do-the-hlist_empty-check.patch
ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page.patch
ksm-unstable_tree_search_insert-error-checking-cleanup.patch

