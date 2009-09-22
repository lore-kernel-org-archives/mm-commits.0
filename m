From: akpm@linux-foundation.org
Subject: [merged] mm-document-is_page_cache_freeable.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:41:51 -0700
Message-ID: <200909222041.n8MKfphQ008379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbZIVUlx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:41:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: document is_page_cache_freeable()
has been removed from the -mm tree.  Its filename was
     mm-document-is_page_cache_freeable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: document is_page_cache_freeable()
From: Johannes Weiner <hannes@cmpxchg.org>

Enlighten the reader of this code about what reference count makes a page
cache page freeable.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/vmscan.c~mm-document-is_page_cache_freeable mm/vmscan.c
--- a/mm/vmscan.c~mm-document-is_page_cache_freeable
+++ a/mm/vmscan.c
@@ -286,6 +286,11 @@ static inline int page_mapping_inuse(str
 
 static inline int is_page_cache_freeable(struct page *page)
 {
+	/*
+	 * A freeable page cache page is referenced only by the caller
+	 * that isolated the page, the page cache radix tree and
+	 * optional buffer heads at page->private.
+	 */
 	return page_count(page) - page_has_private(page) == 2;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch

