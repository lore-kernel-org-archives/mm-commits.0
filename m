From: akpm@linux-foundation.org
Subject: - migration-fix-writepage-error.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:43:05 -0800
Message-ID: <200811202043.mAKKh5Ca007288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755343AbYKTUnn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:43:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     migration: fix writepage error
has been removed from the -mm tree.  Its filename was
     migration-fix-writepage-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: migration: fix writepage error
From: Hugh Dickins <hugh@veritas.com>

Page migration's writeout() has got understandably confused by the nasty
AOP_WRITEPAGE_ACTIVATE case: as in normal success, a writepage() error has
unlocked the page, so writeout() then needs to relock it.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/migrate.c~migration-fix-writepage-error mm/migrate.c
--- a/mm/migrate.c~migration-fix-writepage-error
+++ a/mm/migrate.c
@@ -522,15 +522,12 @@ static int writeout(struct address_space
 	remove_migration_ptes(page, page);
 
 	rc = mapping->a_ops->writepage(page, &wbc);
-	if (rc < 0)
-		/* I/O Error writing */
-		return -EIO;
 
 	if (rc != AOP_WRITEPAGE_ACTIVATE)
 		/* unlocked. Relock */
 		lock_page(page);
 
-	return -EAGAIN;
+	return (rc < 0) ? -EIO : -EAGAIN;
 }
 
 /*
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memcg-swap-cgroup-for-remembering-usage-fix-4.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
prio_tree-debugging-patch.patch

