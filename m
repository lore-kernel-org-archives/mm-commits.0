From: akpm@linux-foundation.org
Subject: - reiser4-reiser4_drop_page-dont-call-remove_from_page_cache.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:59:11 -0800
Message-ID: <200703060159.l261xBbW008573@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46512 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965627AbXCFB7S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:59:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zam@namesys.com, reiser@namesys.com, mm-commits@vger.kernel.org


The patch titled
     Reiser4: reiser4_drop_page: don't call remove_from_page_cache
has been removed from the -mm tree.  Its filename was
     reiser4-reiser4_drop_page-dont-call-remove_from_page_cache.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: Reiser4: reiser4_drop_page: don't call remove_from_page_cache
From: Alexander Zarochentsev <zam@namesys.com>


this patch addresses the following reiser4_drop_page problem :
>  drop_page() is a worry.  Why _does_ reiser4 need to remove pages from
>  pagecache?  That isn't a filesystem function.

Signed-off-by: Alexander Zarochentsev <zam@namesys.com>
Cc: Hans Reiser <reiser@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/page_cache.c |    8 +-------
 1 files changed, 1 insertion(+), 7 deletions(-)

diff -puN fs/reiser4/page_cache.c~reiser4-reiser4_drop_page-dont-call-remove_from_page_cache fs/reiser4/page_cache.c
--- a/fs/reiser4/page_cache.c~reiser4-reiser4_drop_page-dont-call-remove_from_page_cache
+++ a/fs/reiser4/page_cache.c
@@ -261,7 +261,6 @@ void done_formatted_fake(struct super_bl
 	sinfo = get_super_private_nocheck(super);
 
 	if (sinfo->fake != NULL) {
-		assert("vs-1426", sinfo->fake->i_data.nrpages == 0);
 		iput(sinfo->fake);
 		sinfo->fake = NULL;
 	}
@@ -589,12 +588,7 @@ void drop_page(struct page *page)
 #if defined(PG_skipped)
 	ClearPageSkipped(page);
 #endif
-	if (page->mapping != NULL) {
-		remove_from_page_cache(page);
-		unlock_page(page);
-		page_cache_release(page);
-	} else
-		unlock_page(page);
+	unlock_page(page);
 }
 
 /* this is called by truncate_jnodes_range which in its turn is always called
_

Patches currently in -mm which might be from zam@namesys.com are

reiser4.patch
reiser4-reiser4_drop_page-dont-call-remove_from_page_cache.patch
reiser4-get-rid-of-semaphores-wherever-it-is-possible.patch
reiser4-decribe-new-atom-locking-and-nested-atom-locks-to-lock-validator.patch
reiser4-use-generic-file-read.patch
reiser4-use-generic-file-read-fix-readpages-unix-file.patch
reiser4-simplify-reading-of-partially-converted-files.patch
reiser4-use-page_offset.patch
reiser4-use-reiser4_gfp_mask_get-in-reiser4-inode-allocation.patch
reiser4-re-add-page_count-check-to-reiser4_releasepage.patch
reiser4-restore-fibmap-ioctl-support-for-packed-files.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch
