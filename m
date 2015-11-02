From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-move-lazy-free-pages-to-inactive-list-fix.patch removed from -mm tree
Date: Mon, 02 Nov 2015 14:53:02 -0800
Message-ID: <5637e94e.qaqriDhBfHHTOecy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbbKBWxD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 17:53:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, Yalin.Wang@sonymobile.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: document deactivate_page
has been removed from the -mm tree.  Its filename was
     mm-move-lazy-free-pages-to-inactive-list-fix.patch

This patch was dropped because it was folded into mm-move-lazy-free-pages-to-inactive-list.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: document deactivate_page

This patch adds function description for deactivate_page.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Wang, Yalin <Yalin.Wang@sonymobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/swap.c~mm-move-lazy-free-pages-to-inactive-list-fix mm/swap.c
--- a/mm/swap.c~mm-move-lazy-free-pages-to-inactive-list-fix
+++ a/mm/swap.c
@@ -631,6 +631,13 @@ void deactivate_file_page(struct page *p
 	}
 }
 
+/**
+ * deactivate_page - deactivate a page
+ * @page: page to deactivate
+ *
+ * This function moves @page to inactive list if @page was on active list and
+ * was not unevictable page to accelerate to reclaim @page.
+ */
 void deactivate_page(struct page *page)
 {
 	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
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
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch

