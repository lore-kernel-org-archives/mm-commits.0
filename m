From: akpm@linux-foundation.org
Subject: + migration-fix-writepage-error.patch added to -mm tree
Date: Fri, 14 Nov 2008 16:41:26 -0800
Message-ID: <200811150041.mAF0fQiL026561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233AbYKOAle (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 19:41:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     migration: fix writepage error
has been added to the -mm tree.  Its filename is
     migration-fix-writepage-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
sprint_symbol-use-less-stack.patch
migration-fix-writepage-error.patch
vmscan-let-gfp_nofs-go-to-swap-again.patch
dont-unlink-an-active-swapfile.patch
mm-implement-remap_pfn_range-with-apply_to_page_range.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remap_pfn_range-restore-missing-flush.patch
prio_tree-debugging-patch.patch

