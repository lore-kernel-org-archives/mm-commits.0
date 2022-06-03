Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BAE8C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 18:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344173AbiFCSRT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348564AbiFCSQr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 14:16:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9301864D3A
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 11:04:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 043ACB82433
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 18:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB35EC385A9;
        Fri,  3 Jun 2022 18:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654279446;
        bh=4lGr+8tsJ7q15utfMW1B1YKT9uQBi3SIERiai7ld/l8=;
        h=Date:To:From:Subject:From;
        b=o9zg2YI9EkBJHIwOA/+vLqx/wK/KCDm+8lde6mug4tpdge+EdWPbJz0tDExUdIuws
         N1uz2IqF1tyXOLmC1ul33IfUQzFNF5SW72Q2yH+PojQ020cueym+vqvhhFYex35q1G
         qnpbnfF0AEb/zmFF9umSbgReQwEvom3Neb45oc/o=
Date:   Fri, 03 Jun 2022 11:04:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, riteshh@linux.ibm.com, rgoldwyn@suse.de,
        rgoldwyn@suse.com, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        jane.chu@oracle.com, hch@lst.de, djwong@kernel.org,
        david@fromorbit.com, dan.j.williams@intel.com,
        dan.j.wiliams@intel.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-mf_dax_kill_procs-for-fsdax-case.patch added to mm-unstable branch
Message-Id: <20220603180406.AB35EC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce mf_dax_kill_procs() for fsdax case
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-mf_dax_kill_procs-for-fsdax-case.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-mf_dax_kill_procs-for-fsdax-case.patch

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
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: mm: introduce mf_dax_kill_procs() for fsdax case
Date: Fri, 3 Jun 2022 13:37:29 +0800

This new function is a variant of mf_generic_kill_procs that accepts a
file, offset pair instead of a struct to support multiple files sharing a
DAX mapping.  It is intended to be called by the file systems as part of
the memory_failure handler after the file system performed a reverse
mapping from the storage address to the file and file offset.

Link: https://lkml.kernel.org/r/20220603053738.1218681-6-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.wiliams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    2 
 mm/memory-failure.c |   96 +++++++++++++++++++++++++++++++++++++-----
 2 files changed, 88 insertions(+), 10 deletions(-)

--- a/include/linux/mm.h~mm-introduce-mf_dax_kill_procs-for-fsdax-case
+++ a/include/linux/mm.h
@@ -3250,6 +3250,8 @@ enum mf_flags {
 	MF_UNPOISON = 1 << 4,
 	MF_NO_RETRY = 1 << 5,
 };
+int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
+		      unsigned long count, int mf_flags);
 extern int memory_failure(unsigned long pfn, int flags);
 extern void memory_failure_queue(unsigned long pfn, int flags);
 extern void memory_failure_queue_kick(int cpu);
--- a/mm/memory-failure.c~mm-introduce-mf_dax_kill_procs-for-fsdax-case
+++ a/mm/memory-failure.c
@@ -301,10 +301,9 @@ void shake_page(struct page *p)
 }
 EXPORT_SYMBOL_GPL(shake_page);
 
-static unsigned long dev_pagemap_mapping_shift(struct page *page,
-		struct vm_area_struct *vma)
+static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
+		unsigned long address)
 {
-	unsigned long address = vma_address(page, vma);
 	unsigned long ret = 0;
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -344,10 +343,14 @@ static unsigned long dev_pagemap_mapping
 /*
  * Schedule a process for later kill.
  * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
+ *
+ * Notice: @fsdax_pgoff is used only when @p is a fsdax page.
+ *   In other cases, such as anonymous and file-backend page, the address to be
+ *   killed can be caculated by @p itself.
  */
 static void add_to_kill(struct task_struct *tsk, struct page *p,
-		       struct vm_area_struct *vma,
-		       struct list_head *to_kill)
+			pgoff_t fsdax_pgoff, struct vm_area_struct *vma,
+			struct list_head *to_kill)
 {
 	struct to_kill *tk;
 
@@ -358,9 +361,15 @@ static void add_to_kill(struct task_stru
 	}
 
 	tk->addr = page_address_in_vma(p, vma);
-	if (is_zone_device_page(p))
-		tk->size_shift = dev_pagemap_mapping_shift(p, vma);
-	else
+	if (is_zone_device_page(p)) {
+		/*
+		 * Since page->mapping is not used for fsdax, we need
+		 * calculate the address based on the vma.
+		 */
+		if (p->pgmap->type == MEMORY_DEVICE_FS_DAX)
+			tk->addr = vma_pgoff_address(fsdax_pgoff, 1, vma);
+		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
+	} else
 		tk->size_shift = page_shift(compound_head(p));
 
 	/*
@@ -509,7 +518,7 @@ static void collect_procs_anon(struct pa
 			if (!page_mapped_in_vma(page, vma))
 				continue;
 			if (vma->vm_mm == t->mm)
-				add_to_kill(t, page, vma, to_kill);
+				add_to_kill(t, page, 0, vma, to_kill);
 		}
 	}
 	read_unlock(&tasklist_lock);
@@ -545,13 +554,41 @@ static void collect_procs_file(struct pa
 			 * to be informed of all such data corruptions.
 			 */
 			if (vma->vm_mm == t->mm)
-				add_to_kill(t, page, vma, to_kill);
+				add_to_kill(t, page, 0, vma, to_kill);
 		}
 	}
 	read_unlock(&tasklist_lock);
 	i_mmap_unlock_read(mapping);
 }
 
+#ifdef CONFIG_FS_DAX
+/*
+ * Collect processes when the error hit a fsdax page.
+ */
+static void collect_procs_fsdax(struct page *page,
+		struct address_space *mapping, pgoff_t pgoff,
+		struct list_head *to_kill)
+{
+	struct vm_area_struct *vma;
+	struct task_struct *tsk;
+
+	i_mmap_lock_read(mapping);
+	read_lock(&tasklist_lock);
+	for_each_process(tsk) {
+		struct task_struct *t = task_early_kill(tsk, true);
+
+		if (!t)
+			continue;
+		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+			if (vma->vm_mm == t->mm)
+				add_to_kill(t, page, pgoff, vma, to_kill);
+		}
+	}
+	read_unlock(&tasklist_lock);
+	i_mmap_unlock_read(mapping);
+}
+#endif /* CONFIG_FS_DAX */
+
 /*
  * Collect the processes who have the corrupted page mapped to kill.
  */
@@ -1641,6 +1678,45 @@ unlock:
 	return rc;
 }
 
+#ifdef CONFIG_FS_DAX
+/**
+ * mf_dax_kill_procs - Collect and kill processes who are using this file range
+ * @mapping:	address_space of the file in use
+ * @index:	start pgoff of the range within the file
+ * @count:	length of the range, in unit of PAGE_SIZE
+ * @mf_flags:	memory failure flags
+ */
+int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
+		unsigned long count, int mf_flags)
+{
+	LIST_HEAD(to_kill);
+	dax_entry_t cookie;
+	struct page *page;
+	size_t end = index + count;
+
+	mf_flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
+
+	for (; index < end; index++) {
+		page = NULL;
+		cookie = dax_lock_mapping_entry(mapping, index, &page);
+		if (!cookie)
+			return -EBUSY;
+		if (!page)
+			goto unlock;
+
+		SetPageHWPoison(page);
+
+		collect_procs_fsdax(page, mapping, index, &to_kill);
+		unmap_and_kill(&to_kill, page_to_pfn(page), mapping,
+				index, mf_flags);
+unlock:
+		dax_unlock_mapping_entry(mapping, index, cookie);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mf_dax_kill_procs);
+#endif /* CONFIG_FS_DAX */
+
 /*
  * Taking refcount of hugetlb pages needs extra care about race conditions
  * with basic operations like hugepage allocation/free/demotion.
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are

dax-introduce-holder-for-dax_device.patch
mm-factor-helpers-for-memory_failure_dev_pagemap.patch
pagemappmem-introduce-memory_failure.patch
fsdax-introduce-dax_lock_mapping_entry.patch
mm-introduce-mf_dax_kill_procs-for-fsdax-case.patch
xfs-implement-notify_failure-for-xfs.patch
fsdax-set-a-cow-flag-when-associate-reflink-mappings.patch
fsdax-output-address-in-dax_iomap_pfn-and-rename-it.patch
fsdax-introduce-dax_iomap_cow_copy.patch
fsdax-replace-mmap-entry-in-case-of-cow.patch
fsdax-add-dax_iomap_cow_copy-for-dax-zero.patch
fsdax-dedup-file-range-to-use-a-compare-function.patch
xfs-support-cow-in-fsdax-mode.patch
xfs-add-dax-dedupe-support.patch

