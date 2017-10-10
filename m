From: akpm@linux-foundation.org
Subject: + gfs2-use-pagevec_lookup_range_tag.patch added to -mm tree
Date: Tue, 10 Oct 2017 14:00:56 -0700
Message-ID: <59dd3508.DysTF8wyzioUg+Xg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60724 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933410AbdJJVBF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 17:01:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, daniel.m.jordan@oracle.com, rpeterso@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: gfs2: use pagevec_lookup_range_tag()
has been added to the -mm tree.  Its filename is
     gfs2-use-pagevec_lookup_range_tag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gfs2-use-pagevec_lookup_range_tag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gfs2-use-pagevec_lookup_range_tag.patch

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
Subject: gfs2: use pagevec_lookup_range_tag()

We want only pages from given range in gfs2_write_cache_jdata().  Use
pagevec_lookup_range_tag() instead of pagevec_lookup_tag() and remove
unnecessary code.

Link: http://lkml.kernel.org/r/20171009151359.31984-9-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/aops.c |   20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff -puN fs/gfs2/aops.c~gfs2-use-pagevec_lookup_range_tag fs/gfs2/aops.c
--- a/fs/gfs2/aops.c~gfs2-use-pagevec_lookup_range_tag
+++ a/fs/gfs2/aops.c
@@ -280,22 +280,6 @@ static int gfs2_write_jdata_pagevec(stru
 	for(i = 0; i < nr_pages; i++) {
 		struct page *page = pvec->pages[i];
 
-		/*
-		 * At this point, the page may be truncated or
-		 * invalidated (changing page->mapping to NULL), or
-		 * even swizzled back from swapper_space to tmpfs file
-		 * mapping. However, page->index will not change
-		 * because we have a reference on the page.
-		 */
-		if (page->index > end) {
-			/*
-			 * can't be range_cyclic (1st pass) because
-			 * end == -1 in that case.
-			 */
-			ret = 1;
-			break;
-		}
-
 		*done_index = page->index;
 
 		lock_page(page);
@@ -413,8 +397,8 @@ retry:
 		tag_pages_for_writeback(mapping, index, end);
 	done_index = index;
 	while (!done && (index <= end)) {
-		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
-			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
+				tag, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 
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

