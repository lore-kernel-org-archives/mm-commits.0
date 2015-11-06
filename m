From: akpm@linux-foundation.org
Subject: [merged]
 ksm-unstable_tree_search_insert-error-checking-cleanup.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:16:17 -0800
Message-ID: <563d0a91.PB0OKUgaoEQv79MK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162949AbbKFUQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: unstable_tree_search_insert error checking cleanup
has been removed from the -mm tree.  Its filename was
     ksm-unstable_tree_search_insert-error-checking-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: ksm: unstable_tree_search_insert error checking cleanup

get_mergeable_page() can only return NULL (also in case of errors) or the
pinned mergeable page.  It can't return an error different than NULL. 
This optimizes away the unnecessary error check.

Add a return after the "out:" label in the callee to make it more
readable.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Petr Holasek <pholasek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/ksm.c~ksm-unstable_tree_search_insert-error-checking-cleanup mm/ksm.c
--- a/mm/ksm.c~ksm-unstable_tree_search_insert-error-checking-cleanup
+++ a/mm/ksm.c
@@ -475,7 +475,8 @@ static struct page *get_mergeable_page(s
 		flush_dcache_page(page);
 	} else {
 		put_page(page);
-out:		page = NULL;
+out:
+		page = NULL;
 	}
 	up_read(&mm->mmap_sem);
 	return page;
@@ -1358,7 +1359,7 @@ struct rmap_item *unstable_tree_search_i
 		cond_resched();
 		tree_rmap_item = rb_entry(*new, struct rmap_item, node);
 		tree_page = get_mergeable_page(tree_rmap_item);
-		if (IS_ERR_OR_NULL(tree_page))
+		if (!tree_page)
 			return NULL;
 
 		/*
_

Patches currently in -mm which might be from aarcange@redhat.com are


