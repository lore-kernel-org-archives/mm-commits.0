Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FFFC07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbiI0Cv5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbiI0Ctq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:49:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DBCF6F7C
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B12561593
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E321C43149;
        Tue, 27 Sep 2022 02:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246942;
        bh=8QyqH90oRW5yoeNXk/jDo7lU0CfZdEENUWWL7qFM6Jc=;
        h=Date:To:From:Subject:From;
        b=pJUkFEVQukwd9mKzvsuZw6+4O5rdhj9gocv8vyOZ3lmUe0fL6Yi7fbHu4SR6CB9r8
         xV91hk0mu9mfQBMGGm7GyPYxsj8f2u6G07NEYwzMQXoifNDcTSKUOiBlz3qRBKYKP6
         DwmEbBORuIaWt1Qf1nHBEyqsppwFqHrEQ2ROd4P0=
Date:   Mon, 26 Sep 2022 19:49:01 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-maple-tree-operations-for-find_vma_intersection.patch removed from -mm tree
Message-Id: <20220927024902.6E321C43149@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use maple tree operations for find_vma_intersection()
has been removed from the -mm tree.  Its filename was
     mm-use-maple-tree-operations-for-find_vma_intersection.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: use maple tree operations for find_vma_intersection()
Date: Tue, 6 Sep 2022 19:48:50 +0000

Move find_vma_intersection() to mmap.c and change implementation to maple
tree.

When searching for a vma within a range, it is easier to use the maple
tree interface.

Exported find_vma_intersection() for kvm module.

Link: https://lkml.kernel.org/r/20220906194824.2110408-24-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   22 ++++------------------
 mm/mmap.c          |   29 +++++++++++++++++++++++++++++
 mm/nommu.c         |   11 +++++++++++
 3 files changed, 44 insertions(+), 18 deletions(-)

--- a/include/linux/mm.h~mm-use-maple-tree-operations-for-find_vma_intersection
+++ a/include/linux/mm.h
@@ -2778,26 +2778,12 @@ extern struct vm_area_struct * find_vma(
 extern struct vm_area_struct * find_vma_prev(struct mm_struct * mm, unsigned long addr,
 					     struct vm_area_struct **pprev);
 
-/**
- * find_vma_intersection() - Look up the first VMA which intersects the interval
- * @mm: The process address space.
- * @start_addr: The inclusive start user address.
- * @end_addr: The exclusive end user address.
- *
- * Returns: The first VMA within the provided range, %NULL otherwise.  Assumes
- * start_addr < end_addr.
+/*
+ * Look up the first VMA which intersects the interval [start_addr, end_addr)
+ * NULL if none.  Assume start_addr < end_addr.
  */
-static inline
 struct vm_area_struct *find_vma_intersection(struct mm_struct *mm,
-					     unsigned long start_addr,
-					     unsigned long end_addr)
-{
-	struct vm_area_struct *vma = find_vma(mm, start_addr);
-
-	if (vma && end_addr <= vma->vm_start)
-		vma = NULL;
-	return vma;
-}
+			unsigned long start_addr, unsigned long end_addr);
 
 /**
  * vma_lookup() - Find a VMA at a specific address
--- a/mm/mmap.c~mm-use-maple-tree-operations-for-find_vma_intersection
+++ a/mm/mmap.c
@@ -2062,6 +2062,35 @@ get_unmapped_area(struct file *file, uns
 EXPORT_SYMBOL(get_unmapped_area);
 
 /**
+ * find_vma_intersection() - Look up the first VMA which intersects the interval
+ * @mm: The process address space.
+ * @start_addr: The inclusive start user address.
+ * @end_addr: The exclusive end user address.
+ *
+ * Returns: The first VMA within the provided range, %NULL otherwise.  Assumes
+ * start_addr < end_addr.
+ */
+struct vm_area_struct *find_vma_intersection(struct mm_struct *mm,
+					     unsigned long start_addr,
+					     unsigned long end_addr)
+{
+	struct vm_area_struct *vma;
+	unsigned long index = start_addr;
+
+	mmap_assert_locked(mm);
+	/* Check the cache first. */
+	vma = vmacache_find(mm, start_addr);
+	if (likely(vma))
+		return vma;
+
+	vma = mt_find(&mm->mm_mt, &index, end_addr - 1);
+	if (vma)
+		vmacache_update(start_addr, vma);
+	return vma;
+}
+EXPORT_SYMBOL(find_vma_intersection);
+
+/**
  * find_vma() - Find the VMA for a given address, or the next VMA.
  * @mm: The mm_struct to check
  * @addr: The address
--- a/mm/nommu.c~mm-use-maple-tree-operations-for-find_vma_intersection
+++ a/mm/nommu.c
@@ -642,6 +642,17 @@ static void delete_vma(struct mm_struct
 	vm_area_free(vma);
 }
 
+struct vm_area_struct *find_vma_intersection(struct mm_struct *mm,
+					     unsigned long start_addr,
+					     unsigned long end_addr)
+{
+	unsigned long index = start_addr;
+
+	mmap_assert_locked(mm);
+	return mt_find(&mm->mm_mt, &index, end_addr - 1);
+}
+EXPORT_SYMBOL(find_vma_intersection);
+
 /*
  * look up the first VMA in which addr resides, NULL if none
  * - should be called with mm->mmap_lock at least held readlocked
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


