From: akpm@linux-foundation.org
Subject: + mm-use-pagevec_lookup_range_tag-in-write_cache_pages.patch
 added to -mm tree
Date: Tue, 10 Oct 2017 14:01:05 -0700
Message-ID: <59dd3511.PlvFcBXMuSgxD+A3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60774 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932953AbdJJVBL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 17:01:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, daniel.m.jordan@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use pagevec_lookup_range_tag() in write_cache_pages()
has been added to the -mm tree.  Its filename is
     mm-use-pagevec_lookup_range_tag-in-write_cache_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-pagevec_lookup_range_tag-in-write_cache_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-pagevec_lookup_range_tag-in-write_cache_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: use pagevec_lookup_range_tag() in write_cache_pages()

Use pagevec_lookup_range_tag() in write_cache_pages() as it is interested
only in pages from given range.  Remove unnecessary code resulting from
this.

Link: http://lkml.kernel.org/r/20171009151359.31984-12-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff -puN mm/page-writeback.c~mm-use-pagevec_lookup_range_tag-in-write_cache_pages mm/page-writeback.c
--- a/mm/page-writeback.c~mm-use-pagevec_lookup_range_tag-in-write_cache_pages
+++ a/mm/page-writeback.c
@@ -2196,30 +2196,14 @@ retry:
 	while (!done && (index <= end)) {
 		int i;
 
-		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
-			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
+				tag, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
-			/*
-			 * At this point, the page may be truncated or
-			 * invalidated (changing page->mapping to NULL), or
-			 * even swizzled back from swapper_space to tmpfs file
-			 * mapping. However, page->index will not change
-			 * because we have a reference on the page.
-			 */
-			if (page->index > end) {
-				/*
-				 * can't be range_cyclic (1st pass) because
-				 * end == -1 in that case.
-				 */
-				done = 1;
-				break;
-			}
-
 			done_index = page->index;
 
 			lock_page(page);
_

Patches currently in -mm which might be from jack@suse.cz are

mm-readahead-increase-maximum-readahead-window.patch
mm-implement-find_get_pages_range_tag.patch
btrfs-use-pagevec_lookup_range_tag.patch
ceph-use-pagevec_lookup_range_tag.patch
ext4-use-pagevec_lookup_range_tag.patch
f2fs-use-pagevec_lookup_range_tag.patch
f2fs-simplify-page-iteration-loops.patch
f2fs-use-find_get_pages_tag-for-looking-up-single-page.patch
gfs2-use-pagevec_lookup_range_tag.patch
nilfs2-use-pagevec_lookup_range_tag.patch
mm-use-pagevec_lookup_range_tag-in-__filemap_fdatawait_range.patch
mm-use-pagevec_lookup_range_tag-in-write_cache_pages.patch
mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages.patch
ceph-use-pagevec_lookup_range_nr_tag.patch
mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag.patch
afs-use-find_get_pages_range_tag.patch
cifs-use-find_get_pages_range_tag.patch

