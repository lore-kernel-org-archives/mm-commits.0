Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C9C2C77B75
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 23:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240563AbjELXBI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 19:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240473AbjELXAb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 19:00:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019DA1FEB
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 15:59:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64B226593F
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 22:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C43C4339B;
        Fri, 12 May 2023 22:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683932378;
        bh=lRgQ57pPyvUjL7Aa6KHkhgULus9jJxGO/8PpH8OI3Lg=;
        h=Date:To:From:Subject:From;
        b=v6ZNNiHLynUiBJMC08r1zriCzBPX7hT3bip4hIoknwiIhPpILQHrSH3scvNs3Ur1x
         oMy+U0UgNDJP4m/B69zvc1KUeijJCOpv1vISSoo4ymb2JJ1bIBgbyC4Dk8S+SjP0aY
         y8/tJv0BXLSMLCdBpyn2v3EutPZXCzLoYBVDNuPo=
Date:   Fri, 12 May 2023 15:59:38 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-mas_prev_range-and-mas_find_range_rev-interface.patch added to mm-unstable branch
Message-Id: <20230512225938.B8C43C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: add mas_prev_range() and mas_find_range_rev interface
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-mas_prev_range-and-mas_find_range_rev-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-mas_prev_range-and-mas_find_range_rev-interface.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: add mas_prev_range() and mas_find_range_rev interface
Date: Fri, 12 May 2023 14:20:32 -0400

Some users of the maple tree may want to move to the previous range
regardless of the value stored there.  Add this interface as well as the
'find' variant to support walking to the first value, then iterating over
the previous ranges.

Link: https://lkml.kernel.org/r/20230512182036.359030-32-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    2 
 lib/maple_tree.c           |  163 ++++++++++++++++++++++++++---------
 2 files changed, 125 insertions(+), 40 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-add-mas_prev_range-and-mas_find_range_rev-interface
+++ a/include/linux/maple_tree.h
@@ -457,6 +457,7 @@ void mas_store_prealloc(struct ma_state
 void *mas_find(struct ma_state *mas, unsigned long max);
 void *mas_find_range(struct ma_state *mas, unsigned long max);
 void *mas_find_rev(struct ma_state *mas, unsigned long min);
+void *mas_find_range_rev(struct ma_state *mas, unsigned long max);
 int mas_preallocate(struct ma_state *mas, gfp_t gfp);
 bool mas_is_err(struct ma_state *mas);
 
@@ -467,6 +468,7 @@ void mas_destroy(struct ma_state *mas);
 int mas_expected_entries(struct ma_state *mas, unsigned long nr_entries);
 
 void *mas_prev(struct ma_state *mas, unsigned long min);
+void *mas_prev_range(struct ma_state *mas, unsigned long max);
 void *mas_next(struct ma_state *mas, unsigned long max);
 void *mas_next_range(struct ma_state *mas, unsigned long max);
 
--- a/lib/maple_tree.c~maple_tree-add-mas_prev_range-and-mas_find_range_rev-interface
+++ a/lib/maple_tree.c
@@ -4604,7 +4604,7 @@ no_entry:
  *
  * Return: The entry in the previous slot which is possibly NULL
  */
-void *mas_prev_slot(struct ma_state *mas, unsigned long min, bool empty)
+static void *mas_prev_slot(struct ma_state *mas, unsigned long min, bool empty)
 {
 	void *entry;
 	void __rcu **slots;
@@ -5919,18 +5919,8 @@ void *mt_next(struct maple_tree *mt, uns
 }
 EXPORT_SYMBOL_GPL(mt_next);
 
-/**
- * mas_prev() - Get the previous entry
- * @mas: The maple state
- * @min: The minimum value to check.
- *
- * Must hold rcu_read_lock or the write lock.
- * Will reset mas to MAS_START if the node is MAS_NONE.  Will stop on not
- * searchable nodes.
- *
- * Return: the previous value or %NULL.
- */
-void *mas_prev(struct ma_state *mas, unsigned long min)
+static inline bool mas_prev_setup(struct ma_state *mas, unsigned long min,
+		void **entry)
 {
 	if (mas->index <= min)
 		goto none;
@@ -5948,7 +5938,8 @@ void *mas_prev(struct ma_state *mas, uns
 		if (!mas->index)
 			goto none;
 		mas->index = mas->last = 0;
-		return mas_root(mas);
+		*entry = mas_root(mas);
+		return true;
 	}
 
 	if (mas_is_none(mas)) {
@@ -5956,19 +5947,65 @@ void *mas_prev(struct ma_state *mas, uns
 			/* Walked to out-of-range pointer? */
 			mas->index = mas->last = 0;
 			mas->node = MAS_ROOT;
-			return mas_root(mas);
+			*entry = mas_root(mas);
+			return true;
 		}
-		return NULL;
+		return true;
 	}
-	return mas_prev_slot(mas, min, false);
+
+	return false;
 
 none:
 	mas->node = MAS_NONE;
-	return NULL;
+	return true;
+}
+
+/**
+ * mas_prev() - Get the previous entry
+ * @mas: The maple state
+ * @min: The minimum value to check.
+ *
+ * Must hold rcu_read_lock or the write lock.
+ * Will reset mas to MAS_START if the node is MAS_NONE.  Will stop on not
+ * searchable nodes.
+ *
+ * Return: the previous value or %NULL.
+ */
+void *mas_prev(struct ma_state *mas, unsigned long min)
+{
+	void *entry = NULL;
+
+	if (mas_prev_setup(mas, min, &entry))
+		return entry;
+
+	return mas_prev_slot(mas, min, false);
 }
 EXPORT_SYMBOL_GPL(mas_prev);
 
 /**
+ * mas_prev_range() - Advance to the previous range
+ * @mas: The maple state
+ * @min: The minimum value to check.
+ *
+ * Sets @mas->index and @mas->last to the range.
+ * Must hold rcu_read_lock or the write lock.
+ * Will reset mas to MAS_START if the node is MAS_NONE.  Will stop on not
+ * searchable nodes.
+ *
+ * Return: the previous value or %NULL.
+ */
+void *mas_prev_range(struct ma_state *mas, unsigned long min)
+{
+	void *entry = NULL;
+
+	if (mas_prev_setup(mas, min, &entry))
+		return entry;
+
+	return mas_prev_slot(mas, min, true);
+}
+EXPORT_SYMBOL_GPL(mas_prev_range);
+
+/**
  * mt_prev() - get the previous value in the maple tree
  * @mt: The maple tree
  * @index: The start index
@@ -6114,20 +6151,18 @@ void *mas_find_range(struct ma_state *ma
 EXPORT_SYMBOL_GPL(mas_find_range);
 
 /**
- * mas_find_rev: On the first call, find the first non-null entry at or below
- * mas->index down to %min.  Otherwise find the first non-null entry below
- * mas->index down to %min.
+ * mas_find_rev_setup() - Internal function to set up mas_find_*_rev()
  * @mas: The maple state
- * @min: The minimum value to check.
- *
- * Must hold rcu_read_lock or the write lock.
- * If an entry exists, last and index are updated accordingly.
- * May set @mas->node to MAS_NONE.
+ * @min: The minimum index
+ * @entry: Pointer to the entry
  *
- * Return: The entry or %NULL.
+ * Returns: True if entry is the answer, false otherwise.
  */
-void *mas_find_rev(struct ma_state *mas, unsigned long min)
+static inline bool mas_find_rev_setup(struct ma_state *mas, unsigned long min,
+		void **entry)
 {
+	*entry = NULL;
+
 	if (unlikely(mas_is_none(mas))) {
 		if (mas->index <= min)
 			goto none;
@@ -6139,7 +6174,7 @@ void *mas_find_rev(struct ma_state *mas,
 	if (unlikely(mas_is_paused(mas))) {
 		if (unlikely(mas->index <= min)) {
 			mas->node = MAS_NONE;
-			return NULL;
+			return true;
 		}
 		mas->node = MAS_START;
 		mas->last = --mas->index;
@@ -6147,14 +6182,12 @@ void *mas_find_rev(struct ma_state *mas,
 
 	if (unlikely(mas_is_start(mas))) {
 		/* First run or continue */
-		void *entry;
-
 		if (mas->index < min)
-			return NULL;
+			return true;
 
-		entry = mas_walk(mas);
-		if (entry)
-			return entry;
+		*entry = mas_walk(mas);
+		if (*entry)
+			return true;
 	}
 
 	if (unlikely(!mas_searchable(mas))) {
@@ -6168,23 +6201,73 @@ void *mas_find_rev(struct ma_state *mas,
 			 */
 			mas->last = mas->index = 0;
 			mas->node = MAS_ROOT;
-			return mas_root(mas);
+			*entry = mas_root(mas);
+			return true;
 		}
 	}
 
 	if (mas->index < min)
-		return NULL;
+		return true;
 
-	/* Retries on dead nodes handled by mas_prev_slot */
-	return mas_prev_slot(mas, min, false);
+	return false;
 
 none:
 	mas->node = MAS_NONE;
-	return NULL;
+	return true;
+}
+
+/**
+ * mas_find_rev: On the first call, find the first non-null entry at or below
+ * mas->index down to %min.  Otherwise find the first non-null entry below
+ * mas->index down to %min.
+ * @mas: The maple state
+ * @min: The minimum value to check.
+ *
+ * Must hold rcu_read_lock or the write lock.
+ * If an entry exists, last and index are updated accordingly.
+ * May set @mas->node to MAS_NONE.
+ *
+ * Return: The entry or %NULL.
+ */
+void *mas_find_rev(struct ma_state *mas, unsigned long min)
+{
+	void *entry;
+
+	if (mas_find_rev_setup(mas, min, &entry))
+		return entry;
+
+	/* Retries on dead nodes handled by mas_prev_slot */
+	return mas_prev_slot(mas, min, false);
+
 }
 EXPORT_SYMBOL_GPL(mas_find_rev);
 
 /**
+ * mas_find_range_rev: On the first call, find the first non-null entry at or
+ * below mas->index down to %min.  Otherwise advance to the previous slot after
+ * mas->index down to %min.
+ * @mas: The maple state
+ * @min: The minimum value to check.
+ *
+ * Must hold rcu_read_lock or the write lock.
+ * If an entry exists, last and index are updated accordingly.
+ * May set @mas->node to MAS_NONE.
+ *
+ * Return: The entry or %NULL.
+ */
+void *mas_find_range_rev(struct ma_state *mas, unsigned long min)
+{
+	void *entry;
+
+	if (mas_find_rev_setup(mas, min, &entry))
+		return entry;
+
+	/* Retries on dead nodes handled by mas_prev_slot */
+	return mas_prev_slot(mas, min, true);
+}
+EXPORT_SYMBOL_GPL(mas_find_range_rev);
+
+/**
  * mas_erase() - Find the range in which index resides and erase the entire
  * range.
  * @mas: The maple state
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-static-analyser-cppcheck-issue.patch
maple_tree-avoid-unnecessary-ascending.patch
maple_tree-clean-up-mas_dfs_postorder.patch
maple_tree-add-debug-bug_on-and-warn_on-variants.patch
maple_tree-use-mas_bug_on-when-setting-a-leaf-node-as-a-parent.patch
maple_tree-use-mas_bug_on-in-mas_set_height.patch
maple_tree-use-mas_bug_on-from-mas_topiary_range.patch
maple_tree-use-mas_wr_bug_on-in-mas_store_prealloc.patch
maple_tree-use-mas_bug_on-prior-to-calling-mas_meta_gap.patch
maple_tree-return-error-on-mte_pivots-out-of-range.patch
maple_tree-make-test-code-work-without-debug-enabled.patch
mm-update-validate_mm-to-use-vma-iterator.patch
mm-update-vma_iter_store-to-use-mas_warn_on.patch
maple_tree-add-__init-and-__exit-to-test-module.patch
maple_tree-remove-unnecessary-check-from-mas_destroy.patch
maple_tree-mas_start-reset-depth-on-dead-node.patch
mm-mmap-change-do_vmi_align_munmap-for-maple-tree-iterator-changes.patch
maple_tree-try-harder-to-keep-active-node-after-mas_next.patch
maple_tree-try-harder-to-keep-active-node-with-mas_prev.patch
maple_tree-revise-limit-checks-in-mas_empty_area_rev.patch
maple_tree-fix-testing-mas_empty_area.patch
maple_tree-introduce-mas_next_slot-interface.patch
maple_tree-add-mas_next_range-and-mas_find_range-interfaces.patch
maple_tree-relocate-mas_rewalk-and-mas_rewalk_if_dead.patch
maple_tree-introduce-mas_prev_slot-interface.patch
maple_tree-add-mas_prev_range-and-mas_find_range_rev-interface.patch
maple_tree-clear-up-index-and-last-setting-in-single-entry-tree.patch
maple_tree-update-testing-code-for-mas_nextprevwalk.patch
mm-add-vma_iter_nextprev_range-to-vma-iterator.patch
mm-avoid-rewalk-in-mmap_region.patch

