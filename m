Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFEE80BF8
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104131; cv=none; b=iMUA4lBxhPP0nWiq/SdNNajB7KDp1MJ+IJWoXZ5b3bBxbrZPKHeh++sjchA0GfWezcNZvuV7gLgH72cXeDtg96R7ordO4lX7/W/9wI58NF62kI9Ad4AZy+nsdqE2df/klKwzTt12hx+U15g8bcZilla6gCOZwSOjLbXNDmpwuxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104131; c=relaxed/simple;
	bh=adIgyPhR5eVHm6xV3R7LABjNiIMWwS+EgOZtDaA9ynw=;
	h=Date:To:From:Subject:Message-Id; b=Ud4a6ftGbOVq+VeMlRr9+5OaSD3iwl4llBOgTGgptjh3v5P66BnjRB36bRut8iEjR0VQqq1FDOomkMMVVzrJ6TPN8qMeesRR+OrnkVI5oQDr6vzhqVHUdM0+9Od+NVacNtKDGF9/ZSFI5aJGQNwS6/LF7TYgX9czlGkMkkIKqcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nldt+mmz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nldt+mmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3CAC113CD;
	Fri, 26 Apr 2024 04:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104130;
	bh=adIgyPhR5eVHm6xV3R7LABjNiIMWwS+EgOZtDaA9ynw=;
	h=Date:To:From:Subject:From;
	b=Nldt+mmzbsZWnFJbTPVMCXxE5hO8JklclmrIT+19u7IORGzJUHnYNnuDsS2bBR1jB
	 0IctIJoejh5FKMvccRoT4OQunUPrNeqKy//3KzzU3iNBiu9ZonuJoUETzOrPB6OSXz
	 TqK1pn5m506U+D7dCv6fzrTjaGtLECmasEoRPsfk=
Date: Thu, 25 Apr 2024 21:02:10 -0700
To: mm-commits@vger.kernel.org,brauner@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-convert-gather_stats-to-use-a-folio.patch removed from -mm tree
Message-Id: <20240426040210.AC3CAC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: convert gather_stats to use a folio
has been removed from the -mm tree.  Its filename was
     proc-convert-gather_stats-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc: convert gather_stats to use a folio
Date: Wed, 3 Apr 2024 18:14:52 +0100

Patch series "Use folio APIs in procfs".

We're down to very few users of the PageFoo macros, with proc being a
major user.

After this patchset and another patchset I have for khugepaged, we can get
rid of PageActive, PageReadahead and PageSwapBacked.  This patchset has
the usual advantages in its own right of removing hidden calls to
compound_head().  We have the page table lock, so the mapcount & refcount
are stable and there can't be any races with folios suddenly becoming tail
pages.


This patch (of 4):

Replaces six calls to compound_head() with one.  Shrinks the function from
5054 bytes to 1756 bytes in an allmodconfig build.

Link: https://lkml.kernel.org/r/20240403171456.1445117-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240403171456.1445117-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/proc/task_mmu.c~proc-convert-gather_stats-to-use-a-folio
+++ a/fs/proc/task_mmu.c
@@ -2549,28 +2549,29 @@ struct numa_maps_private {
 static void gather_stats(struct page *page, struct numa_maps *md, int pte_dirty,
 			unsigned long nr_pages)
 {
+	struct folio *folio = page_folio(page);
 	int count = page_mapcount(page);
 
 	md->pages += nr_pages;
-	if (pte_dirty || PageDirty(page))
+	if (pte_dirty || folio_test_dirty(folio))
 		md->dirty += nr_pages;
 
-	if (PageSwapCache(page))
+	if (folio_test_swapcache(folio))
 		md->swapcache += nr_pages;
 
-	if (PageActive(page) || PageUnevictable(page))
+	if (folio_test_active(folio) || folio_test_unevictable(folio))
 		md->active += nr_pages;
 
-	if (PageWriteback(page))
+	if (folio_test_writeback(folio))
 		md->writeback += nr_pages;
 
-	if (PageAnon(page))
+	if (folio_test_anon(folio))
 		md->anon += nr_pages;
 
 	if (count > md->mapcount_max)
 		md->mapcount_max = count;
 
-	md->node[page_to_nid(page)] += nr_pages;
+	md->node[folio_nid(folio)] += nr_pages;
 }
 
 static struct page *can_gather_numa_stats(pte_t pte, struct vm_area_struct *vma,
_

Patches currently in -mm which might be from willy@infradead.org are

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch

