From: akpm@linux-foundation.org
Subject: [patch 061/131] gfs2: use pagevec_lookup_range_tag()
Date: Wed, 15 Nov 2017 17:34:58 -0800
Message-ID: <20171116013458.7KmE-Hjsi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39274 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932317AbdKPBfA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:35:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, jack@suse.cz, mm-commits@vger.kernel.org, rpeterso@redhat.com, torvalds@linux-foundation.org

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
