Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107808C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600556; cv=none; b=inwkoPTdBf/C49LLyBqDVxZzZ1aZfN0Nnss8E1RYE4sa9Wqk7ScZiuNTV54VVhE4EjxyzDZc3+JwQvuwYRqSUswFs8nYv9tiwUwZpbFXzi+4MZdkN0um1FLEyG//MQ0yFODenDSCpcMEY/U2X3Vf9G+WCqpdDR6ahG2SM50TIpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600556; c=relaxed/simple;
	bh=mSFy9CxCJKbluT6AOAThDY08yCSJbYxgnr9uhzTKAqk=;
	h=Date:To:From:Subject:Message-Id; b=fdoSguwJCC9elKlpaWHN5/K4YhN8knxR2xuUV/IAmw2PT0FzzzWx85y7sXGet5obGqpW5OGCRWabvLBb8II6L1Ve4puRUhVKrk8MBJmR2OLMQ6P3Q+HhGMHDtq3z98iKsX7gUbLTZ2zAfShs1okbvxNr+B6vIVMLn3N5ULKr3Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pWkyIrpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pWkyIrpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D664CC433F1;
	Tue,  5 Mar 2024 01:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600555;
	bh=mSFy9CxCJKbluT6AOAThDY08yCSJbYxgnr9uhzTKAqk=;
	h=Date:To:From:Subject:From;
	b=pWkyIrpLDd4z1EQ5Ncleh02EoacqsaKY804p2IhlQmYNGI38PTDiSWepTtHQvwOaL
	 SjqPPRAeF+g6lwbqmc0cYVdSb/KRr+7u5ViHCNPk6nElHZ2J70V//6dV2J4Pw8zD12
	 i6qg442e2abVppA7R/bZz5ieJVSl3DDTJMt5+1zw=
Date: Mon, 04 Mar 2024 17:02:35 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memfd-refactor-memfd_tag_pins-and-memfd_wait_for_pins.patch removed from -mm tree
Message-Id: <20240305010235.D664CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memfd: refactor memfd_tag_pins() and memfd_wait_for_pins()
has been removed from the -mm tree.  Its filename was
     mm-memfd-refactor-memfd_tag_pins-and-memfd_wait_for_pins.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memfd: refactor memfd_tag_pins() and memfd_wait_for_pins()
Date: Mon, 26 Feb 2024 15:13:23 +0100

Patch series "mm: remove total_mapcount()", v2.

Let's remove the remaining user from mm/memfd.c so we can get rid of
total_mapcount().


This patch (of 2):

Both functions are the remaining users of total_mapcount().  Let's get rid
of the calls by converting the code to folios.

As it turns out, the code is unnecessarily complicated, especially:

1) We can query the number of pagecache references for a folio simply via
   folio_nr_pages(). This will handle other folio sizes in the future
   correctly.

2) The xas_set(xas, page->index + cache_count) call to increment the
   iterator for large folios is not required. Remove it.

Further, simplify the XA_CHECK_SCHED check, counting each entry exactly
once.

Memfd pages can be swapped out when using shmem; leave xa_is_value()
checks in place.

Link: https://lkml.kernel.org/r/20240226141324.278526-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240226141324.278526-2-david@redhat.com
Co-developed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |   47 ++++++++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 29 deletions(-)

--- a/mm/memfd.c~mm-memfd-refactor-memfd_tag_pins-and-memfd_wait_for_pins
+++ a/mm/memfd.c
@@ -29,29 +29,25 @@
 #define MEMFD_TAG_PINNED        PAGECACHE_TAG_TOWRITE
 #define LAST_SCAN               4       /* about 150ms max */
 
+static bool memfd_folio_has_extra_refs(struct folio *folio)
+{
+	return folio_ref_count(folio) - folio_mapcount(folio) !=
+	       folio_nr_pages(folio);
+}
+
 static void memfd_tag_pins(struct xa_state *xas)
 {
-	struct page *page;
+	struct folio *folio;
 	int latency = 0;
-	int cache_count;
 
 	lru_add_drain();
 
 	xas_lock_irq(xas);
-	xas_for_each(xas, page, ULONG_MAX) {
-		cache_count = 1;
-		if (!xa_is_value(page) &&
-		    PageTransHuge(page) && !PageHuge(page))
-			cache_count = HPAGE_PMD_NR;
-
-		if (!xa_is_value(page) &&
-		    page_count(page) - total_mapcount(page) != cache_count)
+	xas_for_each(xas, folio, ULONG_MAX) {
+		if (!xa_is_value(folio) && memfd_folio_has_extra_refs(folio))
 			xas_set_mark(xas, MEMFD_TAG_PINNED);
-		if (cache_count != 1)
-			xas_set(xas, page->index + cache_count);
 
-		latency += cache_count;
-		if (latency < XA_CHECK_SCHED)
+		if (++latency < XA_CHECK_SCHED)
 			continue;
 		latency = 0;
 
@@ -66,16 +62,16 @@ static void memfd_tag_pins(struct xa_sta
 /*
  * Setting SEAL_WRITE requires us to verify there's no pending writer. However,
  * via get_user_pages(), drivers might have some pending I/O without any active
- * user-space mappings (eg., direct-IO, AIO). Therefore, we look at all pages
+ * user-space mappings (eg., direct-IO, AIO). Therefore, we look at all folios
  * and see whether it has an elevated ref-count. If so, we tag them and wait for
  * them to be dropped.
  * The caller must guarantee that no new user will acquire writable references
- * to those pages to avoid races.
+ * to those folios to avoid races.
  */
 static int memfd_wait_for_pins(struct address_space *mapping)
 {
 	XA_STATE(xas, &mapping->i_pages, 0);
-	struct page *page;
+	struct folio *folio;
 	int error, scan;
 
 	memfd_tag_pins(&xas);
@@ -83,7 +79,6 @@ static int memfd_wait_for_pins(struct ad
 	error = 0;
 	for (scan = 0; scan <= LAST_SCAN; scan++) {
 		int latency = 0;
-		int cache_count;
 
 		if (!xas_marked(&xas, MEMFD_TAG_PINNED))
 			break;
@@ -95,20 +90,15 @@ static int memfd_wait_for_pins(struct ad
 
 		xas_set(&xas, 0);
 		xas_lock_irq(&xas);
-		xas_for_each_marked(&xas, page, ULONG_MAX, MEMFD_TAG_PINNED) {
+		xas_for_each_marked(&xas, folio, ULONG_MAX, MEMFD_TAG_PINNED) {
 			bool clear = true;
 
-			cache_count = 1;
-			if (!xa_is_value(page) &&
-			    PageTransHuge(page) && !PageHuge(page))
-				cache_count = HPAGE_PMD_NR;
-
-			if (!xa_is_value(page) && cache_count !=
-			    page_count(page) - total_mapcount(page)) {
+			if (!xa_is_value(folio) &&
+			    memfd_folio_has_extra_refs(folio)) {
 				/*
 				 * On the last scan, we clean up all those tags
 				 * we inserted; but make a note that we still
-				 * found pages pinned.
+				 * found folios pinned.
 				 */
 				if (scan == LAST_SCAN)
 					error = -EBUSY;
@@ -118,8 +108,7 @@ static int memfd_wait_for_pins(struct ad
 			if (clear)
 				xas_clear_mark(&xas, MEMFD_TAG_PINNED);
 
-			latency += cache_count;
-			if (latency < XA_CHECK_SCHED)
+			if (++latency < XA_CHECK_SCHED)
 				continue;
 			latency = 0;
 
_

Patches currently in -mm which might be from david@redhat.com are


