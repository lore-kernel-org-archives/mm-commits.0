Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671487EF12
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104016; cv=none; b=mYpmX0pyedvi+ATH7kcdE3JFVsOVuOXVfu4kDP8C/tPESm09npLJS/mGeX/aHG0tYlNUxiLzYPc0X1jQjmYVSM3YjAMt2HLUG/w2FWZbNl+OrJa8lbDuZ9i1qHFAmf0jz/QpOA/SOzOd8mxeLAQvx0BDt1e1pWv1CKKvPGm8qAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104016; c=relaxed/simple;
	bh=XOAWe+B/tJuR0F3yhqM+VnU4iB5GFHztldPKW30cVvY=;
	h=Date:To:From:Subject:Message-Id; b=GyelwQ9D1ROpmisOqChvz5lDxw55ZnImlQ9EpSczcD1h41Sv2eDlqkQDbj1ZubRsw7dXTq1na/SI8GYCGhhd+TwLx+qRP9ow33jYT+V+nWQewYPyST9HZjTUWWBAeLrUgS7OunfrjEokqJPlX2jan1UTGxzP2Un3MAwBfDugYW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ahoZfTyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ahoZfTyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDDCC113CD;
	Fri, 26 Apr 2024 04:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104016;
	bh=XOAWe+B/tJuR0F3yhqM+VnU4iB5GFHztldPKW30cVvY=;
	h=Date:To:From:Subject:From;
	b=ahoZfTyRZ0vt60iRBdL+GuD40Ol8i9cegpUYAlLvxXVxvlsLt2Sz448BG78vdro6y
	 KkiYM1VTh3JI4f0D7vNzKeTVWHI9cVHBW08C7TXQKXPth+6E01tD/PeUJjmONvzdC4
	 ves9rvDwgNFBi2PMIg5M7q8lRs9BIxRG8Prs4P/I=
Date: Thu, 25 Apr 2024 21:00:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch removed from -mm tree
Message-Id: <20240426040016.3BDDCC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make folio_test_idle and folio_test_young take a const argument
has been removed from the -mm tree.  Its filename was
     mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: make folio_test_idle and folio_test_young take a const argument
Date: Tue, 26 Mar 2024 17:10:26 +0000

If these functions are defined in page-flags.h, they already take a const
argument; make it true for these alternate definitions too.

Link: https://lkml.kernel.org/r/20240326171045.410737-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_idle.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/page_idle.h~mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument
+++ a/include/linux/page_idle.h
@@ -13,7 +13,7 @@
  * If there is not enough space to store Idle and Young bits in page flags, use
  * page ext flags instead.
  */
-static inline bool folio_test_young(struct folio *folio)
+static inline bool folio_test_young(const struct folio *folio)
 {
 	struct page_ext *page_ext = page_ext_get(&folio->page);
 	bool page_young;
@@ -52,7 +52,7 @@ static inline bool folio_test_clear_youn
 	return page_young;
 }
 
-static inline bool folio_test_idle(struct folio *folio)
+static inline bool folio_test_idle(const struct folio *folio)
 {
 	struct page_ext *page_ext = page_ext_get(&folio->page);
 	bool page_idle;
@@ -60,7 +60,7 @@ static inline bool folio_test_idle(struc
 	if (unlikely(!page_ext))
 		return false;
 
-	page_idle =  test_bit(PAGE_EXT_IDLE, &page_ext->flags);
+	page_idle = test_bit(PAGE_EXT_IDLE, &page_ext->flags);
 	page_ext_put(page_ext);
 
 	return page_idle;
@@ -91,7 +91,7 @@ static inline void folio_clear_idle(stru
 
 #else /* !CONFIG_PAGE_IDLE_FLAG */
 
-static inline bool folio_test_young(struct folio *folio)
+static inline bool folio_test_young(const struct folio *folio)
 {
 	return false;
 }
@@ -105,7 +105,7 @@ static inline bool folio_test_clear_youn
 	return false;
 }
 
-static inline bool folio_test_idle(struct folio *folio)
+static inline bool folio_test_idle(const struct folio *folio)
 {
 	return false;
 }
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

