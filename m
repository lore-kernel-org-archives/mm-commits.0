From: akpm@linux-foundation.org
Subject: [patch 056/131] ceph: use pagevec_lookup_range_tag()
Date: Wed, 15 Nov 2017 17:34:41 -0800
Message-ID: <20171116013441.HFyDuOQ4z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39206 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932972AbdKPBem (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:34:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, idryomov@gmail.com, jack@suse.cz, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, zyan@redhat.com

From: Jan Kara <jack@suse.cz>
Subject: ceph: use pagevec_lookup_range_tag()

We want only pages from given range in ceph_writepages_start().  Use
pagevec_lookup_range_tag() instead of pagevec_lookup_tag() and remove
unnecessary code.

Link: http://lkml.kernel.org/r/20171009151359.31984-4-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/addr.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff -puN fs/ceph/addr.c~ceph-use-pagevec_lookup_range_tag fs/ceph/addr.c
--- a/fs/ceph/addr.c~ceph-use-pagevec_lookup_range_tag
+++ a/fs/ceph/addr.c
@@ -872,13 +872,10 @@ retry:
 get_more_pages:
 		pvec_pages = min_t(unsigned, PAGEVEC_SIZE,
 				   max_pages - locked_pages);
-		if (end - index < (u64)(pvec_pages - 1))
-			pvec_pages = (unsigned)(end - index) + 1;
-
-		pvec_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-						PAGECACHE_TAG_DIRTY,
+		pvec_pages = pagevec_lookup_range_tag(&pvec, mapping, &index,
+						end, PAGECACHE_TAG_DIRTY,
 						pvec_pages);
-		dout("pagevec_lookup_tag got %d\n", pvec_pages);
+		dout("pagevec_lookup_range_tag got %d\n", pvec_pages);
 		if (!pvec_pages && !locked_pages)
 			break;
 		for (i = 0; i < pvec_pages && locked_pages < max_pages; i++) {
@@ -896,16 +893,6 @@ get_more_pages:
 				unlock_page(page);
 				continue;
 			}
-			if (page->index > end) {
-				dout("end of range %p\n", page);
-				/* can't be range_cyclic (1st pass) because
-				 * end == -1 in that case. */
-				stop = true;
-				if (ceph_wbc.head_snapc)
-					done = true;
-				unlock_page(page);
-				break;
-			}
 			if (strip_unit_end && (page->index > strip_unit_end)) {
 				dout("end of strip unit %p\n", page);
 				unlock_page(page);
_
