From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:21:07 -0800
Message-ID: <54de5cb3.TrLAuePvSTEu0GGy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbbBMUVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, gong.chen@linux.intel.com, stable@vger.kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: drop lru_add_drain_all() in __soft_offline_page()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hwpoison: drop lru_add_drain_all() in __soft_offline_page()

A race condition starts to be visible in recent mmotm, where a PG_hwpoison
flag is set on a migration source page *before* it's back in buddy page
poo= l.

This is problematic because no page flag is supposed to be set when
freeing (see __free_one_page().) So the user-visible effect of this race
is that it could trigger the BUG_ON() when soft-offlining is called.

The root cause is that we call lru_add_drain_all() to make sure that the
page is in buddy, but that doesn't work because this function just
schedule= s a work item and doesn't wait its completion. 
drain_all_pages() does drainin= g directly, so simply dropping
lru_add_drain_all() solves this problem.

Fixes: f15bdfa802bf ("mm/memory-failure.c: fix memory leak in successful soft offlining")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: <stable@vger.kernel.org>	[3.11+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memory-failure.c~mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page
+++ a/mm/memory-failure.c
@@ -1647,8 +1647,6 @@ static int __soft_offline_page(struct pa
 			 * setting PG_hwpoison.
 			 */
 			if (!is_free_buddy_page(page))
-				lru_add_drain_all();
-			if (!is_free_buddy_page(page))
 				drain_all_pages(page_zone(page));
 			SetPageHWPoison(page);
 			if (!is_free_buddy_page(page))
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

