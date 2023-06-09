Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2465DC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjFIXa0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjFIX3D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:29:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF263AB9
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EE2263E4A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF54EC433EF;
        Fri,  9 Jun 2023 23:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353317;
        bh=t9ZnvJ0YxE8HWJOqzy8NKUVTkdefws9BL3MF42n3iWU=;
        h=Date:To:From:Subject:From;
        b=HEd677FbyQggVbWvMUgx77dnOoHd1KjBCqq3ayXTcQu3BD/Q7bL8hIFAB4ONbpTvZ
         bdQ0wFZBMY9YJzFefE0euy0Ivs0xAcW/XgajyUV/yP0kh4dVnbH8RACKjwwwjT3rIK
         RQdjdgZtKhZY9gQtXMIF1ESzZsyIzJa/wf/FRlI8=
Date:   Fri, 09 Jun 2023 16:28:37 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-mas_next_range-and-mas_find_range-interfaces.patch removed from -mm tree
Message-Id: <20230609232837.BF54EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: add mas_next_range() and mas_find_range() interfaces
has been removed from the -mm tree.  Its filename was
     maple_tree-add-mas_next_range-and-mas_find_range-interfaces.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: add mas_next_range() and mas_find_range() interfaces
Date: Thu, 18 May 2023 10:55:37 -0400

Some users of the maple tree may want to move to the next range in the
tree, even if it stores a NULL.  This family of function provides that
functionality by advancing one slot at a time and returning the result,
while mas_contiguous() will iterate over the range and stop on
encountering the first NULL.

Link: https://lkml.kernel.org/r/20230518145544.1722059-29-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    3 
 lib/maple_tree.c           |  172 ++++++++++++++++++++++++-----------
 2 files changed, 124 insertions(+), 51 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-add-mas_next_range-and-mas_find_range-interfaces
+++ a/include/linux/maple_tree.h
@@ -455,6 +455,7 @@ void *mas_erase(struct ma_state *mas);
 int mas_store_gfp(struct ma_state *mas, void *entry, gfp_t gfp);
 void mas_store_prealloc(struct ma_state *mas, void *entry);
 void *mas_find(struct ma_state *mas, unsigned long max);
+void *mas_find_range(struct ma_state *mas, unsigned long max);
 void *mas_find_rev(struct ma_state *mas, unsigned long min);
 int mas_preallocate(struct ma_state *mas, gfp_t gfp);
 bool mas_is_err(struct ma_state *mas);
@@ -467,6 +468,7 @@ int mas_expected_entries(struct ma_state
 
 void *mas_prev(struct ma_state *mas, unsigned long min);
 void *mas_next(struct ma_state *mas, unsigned long max);
+void *mas_next_range(struct ma_state *mas, unsigned long max);
 
 int mas_empty_area(struct ma_state *mas, unsigned long min, unsigned long max,
 		   unsigned long size);
@@ -528,7 +530,6 @@ static inline void mas_reset(struct ma_s
 #define mas_for_each(__mas, __entry, __max) \
 	while (((__entry) = mas_find((__mas), (__max))) != NULL)
 
-
 /**
  * mas_set_range() - Set up Maple Tree operation state for a different index.
  * @mas: Maple Tree operation state.
--- a/lib/maple_tree.c~maple_tree-add-mas_next_range-and-mas_find_range-interfaces
+++ a/lib/maple_tree.c
@@ -4793,13 +4793,10 @@ again:
  */
 static inline void *mas_next_entry(struct ma_state *mas, unsigned long limit)
 {
-	void *entry = NULL;
-
 	if (mas->last >= limit)
 		return NULL;
 
-	entry = mas_next_slot(mas, limit, false);
-	return entry;
+	return mas_next_slot(mas, limit, false);
 }
 
 /*
@@ -5880,18 +5877,8 @@ int mas_expected_entries(struct ma_state
 }
 EXPORT_SYMBOL_GPL(mas_expected_entries);
 
-/**
- * mas_next() - Get the next entry.
- * @mas: The maple state
- * @max: The maximum index to check.
- *
- * Returns the next entry after @mas->index.
- * Must hold rcu_read_lock or the write lock.
- * Can return the zero entry.
- *
- * Return: The next entry or %NULL
- */
-void *mas_next(struct ma_state *mas, unsigned long max)
+static inline bool mas_next_setup(struct ma_state *mas, unsigned long max,
+		void **entry)
 {
 	bool was_none = mas_is_none(mas);
 
@@ -5899,25 +5886,72 @@ void *mas_next(struct ma_state *mas, uns
 		mas->node = MAS_START;
 
 	if (mas_is_start(mas))
-		mas_walk(mas); /* Retries on dead nodes handled by mas_walk */
+		*entry = mas_walk(mas); /* Retries on dead nodes handled by mas_walk */
 
 	if (mas_is_ptr(mas)) {
+		*entry = NULL;
 		if (was_none && mas->index == 0) {
 			mas->index = mas->last = 0;
-			return mas_root(mas);
+			return true;
 		}
 		mas->index = 1;
 		mas->last = ULONG_MAX;
 		mas->node = MAS_NONE;
-		return NULL;
+		return true;
 	}
 
-	/* Retries on dead nodes handled by mas_next_entry */
-	return mas_next_entry(mas, max);
+	if (mas_is_none(mas))
+		return true;
+	return false;
+}
+
+/**
+ * mas_next() - Get the next entry.
+ * @mas: The maple state
+ * @max: The maximum index to check.
+ *
+ * Returns the next entry after @mas->index.
+ * Must hold rcu_read_lock or the write lock.
+ * Can return the zero entry.
+ *
+ * Return: The next entry or %NULL
+ */
+void *mas_next(struct ma_state *mas, unsigned long max)
+{
+	void *entry = NULL;
+
+	if (mas_next_setup(mas, max, &entry))
+		return entry;
+
+	/* Retries on dead nodes handled by mas_next_slot */
+	return mas_next_slot(mas, max, false);
 }
 EXPORT_SYMBOL_GPL(mas_next);
 
 /**
+ * mas_next_range() - Advance the maple state to the next range
+ * @mas: The maple state
+ * @max: The maximum index to check.
+ *
+ * Sets @mas->index and @mas->last to the range.
+ * Must hold rcu_read_lock or the write lock.
+ * Can return the zero entry.
+ *
+ * Return: The next entry or %NULL
+ */
+void *mas_next_range(struct ma_state *mas, unsigned long max)
+{
+	void *entry = NULL;
+
+	if (mas_next_setup(mas, max, &entry))
+		return entry;
+
+	/* Retries on dead nodes handled by mas_next_slot */
+	return mas_next_slot(mas, max, true);
+}
+EXPORT_SYMBOL_GPL(mas_next_range);
+
+/**
  * mt_next() - get the next value in the maple tree
  * @mt: The maple tree
  * @index: The start index
@@ -6026,49 +6060,41 @@ void mas_pause(struct ma_state *mas)
 EXPORT_SYMBOL_GPL(mas_pause);
 
 /**
- * mas_find() - On the first call, find the entry at or after mas->index up to
- * %max.  Otherwise, find the entry after mas->index.
+ * mas_find_setup() - Internal function to set up mas_find*().
  * @mas: The maple state
- * @max: The maximum value to check.
- *
- * Must hold rcu_read_lock or the write lock.
- * If an entry exists, last and index are updated accordingly.
- * May set @mas->node to MAS_NONE.
+ * @max: The maximum index
+ * @entry: Pointer to the entry
  *
- * Return: The entry or %NULL.
+ * Returns: True if entry is the answer, false otherwise.
  */
-void *mas_find(struct ma_state *mas, unsigned long max)
+static inline bool mas_find_setup(struct ma_state *mas, unsigned long max,
+		void **entry)
 {
+	*entry = NULL;
+
 	if (unlikely(mas_is_none(mas))) {
 		if (unlikely(mas->last >= max))
-			return NULL;
+			return true;
 
 		mas->index = mas->last;
 		mas->node = MAS_START;
-	}
-
-	if (unlikely(mas_is_paused(mas))) {
+	} else if (unlikely(mas_is_paused(mas))) {
 		if (unlikely(mas->last >= max))
-			return NULL;
+			return true;
 
 		mas->node = MAS_START;
 		mas->index = ++mas->last;
-	}
-
-
-	if (unlikely(mas_is_ptr(mas)))
+	} else if (unlikely(mas_is_ptr(mas)))
 		goto ptr_out_of_range;
 
 	if (unlikely(mas_is_start(mas))) {
 		/* First run or continue */
-		void *entry;
-
 		if (mas->index > max)
-			return NULL;
+			return true;
 
-		entry = mas_walk(mas);
-		if (entry)
-			return entry;
+		*entry = mas_walk(mas);
+		if (*entry)
+			return true;
 
 	}
 
@@ -6076,24 +6102,70 @@ void *mas_find(struct ma_state *mas, uns
 		if (unlikely(mas_is_ptr(mas)))
 			goto ptr_out_of_range;
 
-		return NULL;
+		return true;
 	}
 
 	if (mas->index == max)
-		return NULL;
+		return true;
 
-	/* Retries on dead nodes handled by mas_next_slot */
-	return mas_next_slot(mas, max, false);
+	return false;
 
 ptr_out_of_range:
 	mas->node = MAS_NONE;
 	mas->index = 1;
 	mas->last = ULONG_MAX;
-	return NULL;
+	return true;
+}
+
+/**
+ * mas_find() - On the first call, find the entry at or after mas->index up to
+ * %max.  Otherwise, find the entry after mas->index.
+ * @mas: The maple state
+ * @max: The maximum value to check.
+ *
+ * Must hold rcu_read_lock or the write lock.
+ * If an entry exists, last and index are updated accordingly.
+ * May set @mas->node to MAS_NONE.
+ *
+ * Return: The entry or %NULL.
+ */
+void *mas_find(struct ma_state *mas, unsigned long max)
+{
+	void *entry = NULL;
+
+	if (mas_find_setup(mas, max, &entry))
+		return entry;
+
+	/* Retries on dead nodes handled by mas_next_slot */
+	return mas_next_slot(mas, max, false);
 }
 EXPORT_SYMBOL_GPL(mas_find);
 
 /**
+ * mas_find_range() - On the first call, find the entry at or after
+ * mas->index up to %max.  Otherwise, advance to the next slot mas->index.
+ * @mas: The maple state
+ * @max: The maximum value to check.
+ *
+ * Must hold rcu_read_lock or the write lock.
+ * If an entry exists, last and index are updated accordingly.
+ * May set @mas->node to MAS_NONE.
+ *
+ * Return: The entry or %NULL.
+ */
+void *mas_find_range(struct ma_state *mas, unsigned long max)
+{
+	void *entry;
+
+	if (mas_find_setup(mas, max, &entry))
+		return entry;
+
+	/* Retries on dead nodes handled by mas_next_slot */
+	return mas_next_slot(mas, max, true);
+}
+EXPORT_SYMBOL_GPL(mas_find_range);
+
+/**
  * mas_find_rev: On the first call, find the first non-null entry at or below
  * mas->index down to %min.  Otherwise find the first non-null entry below
  * mas->index down to %min.
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mprotect-fix-do_mprotect_pkey-limit-check.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-move-unmap_vmas-declaration-to-internal-header.patch
mm-change-do_vmi_align_munmap-side-tree-index.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch
userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch

