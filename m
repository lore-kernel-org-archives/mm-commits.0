Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CD11E4A3;
	Mon, 18 Dec 2023 16:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YorlBlFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5C0C433C7;
	Mon, 18 Dec 2023 16:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702918636;
	bh=GvoKdwwn+fGa9nezlr0HyulvRqAygr2NEV1r+UTn23I=;
	h=Date:To:From:Subject:From;
	b=YorlBlFc+m4XiIQtXKsFYDkTSgkoVoetNzFFpccVH/w804fp1zECAt6osPr9h3QKI
	 +f07f5Ckllsy79nn0U3R7KzwYs+uThqTk4x9P9eSlv3wR5lVvg75qdW06y1jq2vWA5
	 vbGckAop+AqmhREjrs0ekT6Ckfb89Tw0Q0mdnwaU=
Date: Mon, 18 Dec 2023 08:57:15 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,n-horiguchi@ah.jp.nec.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-pass-the-folio-and-the-page-to-collect_procs.patch added to mm-hotfixes-unstable branch
Message-Id: <20231218165716.1C5C0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: pass the folio and the page to collect_procs()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-pass-the-folio-and-the-page-to-collect_procs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-pass-the-folio-and-the-page-to-collect_procs.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memory-failure: pass the folio and the page to collect_procs()
Date: Mon, 18 Dec 2023 13:58:35 +0000

Patch series "Three memory-failure fixes".

I've been looking at the memory-failure code and I believe I have found
three bugs that need fixing -- one going all the way back to 2010!  I'll
have more patches later to use folios more extensively but didn't want
these bugfixes to get caught up in that.


This patch (of 3):

Both collect_procs_anon() and collect_procs_file() iterate over the VMA
interval trees looking for a single pgoff, so it is wrong to look for the
pgoff of the head page as is currently done.  However, it is also wrong to
look at page->mapping of the precise page as this is invalid for tail
pages.  Clear up the confusion by passing both the folio and the precise
page to collect_procs().

Link: https://lkml.kernel.org/r/20231218135837.3310403-2-willy@infradead.org
Fixes: 415c64c1453a ("mm/memory-failure: split thp earlier in memory error handling")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-pass-the-folio-and-the-page-to-collect_procs
+++ a/mm/memory-failure.c
@@ -595,10 +595,9 @@ struct task_struct *task_early_kill(stru
 /*
  * Collect processes when the error hit an anonymous page.
  */
-static void collect_procs_anon(struct page *page, struct list_head *to_kill,
-				int force_early)
+static void collect_procs_anon(struct folio *folio, struct page *page,
+		struct list_head *to_kill, int force_early)
 {
-	struct folio *folio = page_folio(page);
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
 	struct anon_vma *av;
@@ -633,12 +632,12 @@ static void collect_procs_anon(struct pa
 /*
  * Collect processes when the error hit a file mapped page.
  */
-static void collect_procs_file(struct page *page, struct list_head *to_kill,
-				int force_early)
+static void collect_procs_file(struct folio *folio, struct page *page,
+		struct list_head *to_kill, int force_early)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = folio->mapping;
 	pgoff_t pgoff;
 
 	i_mmap_lock_read(mapping);
@@ -704,17 +703,17 @@ static void collect_procs_fsdax(struct p
 /*
  * Collect the processes who have the corrupted page mapped to kill.
  */
-static void collect_procs(struct page *page, struct list_head *tokill,
-				int force_early)
+static void collect_procs(struct folio *folio, struct page *page,
+		struct list_head *tokill, int force_early)
 {
-	if (!page->mapping)
+	if (!folio->mapping)
 		return;
 	if (unlikely(PageKsm(page)))
 		collect_procs_ksm(page, tokill, force_early);
 	else if (PageAnon(page))
-		collect_procs_anon(page, tokill, force_early);
+		collect_procs_anon(folio, page, tokill, force_early);
 	else
-		collect_procs_file(page, tokill, force_early);
+		collect_procs_file(folio, page, tokill, force_early);
 }
 
 struct hwpoison_walk {
@@ -1602,7 +1601,7 @@ static bool hwpoison_user_mappings(struc
 	 * mapped in dirty form.  This has to be done before try_to_unmap,
 	 * because ttu takes the rmap data structures down.
 	 */
-	collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
+	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
 
 	if (PageHuge(hpage) && !PageAnon(hpage)) {
 		/*
@@ -1772,7 +1771,7 @@ static int mf_generic_kill_procs(unsigne
 	 * SIGBUS (i.e. MF_MUST_KILL)
 	 */
 	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
-	collect_procs(&folio->page, &to_kill, true);
+	collect_procs(folio, &folio->page, &to_kill, true);
 
 	unmap_and_kill(&to_kill, pfn, folio->mapping, folio->index, flags);
 unlock:
_

Patches currently in -mm which might be from willy@infradead.org are

mm-memory-failure-pass-the-folio-and-the-page-to-collect_procs.patch
mm-memory-failure-check-the-mapcount-of-the-precise-page.patch
mm-memory-failure-cast-index-to-loff_t-before-shifting-it.patch
mailmap-add-an-old-address-for-naoya-horiguchi.patch
buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios-fix.patch
mm-remove-pageanonexclusive-assertions-in-unuse_pte.patch
mm-convert-unuse_pte-to-use-a-folio-throughout.patch
mm-remove-some-calls-to-page_add_new_anon_rmap.patch
mm-remove-stale-example-from-comment.patch
mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch
mm-convert-migrate_vma_insert_page-to-use-a-folio.patch
mm-convert-collapse_huge_page-to-use-a-folio.patch
mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch
mm-return-the-folio-from-__read_swap_cache_async.patch
mm-pass-a-folio-to-__swap_writepage.patch
mm-pass-a-folio-to-swap_writepage_fs.patch
mm-pass-a-folio-to-swap_writepage_bdev_sync.patch
mm-pass-a-folio-to-swap_writepage_bdev_async.patch
mm-pass-a-folio-to-swap_readpage_fs.patch
mm-pass-a-folio-to-swap_readpage_bdev_sync.patch
mm-pass-a-folio-to-swap_readpage_bdev_async.patch
mm-convert-swap_page_sector-to-swap_folio_sector.patch
mm-convert-swap_readpage-to-swap_read_folio.patch
mm-remove-page_swap_info.patch
mm-return-a-folio-from-read_swap_cache_async.patch
mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio.patch

