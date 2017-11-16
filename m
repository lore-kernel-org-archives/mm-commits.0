From: akpm@linux-foundation.org
Subject: [merged] cifs-use-find_get_pages_range_tag.patch removed
 from -mm tree
Date: Thu, 16 Nov 2017 12:02:13 -0800
Message-ID: <20171116200213.q5-9t0mYk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46622 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbdKPUCO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:02:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, jack@suse.cz, mm-commits@vger.kernel.org, sfrench@samba.org


The patch titled
     Subject: cifs: use find_get_pages_range_tag()
has been removed from the -mm tree.  Its filename was
     cifs-use-find_get_pages_range_tag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
