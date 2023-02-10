Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C276C636D3
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjBJAwp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjBJAwf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CC36BD30
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D448CB82397
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78544C433EF;
        Fri, 10 Feb 2023 00:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990350;
        bh=IEVL6veF/8FSArEo04baB8YFBvNFPTTQntXiIKKn4LQ=;
        h=Date:To:From:Subject:From;
        b=0B0iuDq37uRxaNdnwKAAYq5sQdvMKLysoVQbWZHtdBJplH/IDA920gdWQB1OcWkn3
         k7B/LtGHb1cH0mZiSg8P82Aa0/loIZX8ZXFs8AQCADv4yFwW76vz5yL4nzKLwQV0a2
         cQQU7PzmXJNi5uL/OTa3UAOSYXUVCUQ6DRpT/Zpk=
Date:   Thu, 09 Feb 2023 16:52:30 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-expand-vma-iterator-interface.patch removed from -mm tree
Message-Id: <20230210005230.78544C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: expand vma iterator interface
has been removed from the -mm tree.  Its filename was
     mm-expand-vma-iterator-interface.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: expand vma iterator interface
Date: Fri, 20 Jan 2023 11:26:08 -0500

Add wrappers for the maple tree to the vma iterator.  This will provide
type safety at compile time.

Link: https://lkml.kernel.org/r/20230120162650.984577-8-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   46 ++++++++++++++++++++++++--
 include/linux/mm_types.h |    4 --
 mm/internal.h            |   64 +++++++++++++++++++++++++++++++++++++
 mm/mmap.c                |   18 ++++++++++
 4 files changed, 125 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-expand-vma-iterator-interface
+++ a/include/linux/mm.h
@@ -670,16 +670,16 @@ static inline bool vma_is_accessible(str
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
-	return mas_find(&vmi->mas, max);
+	return mas_find(&vmi->mas, max - 1);
 }
 
 static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
 {
 	/*
-	 * Uses vma_find() to get the first VMA when the iterator starts.
+	 * Uses mas_find() to get the first VMA when the iterator starts.
 	 * Calling mas_next() could skip the first entry.
 	 */
-	return vma_find(vmi, ULONG_MAX);
+	return mas_find(&vmi->mas, ULONG_MAX);
 }
 
 static inline struct vm_area_struct *vma_prev(struct vma_iterator *vmi)
@@ -692,12 +692,50 @@ static inline unsigned long vma_iter_add
 	return vmi->mas.index;
 }
 
+static inline unsigned long vma_iter_end(struct vma_iterator *vmi)
+{
+	return vmi->mas.last + 1;
+}
+static inline int vma_iter_bulk_alloc(struct vma_iterator *vmi,
+				      unsigned long count)
+{
+	return mas_expected_entries(&vmi->mas, count);
+}
+
+/* Free any unused preallocations */
+static inline void vma_iter_free(struct vma_iterator *vmi)
+{
+	mas_destroy(&vmi->mas);
+}
+
+static inline int vma_iter_bulk_store(struct vma_iterator *vmi,
+				      struct vm_area_struct *vma)
+{
+	vmi->mas.index = vma->vm_start;
+	vmi->mas.last = vma->vm_end - 1;
+	mas_store(&vmi->mas, vma);
+	if (unlikely(mas_is_err(&vmi->mas)))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static inline void vma_iter_invalidate(struct vma_iterator *vmi)
+{
+	mas_pause(&vmi->mas);
+}
+
+static inline void vma_iter_set(struct vma_iterator *vmi, unsigned long addr)
+{
+	mas_set(&vmi->mas, addr);
+}
+
 #define for_each_vma(__vmi, __vma)					\
 	while (((__vma) = vma_next(&(__vmi))) != NULL)
 
 /* The MM code likes to work with exclusive end addresses */
 #define for_each_vma_range(__vmi, __vma, __end)				\
-	while (((__vma) = vma_find(&(__vmi), (__end) - 1)) != NULL)
+	while (((__vma) = vma_find(&(__vmi), (__end))) != NULL)
 
 #ifdef CONFIG_SHMEM
 /*
--- a/include/linux/mm_types.h~mm-expand-vma-iterator-interface
+++ a/include/linux/mm_types.h
@@ -849,9 +849,7 @@ struct vma_iterator {
 static inline void vma_iter_init(struct vma_iterator *vmi,
 		struct mm_struct *mm, unsigned long addr)
 {
-	vmi->mas.tree = &mm->mm_mt;
-	vmi->mas.index = addr;
-	vmi->mas.node = MAS_START;
+	mas_init(&vmi->mas, &mm->mm_mt, addr);
 }
 
 struct mmu_gather;
--- a/mm/internal.h~mm-expand-vma-iterator-interface
+++ a/mm/internal.h
@@ -877,4 +877,68 @@ static inline bool vma_soft_dirty_enable
 	return !(vma->vm_flags & VM_SOFTDIRTY);
 }
 
+/*
+ * VMA Iterator functions shared between nommu and mmap
+ */
+static inline int vma_iter_prealloc(struct vma_iterator *vmi)
+{
+	return mas_preallocate(&vmi->mas, GFP_KERNEL);
+}
+
+static inline void vma_iter_clear(struct vma_iterator *vmi,
+				  unsigned long start, unsigned long end)
+{
+	mas_set_range(&vmi->mas, start, end - 1);
+	mas_store_prealloc(&vmi->mas, NULL);
+}
+
+static inline struct vm_area_struct *vma_iter_load(struct vma_iterator *vmi)
+{
+	return mas_walk(&vmi->mas);
+}
+
+/* Store a VMA with preallocated memory */
+static inline void vma_iter_store(struct vma_iterator *vmi,
+				  struct vm_area_struct *vma)
+{
+
+#if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
+	if (WARN_ON(vmi->mas.node != MAS_START && vmi->mas.index > vma->vm_start)) {
+		printk("%lu > %lu\n", vmi->mas.index, vma->vm_start);
+		printk("store of vma %lu-%lu", vma->vm_start, vma->vm_end);
+		printk("into slot    %lu-%lu", vmi->mas.index, vmi->mas.last);
+		mt_dump(vmi->mas.tree);
+	}
+	if (WARN_ON(vmi->mas.node != MAS_START && vmi->mas.last <  vma->vm_start)) {
+		printk("%lu < %lu\n", vmi->mas.last, vma->vm_start);
+		printk("store of vma %lu-%lu", vma->vm_start, vma->vm_end);
+		printk("into slot    %lu-%lu", vmi->mas.index, vmi->mas.last);
+		mt_dump(vmi->mas.tree);
+	}
+#endif
+
+	if (vmi->mas.node != MAS_START &&
+	    ((vmi->mas.index > vma->vm_start) || (vmi->mas.last < vma->vm_start)))
+		vma_iter_invalidate(vmi);
+
+	vmi->mas.index = vma->vm_start;
+	vmi->mas.last = vma->vm_end - 1;
+	mas_store_prealloc(&vmi->mas, vma);
+}
+
+static inline int vma_iter_store_gfp(struct vma_iterator *vmi,
+			struct vm_area_struct *vma, gfp_t gfp)
+{
+	if (vmi->mas.node != MAS_START &&
+	    ((vmi->mas.index > vma->vm_start) || (vmi->mas.last < vma->vm_start)))
+		vma_iter_invalidate(vmi);
+
+	vmi->mas.index = vma->vm_start;
+	vmi->mas.last = vma->vm_end - 1;
+	mas_store_gfp(&vmi->mas, vma, gfp);
+	if (unlikely(mas_is_err(&vmi->mas)))
+		return -ENOMEM;
+
+	return 0;
+}
 #endif	/* __MM_INTERNAL_H */
--- a/mm/mmap.c~mm-expand-vma-iterator-interface
+++ a/mm/mmap.c
@@ -144,6 +144,24 @@ static void remove_vma(struct vm_area_st
 	vm_area_free(vma);
 }
 
+static inline struct vm_area_struct *vma_prev_limit(struct vma_iterator *vmi,
+						    unsigned long min)
+{
+	return mas_prev(&vmi->mas, min);
+}
+
+static inline int vma_iter_clear_gfp(struct vma_iterator *vmi,
+			unsigned long start, unsigned long end, gfp_t gfp)
+{
+	vmi->mas.index = start;
+	vmi->mas.last = end - 1;
+	mas_store_gfp(&vmi->mas, NULL, gfp);
+	if (unlikely(mas_is_err(&vmi->mas)))
+		return -ENOMEM;
+
+	return 0;
+}
+
 /*
  * check_brk_limits() - Use platform specific check of range & verify mlock
  * limits.
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


