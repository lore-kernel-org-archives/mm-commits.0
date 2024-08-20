Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB302BAEB
	for <mm-commits@vger.kernel.org>; Tue, 20 Aug 2024 05:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724132331; cv=none; b=N3z9jsL3tI0E5zi/FcpgR6N1D01xW0LVrPmcLydqS9zFtmjOvsLgridGTo09aLuRMM98aRQiwtsYHKs+ki37gVi/1q0h3I4reGBRrWqUUh9M3h4+rqyG5MX0u1CsGk4QEAJbLGN7SQU8PvlmnsBZElACR+l2wdKRMFQkVlrRXRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724132331; c=relaxed/simple;
	bh=Qsz/iayKCtyjFLztPoX/pKn3BQdcDoWtX2Gw7RCLLxw=;
	h=Date:To:From:Subject:Message-Id; b=bLgDaXSU9BbBlU6z/4FAFBTRkU8PAjL2302VvdCBhsZze515SLIeFrX3IMcnsIYE5ji0FsKMmd1GRbZ2cj0wEztlH1Li/PRLfc8/ziZDFLNg88oE6RcKaCm81gLHOU4j9mxnX7ASbEetQJgkwn/ccUFfp/zpjLtFqDFi3UImCmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UIy32ntk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UIy32ntk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56723C4AF0C;
	Tue, 20 Aug 2024 05:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724132330;
	bh=Qsz/iayKCtyjFLztPoX/pKn3BQdcDoWtX2Gw7RCLLxw=;
	h=Date:To:From:Subject:From;
	b=UIy32ntkfIkcGR1NhGUcZyQ8SZRWd+epVBSYo5cCq0VyYjvRiECJLTu2WOK8vnuVS
	 sk6qI9Pj3FuD2JlKmVRz0xs09CdmAcj4mEH7Zn85ZLJRQZNRM8GtgklV4nmzR3YuFn
	 /RSNGdofzDkaJMbFkl1Fd38EXvSif5W7Hc/tlSck=
Date: Mon, 19 Aug 2024 22:38:49 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@Huawei.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-add-unmap_posioned_folio.patch added to mm-unstable branch
Message-Id: <20240820053850.56723C4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory-failure: add unmap_posioned_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-add-unmap_posioned_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-add-unmap_posioned_folio.patch

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
Subject: mm: memory-failure: add unmap_posioned_folio()
Date: Sat, 17 Aug 2024 16:49:38 +0800

Add unmap_posioned_folio() helper which will be reused by
do_migrate_range() from memory hotplug soon.

Link: https://lkml.kernel.org/r/20240817084941.2375713-3-wangkefeng.wang@huawei.com
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h       |    9 ++++++++
 mm/memory-failure.c |   43 +++++++++++++++++++++++++-----------------
 2 files changed, 35 insertions(+), 17 deletions(-)

--- a/mm/internal.h~mm-memory-failure-add-unmap_posioned_folio
+++ a/mm/internal.h
@@ -1048,6 +1048,8 @@ static inline int find_next_best_node(in
 /*
  * mm/memory-failure.c
  */
+#ifdef CONFIG_MEMORY_FAILURE
+int unmap_posioned_folio(struct folio *folio, enum ttu_flags ttu);
 void shake_folio(struct folio *folio);
 extern int hwpoison_filter(struct page *p);
 
@@ -1068,6 +1070,13 @@ void add_to_kill_ksm(struct task_struct
 		     unsigned long ksm_addr);
 unsigned long page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
 
+#else
+static inline int unmap_posioned_folio(struct folio *folio, enum ttu_flags ttu)
+{
+	return 0;
+}
+#endif
+
 extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
--- a/mm/memory-failure.c~mm-memory-failure-add-unmap_posioned_folio
+++ a/mm/memory-failure.c
@@ -1554,6 +1554,30 @@ static int get_hwpoison_page(struct page
 	return ret;
 }
 
+int unmap_posioned_folio(struct folio *folio, enum ttu_flags ttu)
+{
+	if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
+		struct address_space *mapping;
+		/*
+		 * For hugetlb pages in shared mappings, try_to_unmap
+		 * could potentially call huge_pmd_unshare.  Because of
+		 * this, take semaphore in write mode here and set
+		 * TTU_RMAP_LOCKED to indicate we have taken the lock
+		 * at this higher level.
+		 */
+		mapping = hugetlb_folio_mapping_lock_write(folio);
+		if (!mapping)
+			return -EAGAIN;
+
+		try_to_unmap(folio, ttu|TTU_RMAP_LOCKED);
+		i_mmap_unlock_write(mapping);
+	} else {
+		try_to_unmap(folio, ttu);
+	}
+
+	return 0;
+}
+
 /*
  * Do all that is necessary to remove user space mappings. Unmap
  * the pages and send SIGBUS to the processes if the data was dirty.
@@ -1615,23 +1639,8 @@ static bool hwpoison_user_mappings(struc
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
+	if (unmap_posioned_folio(folio, ttu))
+		pr_info("%#lx: could not lock mapping for mapped huge page\n", pfn);
 
 	unmap_success = !folio_mapped(folio);
 	if (!unmap_success)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_posioned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch

