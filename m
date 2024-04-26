Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E9280BF7
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104130; cv=none; b=FSKcPEYqaCi9irBOGXaMRW69D3kBJgLToZlf2PKxo/MYUy3qL0g7T7fYndGmgHdPZQK5081C4ny6hN4PPRZLf7e9xBeicnOjYA8aevylMlNa1YNy6NAO4T0/CxYK72lgzSM3B27zHifEPpuFBXlv0BFktp3L4tPyxaohICnNtR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104130; c=relaxed/simple;
	bh=oMDSS/+OmtkvrnR2ZWlLy2Nn7N25BBOvtcDh7dIMTOA=;
	h=Date:To:From:Subject:Message-Id; b=IecDfuR5XgzgZvlk6e+CS2ZPqbo6OoHQFwlIf9rlFbPWXunMlRsDF+GlppXlGpwnFVHsF1WyyLbZPn674p1s6BKT42puuz4nVc1cCXC5ECJ5TZxedYpLF/WfujxfcwlhYsSYRdrDNRxVvQw0Ro8m7cd/Gyx9Z6Wu8tB6XIu/n+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LcnHFS5Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LcnHFS5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5063C2BD11;
	Fri, 26 Apr 2024 04:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104129;
	bh=oMDSS/+OmtkvrnR2ZWlLy2Nn7N25BBOvtcDh7dIMTOA=;
	h=Date:To:From:Subject:From;
	b=LcnHFS5YJH2zfrQiwqkDEK8p/IcRN8MjJx3MWZc+PnQZnqza9Qm43J24cP/J3nDPs
	 0H6boHLk2iId39CdHK7gDCdFj/CglEud/arKurqvvyhhEm/ziazjzGGD+ZSD9G30pF
	 Hpour4S2jWeS9SZMIs1doZ0jWJanUIhzChYpxm5k=
Date: Thu, 25 Apr 2024 21:02:09 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-generate-page_idle_flag-definitions.patch removed from -mm tree
Message-Id: <20240426040209.A5063C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: generate PAGE_IDLE_FLAG definitions
has been removed from the -mm tree.  Its filename was
     mm-generate-page_idle_flag-definitions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: generate PAGE_IDLE_FLAG definitions
Date: Tue, 2 Apr 2024 21:12:51 +0100

If CONFIG_PAGE_IDLE_FLAG is not set, we can use FOLIO_FLAG_FALSE() to
generate these definitions.

Link: https://lkml.kernel.org/r/20240402201252.917342-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    9 +++++++-
 include/linux/page_idle.h  |   37 +----------------------------------
 2 files changed, 10 insertions(+), 36 deletions(-)

--- a/include/linux/page-flags.h~mm-generate-page_idle_flag-definitions
+++ a/include/linux/page-flags.h
@@ -626,12 +626,19 @@ PAGEFLAG_FALSE(HWPoison, hwpoison)
 #define __PG_HWPOISON 0
 #endif
 
-#if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
+#ifdef CONFIG_PAGE_IDLE_FLAG
+#ifdef CONFIG_64BIT
 FOLIO_TEST_FLAG(young, FOLIO_HEAD_PAGE)
 FOLIO_SET_FLAG(young, FOLIO_HEAD_PAGE)
 FOLIO_TEST_CLEAR_FLAG(young, FOLIO_HEAD_PAGE)
 FOLIO_FLAG(idle, FOLIO_HEAD_PAGE)
 #endif
+/* See page_idle.h for !64BIT workaround */
+#else /* !CONFIG_PAGE_IDLE_FLAG */
+FOLIO_FLAG_FALSE(young)
+FOLIO_TEST_CLEAR_FLAG_FALSE(young)
+FOLIO_FLAG_FALSE(idle)
+#endif
 
 /*
  * PageReported() is used to track reported free pages within the Buddy
--- a/include/linux/page_idle.h~mm-generate-page_idle_flag-definitions
+++ a/include/linux/page_idle.h
@@ -6,9 +6,7 @@
 #include <linux/page-flags.h>
 #include <linux/page_ext.h>
 
-#ifdef CONFIG_PAGE_IDLE_FLAG
-
-#ifndef CONFIG_64BIT
+#if defined(CONFIG_PAGE_IDLE_FLAG) && !defined(CONFIG_64BIT)
 /*
  * If there is not enough space to store Idle and Young bits in page flags, use
  * page ext flags instead.
@@ -87,36 +85,5 @@ static inline void folio_clear_idle(stru
 	clear_bit(PAGE_EXT_IDLE, &page_ext->flags);
 	page_ext_put(page_ext);
 }
-#endif /* !CONFIG_64BIT */
-
-#else /* !CONFIG_PAGE_IDLE_FLAG */
-
-static inline bool folio_test_young(const struct folio *folio)
-{
-	return false;
-}
-
-static inline void folio_set_young(struct folio *folio)
-{
-}
-
-static inline bool folio_test_clear_young(struct folio *folio)
-{
-	return false;
-}
-
-static inline bool folio_test_idle(const struct folio *folio)
-{
-	return false;
-}
-
-static inline void folio_set_idle(struct folio *folio)
-{
-}
-
-static inline void folio_clear_idle(struct folio *folio)
-{
-}
-
-#endif /* CONFIG_PAGE_IDLE_FLAG */
+#endif /* CONFIG_PAGE_IDLE_FLAG && !64BIT */
 #endif /* _LINUX_MM_PAGE_IDLE_H */
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

