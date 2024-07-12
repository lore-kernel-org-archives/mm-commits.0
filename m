Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028AA1CF96
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824838; cv=none; b=cdRKE1idt1NOLq/vqN/ejiFK78zYDvbxMQ9n1DR6y4EhWEfX9ScOnoffwgqvy+Y+TcUx580Lb460wMqKwtMIBsXt8aupoVWW4TwYysRa6iRX9KtZ4uF2k771L78ZanQxiQRammAvWDWwCd1opF3wdFAGjGTqj9o8wsC2iJe8p/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824838; c=relaxed/simple;
	bh=yUkh/Q27CNtW4sW5ibn/QS/7oUa20AJcLH4ICsgLEOE=;
	h=Date:To:From:Subject:Message-Id; b=LOr1q7Tu8bIpEbpOmGgvFuqaDS9pM9YNd8VUrmFIiaXVd1BNvzFsTCizdfrHni9y6qIRCljjE/jqSAcPRxzUcpGeFxzqfNxvQV5EPiSOjtojMPITbauUfqPCVlbnNbO6TQkugXC495OBg3yR5LPgmMY5oX3jvg5joC2fhQEj4iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pfw1H6h3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pfw1H6h3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF69C4AF07;
	Fri, 12 Jul 2024 22:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824837;
	bh=yUkh/Q27CNtW4sW5ibn/QS/7oUa20AJcLH4ICsgLEOE=;
	h=Date:To:From:Subject:From;
	b=pfw1H6h3O9iEcgjMKSAXGPMYlTrD2MyWQ/z3HsYUy1RBYUw+Okm1dV5PglSYpL2pZ
	 4bHntQQ04nrRB1SazCkPM9GwdMRENnaDu9j6BNu/A44ol8KnChjd29eHOQQY+ye29L
	 T+SuXHH60Jww0gM4ZEElKcm7TGLzM3vHL3QznSM4=
Date: Fri, 12 Jul 2024 15:53:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,peterx@redhat.com,osalvador@suse.de,mike.kravetz@oracle.com,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,airlied@redhat.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-introduce-check_and_migrate_movable_folios.patch removed from -mm tree
Message-Id: <20240712225357.7FF69C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: introduce check_and_migrate_movable_folios()
has been removed from the -mm tree.  Its filename was
     mm-gup-introduce-check_and_migrate_movable_folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: mm/gup: introduce check_and_migrate_movable_folios()
Date: Sun, 23 Jun 2024 23:36:10 -0700

This helper is the folio equivalent of check_and_migrate_movable_pages(). 
Therefore, all the rules that apply to check_and_migrate_movable_pages()
also apply to this one as well.  Currently, this helper is only used by
memfd_pin_folios().

This patch also includes changes to rename and convert the internal
functions collect_longterm_unpinnable_pages() and
migrate_longterm_unpinnable_pages() to work on folios.  As a result,
check_and_migrate_movable_pages() is now a wrapper around
check_and_migrate_movable_folios().

Link: https://lkml.kernel.org/r/20240624063952.1572359-3-vivek.kasireddy@intel.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Dave Airlie <airlied@redhat.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  124 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 77 insertions(+), 47 deletions(-)

--- a/mm/gup.c~mm-gup-introduce-check_and_migrate_movable_folios
+++ a/mm/gup.c
@@ -2441,19 +2441,19 @@ struct page *get_dump_page(unsigned long
 
 #ifdef CONFIG_MIGRATION
 /*
- * Returns the number of collected pages. Return value is always >= 0.
+ * Returns the number of collected folios. Return value is always >= 0.
  */
-static unsigned long collect_longterm_unpinnable_pages(
-					struct list_head *movable_page_list,
-					unsigned long nr_pages,
-					struct page **pages)
+static unsigned long collect_longterm_unpinnable_folios(
+					struct list_head *movable_folio_list,
+					unsigned long nr_folios,
+					struct folio **folios)
 {
 	unsigned long i, collected = 0;
 	struct folio *prev_folio = NULL;
 	bool drain_allow = true;
 
-	for (i = 0; i < nr_pages; i++) {
-		struct folio *folio = page_folio(pages[i]);
+	for (i = 0; i < nr_folios; i++) {
+		struct folio *folio = folios[i];
 
 		if (folio == prev_folio)
 			continue;
@@ -2468,7 +2468,7 @@ static unsigned long collect_longterm_un
 			continue;
 
 		if (folio_test_hugetlb(folio)) {
-			isolate_hugetlb(folio, movable_page_list);
+			isolate_hugetlb(folio, movable_folio_list);
 			continue;
 		}
 
@@ -2480,7 +2480,7 @@ static unsigned long collect_longterm_un
 		if (!folio_isolate_lru(folio))
 			continue;
 
-		list_add_tail(&folio->lru, movable_page_list);
+		list_add_tail(&folio->lru, movable_folio_list);
 		node_stat_mod_folio(folio,
 				    NR_ISOLATED_ANON + folio_is_file_lru(folio),
 				    folio_nr_pages(folio));
@@ -2490,27 +2490,28 @@ static unsigned long collect_longterm_un
 }
 
 /*
- * Unpins all pages and migrates device coherent pages and movable_page_list.
- * Returns -EAGAIN if all pages were successfully migrated or -errno for failure
- * (or partial success).
+ * Unpins all folios and migrates device coherent folios and movable_folio_list.
+ * Returns -EAGAIN if all folios were successfully migrated or -errno for
+ * failure (or partial success).
  */
-static int migrate_longterm_unpinnable_pages(
-					struct list_head *movable_page_list,
-					unsigned long nr_pages,
-					struct page **pages)
+static int migrate_longterm_unpinnable_folios(
+					struct list_head *movable_folio_list,
+					unsigned long nr_folios,
+					struct folio **folios)
 {
 	int ret;
 	unsigned long i;
 
-	for (i = 0; i < nr_pages; i++) {
-		struct folio *folio = page_folio(pages[i]);
+	for (i = 0; i < nr_folios; i++) {
+		struct folio *folio = folios[i];
 
 		if (folio_is_device_coherent(folio)) {
 			/*
-			 * Migration will fail if the page is pinned, so convert
-			 * the pin on the source page to a normal reference.
+			 * Migration will fail if the folio is pinned, so
+			 * convert the pin on the source folio to a normal
+			 * reference.
 			 */
-			pages[i] = NULL;
+			folios[i] = NULL;
 			folio_get(folio);
 			gup_put_folio(folio, 1, FOLL_PIN);
 
@@ -2523,24 +2524,24 @@ static int migrate_longterm_unpinnable_p
 		}
 
 		/*
-		 * We can't migrate pages with unexpected references, so drop
+		 * We can't migrate folios with unexpected references, so drop
 		 * the reference obtained by __get_user_pages_locked().
-		 * Migrating pages have been added to movable_page_list after
+		 * Migrating folios have been added to movable_folio_list after
 		 * calling folio_isolate_lru() which takes a reference so the
-		 * page won't be freed if it's migrating.
+		 * folio won't be freed if it's migrating.
 		 */
-		unpin_user_page(pages[i]);
-		pages[i] = NULL;
+		unpin_folio(folios[i]);
+		folios[i] = NULL;
 	}
 
-	if (!list_empty(movable_page_list)) {
+	if (!list_empty(movable_folio_list)) {
 		struct migration_target_control mtc = {
 			.nid = NUMA_NO_NODE,
 			.gfp_mask = GFP_USER | __GFP_NOWARN,
 			.reason = MR_LONGTERM_PIN,
 		};
 
-		if (migrate_pages(movable_page_list, alloc_migration_target,
+		if (migrate_pages(movable_folio_list, alloc_migration_target,
 				  NULL, (unsigned long)&mtc, MIGRATE_SYNC,
 				  MR_LONGTERM_PIN, NULL)) {
 			ret = -ENOMEM;
@@ -2548,48 +2549,71 @@ static int migrate_longterm_unpinnable_p
 		}
 	}
 
-	putback_movable_pages(movable_page_list);
+	putback_movable_pages(movable_folio_list);
 
 	return -EAGAIN;
 
 err:
-	for (i = 0; i < nr_pages; i++)
-		if (pages[i])
-			unpin_user_page(pages[i]);
-	putback_movable_pages(movable_page_list);
+	unpin_folios(folios, nr_folios);
+	putback_movable_pages(movable_folio_list);
 
 	return ret;
 }
 
 /*
- * Check whether all pages are *allowed* to be pinned. Rather confusingly, all
- * pages in the range are required to be pinned via FOLL_PIN, before calling
- * this routine.
+ * Check whether all folios are *allowed* to be pinned indefinitely (longterm).
+ * Rather confusingly, all folios in the range are required to be pinned via
+ * FOLL_PIN, before calling this routine.
  *
- * If any pages in the range are not allowed to be pinned, then this routine
- * will migrate those pages away, unpin all the pages in the range and return
+ * If any folios in the range are not allowed to be pinned, then this routine
+ * will migrate those folios away, unpin all the folios in the range and return
  * -EAGAIN. The caller should re-pin the entire range with FOLL_PIN and then
  * call this routine again.
  *
  * If an error other than -EAGAIN occurs, this indicates a migration failure.
  * The caller should give up, and propagate the error back up the call stack.
  *
- * If everything is OK and all pages in the range are allowed to be pinned, then
- * this routine leaves all pages pinned and returns zero for success.
+ * If everything is OK and all folios in the range are allowed to be pinned,
+ * then this routine leaves all folios pinned and returns zero for success.
  */
-static long check_and_migrate_movable_pages(unsigned long nr_pages,
-					    struct page **pages)
+static long check_and_migrate_movable_folios(unsigned long nr_folios,
+					     struct folio **folios)
 {
 	unsigned long collected;
-	LIST_HEAD(movable_page_list);
+	LIST_HEAD(movable_folio_list);
 
-	collected = collect_longterm_unpinnable_pages(&movable_page_list,
-						nr_pages, pages);
+	collected = collect_longterm_unpinnable_folios(&movable_folio_list,
+						       nr_folios, folios);
 	if (!collected)
 		return 0;
 
-	return migrate_longterm_unpinnable_pages(&movable_page_list, nr_pages,
-						pages);
+	return migrate_longterm_unpinnable_folios(&movable_folio_list,
+						  nr_folios, folios);
+}
+
+/*
+ * This routine just converts all the pages in the @pages array to folios and
+ * calls check_and_migrate_movable_folios() to do the heavy lifting.
+ *
+ * Please see the check_and_migrate_movable_folios() documentation for details.
+ */
+static long check_and_migrate_movable_pages(unsigned long nr_pages,
+					    struct page **pages)
+{
+	struct folio **folios;
+	long i, ret;
+
+	folios = kmalloc_array(nr_pages, sizeof(*folios), GFP_KERNEL);
+	if (!folios)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_pages; i++)
+		folios[i] = page_folio(pages[i]);
+
+	ret = check_and_migrate_movable_folios(nr_pages, folios);
+
+	kfree(folios);
+	return ret;
 }
 #else
 static long check_and_migrate_movable_pages(unsigned long nr_pages,
@@ -2597,6 +2621,12 @@ static long check_and_migrate_movable_pa
 {
 	return 0;
 }
+
+static long check_and_migrate_movable_folios(unsigned long nr_folios,
+					     struct folio **folios)
+{
+	return 0;
+}
 #endif /* CONFIG_MIGRATION */
 
 /*
_

Patches currently in -mm which might be from vivek.kasireddy@intel.com are


