Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A912146D5A
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 04:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789963775; cv=none; b=O7LMTY/0QMBUD5cAifN5/tV9vgi0H25PMV23KccIr6iO+JY/voO1rYrIamCf1jxuW5OvT8eujH23HdKzvkamXvI5m4DySXNOdlkOc5SZLE7XjtpMLZ8MPbpp0vN+VxVUQdaRkA1Io1hwMT/H4mZPvTWtGC8uZOh47DKmVT7Ns+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789963775; c=relaxed/simple;
	bh=SFMA0Oo6dznwkPKfFraOKAa9obzOF+aBhYj0nTicIdA=;
	h=Date:To:From:Subject:Message-Id; b=rHRWZGD5NG9Ad8YbsxVd27eGHOT3pL1jGklkNU2/omX0dqdoUiXWQ1ci2vI6VIX378CThQeC/lQt6TnaccIdsic4pbktikjjVX2pymtDQAe1diKd8D/q+kS8H3Rnmk+oaP17zb+NsnU6/gOW28Off9sgMcfEiEzykezeOAym/Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kI9Rs/KW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kI9Rs/KW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDAB1F000FF;
	Mon, 21 Sep 2026 04:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789963773;
	bh=R1VPTO8KNJkgYnJUs37dEIhGDK9DxDNcXnr2RdEEcFs=;
	h=Date:To:From:Subject;
	b=kI9Rs/KW4cCpIcU1v5axY7ZaTBPBC/cG/coAxwmm4REiCvGvSSKkyQIDZAcsCEQ+5
	 s5HR+TpXmb13D7WdnI1Fig9gNNZxvQjIBriIC/KvaDdiQTXc+j7vnSitaTqpIFEwbw
	 A3QFBFNEANypegJzkUm9hb7GmJLcYfZ5aa4pO3ZI=
Date: Sun, 20 Sep 2026 21:09:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-replace-pg_private-with-pointer-comparison.patch added to mm-unstable branch
Message-Id: <20260921040933.ADDAB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: replace PG_private with pointer comparison
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-replace-pg_private-with-pointer-comparison.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-replace-pg_private-with-pointer-comparison.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/zsmalloc: replace PG_private with pointer comparison
Date: Sun, 20 Sep 2026 22:27:57 -0400

Patch series "Remove PG_private by using page/folio->private checks
instead", v5.

This patchset removes PG_private to make space for upcoming PG_folio for
identifying pages from a folio (more details in Note below).  Instead of
checking PG_private, all code is changed to check page/folio->private !=
NULL instead.

Overview
===
Most code uses folio_attach/detach/change_private() functions, so folio
refcount is increased and decreased when folio->private is set and reset,
respectively. There is no need to change them.

Changes are needed for exceptional users:
1. zsmalloc uses PG_private to indicate first component zpdesc page and
   page->private is used to store zspage in zpdesc. To remove PG_private,
   is_first_zpdesc() is replaced by pointer comparison.

2. kernel/events/ring_buffer.c stores page order in page->private.
   Replacing PG_private with page->private != NULL works.

3. drivers/xen/grant-table.c stores xen_page_foreign in page->private,
   where on 32-bit, a pointer to xen_page_foreign is stored; on 64-bit,
   page->private is used as xen_page_foreign. PG_private check is replaced
   by page->private != NULL on 32-bit for xen_page_foreign deallocation.
   On 64-bit, page->private is cleared unconditionally since {domid=0,
   gref=0} (xen_page_foreign can be 0) is valid.

4. fs/crypto/crypto.c stores a folio pointer in page->private, PG_private
   checks are replaced by page->private != NULL.

5. fs/erofs has two different uses:

    5a. folio->private is used to form a reversed list of
    the outputs of readahead_folio(). readahead_folio_last() is added to
    output folios in reversed order, so that ->private is no longer needed.

    5b. folio->private is used as an in-flight I/O counter. Convert the
    code to use folio_attach/detach/get_private() and add bias==1 to the
    counter to avoid folio->private being zero.

6. fs/nfs/write.c: folio refcount maintenance is in a bigger scope than
   folio->private. So folio_attach/detach/get_private() is not used.
   Nothing to change.

7. fs/f2fs uses attach_page_private() to first reset folio->private then
   immediately sets PAGE_PRIVATE_NOT_POINTER bit on it. Change it to use
   attach_page_private() to set PAGE_PRIVATE_NOT_POINTER bit directly to
   avoid folio->private == NULL gap inside set_page_private_##name().

8. hugetlb uses folio_change_private(folio, NULL) without folio refcount
   maintenance. Change it to folio->private = NULL.

After the above changes, PG_private ops are converted to
page/folio->private ops.

folio_has_attached_private() is added to check filesystem-only private data
by excluding swapcache and hugetlb folios, because swapcache folios overlap
swp_entry_t swap with ->private and hugetlb sets its own flags in
->private.

Note
===
1. KPF_PRIVATE is removed after PG_private is removed.

2. Documentation/mm/hugetlbfs_reserv.rst is outdated, so I did not remove
   PG_private related text. It should be rewritten.

3. PG_folio is planned to be set on every page from a folio in
   page_rmappable_folio(), so folios with any order (currently
   PG_large_rmappable is used to identify >0 order folios, but not order-0
   folios) can be identified. Then vm_insert_*() can correctly reject all
   folios and rmap code will only see folios. Eventually, page_folio()
   will return NULL for non-folio pages by checking PG_folio, but before
   that all existing users that treat compound pages as folios will need
   to be converted.


This patch (of 17):

zsmalloc uses PG_private to indicate first zpdesc in a zspage chain. It is
equivalent to check zpdesc == zspage->first_zpdesc. Replace
is_first_zpdesc() with zpdesc == zspage->first_zpdesc in obj_allocated().

For get_first_zpdesc(), first_zpdesc is from zspage->first_zpdesc, so
replace is_first_zpdesc() with first_zpdesc->zspage == zspage, the second
requirement of a zspage chain, where all zpdescs point to the same zspage.

is_first_zpdesc(), is only used in VM_BUG_ON_PAGE(), so performance impact
should be negligible. While at it, change VM_BUG_ON() to
VM_WARN_ON_ONCE_PAGE().

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: LLM
Link: https://lore.kernel.org/20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com
Link: https://lore.kernel.org/20260920-remove-pg_private-v5-1-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
---

 mm/zpdesc.h   |    2 +-
 mm/zsmalloc.c |   24 ++++++------------------
 2 files changed, 7 insertions(+), 19 deletions(-)

--- a/mm/zpdesc.h~mm-zsmalloc-replace-pg_private-with-pointer-comparison
+++ a/mm/zpdesc.h
@@ -26,8 +26,8 @@
  * with memcg_data.
  *
  * Page flags used:
- * * PG_private identifies the first component page.
  * * PG_locked is used by page migration code.
+ * The first component page has zpdesc->zspage->first_zpdesc == zpdesc
  */
 struct zpdesc {
 	unsigned long flags;
--- a/mm/zsmalloc.c~mm-zsmalloc-replace-pg_private-with-pointer-comparison
+++ a/mm/zsmalloc.c
@@ -290,11 +290,6 @@ struct zs_pool {
 	atomic_t compaction_in_progress;
 };
 
-static inline void zpdesc_set_first(struct zpdesc *zpdesc)
-{
-	SetPagePrivate(zpdesc_page(zpdesc));
-}
-
 static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
 {
 	inc_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
@@ -476,11 +471,6 @@ static void record_obj(unsigned long han
 	WRITE_ONCE(*(unsigned long *)handle, obj);
 }
 
-static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
-{
-	return PagePrivate(zpdesc_page(zpdesc));
-}
-
 /* Protected by class->lock */
 static inline int get_zspage_inuse(struct zspage *zspage)
 {
@@ -496,7 +486,8 @@ static struct zpdesc *get_first_zpdesc(s
 {
 	struct zpdesc *first_zpdesc = zspage->first_zpdesc;
 
-	VM_BUG_ON_PAGE(!is_first_zpdesc(first_zpdesc), zpdesc_page(first_zpdesc));
+	/* the first zpdesc must point back to this zspage */
+	VM_WARN_ON_ONCE_PAGE(first_zpdesc->zspage != zspage, zpdesc_page(first_zpdesc));
 	return first_zpdesc;
 }
 
@@ -838,7 +829,8 @@ static inline bool obj_allocated(struct
 	struct zspage *zspage = get_zspage(zpdesc);
 
 	if (unlikely(ZsHugePage(zspage))) {
-		VM_BUG_ON_PAGE(!is_first_zpdesc(zpdesc), zpdesc_page(zpdesc));
+		/* only first zpdesc holds the handle */
+		VM_WARN_ON_ONCE_PAGE(zspage->first_zpdesc != zpdesc, zpdesc_page(zpdesc));
 		handle = zpdesc->handle;
 	} else
 		handle = *(unsigned long *)obj;
@@ -853,9 +845,6 @@ static inline bool obj_allocated(struct
 
 static void reset_zpdesc(struct zpdesc *zpdesc)
 {
-	struct page *page = zpdesc_page(zpdesc);
-
-	ClearPagePrivate(page);
 	zpdesc->zspage = NULL;
 	zpdesc->next = NULL;
 	/* PageZsmalloc is sticky until the page is freed to the buddy. */
@@ -1006,8 +995,8 @@ static void create_page_chain(struct siz
 	 * 1. all pages are linked together using zpdesc->next
 	 * 2. each sub-page point to zspage using zpdesc->zspage
 	 *
-	 * we set PG_private to identify the first zpdesc (i.e. no other zpdesc
-	 * has this flag set).
+	 * The first zpdesc has its zspage->first_zpdesc set to itself, no
+	 * other zpdesc has this set.
 	 */
 	for (i = 0; i < nr_zpdescs; i++) {
 		zpdesc = zpdescs[i];
@@ -1015,7 +1004,6 @@ static void create_page_chain(struct siz
 		zpdesc->next = NULL;
 		if (i == 0) {
 			zspage->first_zpdesc = zpdesc;
-			zpdesc_set_first(zpdesc);
 			if (unlikely(class->objs_per_zspage == 1 &&
 					class->pages_per_zspage == 1))
 				SetZsHugePage(zspage);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-zsmalloc-replace-pg_private-with-pointer-comparison.patch
perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch
xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping.patch
fscrypt-stop-setting-pg_private-on-bounce-page.patch
mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch
f2fs-stop-using-pg_private.patch
f2fs-convert-the-private-flag-helpers-to-folio-only.patch
erofs-mm-pagemap-add-readahead_folio_last-to-avoid-folio-private.patch
erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch
mm-page-flags-check-page-folio-private-instead-of-pg_private.patch
treewide-remove-folio_set-clear_private-usage.patch
ceph-replace-pageprivate-with-page_private.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

