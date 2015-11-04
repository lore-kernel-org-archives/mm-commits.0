From: akpm@linux-foundation.org
Subject: +
 ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page-v2.patch added to
 -mm tree
Date: Tue, 03 Nov 2015 16:23:30 -0800
Message-ID: <56395002.eMR68fYiUJAlzzHA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647AbbKDAXb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2015 19:23:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page-v2
has been added to the -mm tree.  Its filename is
     ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page-v2.patch

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
Subject: ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page-v2

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Petr Holasek <pholasek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/ksm.c~ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page-v2 mm/ksm.c
--- a/mm/ksm.c~ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page-v2
+++ a/mm/ksm.c
@@ -1085,8 +1085,6 @@ static int try_to_merge_with_ksm_page(st
 	int err = -EFAULT;
 
 	down_read(&mm->mmap_sem);
-	if (ksm_test_exit(mm))
-		goto out;
 	vma = find_mergeable_vma(mm, rmap_item->address);
 	if (!vma)
 		goto out;
_

Patches currently in -mm which might be from aarcange@redhat.com are

ksm-add-cond_resched-to-the-rmap_walks.patch
ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes.patch
ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes-v2.patch
ksm-use-the-helper-method-to-do-the-hlist_empty-check.patch
ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page.patch
ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page-v2.patch
ksm-unstable_tree_search_insert-error-checking-cleanup.patch

