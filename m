From: akpm@linux-foundation.org
Subject: [folded-merged]
 page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch removed
 from -mm tree
Date: Thu, 14 Jan 2016 14:32:06 -0800
Message-ID: <569821e6.Y7vihtbGwFI7IorF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697AbcANWcH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:32:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fs-obey-gfp_mapping-for-add_to_page_cache-fix
has been removed from the -mm tree.  Its filename was
     page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch

This patch was dropped because it was folded into page-flags-define-pg_locked-behavior-on-compound-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fs-obey-gfp_mapping-for-add_to_page_cache-fix

fix fs/cifs/file.c

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/file.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/cifs/file.c~page-flags-define-pg_locked-behavior-on-compound-pages-fix fs/cifs/file.c
--- a/fs/cifs/file.c~page-flags-define-pg_locked-behavior-on-compound-pages-fix
+++ a/fs/cifs/file.c
@@ -3391,13 +3391,13 @@ readpages_get_pages(struct address_space
 	 * should have access to this page, we're safe to simply set
 	 * PG_locked without checking it first.
 	 */
-	__set_page_locked(page);
+	__SetPageLocked(page);
 	rc = add_to_page_cache_locked(page, mapping,
 				      page->index, gfp);
 
 	/* give up if we can't stick it in the cache */
 	if (rc) {
-		__clear_page_locked(page);
+		__ClearPageLocked(page);
 		return rc;
 	}
 
@@ -3418,9 +3418,9 @@ readpages_get_pages(struct address_space
 		if (*bytes + PAGE_CACHE_SIZE > rsize)
 			break;
 
-		__set_page_locked(page);
+		__SetPageLocked(page);
 		if (add_to_page_cache_locked(page, mapping, page->index, gfp)) {
-			__clear_page_locked(page);
+			__ClearPageLocked(page);
 			break;
 		}
 		list_move_tail(&page->lru, tmplist);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
thp-reintroduce-split_huge_page-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch

