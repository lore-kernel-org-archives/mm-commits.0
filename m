From: akpm@linux-foundation.org
Subject: + cifs-use-find_get_pages_range_tag.patch added to -mm tree
Date: Tue, 10 Oct 2017 14:01:20 -0700
Message-ID: <59dd3520.zVwVnIL68W6diyHh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32908 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933277AbdJJVBW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 17:01:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, daniel.m.jordan@oracle.com, sfrench@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cifs: use find_get_pages_range_tag()
has been added to the -mm tree.  Its filename is
     cifs-use-find_get_pages_range_tag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cifs-use-find_get_pages_range_tag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cifs-use-find_get_pages_range_tag.patch

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
Subject: cifs: use find_get_pages_range_tag()

wdata_alloc_and_fillpages() needlessly iterates calls to
find_get_pages_tag().  Also it wants only pages from given range.  Make it
use find_get_pages_range_tag().

Link: http://lkml.kernel.org/r/20171009151359.31984-17-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Suggested-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/file.c |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff -puN fs/cifs/file.c~cifs-use-find_get_pages_range_tag fs/cifs/file.c
--- a/fs/cifs/file.c~cifs-use-find_get_pages_range_tag
+++ a/fs/cifs/file.c
@@ -1963,8 +1963,6 @@ wdata_alloc_and_fillpages(pgoff_t tofind
 			  pgoff_t end, pgoff_t *index,
 			  unsigned int *found_pages)
 {
-	unsigned int nr_pages;
-	struct page **pages;
 	struct cifs_writedata *wdata;
 
 	wdata = cifs_writedata_alloc((unsigned int)tofind,
@@ -1972,23 +1970,8 @@ wdata_alloc_and_fillpages(pgoff_t tofind
 	if (!wdata)
 		return NULL;
 
-	/*
-	 * find_get_pages_tag seems to return a max of 256 on each
-	 * iteration, so we must call it several times in order to
-	 * fill the array or the wsize is effectively limited to
-	 * 256 * PAGE_SIZE.
-	 */
-	*found_pages = 0;
-	pages = wdata->pages;
-	do {
-		nr_pages = find_get_pages_tag(mapping, index,
-					      PAGECACHE_TAG_DIRTY, tofind,
-					      pages);
-		*found_pages += nr_pages;
-		tofind -= nr_pages;
-		pages += nr_pages;
-	} while (nr_pages && tofind && *index <= end);
-
+	*found_pages = find_get_pages_range_tag(mapping, index, end,
+				PAGECACHE_TAG_DIRTY, tofind, wdata->pages);
 	return wdata;
 }
 
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

