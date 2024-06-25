Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFBF4596E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291527; cv=none; b=tMcc9rjxeCp1VN/QqiQt20w3+aabcvAzo9a0jRXX8tyItDHKcDxvm6HNIuTthmGNzG+gmf3/61b2mmo0+4E7I+dPC0ecXKIqKn1VABaw8qSMsPS/NEFQuUMXmuB3OD6jYGBKjqMs3T/FUOi6xhVF98hTFo/jajzPhyy/P8eQOXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291527; c=relaxed/simple;
	bh=X8BLtZXlTa9/EDgmzuAaKkmGXy/G3V+2hJf4B+75Ojc=;
	h=Date:To:From:Subject:Message-Id; b=nr/zhNpTMEc//SQFBnkk4p95V9qipxI1jQGcOHoYo6e6fgvTPfRW1KvkQDvfeTI9OyHFyAxOdq7GGEgVQrQOB6JAIAJgumn7/uOFtVsSk3cC0dK8aM+Qk7njsYj0l7aa6enhGUmTplq9Lp79i6LM3hhP+rG/WiHd4pObU1x4clQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vKF7+5dG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vKF7+5dG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B08FC32789;
	Tue, 25 Jun 2024 04:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291526;
	bh=X8BLtZXlTa9/EDgmzuAaKkmGXy/G3V+2hJf4B+75Ojc=;
	h=Date:To:From:Subject:From;
	b=vKF7+5dG0IpcUIxaxOPYu4eVx/cUPn9blXFRWB/FSGshWUThah/ZNafCl6p4/QnnU
	 YhE7jsJBW/8yT1YcbdAKFIf1RuqNEBIRIuSX0ohxp0LIh5TpgdSEaEUjZRzPiVj2ge
	 YBC1scAOHSmdU4B8LMnN9AwRJnyKCk0/4dGRaqN4=
Date: Mon, 24 Jun 2024 21:58:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,corbet@lwn.net,illia@yshyn.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-update-stale-references-to-shrink_page_list.patch removed from -mm tree
Message-Id: <20240625045846.7B08FC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: update stale references to shrink_page_list
has been removed from the -mm tree.  Its filename was
     mm-vmscan-update-stale-references-to-shrink_page_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4541,7 +4541,7 @@ static vm_fault_t __do_fault(struct vm_f
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


