From: akpm@osdl.org
Subject: - mm-make-compound-page-destructor-handling-explicit.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:31 -0800
Message-ID: <200612072258.kB7MwVJc029413@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50856 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163667AbWLGW7E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     mm: make compound page destructor handling explicit
has been removed from the -mm tree.  Its filename was
     mm-make-compound-page-destructor-handling-explicit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: make compound page destructor handling explicit
From: Andy Whitcroft <apw@shadowen.org>

Currently we we use the lru head link of the second page of a compound page
to hold its destructor.  This was ok when it was purely an internal
implmentation detail.  However, hugetlbfs overrides this destructor
violating the layering.  Abstract this out as explicit calls, also
introduce a type for the callback function allowing them to be type
checked.  For each callback we pre-declare the function, causing a type
error on definition rather than on use elsewhere.

[akpm@osdl.org: cleanups]
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/mm.h |   18 ++++++++++++++++++
 mm/hugetlb.c       |    2 +-
 mm/page_alloc.c    |    2 +-
 mm/swap.c          |    4 ++--
 4 files changed, 22 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~mm-make-compound-page-destructor-handling-explicit include/linux/mm.h
--- a/include/linux/mm.h~mm-make-compound-page-destructor-handling-explicit
+++ a/include/linux/mm.h
@@ -296,6 +296,24 @@ void put_pages_list(struct list_head *pa
 void split_page(struct page *page, unsigned int order);
 
 /*
+ * Compound pages have a destructor function.  Provide a
+ * prototype for that function and accessor functions.
+ * These are _only_ valid on the head of a PG_compound page.
+ */
+typedef void compound_page_dtor(struct page *);
+
+static inline void set_compound_page_dtor(struct page *page,
+						compound_page_dtor *dtor)
+{
+	page[1].lru.next = (void *)dtor;
+}
+
+static inline compound_page_dtor *get_compound_page_dtor(struct page *page)
+{
+	return (compound_page_dtor *)page[1].lru.next;
+}
+
+/*
  * Multiple processes may "see" the same page. E.g. for untouched
  * mappings of /dev/null, all processes see the same page full of
  * zeroes, and text pages of executables and shared libraries have
diff -puN mm/hugetlb.c~mm-make-compound-page-destructor-handling-explicit mm/hugetlb.c
--- a/mm/hugetlb.c~mm-make-compound-page-destructor-handling-explicit
+++ a/mm/hugetlb.c
@@ -109,7 +109,7 @@ static int alloc_fresh_huge_page(void)
 	if (nid == MAX_NUMNODES)
 		nid = first_node(node_online_map);
 	if (page) {
-		page[1].lru.next = (void *)free_huge_page;	/* dtor */
+		set_compound_page_dtor(page, free_huge_page);
 		spin_lock(&hugetlb_lock);
 		nr_huge_pages++;
 		nr_huge_pages_node[page_to_nid(page)]++;
diff -puN mm/page_alloc.c~mm-make-compound-page-destructor-handling-explicit mm/page_alloc.c
--- a/mm/page_alloc.c~mm-make-compound-page-destructor-handling-explicit
+++ a/mm/page_alloc.c
@@ -230,7 +230,7 @@ static void prep_compound_page(struct pa
 	int i;
 	int nr_pages = 1 << order;
 
-	page[1].lru.next = (void *)free_compound_page;	/* set dtor */
+	set_compound_page_dtor(page, free_compound_page);
 	page[1].lru.prev = (void *)order;
 	for (i = 0; i < nr_pages; i++) {
 		struct page *p = page + i;
diff -puN mm/swap.c~mm-make-compound-page-destructor-handling-explicit mm/swap.c
--- a/mm/swap.c~mm-make-compound-page-destructor-handling-explicit
+++ a/mm/swap.c
@@ -57,9 +57,9 @@ static void put_compound_page(struct pag
 {
 	page = (struct page *)page_private(page);
 	if (put_page_testzero(page)) {
-		void (*dtor)(struct page *page);
+		compound_page_dtor *dtor;
 
-		dtor = (void (*)(struct page *))page[1].lru.next;
+		dtor = get_compound_page_dtor(page);
 		(*dtor)(page);
 	}
 }
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
git-acpi.patch
pci-device-ensure-sysdata-initialised-v2.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
optional-zone_dma-in-the-vm.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch

