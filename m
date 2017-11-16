From: akpm@linux-foundation.org
Subject: [merged]
 mm-soft_offline-improve-hugepage-soft-offlining-error-log.patch removed
 from -mm tree
Date: Thu, 16 Nov 2017 12:03:36 -0800
Message-ID: <20171116200336.0T8bzI9p-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47062 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935293AbdKPUDh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:03:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laszlth@gmail.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: mm, soft_offline: improve hugepage soft offlining error log
has been removed from the -mm tree.  Its filename was
     mm-soft_offline-improve-hugepage-soft-offlining-error-log.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laszlo Toth <laszlth@gmail.com>
Subject: mm, soft_offline: improve hugepage soft offlining error log

On a failed attempt, we get the following entry: soft offline: 0x3c0000:
migration failed 1, type 17ffffc0008008 (uptodate|head)

Make this more specific to be straightforward and to follow other error
log formats in soft_offline_huge_page().

Link: http://lkml.kernel.org/r/20171016171757.GA3018@ubuntu-desk-vm
Signed-off-by: Laszlo Toth <laszlth@gmail.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-soft_offline-improve-hugepage-soft-offlining-error-log mm/memory-failure.c
--- a/mm/memory-failure.c~mm-soft_offline-improve-hugepage-soft-offlining-error-log
+++ a/mm/memory-failure.c
@@ -1587,7 +1587,7 @@ static int soft_offline_huge_page(struct
 	ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 				MIGRATE_SYNC, MR_MEMORY_FAILURE);
 	if (ret) {
-		pr_info("soft offline: %#lx: migration failed %d, type %lx (%pGp)\n",
+		pr_info("soft offline: %#lx: hugepage migration failed %d, type %lx (%pGp)\n",
 			pfn, ret, page->flags, &page->flags);
 		if (!list_empty(&pagelist))
 			putback_movable_pages(&pagelist);
_

Patches currently in -mm which might be from laszlth@gmail.com are


