Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5349918EAD;
	Tue,  5 Nov 2024 04:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730779726; cv=none; b=DEZZzi49D4waUfCwB5jdmXzzwUlFztu9KXdUm40UckJ9ba3Lt2mrs6GqdXlKM44f0V0uhLTQ9Bbj4Q6hYXdYHftwCQzD0jwSvrSDaLTGQ4khmOc+znjCCgxWu/bm8bT7QExX90DdRQ0yZ32GvnxljiigkgOFyt0p3VbCSoFOfm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730779726; c=relaxed/simple;
	bh=24kRrW8ID/qKNZKhjNJgZxAwpQ5Wo7eTmn9g6afYQ30=;
	h=Date:To:From:Subject:Message-Id; b=atWQjw0Xd0OMjW7boOsGE+Ih/IN6QVqxYy091BMtPQKmGNeCaF68kLX7c+YoApq9B228Q/ANSboVh730WZgZJfzM1mioDeHgBCEJvqnvkW5OAgOXPsofa3Ihf6+QeIaeQFVS5I8ZPkNGXAHKtnO60LEJ/Cu5dRcXr+PTKzs+nQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QnQ37iTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QnQ37iTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFDEC4CED2;
	Tue,  5 Nov 2024 04:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730779725;
	bh=24kRrW8ID/qKNZKhjNJgZxAwpQ5Wo7eTmn9g6afYQ30=;
	h=Date:To:From:Subject:From;
	b=QnQ37iTMmNmO0JC7SvbEkCzwMEeOd1WrzJkuJj8nkt16r3JKfXg2K5J5NrZI/9qUJ
	 tdUpIkwEutnwW0AVDkC6EwcGm1LJI2lGaU/BFbd8qWXczgtJSTkijEdslQtXZ2m/Yd
	 ZuvzDemdoRcYjNxE4TXlrO12BF9SPRDVS+Jse23Q=
Date: Mon, 04 Nov 2024 20:08:45 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,stable@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,mike.kravetz@oracle.com,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,airlied@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases.patch added to mm-hotfixes-unstable branch
Message-Id: <20241105040845.ACFDEC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: avoid an unnecessary allocation call for FOLL_LONGTERM cases
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: avoid an unnecessary allocation call for FOLL_LONGTERM cases
Date: Mon, 4 Nov 2024 19:29:44 -0800

commit 53ba78de064b ("mm/gup: introduce
check_and_migrate_movable_folios()") created a new constraint on the
pin_user_pages*() API family: a potentially large internal allocation must
now occur, for FOLL_LONGTERM cases.

A user-visible consequence has now appeared: user space can no longer pin
more than 2GB of memory anymore on x86_64.  That's because, on a 4KB
PAGE_SIZE system, when user space tries to (indirectly, via a device
driver that calls pin_user_pages()) pin 2GB, this requires an allocation
of a folio pointers array of MAX_PAGE_ORDER size, which is the limit for
kmalloc().

In addition to the directly visible effect described above, there is also
the problem of adding an unnecessary allocation.  The **pages array
argument has already been allocated, and there is no need for a redundant
**folios array allocation in this case.

Fix this by avoiding the new allocation entirely.  This is done by
referring to either the original page[i] within **pages, or to the
associated folio.  Thanks to David Hildenbrand for suggesting this
approach and for providing the initial implementation (which I've tested
and adjusted slightly) as well.

Link: https://lkml.kernel.org/r/20241105032944.141488-2-jhubbard@nvidia.com
Fixes: 53ba78de064b ("mm/gup: introduce check_and_migrate_movable_folios()")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  116 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 77 insertions(+), 39 deletions(-)

--- a/mm/gup.c~mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases
+++ a/mm/gup.c
@@ -2273,20 +2273,57 @@ struct page *get_dump_page(unsigned long
 #endif /* CONFIG_ELF_CORE */
 
 #ifdef CONFIG_MIGRATION
+
+/*
+ * An array of either pages or folios ("pofs"). Although it may seem tempting to
+ * avoid this complication, by simply interpreting a list of folios as a list of
+ * pages, that approach won't work in the longer term, because eventually the
+ * layouts of struct page and struct folio will become completely different.
+ * Furthermore, this pof approach avoids excessive page_folio() calls.
+ */
+struct pages_or_folios {
+	union {
+		struct page **pages;
+		struct folio **folios;
+		void **entries;
+	};
+	bool has_folios;
+	long nr_entries;
+};
+
+static struct folio *pofs_get_folio(struct pages_or_folios *pofs, long i)
+{
+	if (pofs->has_folios)
+		return pofs->folios[i];
+	return page_folio(pofs->pages[i]);
+}
+
+static void pofs_clear_entry(struct pages_or_folios *pofs, long i)
+{
+	pofs->entries[i] = NULL;
+}
+
+static void pofs_unpin(struct pages_or_folios *pofs)
+{
+	if (pofs->has_folios)
+		unpin_folios(pofs->folios, pofs->nr_entries);
+	else
+		unpin_user_pages(pofs->pages, pofs->nr_entries);
+}
+
 /*
  * Returns the number of collected folios. Return value is always >= 0.
  */
 static unsigned long collect_longterm_unpinnable_folios(
-					struct list_head *movable_folio_list,
-					unsigned long nr_folios,
-					struct folio **folios)
+		struct list_head *movable_folio_list,
+		struct pages_or_folios *pofs)
 {
 	unsigned long i, collected = 0;
 	struct folio *prev_folio = NULL;
 	bool drain_allow = true;
 
-	for (i = 0; i < nr_folios; i++) {
-		struct folio *folio = folios[i];
+	for (i = 0; i < pofs->nr_entries; i++) {
+		struct folio *folio = pofs_get_folio(pofs, i);
 
 		if (folio == prev_folio)
 			continue;
@@ -2327,16 +2364,15 @@ static unsigned long collect_longterm_un
  * Returns -EAGAIN if all folios were successfully migrated or -errno for
  * failure (or partial success).
  */
-static int migrate_longterm_unpinnable_folios(
-					struct list_head *movable_folio_list,
-					unsigned long nr_folios,
-					struct folio **folios)
+static int
+migrate_longterm_unpinnable_folios(struct list_head *movable_folio_list,
+				   struct pages_or_folios *pofs)
 {
 	int ret;
 	unsigned long i;
 
-	for (i = 0; i < nr_folios; i++) {
-		struct folio *folio = folios[i];
+	for (i = 0; i < pofs->nr_entries; i++) {
+		struct folio *folio = pofs_get_folio(pofs, i);
 
 		if (folio_is_device_coherent(folio)) {
 			/*
@@ -2344,7 +2380,7 @@ static int migrate_longterm_unpinnable_f
 			 * convert the pin on the source folio to a normal
 			 * reference.
 			 */
-			folios[i] = NULL;
+			pofs_clear_entry(pofs, i);
 			folio_get(folio);
 			gup_put_folio(folio, 1, FOLL_PIN);
 
@@ -2363,8 +2399,8 @@ static int migrate_longterm_unpinnable_f
 		 * calling folio_isolate_lru() which takes a reference so the
 		 * folio won't be freed if it's migrating.
 		 */
-		unpin_folio(folios[i]);
-		folios[i] = NULL;
+		unpin_folio(pofs_get_folio(pofs, i));
+		pofs_clear_entry(pofs, i);
 	}
 
 	if (!list_empty(movable_folio_list)) {
@@ -2387,12 +2423,26 @@ static int migrate_longterm_unpinnable_f
 	return -EAGAIN;
 
 err:
-	unpin_folios(folios, nr_folios);
+	pofs_unpin(pofs);
 	putback_movable_pages(movable_folio_list);
 
 	return ret;
 }
 
+static long
+check_and_migrate_movable_pages_or_folios(struct pages_or_folios *pofs)
+{
+	LIST_HEAD(movable_folio_list);
+	unsigned long collected;
+
+	collected =
+		collect_longterm_unpinnable_folios(&movable_folio_list, pofs);
+	if (!collected)
+		return 0;
+
+	return migrate_longterm_unpinnable_folios(&movable_folio_list, pofs);
+}
+
 /*
  * Check whether all folios are *allowed* to be pinned indefinitely (long term).
  * Rather confusingly, all folios in the range are required to be pinned via
@@ -2417,16 +2467,13 @@ err:
 static long check_and_migrate_movable_folios(unsigned long nr_folios,
 					     struct folio **folios)
 {
-	unsigned long collected;
-	LIST_HEAD(movable_folio_list);
+	struct pages_or_folios pofs = {
+		.folios = folios,
+		.has_folios = true,
+		.nr_entries = nr_folios,
+	};
 
-	collected = collect_longterm_unpinnable_folios(&movable_folio_list,
-						       nr_folios, folios);
-	if (!collected)
-		return 0;
-
-	return migrate_longterm_unpinnable_folios(&movable_folio_list,
-						  nr_folios, folios);
+	return check_and_migrate_movable_pages_or_folios(&pofs);
 }
 
 /*
@@ -2436,22 +2483,13 @@ static long check_and_migrate_movable_fo
 static long check_and_migrate_movable_pages(unsigned long nr_pages,
 					    struct page **pages)
 {
-	struct folio **folios;
-	long i, ret;
-
-	folios = kmalloc_array(nr_pages, sizeof(*folios), GFP_KERNEL);
-	if (!folios) {
-		unpin_user_pages(pages, nr_pages);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < nr_pages; i++)
-		folios[i] = page_folio(pages[i]);
+	struct pages_or_folios pofs = {
+		.pages = pages,
+		.has_folios = false,
+		.nr_entries = nr_pages,
+	};
 
-	ret = check_and_migrate_movable_folios(nr_pages, folios);
-
-	kfree(folios);
-	return ret;
+	return check_and_migrate_movable_pages_or_folios(&pofs);
 }
 #else
 static long check_and_migrate_movable_pages(unsigned long nr_pages,
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases.patch
kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end.patch

