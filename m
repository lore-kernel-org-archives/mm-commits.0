Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11843C7EE45
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbjFIX3p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbjFIX2h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5863A9B
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D33A061AE1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3637EC433D2;
        Fri,  9 Jun 2023 23:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353290;
        bh=wfjQFOj+Pp8lECg0pR2yKr77fbBleSwAzpiRm6o0eVM=;
        h=Date:To:From:Subject:From;
        b=sUYFVNhrskJN14IRhV7xX3WrU28CMUBoDSmeagLwa47+W30Dd0QAyX+HE6QK50vyu
         Z/Bd2/Br/sEaLB61i072bDxkMMDMm5lronGDxNaNmqMRe/lkNXRKYrcji5JfT/e3+i
         /BgJ/9RRi5u2z2/gt3k0atb0sJwEemGoGOdCscjA=
Date:   Fri, 09 Jun 2023 16:28:09 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-debug-bug_on-and-warn_on-variants.patch removed from -mm tree
Message-Id: <20230609232810.3637EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: add debug BUG_ON and WARN_ON variants
has been removed from the -mm tree.  Its filename was
     maple_tree-add-debug-bug_on-and-warn_on-variants.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: add debug BUG_ON and WARN_ON variants
Date: Thu, 18 May 2023 10:55:15 -0400

Add debug macros to dump the maple state and/or the tree for both warning
and bug_on calls.

Link: https://lkml.kernel.org/r/20230518145544.1722059-7-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |  100 +++++++++++++++++++++++++++++++++--
 lib/maple_tree.c           |   34 +++++++++++
 2 files changed, 129 insertions(+), 5 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-add-debug-bug_on-and-warn_on-variants
+++ a/include/linux/maple_tree.h
@@ -482,13 +482,13 @@ static inline void mas_init(struct ma_st
 }
 
 /* Checks if a mas has not found anything */
-static inline bool mas_is_none(struct ma_state *mas)
+static inline bool mas_is_none(const struct ma_state *mas)
 {
 	return mas->node == MAS_NONE;
 }
 
 /* Checks if a mas has been paused */
-static inline bool mas_is_paused(struct ma_state *mas)
+static inline bool mas_is_paused(const struct ma_state *mas)
 {
 	return mas->node == MAS_PAUSE;
 }
@@ -679,6 +679,8 @@ extern atomic_t maple_tree_tests_run;
 extern atomic_t maple_tree_tests_passed;
 
 void mt_dump(const struct maple_tree *mt, enum mt_dump_format format);
+void mas_dump(const struct ma_state *mas);
+void mas_wr_dump(const struct ma_wr_state *wr_mas);
 void mt_validate(struct maple_tree *mt);
 void mt_cache_shrink(void);
 #define MT_BUG_ON(__tree, __x) do {					\
@@ -695,8 +697,100 @@ void mt_cache_shrink(void);
 		atomic_inc(&maple_tree_tests_passed);			\
 	}								\
 } while (0)
+
+#define MAS_BUG_ON(__mas, __x) do {					\
+	atomic_inc(&maple_tree_tests_run);				\
+	if (__x) {							\
+		pr_info("BUG at %s:%d (%u)\n",				\
+		__func__, __LINE__, __x);				\
+		mas_dump(__mas);					\
+		mt_dump((__mas)->tree, mt_dump_hex);			\
+		pr_info("Pass: %u Run:%u\n",				\
+			atomic_read(&maple_tree_tests_passed),		\
+			atomic_read(&maple_tree_tests_run));		\
+		dump_stack();						\
+	} else {							\
+		atomic_inc(&maple_tree_tests_passed);			\
+	}								\
+} while (0)
+
+#define MAS_WR_BUG_ON(__wrmas, __x) do {				\
+	atomic_inc(&maple_tree_tests_run);				\
+	if (__x) {							\
+		pr_info("BUG at %s:%d (%u)\n",				\
+		__func__, __LINE__, __x);				\
+		mas_wr_dump(__wrmas);					\
+		mas_dump((__wrmas)->mas);				\
+		mt_dump((__wrmas)->mas->tree, mt_dump_hex);		\
+		pr_info("Pass: %u Run:%u\n",				\
+			atomic_read(&maple_tree_tests_passed),		\
+			atomic_read(&maple_tree_tests_run));		\
+		dump_stack();						\
+	} else {							\
+		atomic_inc(&maple_tree_tests_passed);			\
+	}								\
+} while (0)
+
+#define MT_WARN_ON(__tree, __x)  ({					\
+	int ret = !!(__x);						\
+	atomic_inc(&maple_tree_tests_run);				\
+	if (ret) {							\
+		pr_info("WARN at %s:%d (%u)\n",				\
+		__func__, __LINE__, __x);				\
+		mt_dump(__tree, mt_dump_hex);				\
+		pr_info("Pass: %u Run:%u\n",				\
+			atomic_read(&maple_tree_tests_passed),		\
+			atomic_read(&maple_tree_tests_run));		\
+		dump_stack();						\
+	} else {							\
+		atomic_inc(&maple_tree_tests_passed);			\
+	}								\
+	unlikely(ret);							\
+})
+
+#define MAS_WARN_ON(__mas, __x) ({					\
+	int ret = !!(__x);						\
+	atomic_inc(&maple_tree_tests_run);				\
+	if (ret) {							\
+		pr_info("WARN at %s:%d (%u)\n",				\
+		__func__, __LINE__, __x);				\
+		mas_dump(__mas);					\
+		mt_dump((__mas)->tree, mt_dump_hex);			\
+		pr_info("Pass: %u Run:%u\n",				\
+			atomic_read(&maple_tree_tests_passed),		\
+			atomic_read(&maple_tree_tests_run));		\
+		dump_stack();						\
+	} else {							\
+		atomic_inc(&maple_tree_tests_passed);			\
+	}								\
+	unlikely(ret);							\
+})
+
+#define MAS_WR_WARN_ON(__wrmas, __x) ({					\
+	int ret = !!(__x);						\
+	atomic_inc(&maple_tree_tests_run);				\
+	if (ret) {							\
+		pr_info("WARN at %s:%d (%u)\n",				\
+		__func__, __LINE__, __x);				\
+		mas_wr_dump(__wrmas);					\
+		mas_dump((__wrmas)->mas);				\
+		mt_dump((__wrmas)->mas->tree, mt_dump_hex);		\
+		pr_info("Pass: %u Run:%u\n",				\
+			atomic_read(&maple_tree_tests_passed),		\
+			atomic_read(&maple_tree_tests_run));		\
+		dump_stack();						\
+	} else {							\
+		atomic_inc(&maple_tree_tests_passed);			\
+	}								\
+	unlikely(ret);							\
+})
 #else
-#define MT_BUG_ON(__tree, __x) BUG_ON(__x)
+#define MT_BUG_ON(__tree, __x)		BUG_ON(__x)
+#define MAS_BUG_ON(__mas, __x)		BUG_ON(__x)
+#define MAS_WR_BUG_ON(__mas, __x)	BUG_ON(__x)
+#define MT_WARN_ON(__tree, __x)		WARN_ON(__x)
+#define MAS_WARN_ON(__mas, __x)		WARN_ON(__x)
+#define MAS_WR_WARN_ON(__mas, __x)	WARN_ON(__x)
 #endif /* CONFIG_DEBUG_MAPLE_TREE */
 
 #endif /*_LINUX_MAPLE_TREE_H */
--- a/lib/maple_tree.c~maple_tree-add-debug-bug_on-and-warn_on-variants
+++ a/lib/maple_tree.c
@@ -240,12 +240,12 @@ static inline void mas_set_err(struct ma
 	mas->node = MA_ERROR(err);
 }
 
-static inline bool mas_is_ptr(struct ma_state *mas)
+static inline bool mas_is_ptr(const struct ma_state *mas)
 {
 	return mas->node == MAS_ROOT;
 }
 
-static inline bool mas_is_start(struct ma_state *mas)
+static inline bool mas_is_start(const struct ma_state *mas)
 {
 	return mas->node == MAS_START;
 }
@@ -7246,4 +7246,34 @@ done:
 }
 EXPORT_SYMBOL_GPL(mt_validate);
 
+void mas_dump(const struct ma_state *mas)
+{
+	pr_err("MAS: tree=%p enode=%p ", mas->tree, mas->node);
+	if (mas_is_none(mas))
+		pr_err("(MAS_NONE) ");
+	else if (mas_is_ptr(mas))
+		pr_err("(MAS_ROOT) ");
+	else if (mas_is_start(mas))
+		 pr_err("(MAS_START) ");
+	else if (mas_is_paused(mas))
+		pr_err("(MAS_PAUSED) ");
+
+	pr_err("[%u] index=%lx last=%lx\n", mas->offset, mas->index, mas->last);
+	pr_err("     min=%lx max=%lx alloc=%p, depth=%u, flags=%x\n",
+	       mas->min, mas->max, mas->alloc, mas->depth, mas->mas_flags);
+	if (mas->index > mas->last)
+		pr_err("Check index & last\n");
+}
+EXPORT_SYMBOL_GPL(mas_dump);
+
+void mas_wr_dump(const struct ma_wr_state *wr_mas)
+{
+	pr_err("WR_MAS: node=%p r_min=%lx r_max=%lx\n",
+	       wr_mas->node, wr_mas->r_min, wr_mas->r_max);
+	pr_err("        type=%u off_end=%u, node_end=%u, end_piv=%lx\n",
+	       wr_mas->type, wr_mas->offset_end, wr_mas->node_end,
+	       wr_mas->end_piv);
+}
+EXPORT_SYMBOL_GPL(mas_wr_dump);
+
 #endif /* CONFIG_DEBUG_MAPLE_TREE */
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

