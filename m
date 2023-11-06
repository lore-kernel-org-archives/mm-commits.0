Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B41FC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 17:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjKFReS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjKFReN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 12:34:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FBDD47
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 09:34:10 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58DBC433C9;
        Mon,  6 Nov 2023 17:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699292050;
        bh=EtfVmZDlv3FTbkLwr2Xk2Lk1hd8WJBG2wJQKAwWThwM=;
        h=Date:To:From:Subject:From;
        b=RwwRoV9EvGiQT8DTJqVIZ1wIlHJ7HQx2rrKyoHvsXSwQy0f2Q+LAtAhwTfoMOpJuN
         rMT4XNmQhmMUjWudphm9Ed4YB0eoQ7G+nYjv38yH++8ZebclSEuuUJkmtKfnRaNhn5
         bZbWM7QXWOgQGNEA75vVPhx9glWWSNitqTBaSc9g=
Date:   Mon, 06 Nov 2023 09:34:09 -0800
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-move-debug-check-to-__mas_set_range.patch added to mm-unstable branch
Message-Id: <20231106173409.E58DBC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: move debug check to __mas_set_range()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-move-debug-check-to-__mas_set_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-move-debug-check-to-__mas_set_range.patch

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
Subject: maple_tree: move debug check to __mas_set_range()
Date: Wed, 1 Nov 2023 13:16:20 -0400

__mas_set_range() was created to shortcut resetting the maple state and a
debug check was added to the caller (the vma iterator) to ensure the
internal maple state remains safe to use.  Move the debug check from the
vma iterator into the maple tree itself so other users do not incorrectly
use the advanced maple state modification.

Fallout from this change include a large amount of debug setup needed to
be moved to earlier in the header, and the maple_tree.h radix-tree test
code needed to move the inclusion of the header to after the atomic
define.  None of those changes have functional changes.

Link: https://lkml.kernel.org/r/20231101171629.3612299-4-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h                  |  255 +++++++++---------
 mm/internal.h                               |    2 
 tools/testing/radix-tree/linux/maple_tree.h |    2 
 3 files changed, 130 insertions(+), 129 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-move-debug-check-to-__mas_set_range
+++ a/include/linux/maple_tree.h
@@ -557,6 +557,131 @@ static inline void mas_reset(struct ma_s
  */
 #define mas_for_each(__mas, __entry, __max) \
 	while (((__entry) = mas_find((__mas), (__max))) != NULL)
+
+#ifdef CONFIG_DEBUG_MAPLE_TREE
+enum mt_dump_format {
+	mt_dump_dec,
+	mt_dump_hex,
+};
+
+extern atomic_t maple_tree_tests_run;
+extern atomic_t maple_tree_tests_passed;
+
+void mt_dump(const struct maple_tree *mt, enum mt_dump_format format);
+void mas_dump(const struct ma_state *mas);
+void mas_wr_dump(const struct ma_wr_state *wr_mas);
+void mt_validate(struct maple_tree *mt);
+void mt_cache_shrink(void);
+#define MT_BUG_ON(__tree, __x) do {					\
+	atomic_inc(&maple_tree_tests_run);				\
+	if (__x) {							\
+		pr_info("BUG at %s:%d (%u)\n",				\
+		__func__, __LINE__, __x);				\
+		mt_dump(__tree, mt_dump_hex);				\
+		pr_info("Pass: %u Run:%u\n",				\
+			atomic_read(&maple_tree_tests_passed),		\
+			atomic_read(&maple_tree_tests_run));		\
+		dump_stack();						\
+	} else {							\
+		atomic_inc(&maple_tree_tests_passed);			\
+	}								\
+} while (0)
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
+#else
+#define MT_BUG_ON(__tree, __x)		BUG_ON(__x)
+#define MAS_BUG_ON(__mas, __x)		BUG_ON(__x)
+#define MAS_WR_BUG_ON(__mas, __x)	BUG_ON(__x)
+#define MT_WARN_ON(__tree, __x)		WARN_ON(__x)
+#define MAS_WARN_ON(__mas, __x)		WARN_ON(__x)
+#define MAS_WR_WARN_ON(__mas, __x)	WARN_ON(__x)
+#endif /* CONFIG_DEBUG_MAPLE_TREE */
+
 /**
  * __mas_set_range() - Set up Maple Tree operation state to a sub-range of the
  * current location.
@@ -570,6 +695,9 @@ static inline void mas_reset(struct ma_s
 static inline void __mas_set_range(struct ma_state *mas, unsigned long start,
 		unsigned long last)
 {
+	/* Ensure the range starts within the current slot */
+	MAS_WARN_ON(mas, mas_is_active(mas) &&
+		   (mas->index > start || mas->last < start));
 	mas->index = start;
 	mas->last = last;
 }
@@ -587,8 +715,8 @@ static inline void __mas_set_range(struc
 static inline
 void mas_set_range(struct ma_state *mas, unsigned long start, unsigned long last)
 {
-	__mas_set_range(mas, start, last);
 	mas->node = MAS_START;
+	__mas_set_range(mas, start, last);
 }
 
 /**
@@ -713,129 +841,4 @@ void *mt_next(struct maple_tree *mt, uns
 	for (__entry = mt_find(__tree, &(__index), __max); \
 		__entry; __entry = mt_find_after(__tree, &(__index), __max))
 
-
-#ifdef CONFIG_DEBUG_MAPLE_TREE
-enum mt_dump_format {
-	mt_dump_dec,
-	mt_dump_hex,
-};
-
-extern atomic_t maple_tree_tests_run;
-extern atomic_t maple_tree_tests_passed;
-
-void mt_dump(const struct maple_tree *mt, enum mt_dump_format format);
-void mas_dump(const struct ma_state *mas);
-void mas_wr_dump(const struct ma_wr_state *wr_mas);
-void mt_validate(struct maple_tree *mt);
-void mt_cache_shrink(void);
-#define MT_BUG_ON(__tree, __x) do {					\
-	atomic_inc(&maple_tree_tests_run);				\
-	if (__x) {							\
-		pr_info("BUG at %s:%d (%u)\n",				\
-		__func__, __LINE__, __x);				\
-		mt_dump(__tree, mt_dump_hex);				\
-		pr_info("Pass: %u Run:%u\n",				\
-			atomic_read(&maple_tree_tests_passed),		\
-			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
-	} else {							\
-		atomic_inc(&maple_tree_tests_passed);			\
-	}								\
-} while (0)
-
-#define MAS_BUG_ON(__mas, __x) do {					\
-	atomic_inc(&maple_tree_tests_run);				\
-	if (__x) {							\
-		pr_info("BUG at %s:%d (%u)\n",				\
-		__func__, __LINE__, __x);				\
-		mas_dump(__mas);					\
-		mt_dump((__mas)->tree, mt_dump_hex);			\
-		pr_info("Pass: %u Run:%u\n",				\
-			atomic_read(&maple_tree_tests_passed),		\
-			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
-	} else {							\
-		atomic_inc(&maple_tree_tests_passed);			\
-	}								\
-} while (0)
-
-#define MAS_WR_BUG_ON(__wrmas, __x) do {				\
-	atomic_inc(&maple_tree_tests_run);				\
-	if (__x) {							\
-		pr_info("BUG at %s:%d (%u)\n",				\
-		__func__, __LINE__, __x);				\
-		mas_wr_dump(__wrmas);					\
-		mas_dump((__wrmas)->mas);				\
-		mt_dump((__wrmas)->mas->tree, mt_dump_hex);		\
-		pr_info("Pass: %u Run:%u\n",				\
-			atomic_read(&maple_tree_tests_passed),		\
-			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
-	} else {							\
-		atomic_inc(&maple_tree_tests_passed);			\
-	}								\
-} while (0)
-
-#define MT_WARN_ON(__tree, __x)  ({					\
-	int ret = !!(__x);						\
-	atomic_inc(&maple_tree_tests_run);				\
-	if (ret) {							\
-		pr_info("WARN at %s:%d (%u)\n",				\
-		__func__, __LINE__, __x);				\
-		mt_dump(__tree, mt_dump_hex);				\
-		pr_info("Pass: %u Run:%u\n",				\
-			atomic_read(&maple_tree_tests_passed),		\
-			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
-	} else {							\
-		atomic_inc(&maple_tree_tests_passed);			\
-	}								\
-	unlikely(ret);							\
-})
-
-#define MAS_WARN_ON(__mas, __x) ({					\
-	int ret = !!(__x);						\
-	atomic_inc(&maple_tree_tests_run);				\
-	if (ret) {							\
-		pr_info("WARN at %s:%d (%u)\n",				\
-		__func__, __LINE__, __x);				\
-		mas_dump(__mas);					\
-		mt_dump((__mas)->tree, mt_dump_hex);			\
-		pr_info("Pass: %u Run:%u\n",				\
-			atomic_read(&maple_tree_tests_passed),		\
-			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
-	} else {							\
-		atomic_inc(&maple_tree_tests_passed);			\
-	}								\
-	unlikely(ret);							\
-})
-
-#define MAS_WR_WARN_ON(__wrmas, __x) ({					\
-	int ret = !!(__x);						\
-	atomic_inc(&maple_tree_tests_run);				\
-	if (ret) {							\
-		pr_info("WARN at %s:%d (%u)\n",				\
-		__func__, __LINE__, __x);				\
-		mas_wr_dump(__wrmas);					\
-		mas_dump((__wrmas)->mas);				\
-		mt_dump((__wrmas)->mas->tree, mt_dump_hex);		\
-		pr_info("Pass: %u Run:%u\n",				\
-			atomic_read(&maple_tree_tests_passed),		\
-			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
-	} else {							\
-		atomic_inc(&maple_tree_tests_passed);			\
-	}								\
-	unlikely(ret);							\
-})
-#else
-#define MT_BUG_ON(__tree, __x)		BUG_ON(__x)
-#define MAS_BUG_ON(__mas, __x)		BUG_ON(__x)
-#define MAS_WR_BUG_ON(__mas, __x)	BUG_ON(__x)
-#define MT_WARN_ON(__tree, __x)		WARN_ON(__x)
-#define MAS_WARN_ON(__mas, __x)		WARN_ON(__x)
-#define MAS_WR_WARN_ON(__mas, __x)	WARN_ON(__x)
-#endif /* CONFIG_DEBUG_MAPLE_TREE */
-
 #endif /*_LINUX_MAPLE_TREE_H */
--- a/mm/internal.h~maple_tree-move-debug-check-to-__mas_set_range
+++ a/mm/internal.h
@@ -1135,8 +1135,6 @@ static inline bool vma_soft_dirty_enable
 static inline void vma_iter_config(struct vma_iterator *vmi,
 		unsigned long index, unsigned long last)
 {
-	MAS_BUG_ON(&vmi->mas, vmi->mas.node != MAS_START &&
-		   (vmi->mas.index > index || vmi->mas.last < index));
 	__mas_set_range(&vmi->mas, index, last - 1);
 }
 
--- a/tools/testing/radix-tree/linux/maple_tree.h~maple_tree-move-debug-check-to-__mas_set_range
+++ a/tools/testing/radix-tree/linux/maple_tree.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 #define atomic_t int32_t
-#include "../../../../include/linux/maple_tree.h"
 #define atomic_inc(x) uatomic_inc(x)
 #define atomic_read(x) uatomic_read(x)
 #define atomic_set(x, y) do {} while (0)
 #define U8_MAX UCHAR_MAX
+#include "../../../../include/linux/maple_tree.h"
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-remove-unnecessary-default-labels-from-switch-statements.patch
maple_tree-make-mas_erase-more-robust.patch
maple_tree-move-debug-check-to-__mas_set_range.patch
maple_tree-add-end-of-node-tracking-to-the-maple-state.patch
maple_tree-use-cached-node-end-in-mas_next.patch
maple_tree-use-cached-node-end-in-mas_destroy.patch
maple_tree-clean-up-inlines-for-some-functions.patch
maple_tree-separate-ma_state-node-from-status.patch
maple_tree-separate-ma_state-node-from-status-fix-1.patch
maple_tree-separate-ma_state-node-from-status-fix-2.patch
maple_tree-remove-mas_searchable.patch
maple_tree-use-maple-state-end-for-write-operations.patch
maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch
maple_tree-mtree_range_walk-clean-up.patch

