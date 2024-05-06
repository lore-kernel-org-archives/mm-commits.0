Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EDE25757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957094; cv=none; b=MOsVX8NVxbg8jhxe110Tzx2Brg6GR5YKsIDKevzXXlDcxuWq1JCj1r/+nYqZ+OY8VQjeqKbCynUXZHwhT5dVTEOHrJt0/t2DAQ4UOfPwld4e2zQD1c80ABtgFosi3pTFfZAWabq4nSMQIcusLF40HGspCLiKeLsUM2AhKJjwRU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957094; c=relaxed/simple;
	bh=9TTmv0s70YXk0e4tr2bt5Gg0qPJL9l6XCffHb5z+M2U=;
	h=Date:To:From:Subject:Message-Id; b=V9rRBtrCsWZBGn702eaEd0dO7SOmbvLQNUUIn8WBIY2MchGxO3UJaBiQCesA0xtoF2oGF0BP3B+zIs/K4Xn3ukXBdRzLA1HpyLLe+HWBr9RSBXax22JpMoWna50uTx8apqrt6LrnfSXehTd4riIfk/FW0hAFlxbrWPL5JZ1I5Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vDpxRuhr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vDpxRuhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF61C116B1;
	Mon,  6 May 2024 00:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957094;
	bh=9TTmv0s70YXk0e4tr2bt5Gg0qPJL9l6XCffHb5z+M2U=;
	h=Date:To:From:Subject:From;
	b=vDpxRuhrzCNyUtAM3oBdrKSlRR2sbUSw4p9u0aD02iP57dLs6QjUdMGmSebyjKAxA
	 hyTTEUUj/SgZF3QYUll9DMdTQbbIyeuD5pMxDSoTVB6QI32NBNHzNa+wUs3Omt5WaZ
	 cxgbpmRGayf77tuVJT1i+KxO0d59eE3f5FAvdzpM=
Date: Sun, 05 May 2024 17:58:13 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch removed from -mm tree
Message-Id: <20240506005814.5FF61C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: pass the folio to collect_procs_ksm()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memory-failure: pass the folio to collect_procs_ksm()
Date: Fri, 12 Apr 2024 20:35:08 +0100

We've already calculated it, so pass it in instead of recalculating it in
collect_procs_ksm().

Link: https://lkml.kernel.org/r/20240412193510.2356957-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |   14 +++-----------
 mm/ksm.c            |    5 ++---
 mm/memory-failure.c |    2 +-
 3 files changed, 6 insertions(+), 15 deletions(-)

--- a/include/linux/ksm.h~mm-memory-failure-pass-the-folio-to-collect_procs_ksm
+++ a/include/linux/ksm.h
@@ -81,15 +81,9 @@ struct folio *ksm_might_need_to_copy(str
 
 void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc);
 void folio_migrate_ksm(struct folio *newfolio, struct folio *folio);
-
-#ifdef CONFIG_MEMORY_FAILURE
-void collect_procs_ksm(struct page *page, struct list_head *to_kill,
-		       int force_early);
-#endif
-
-#ifdef CONFIG_PROC_FS
+void collect_procs_ksm(struct folio *folio, struct page *page,
+		struct list_head *to_kill, int force_early);
 long ksm_process_profit(struct mm_struct *);
-#endif /* CONFIG_PROC_FS */
 
 #else  /* !CONFIG_KSM */
 
@@ -120,12 +114,10 @@ static inline void ksm_might_unmap_zero_
 {
 }
 
-#ifdef CONFIG_MEMORY_FAILURE
-static inline void collect_procs_ksm(struct page *page,
+static inline void collect_procs_ksm(struct folio *folio, struct page *page,
 				     struct list_head *to_kill, int force_early)
 {
 }
-#endif
 
 #ifdef CONFIG_MMU
 static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
--- a/mm/ksm.c~mm-memory-failure-pass-the-folio-to-collect_procs_ksm
+++ a/mm/ksm.c
@@ -3178,12 +3178,11 @@ again:
 /*
  * Collect processes when the error hit an ksm page.
  */
-void collect_procs_ksm(struct page *page, struct list_head *to_kill,
-		       int force_early)
+void collect_procs_ksm(struct folio *folio, struct page *page,
+		struct list_head *to_kill, int force_early)
 {
 	struct ksm_stable_node *stable_node;
 	struct ksm_rmap_item *rmap_item;
-	struct folio *folio = page_folio(page);
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
 
--- a/mm/memory-failure.c~mm-memory-failure-pass-the-folio-to-collect_procs_ksm
+++ a/mm/memory-failure.c
@@ -729,7 +729,7 @@ static void collect_procs(struct folio *
 	if (!folio->mapping)
 		return;
 	if (unlikely(folio_test_ksm(folio)))
-		collect_procs_ksm(page, tokill, force_early);
+		collect_procs_ksm(folio, page, tokill, force_early);
 	else if (folio_test_anon(folio))
 		collect_procs_anon(folio, page, tokill, force_early);
 	else
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

