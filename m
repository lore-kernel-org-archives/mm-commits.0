From: akpm@linux-foundation.org
Subject: + ksm-unstable_tree_search_insert-error-checking-cleanup.patch
 added to -mm tree
Date: Thu, 15 Oct 2015 12:35:03 -0700
Message-ID: <561fffe7.9ke1hbmG5kcylxD5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbbJOTfE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Oct 2015 15:35:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: unstable_tree_search_insert error checking cleanup
has been added to the -mm tree.  Its filename is
     ksm-unstable_tree_search_insert-error-checking-cleanup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ksm-unstable_tree_search_insert-error-checking-cleanup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ksm-unstable_tree_search_insert-error-checking-cleanup.patch

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
Subject: ksm: unstable_tree_search_insert error checking cleanup

get_mergeable_page() can only return NULL (in case of errors) or the
pinned mergeable page.  It can't return an error different than NULL. 
This makes it more readable and less confusion in addition to optimizing
the check.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Petr Holasek <pholasek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/ksm.c~ksm-unstable_tree_search_insert-error-checking-cleanup mm/ksm.c
--- a/mm/ksm.c~ksm-unstable_tree_search_insert-error-checking-cleanup
+++ a/mm/ksm.c
@@ -1409,7 +1409,7 @@ struct rmap_item *unstable_tree_search_i
 		cond_resched();
 		tree_rmap_item = rb_entry(*new, struct rmap_item, node);
 		tree_page = get_mergeable_page(tree_rmap_item);
-		if (IS_ERR_OR_NULL(tree_page))
+		if (!tree_page)
 			return NULL;
 
 		/*
_

Patches currently in -mm which might be from aarcange@redhat.com are

ksm-fix-rmap_item-anon_vma-memory-corruption-and-vma-user-after-free.patch
ksm-add-cond_resched-to-the-rmap_walks.patch
ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes.patch
ksm-use-the-helper-method-to-do-the-hlist_empty-check.patch
ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page.patch
ksm-unstable_tree_search_insert-error-checking-cleanup.patch

