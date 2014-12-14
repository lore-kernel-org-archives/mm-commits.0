From: akpm@linux-foundation.org
Subject: [merged] mm-mincore-add-hwpoison-page-handle.patch removed from
 -mm tree
Date: Sat, 13 Dec 2014 20:07:06 -0800
Message-ID: <548d0cea.QOIHsFVeVBA6qymT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbaLNEG6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:06:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.com, n-horiguchi@ah.jp.nec.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mincore: add hwpoison page handle
has been removed from the -mm tree.  Its filename was
     mm-mincore-add-hwpoison-page-handle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm: mincore: add hwpoison page handle

When the encountered pte is a swap entry, the current code handles two
cases: migration and normal swapentry, but we have a third case: hwpoison
page.

This patch adds hwpoison page handle, consider hwpoison page incore as
same as migration.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/mincore.c~mm-mincore-add-hwpoison-page-handle mm/mincore.c
--- a/mm/mincore.c~mm-mincore-add-hwpoison-page-handle
+++ a/mm/mincore.c
@@ -137,8 +137,11 @@ static void mincore_pte_range(struct vm_
 		} else { /* pte is a swap entry */
 			swp_entry_t entry = pte_to_swp_entry(pte);
 
-			if (is_migration_entry(entry)) {
-				/* migration entries are always uptodate */
+			if (non_swap_entry(entry)) {
+				/*
+				 * migration or hwpoison entries are always
+				 * uptodate
+				 */
 				*vec = 1;
 			} else {
 #ifdef CONFIG_SWAP
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

origin.patch
mm-page_isolation-check-pfn-validity-before-access.patch

