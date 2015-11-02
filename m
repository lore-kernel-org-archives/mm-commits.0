From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch removed from -mm tree
Date: Mon, 02 Nov 2015 14:53:08 -0800
Message-ID: <5637e954.xMTpDwb+gL2PZIhq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbbKBWxJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 17:53:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: lru_deactivate_fn should clear PG_referenced
has been removed from the -mm tree.  Its filename was
     mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch

This patch was dropped because it was folded into mm-move-lazy-free-pages-to-inactive-list.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: lru_deactivate_fn should clear PG_referenced

deactivate_page aims for accelerate for reclaiming through
moving pages from active list to inactive list so we should
clear PG_referenced for the goal.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/swap.c~mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix mm/swap.c
--- a/mm/swap.c~mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix
+++ a/mm/swap.c
@@ -565,6 +565,7 @@ static void lru_deactivate_fn(struct pag
 
 		del_page_from_lru_list(page, lruvec, lru + LRU_ACTIVE);
 		ClearPageActive(page);
+		ClearPageReferenced(page);
 		add_page_to_lru_list(page, lruvec, lru);
 
 		__count_vm_event(PGDEACTIVATE);
_

Patches currently in -mm which might be from minchan@kernel.org are

x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-mark-stable-page-dirty-in-ksm.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch

