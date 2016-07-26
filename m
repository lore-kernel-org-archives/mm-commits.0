From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
 removed from -mm tree
Date: Tue, 26 Jul 2016 15:03:05 -0700
Message-ID: <5797de19.REYkYbC3U2+tK1bt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161275AbcGZWDG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:03:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-memcg-use-consistent-gfp-flags-during-readahead.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes

WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
#155: FILE: mm/readahead.c:111:
+		struct list_head *pages, unsigned nr_pages, gfp_t gfp_mask)

WARNING: line over 80 characters
#165: FILE: mm/readahead.c:129:
+		if (!add_to_page_cache_lru(page, mapping, page->index, gfp_mask)) {

WARNING: braces {} are not necessary for single statement blocks
#165: FILE: mm/readahead.c:129:
+		if (!add_to_page_cache_lru(page, mapping, page->index, gfp_mask)) {
 			mapping->a_ops->readpage(filp, page);
 		}

total: 0 errors, 3 warnings, 111 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-memcg-use-consistent-gfp-flags-during-readahead.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/readahead.c~mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes mm/readahead.c
--- a/mm/readahead.c~mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes
+++ a/mm/readahead.c
@@ -108,7 +108,7 @@ int read_cache_pages(struct address_spac
 EXPORT_SYMBOL(read_cache_pages);
 
 static int read_pages(struct address_space *mapping, struct file *filp,
-		struct list_head *pages, unsigned nr_pages, gfp_t gfp_mask)
+		struct list_head *pages, unsigned int nr_pages, gfp_t gfp)
 {
 	struct blk_plug plug;
 	unsigned page_idx;
@@ -126,9 +126,8 @@ static int read_pages(struct address_spa
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
 		struct page *page = lru_to_page(pages);
 		list_del(&page->lru);
-		if (!add_to_page_cache_lru(page, mapping, page->index, gfp_mask)) {
+		if (!add_to_page_cache_lru(page, mapping, page->index, gfp))
 			mapping->a_ops->readpage(filp, page);
-		}
 		put_page(page);
 	}
 	ret = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-use-consistent-gfp-flags-during-readahead.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch

