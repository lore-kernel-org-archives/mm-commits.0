Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D51335C7
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 23:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716161782; cv=none; b=Ij+frL4LUuPvDb+UsdvrY1UGVows1ZqpT8cJWao7KHPeUvNMmRNCYY7TaqsVphClKeV2X4F2tyI1D0h/yXI14RDu1pC+uPf3HPtq9u8XcHC2NsHqxRRrTlYYuno/HbXmiHQ2nVtVw2NLEf9pUTH4QBYaRJcxLs4UiNjNERr9v9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716161782; c=relaxed/simple;
	bh=tRA6gFu2niu5aKS/JmhS8GH3K3C9ylcRffqWc4yqfT8=;
	h=Date:To:From:Subject:Message-Id; b=lRw3I1hkvb1DTcRlY7Z9BwWulpr+TI4SatwsyfnwpkJXNkjTiPAbkh7DpoZbbLuthYY2LIRWrq8EvVfHVVprqJ8PBII7nA8gaZj/NolIY+tKumc1BC7Ma/Ej5Q8odlx70F3KSWGXR60h+tF6Wi5POKPDxGevpTxEM+cJPt0dRyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PAoXmwc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PAoXmwc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84067C32781;
	Sun, 19 May 2024 23:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716161781;
	bh=tRA6gFu2niu5aKS/JmhS8GH3K3C9ylcRffqWc4yqfT8=;
	h=Date:To:From:Subject:From;
	b=PAoXmwc+y5NxbVpgyASLii1AXJUSTGE3UxDUYQfiTJqQSYHe5Sxq5z8/a0psLPOp+
	 KCluoPPcK+en9Axu9U5IFQZpWOHicZEQaXn1yPJHY91AQolmMjKfPyhGNgJsFEMYk3
	 0MjwxhYRzuaghzDDEQ3jhmNNFTD3+2tewQCDi2U4=
Date: Sun, 19 May 2024 16:36:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,corbet@lwn.net,illia@yshyn.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-update-stale-references-to-shrink_page_list.patch added to mm-unstable branch
Message-Id: <20240519233621.84067C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: update stale references to shrink_page_list
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-update-stale-references-to-shrink_page_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-update-stale-references-to-shrink_page_list.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Illia Ostapyshyn <illia@yshyn.com>
Subject: mm/vmscan: update stale references to shrink_page_list
Date: Fri, 17 May 2024 11:13:48 +0200

Commit 49fd9b6df54e ("mm/vmscan: fix a lot of comments") renamed
shrink_page_list() to shrink_folio_list().  Fix up the remaining
references to the old name in comments and documentation.

Link: https://lkml.kernel.org/r/20240517091348.1185566-1-illia@yshyn.com
Signed-off-by: Illia Ostapyshyn <illia@yshyn.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/unevictable-lru.rst |   10 +++++-----
 mm/memory.c                          |    2 +-
 mm/swap_state.c                      |    2 +-
 mm/truncate.c                        |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/Documentation/mm/unevictable-lru.rst~mm-vmscan-update-stale-references-to-shrink_page_list
+++ a/Documentation/mm/unevictable-lru.rst
@@ -191,13 +191,13 @@ have become evictable again (via munlock
 from the unevictable list.  However, there may be situations where we decide,
 for the sake of expediency, to leave an unevictable folio on one of the regular
 active/inactive LRU lists for vmscan to deal with.  vmscan checks for such
-folios in all of the shrink_{active|inactive|page}_list() functions and will
+folios in all of the shrink_{active|inactive|folio}_list() functions and will
 "cull" such folios that it encounters: that is, it diverts those folios to the
 unevictable list for the memory cgroup and node being scanned.
 
 There may be situations where a folio is mapped into a VM_LOCKED VMA,
 but the folio does not have the mlocked flag set.  Such folios will make
-it all the way to shrink_active_list() or shrink_page_list() where they
+it all the way to shrink_active_list() or shrink_folio_list() where they
 will be detected when vmscan walks the reverse map in folio_referenced()
 or try_to_unmap().  The folio is culled to the unevictable list when it
 is released by the shrinker.
@@ -269,7 +269,7 @@ the LRU.  Such pages can be "noticed" by
 
  (4) in the fault path and when a VM_LOCKED stack segment is expanded; or
 
- (5) as mentioned above, in vmscan:shrink_page_list() when attempting to
+ (5) as mentioned above, in vmscan:shrink_folio_list() when attempting to
      reclaim a page in a VM_LOCKED VMA by folio_referenced() or try_to_unmap().
 
 mlocked pages become unlocked and rescued from the unevictable list when:
@@ -548,12 +548,12 @@ Some examples of these unevictable pages
  (3) pages still mapped into VM_LOCKED VMAs, which should be marked mlocked,
      but events left mlock_count too low, so they were munlocked too early.
 
-vmscan's shrink_inactive_list() and shrink_page_list() also divert obviously
+vmscan's shrink_inactive_list() and shrink_folio_list() also divert obviously
 unevictable pages found on the inactive lists to the appropriate memory cgroup
 and node unevictable list.
 
 rmap's folio_referenced_one(), called via vmscan's shrink_active_list() or
-shrink_page_list(), and rmap's try_to_unmap_one() called via shrink_page_list(),
+shrink_folio_list(), and rmap's try_to_unmap_one() called via shrink_folio_list(),
 check for (3) pages still mapped into VM_LOCKED VMAs, and call mlock_vma_folio()
 to correct them.  Such pages are culled to the unevictable list when released
 by the shrinker.
--- a/mm/memory.c~mm-vmscan-update-stale-references-to-shrink_page_list
+++ a/mm/memory.c
@@ -4547,7 +4547,7 @@ static vm_fault_t __do_fault(struct vm_f
 	 * lock_page(B)
 	 *				lock_page(B)
 	 * pte_alloc_one
-	 *   shrink_page_list
+	 *   shrink_folio_list
 	 *     wait_on_page_writeback(A)
 	 *				SetPageWriteback(B)
 	 *				unlock_page(B)
--- a/mm/swap_state.c~mm-vmscan-update-stale-references-to-shrink_page_list
+++ a/mm/swap_state.c
@@ -28,7 +28,7 @@
 
 /*
  * swapper_space is a fiction, retained to simplify the path through
- * vmscan's shrink_page_list.
+ * vmscan's shrink_folio_list.
  */
 static const struct address_space_operations swap_aops = {
 	.writepage	= swap_writepage,
--- a/mm/truncate.c~mm-vmscan-update-stale-references-to-shrink_page_list
+++ a/mm/truncate.c
@@ -554,7 +554,7 @@ EXPORT_SYMBOL(invalidate_mapping_pages);
  * This is like mapping_evict_folio(), except it ignores the folio's
  * refcount.  We do this because invalidate_inode_pages2() needs stronger
  * invalidation guarantees, and cannot afford to leave folios behind because
- * shrink_page_list() has a temp ref on them, or because they're transiently
+ * shrink_folio_list() has a temp ref on them, or because they're transiently
  * sitting in the folio_add_lru() caches.
  */
 static int invalidate_complete_folio2(struct address_space *mapping,
_

Patches currently in -mm which might be from illia@yshyn.com are

mm-vmscan-update-stale-references-to-shrink_page_list.patch

