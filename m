From: akpm@linux-foundation.org
Subject: [folded-merged]
 ksm-unstable_tree_search_insert-error-checking-cleanup-v2.patch removed
 from -mm tree
Date: Thu, 05 Nov 2015 18:29:04 -0800
Message-ID: <563c1070.dD8u2jR7KrXPDuIH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFC3E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:29:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm-unstable_tree_search_insert-error-checking-cleanup-v2
has been removed from the -mm tree.  Its filename was
     ksm-unstable_tree_search_insert-error-checking-cleanup-v2.patch

This patch was dropped because it was folded into ksm-unstable_tree_search_insert-error-checking-cleanup.patch

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: ksm-unstable_tree_search_insert-error-checking-cleanup-v2

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Petr Holasek <pholasek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/ksm.c~ksm-unstable_tree_search_insert-error-checking-cleanup-v2 mm/ksm.c
--- a/mm/ksm.c~ksm-unstable_tree_search_insert-error-checking-cleanup-v2
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
_

Patches currently in -mm which might be from aarcange@redhat.com are

ksm-add-cond_resched-to-the-rmap_walks.patch
ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes.patch
ksm-use-the-helper-method-to-do-the-hlist_empty-check.patch
ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page.patch
ksm-unstable_tree_search_insert-error-checking-cleanup.patch

