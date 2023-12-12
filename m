Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F7E7F55D
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vga5UZnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FAFC433CA;
	Tue, 12 Dec 2023 18:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407541;
	bh=vF9sQOP07+HOqzoZCBHmXIxl75HdRIiLRh21uk0sWVw=;
	h=Date:To:From:Subject:From;
	b=Vga5UZnpYP64F5JFkmS4ukaJQxHoCqY0+JUnTRiS9H33sdxMOoAY0rE2PEHXabsTQ
	 VF1DLiRenk0Wy6wAEQ/V5uqMVHiUfwYGjsl2aScT3uYFypiHy9ZPGT4BNysERVYRbv
	 sza5NLcwT2/CiefQ2ewvSe9Zt6iP8p3kW1NFlci4=
Date: Tue, 12 Dec 2023 10:59:00 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-move-debug-check-to-__mas_set_range.patch removed from -mm tree
Message-Id: <20231212185901.50FAFC433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: move debug check to __mas_set_range()
has been removed from the -mm tree.  Its filename was
     maple_tree-move-debug-check-to-__mas_set_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


