From: akpm@linux-foundation.org
Subject: + ksm-add-cond_resched-to-the-rmap_walks.patch added to -mm tree
Date: Thu, 15 Oct 2015 12:34:55 -0700
Message-ID: <561fffdf.adDI3pNeHV4/mM1B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbbJOTe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Oct 2015 15:34:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: add cond_resched() to the rmap_walks
has been added to the -mm tree.  Its filename is
     ksm-add-cond_resched-to-the-rmap_walks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ksm-add-cond_resched-to-the-rmap_walks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ksm-add-cond_resched-to-the-rmap_walks.patch

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
Subject: ksm: add cond_resched() to the rmap_walks

While at it add it to the file and anon walks too.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Petr Holasek <pholasek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c  |    2 ++
 mm/rmap.c |    4 ++++
 2 files changed, 6 insertions(+)

diff -puN mm/ksm.c~ksm-add-cond_resched-to-the-rmap_walks mm/ksm.c
--- a/mm/ksm.c~ksm-add-cond_resched-to-the-rmap_walks
+++ a/mm/ksm.c
@@ -1961,9 +1961,11 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
+		cond_resched();
 		anon_vma_lock_read(anon_vma);
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
 					       0, ULONG_MAX) {
+			cond_resched();
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
 			    rmap_item->address >= vma->vm_end)
diff -puN mm/rmap.c~ksm-add-cond_resched-to-the-rmap_walks mm/rmap.c
--- a/mm/rmap.c~ksm-add-cond_resched-to-the-rmap_walks
+++ a/mm/rmap.c
@@ -1609,6 +1609,8 @@ static int rmap_walk_anon(struct page *p
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
 
+		cond_resched();
+
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
 			continue;
 
@@ -1658,6 +1660,8 @@ static int rmap_walk_file(struct page *p
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
 
+		cond_resched();
+
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
 			continue;
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

ksm-fix-rmap_item-anon_vma-memory-corruption-and-vma-user-after-free.patch
ksm-add-cond_resched-to-the-rmap_walks.patch
ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes.patch
ksm-use-the-helper-method-to-do-the-hlist_empty-check.patch
ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page.patch
ksm-unstable_tree_search_insert-error-checking-cleanup.patch

