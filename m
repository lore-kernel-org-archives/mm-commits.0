Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1D0320E
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 17:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709054491; cv=none; b=CTee7JPG7S6CUfEwU3s6PinKdadPh3OGyINF9uLX7lTZiGeh/kWVpRPYN4WoWWo/owhuBkmOmNZYeNmbANYzyhIWlCgUcqQByxAJWDYVNYPn65G7bPhqknF5hk/6+n/avZPZaNtVBDP3No32SNQ9LvC725I416j5AsgX1LgLNOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709054491; c=relaxed/simple;
	bh=QYF6dfN4rDAqRI9L3HixqbDL92TWDf5LhCfFDnearZw=;
	h=Date:To:From:Subject:Message-Id; b=u3i7MVuT4d2vEztjjIcv9U6Sh18BkaYbOpbAlXzheHqAXi3FfuLv0q0i7rFpZvHMbC05FpPIYPUnmos0oiTU1IHAGeATSQhry8teWl+wKkN1mtjBsjFR2YYgUwiysyN+Uox+hLTlomcLuntyk7bxuz+W5prahvTpbv9dnhrLq9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Navxl8dL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Navxl8dL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA20C433F1;
	Tue, 27 Feb 2024 17:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709054490;
	bh=QYF6dfN4rDAqRI9L3HixqbDL92TWDf5LhCfFDnearZw=;
	h=Date:To:From:Subject:From;
	b=Navxl8dLNPrctT4fGwX/lJh9urFXHPEdX/L+L8bSel4kFWaG5kvcr9O4gc7l6+DHS
	 UZTTotuCB8RZ9LfxpEphZohzQdy0oEJ6JkqUzys3SoUncMmMx6DCHXK65wpTi+lPrU
	 rG8JITTkLHBvIRYJc4nOWqLAI2WFBAiZVMEncykA=
Date: Tue, 27 Feb 2024 09:21:27 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-refactor-memfd_tag_pins-and-memfd_wait_for_pins.patch added to mm-unstable branch
Message-Id: <20240227172130.6EA20C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd: refactor memfd_tag_pins() and memfd_wait_for_pins()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memfd-refactor-memfd_tag_pins-and-memfd_wait_for_pins.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-refactor-memfd_tag_pins-and-memfd_wait_for_pins.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-memfd-refactor-memfd_tag_pins-and-memfd_wait_for_pins.patch
mm-remove-total_mapcount.patch

