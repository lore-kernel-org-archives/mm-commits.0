Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A7684A2F
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724799790; cv=none; b=gYXBZga+YypeIaEP8d9v5khPPTCxPXIfzGAKIrJakM55gX92aiRezBkKvhUqweuIqpY1WJyp8FyC/QKxODaCNsJh6Rx5LfVOC8CQS+PN9J/9DRx1IjODLPdSGtCYanPndMA73WwGVMX9FOw7P3oEOl7RyBE8jom4fl9DoyZ4IaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724799790; c=relaxed/simple;
	bh=SA5JAfWa/s8NvqzeCXuTxFvZieYWEs3pDT7dYnyVJdM=;
	h=Date:To:From:Subject:Message-Id; b=M+uzmQFD63A7EIqKqH/dkoTQ3hN9O1aBB0ei12gOW+UKLysdEQ5A7ZTWmiX94hS/E243rN96/6i0gxRT4gg6Ibv/6ZXx/mPxDxZLlc+NmZ60NlAqXst3eJ6/fe+PzkMR/3CdLmO+Q1RZuOW3mY3JyhZlZNP+6p9ppx90uc0GhQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pGPAvlty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pGPAvlty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7BCC4AF14;
	Tue, 27 Aug 2024 23:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724799789;
	bh=SA5JAfWa/s8NvqzeCXuTxFvZieYWEs3pDT7dYnyVJdM=;
	h=Date:To:From:Subject:From;
	b=pGPAvltyD8jnNds/9EV5nOs710vQXIQdsY8H32yX6Fha845EuOL9RfFiICpuJha0g
	 eqBiQoo5mtJ5LWPwChXJnao+o/TMKOCNeBqUkj4H2wbTUdJei2/QuVIQKIPBbVlCXZ
	 OOsEXF4cbNxkSxDm03Dhq92uMAhRxu/kXB+xR4/M=
Date: Tue, 27 Aug 2024 16:03:08 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@huawei.com,david@redhat.com,dan.carpenter@linaro.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-add-unmap_poisoned_folio.patch added to mm-unstable branch
Message-Id: <20240827230309.4D7BCC4AF14@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory-failure: add unmap_poisoned_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-add-unmap_poisoned_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-add-unmap_poisoned_folio.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory-failure: add unmap_poisoned_folio()
Date: Tue, 27 Aug 2024 19:47:25 +0800

Add unmap_poisoned_folio() helper which will be reused by
do_migrate_range() from memory hotplug soon.

Link: https://lkml.kernel.org/r/20240827114728.3212578-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h       |    8 +++++++
 mm/memory-failure.c |   43 +++++++++++++++++++++++++-----------------
 2 files changed, 34 insertions(+), 17 deletions(-)

--- a/mm/internal.h~mm-memory-failure-add-unmap_poisoned_folio
+++ a/mm/internal.h
@@ -1048,6 +1048,8 @@ static inline int find_next_best_node(in
 /*
  * mm/memory-failure.c
  */
+#ifdef CONFIG_MEMORY_FAILURE
+void unmap_poisoned_folio(struct folio *folio, enum ttu_flags ttu);
 void shake_folio(struct folio *folio);
 extern int hwpoison_filter(struct page *p);
 
@@ -1068,6 +1070,12 @@ void add_to_kill_ksm(struct task_struct
 		     unsigned long ksm_addr);
 unsigned long page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
 
+#else
+static inline void unmap_poisoned_folio(struct folio *folio, enum ttu_flags ttu)
+{
+}
+#endif
+
 extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
--- a/mm/memory-failure.c~mm-memory-failure-add-unmap_poisoned_folio
+++ a/mm/memory-failure.c
@@ -1554,6 +1554,31 @@ static int get_hwpoison_page(struct page
 	return ret;
 }
 
+void unmap_poisoned_folio(struct folio *folio, enum ttu_flags ttu)
+{
+	if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
+		struct address_space *mapping;
+		/*
+		 * For hugetlb folios in shared mappings, try_to_unmap
+		 * could potentially call huge_pmd_unshare.  Because of
+		 * this, take semaphore in write mode here and set
+		 * TTU_RMAP_LOCKED to indicate we have taken the lock
+		 * at this higher level.
+		 */
+		mapping = hugetlb_folio_mapping_lock_write(folio);
+		if (!mapping) {
+			pr_info("%#lx: could not lock mapping for mapped hugetlb folio\n",
+				folio_pfn(folio));
+			return;
+		}
+
+		try_to_unmap(folio, ttu|TTU_RMAP_LOCKED);
+		i_mmap_unlock_write(mapping);
+	} else {
+		try_to_unmap(folio, ttu);
+	}
+}
+
 /*
  * Do all that is necessary to remove user space mappings. Unmap
  * the pages and send SIGBUS to the processes if the data was dirty.
@@ -1615,23 +1640,7 @@ static bool hwpoison_user_mappings(struc
 	 */
 	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
 
-	if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
-		/*
-		 * For hugetlb pages in shared mappings, try_to_unmap
-		 * could potentially call huge_pmd_unshare.  Because of
-		 * this, take semaphore in write mode here and set
-		 * TTU_RMAP_LOCKED to indicate we have taken the lock
-		 * at this higher level.
-		 */
-		mapping = hugetlb_folio_mapping_lock_write(folio);
-		if (mapping) {
-			try_to_unmap(folio, ttu|TTU_RMAP_LOCKED);
-			i_mmap_unlock_write(mapping);
-		} else
-			pr_info("%#lx: could not lock mapping for mapped huge page\n", pfn);
-	} else {
-		try_to_unmap(folio, ttu);
-	}
+	unmap_poisoned_folio(folio, ttu);
 
 	unmap_success = !folio_mapped(folio);
 	if (!unmap_success)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-remove-migration-for-hugepage-in-isolate_single_pageblock.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_poisoned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch

