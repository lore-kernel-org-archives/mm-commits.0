Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE7DC77B7D
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 19:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjEETan (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 15:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbjEETaf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 15:30:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B314C05
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 12:30:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BEE264024
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 19:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEA7C433D2;
        Fri,  5 May 2023 19:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683315025;
        bh=qZTDAZWv3mnq3T+2p/8hnUZqkQf6Y5X0NjCvMAG1DpA=;
        h=Date:To:From:Subject:From;
        b=jhr+IsW0MIiuQcNmlC/n7sEsTWykv+7SXQ+dN2S0YOKXAw8e2qonQ/rOrmgOLm7W2
         /CxhvgsjoeGEfPz+h0MVqMKI+qB1PEBiT8Ur8SzsYUqRsZMa95EIoEyhrQpL4bTKUO
         ev2NIMXQYfP4i1ICsQq1XOCUzCYyYjGUyIrSagYo=
Date:   Fri, 05 May 2023 12:30:24 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        senozhatsky@chromium.org, richard.weiyang@gmail.com,
        Liam.Howlett@oracle.com, dcb314@hotmail.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-format-option-to-mt_dump.patch added to mm-unstable branch
Message-Id: <20230505193025.7EEA7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: add format option to mt_dump()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-format-option-to-mt_dump.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-format-option-to-mt_dump.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: maple_tree: add format option to mt_dump()
Date: Fri, 5 May 2023 13:41:33 -0400

Allow different formatting strings to be used when dumping the tree. 
Currently supports hex and decimal.

Link: https://lkml.kernel.org/r/20230505174204.2665599-6-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h       |    9 ++-
 lib/maple_tree.c                 |   87 +++++++++++++++++++----------
 lib/test_maple_tree.c            |   10 +--
 mm/internal.h                    |    4 -
 mm/mmap.c                        |    8 +-
 tools/testing/radix-tree/maple.c |   12 ++--
 6 files changed, 82 insertions(+), 48 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-add-format-option-to-mt_dump
+++ a/include/linux/maple_tree.h
@@ -670,10 +670,15 @@ void *mt_next(struct maple_tree *mt, uns
 
 
 #ifdef CONFIG_DEBUG_MAPLE_TREE
+enum mt_dump_format {
+	mt_dump_dec,
+	mt_dump_hex,
+};
+
 extern atomic_t maple_tree_tests_run;
 extern atomic_t maple_tree_tests_passed;
 
-void mt_dump(const struct maple_tree *mt);
+void mt_dump(const struct maple_tree *mt, enum mt_dump_format format);
 void mt_validate(struct maple_tree *mt);
 void mt_cache_shrink(void);
 #define MT_BUG_ON(__tree, __x) do {					\
@@ -681,7 +686,7 @@ void mt_cache_shrink(void);
 	if (__x) {							\
 		pr_info("BUG at %s:%d (%u)\n",				\
 		__func__, __LINE__, __x);				\
-		mt_dump(__tree);					\
+		mt_dump(__tree, mt_dump_hex);				\
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
--- a/lib/maple_tree.c~maple_tree-add-format-option-to-mt_dump
+++ a/lib/maple_tree.c
@@ -5699,7 +5699,7 @@ void *mas_store(struct ma_state *mas, vo
 	trace_ma_write(__func__, mas, 0, entry);
 #ifdef CONFIG_DEBUG_MAPLE_TREE
 	if (mas->index > mas->last)
-		pr_err("Error %lu > %lu %p\n", mas->index, mas->last, entry);
+		pr_err("Error %lX > %lX %p\n", mas->index, mas->last, entry);
 	MT_BUG_ON(mas->tree, mas->index > mas->last);
 	if (mas->index > mas->last) {
 		mas_set_err(mas, -EINVAL);
@@ -6753,22 +6753,33 @@ static void mas_dfs_postorder(struct ma_
 
 /* Tree validations */
 static void mt_dump_node(const struct maple_tree *mt, void *entry,
-		unsigned long min, unsigned long max, unsigned int depth);
+		unsigned long min, unsigned long max, unsigned int depth,
+		enum mt_dump_format format);
 static void mt_dump_range(unsigned long min, unsigned long max,
-			  unsigned int depth)
+			  unsigned int depth, enum mt_dump_format format)
 {
 	static const char spaces[] = "                                ";
 
-	if (min == max)
-		pr_info("%.*s%lu: ", depth * 2, spaces, min);
-	else
-		pr_info("%.*s%lu-%lu: ", depth * 2, spaces, min, max);
+	switch(format) {
+	case mt_dump_hex:
+		if (min == max)
+			pr_info("%.*s%lx: ", depth * 2, spaces, min);
+		else
+			pr_info("%.*s%lx-%lx: ", depth * 2, spaces, min, max);
+		break;
+	default:
+	case mt_dump_dec:
+		if (min == max)
+			pr_info("%.*s%lu: ", depth * 2, spaces, min);
+		else
+			pr_info("%.*s%lu-%lu: ", depth * 2, spaces, min, max);
+	}
 }
 
 static void mt_dump_entry(void *entry, unsigned long min, unsigned long max,
-			  unsigned int depth)
+			  unsigned int depth, enum mt_dump_format format)
 {
-	mt_dump_range(min, max, depth);
+	mt_dump_range(min, max, depth, format);
 
 	if (xa_is_value(entry))
 		pr_cont("value %ld (0x%lx) [%p]\n", xa_to_value(entry),
@@ -6782,7 +6793,8 @@ static void mt_dump_entry(void *entry, u
 }
 
 static void mt_dump_range64(const struct maple_tree *mt, void *entry,
-			unsigned long min, unsigned long max, unsigned int depth)
+		unsigned long min, unsigned long max, unsigned int depth,
+		enum mt_dump_format format)
 {
 	struct maple_range_64 *node = &mte_to_node(entry)->mr64;
 	bool leaf = mte_is_leaf(entry);
@@ -6790,8 +6802,16 @@ static void mt_dump_range64(const struct
 	int i;
 
 	pr_cont(" contents: ");
-	for (i = 0; i < MAPLE_RANGE64_SLOTS - 1; i++)
-		pr_cont("%p %lu ", node->slot[i], node->pivot[i]);
+	for (i = 0; i < MAPLE_RANGE64_SLOTS - 1; i++) {
+		switch(format) {
+		case mt_dump_hex:
+			pr_cont("%p %lX ", node->slot[i], node->pivot[i]);
+			break;
+		default:
+		case mt_dump_dec:
+			pr_cont("%p %lu ", node->slot[i], node->pivot[i]);
+		}
+	}
 	pr_cont("%p\n", node->slot[i]);
 	for (i = 0; i < MAPLE_RANGE64_SLOTS; i++) {
 		unsigned long last = max;
@@ -6804,24 +6824,32 @@ static void mt_dump_range64(const struct
 			break;
 		if (leaf)
 			mt_dump_entry(mt_slot(mt, node->slot, i),
-					first, last, depth + 1);
+					first, last, depth + 1, format);
 		else if (node->slot[i])
 			mt_dump_node(mt, mt_slot(mt, node->slot, i),
-					first, last, depth + 1);
+					first, last, depth + 1, format);
 
 		if (last == max)
 			break;
 		if (last > max) {
-			pr_err("node %p last (%lu) > max (%lu) at pivot %d!\n",
+			switch(format) {
+			case mt_dump_hex:
+				pr_err("node %p last (%lx) > max (%lx) at pivot %d!\n",
 					node, last, max, i);
-			break;
+				break;
+			default:
+			case mt_dump_dec:
+				pr_err("node %p last (%lu) > max (%lu) at pivot %d!\n",
+					node, last, max, i);
+			}
 		}
 		first = last + 1;
 	}
 }
 
 static void mt_dump_arange64(const struct maple_tree *mt, void *entry,
-			unsigned long min, unsigned long max, unsigned int depth)
+	unsigned long min, unsigned long max, unsigned int depth,
+	enum mt_dump_format format)
 {
 	struct maple_arange_64 *node = &mte_to_node(entry)->ma64;
 	bool leaf = mte_is_leaf(entry);
@@ -6846,10 +6874,10 @@ static void mt_dump_arange64(const struc
 			break;
 		if (leaf)
 			mt_dump_entry(mt_slot(mt, node->slot, i),
-					first, last, depth + 1);
+					first, last, depth + 1, format);
 		else if (node->slot[i])
 			mt_dump_node(mt, mt_slot(mt, node->slot, i),
-					first, last, depth + 1);
+					first, last, depth + 1, format);
 
 		if (last == max)
 			break;
@@ -6863,13 +6891,14 @@ static void mt_dump_arange64(const struc
 }
 
 static void mt_dump_node(const struct maple_tree *mt, void *entry,
-		unsigned long min, unsigned long max, unsigned int depth)
+		unsigned long min, unsigned long max, unsigned int depth,
+		enum mt_dump_format format)
 {
 	struct maple_node *node = mte_to_node(entry);
 	unsigned int type = mte_node_type(entry);
 	unsigned int i;
 
-	mt_dump_range(min, max, depth);
+	mt_dump_range(min, max, depth, format);
 
 	pr_cont("node %p depth %d type %d parent %p", node, depth, type,
 			node ? node->parent : NULL);
@@ -6880,15 +6909,15 @@ static void mt_dump_node(const struct ma
 			if (min + i > max)
 				pr_cont("OUT OF RANGE: ");
 			mt_dump_entry(mt_slot(mt, node->slot, i),
-					min + i, min + i, depth);
+					min + i, min + i, depth, format);
 		}
 		break;
 	case maple_leaf_64:
 	case maple_range_64:
-		mt_dump_range64(mt, entry, min, max, depth);
+		mt_dump_range64(mt, entry, min, max, depth, format);
 		break;
 	case maple_arange_64:
-		mt_dump_arange64(mt, entry, min, max, depth);
+		mt_dump_arange64(mt, entry, min, max, depth, format);
 		break;
 
 	default:
@@ -6896,16 +6925,16 @@ static void mt_dump_node(const struct ma
 	}
 }
 
-void mt_dump(const struct maple_tree *mt)
+void mt_dump(const struct maple_tree *mt, enum mt_dump_format format)
 {
 	void *entry = rcu_dereference_check(mt->ma_root, mt_locked(mt));
 
 	pr_info("maple_tree(%p) flags %X, height %u root %p\n",
 		 mt, mt->ma_flags, mt_height(mt), entry);
 	if (!xa_is_node(entry))
-		mt_dump_entry(entry, 0, 0, 0);
+		mt_dump_entry(entry, 0, 0, 0, format);
 	else if (entry)
-		mt_dump_node(mt, entry, 0, mt_node_max(entry), 0);
+		mt_dump_node(mt, entry, 0, mt_node_max(entry), 0, format);
 }
 EXPORT_SYMBOL_GPL(mt_dump);
 
@@ -6958,7 +6987,7 @@ static void mas_validate_gaps(struct ma_
 						mas_mn(mas), i,
 						mas_get_slot(mas, i), gap,
 						p_end, p_start);
-					mt_dump(mas->tree);
+					mt_dump(mas->tree, mt_dump_hex);
 
 					MT_BUG_ON(mas->tree,
 						gap != p_end - p_start + 1);
@@ -6991,7 +7020,7 @@ counted:
 	MT_BUG_ON(mas->tree, max_gap > mas->max);
 	if (ma_gaps(p_mn, mas_parent_type(mas, mte))[p_slot] != max_gap) {
 		pr_err("gap %p[%u] != %lu\n", p_mn, p_slot, max_gap);
-		mt_dump(mas->tree);
+		mt_dump(mas->tree, mt_dump_hex);
 	}
 
 	MT_BUG_ON(mas->tree,
--- a/lib/test_maple_tree.c~maple_tree-add-format-option-to-mt_dump
+++ a/lib/test_maple_tree.c
@@ -219,7 +219,7 @@ static noinline void check_rev_seq(struc
 #ifndef __KERNEL__
 	if (verbose) {
 		rcu_barrier();
-		mt_dump(mt);
+		mt_dump(mt, mt_dump_dec);
 		pr_info(" %s test of 0-%lu %luK in %d active (%d total)\n",
 			__func__, max, mt_get_alloc_size()/1024, mt_nr_allocated(),
 			mt_nr_tallocated());
@@ -248,7 +248,7 @@ static noinline void check_seq(struct ma
 #ifndef __KERNEL__
 	if (verbose) {
 		rcu_barrier();
-		mt_dump(mt);
+		mt_dump(mt, mt_dump_dec);
 		pr_info(" seq test of 0-%lu %luK in %d active (%d total)\n",
 			max, mt_get_alloc_size()/1024, mt_nr_allocated(),
 			mt_nr_tallocated());
@@ -893,7 +893,7 @@ static noinline void check_alloc_range(s
 #if DEBUG_ALLOC_RANGE
 		pr_debug("\tInsert %lu-%lu\n", range[i] >> 12,
 			 (range[i + 1] >> 12) - 1);
-		mt_dump(mt);
+		mt_dump(mt, mt_dump_hex);
 #endif
 		check_insert_range(mt, range[i] >> 12, (range[i + 1] >> 12) - 1,
 				xa_mk_value(range[i] >> 12), 0);
@@ -934,7 +934,7 @@ static noinline void check_alloc_range(s
 				xa_mk_value(req_range[i] >> 12)); /* pointer */
 		mt_validate(mt);
 #if DEBUG_ALLOC_RANGE
-		mt_dump(mt);
+		mt_dump(mt, mt_dump_hex);
 #endif
 	}
 
@@ -1572,7 +1572,7 @@ static noinline void check_node_overwrit
 		mtree_test_store_range(mt, i*100, i*100 + 50, xa_mk_value(i*100));
 
 	mtree_test_store_range(mt, 319951, 367950, NULL);
-	/*mt_dump(mt); */
+	/*mt_dump(mt, mt_dump_dec); */
 	mt_validate(mt);
 }
 
--- a/mm/internal.h~maple_tree-add-format-option-to-mt_dump
+++ a/mm/internal.h
@@ -1051,13 +1051,13 @@ static inline void vma_iter_store(struct
 		printk("%lu > %lu\n", vmi->mas.index, vma->vm_start);
 		printk("store of vma %lu-%lu", vma->vm_start, vma->vm_end);
 		printk("into slot    %lu-%lu", vmi->mas.index, vmi->mas.last);
-		mt_dump(vmi->mas.tree);
+		mt_dump(vmi->mas.tree, mt_dump_hex);
 	}
 	if (WARN_ON(vmi->mas.node != MAS_START && vmi->mas.last <  vma->vm_start)) {
 		printk("%lu < %lu\n", vmi->mas.last, vma->vm_start);
 		printk("store of vma %lu-%lu", vma->vm_start, vma->vm_end);
 		printk("into slot    %lu-%lu", vmi->mas.index, vmi->mas.last);
-		mt_dump(vmi->mas.tree);
+		mt_dump(vmi->mas.tree, mt_dump_hex);
 	}
 #endif
 
--- a/mm/mmap.c~maple_tree-add-format-option-to-mt_dump
+++ a/mm/mmap.c
@@ -301,7 +301,7 @@ out:
 
 #if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
 extern void mt_validate(struct maple_tree *mt);
-extern void mt_dump(const struct maple_tree *mt);
+extern void mt_dump(const struct maple_tree *mt, enum mt_dump_format fmt);
 
 /* Validate the maple tree */
 static void validate_mm_mt(struct mm_struct *mm)
@@ -323,18 +323,18 @@ static void validate_mm_mt(struct mm_str
 			pr_emerg("mt vma: %p %lu - %lu\n", vma_mt,
 				 vma_mt->vm_start, vma_mt->vm_end);
 
-			mt_dump(mas.tree);
+			mt_dump(mas.tree, mt_dump_hex);
 			if (vma_mt->vm_end != mas.last + 1) {
 				pr_err("vma: %p vma_mt %lu-%lu\tmt %lu-%lu\n",
 						mm, vma_mt->vm_start, vma_mt->vm_end,
 						mas.index, mas.last);
-				mt_dump(mas.tree);
+				mt_dump(mas.tree, mt_dump_hex);
 			}
 			VM_BUG_ON_MM(vma_mt->vm_end != mas.last + 1, mm);
 			if (vma_mt->vm_start != mas.index) {
 				pr_err("vma: %p vma_mt %p %lu - %lu doesn't match\n",
 						mm, vma_mt, vma_mt->vm_start, vma_mt->vm_end);
-				mt_dump(mas.tree);
+				mt_dump(mas.tree, mt_dump_hex);
 			}
 			VM_BUG_ON_MM(vma_mt->vm_start != mas.index, mm);
 		}
--- a/tools/testing/radix-tree/maple.c~maple_tree-add-format-option-to-mt_dump
+++ a/tools/testing/radix-tree/maple.c
@@ -1054,7 +1054,7 @@ static noinline void check_erase2_testse
 		if (entry_count)
 			MT_BUG_ON(mt, !mt_height(mt));
 #if check_erase2_debug > 1
-		mt_dump(mt);
+		mt_dump(mt, mt_dump_hex);
 #endif
 #if check_erase2_debug
 		pr_err("Done\n");
@@ -1085,7 +1085,7 @@ static noinline void check_erase2_testse
 		mas_for_each(&mas, foo, ULONG_MAX) {
 			if (xa_is_zero(foo)) {
 				if (addr == mas.index) {
-					mt_dump(mas.tree);
+					mt_dump(mas.tree, mt_dump_hex);
 					pr_err("retry failed %lu - %lu\n",
 						mas.index, mas.last);
 					MT_BUG_ON(mt, 1);
@@ -34513,7 +34513,7 @@ static void *rcu_reader_rev(void *ptr)
 			if (mas.index != r_start) {
 				alt = xa_mk_value(index + i * 2 + 1 +
 						  RCU_RANGE_COUNT);
-				mt_dump(test->mt);
+				mt_dump(test->mt, mt_dump_dec);
 				printk("Error: %lu-%lu %p != %lu-%lu %p %p line %d i %d\n",
 				       mas.index, mas.last, entry,
 				       r_start, r_end, expected, alt,
@@ -35784,10 +35784,10 @@ void farmer_tests(void)
 	struct maple_node *node;
 	DEFINE_MTREE(tree);
 
-	mt_dump(&tree);
+	mt_dump(&tree, mt_dump_dec);
 
 	tree.ma_root = xa_mk_value(0);
-	mt_dump(&tree);
+	mt_dump(&tree, mt_dump_dec);
 
 	node = mt_alloc_one(GFP_KERNEL);
 	node->parent = (void *)((unsigned long)(&tree) | 1);
@@ -35797,7 +35797,7 @@ void farmer_tests(void)
 	node->mr64.pivot[1] = 1;
 	node->mr64.pivot[2] = 0;
 	tree.ma_root = mt_mk_node(node, maple_leaf_64);
-	mt_dump(&tree);
+	mt_dump(&tree, mt_dump_dec);
 
 	node->parent = ma_parent_ptr(node);
 	ma_free_rcu(node);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-clean-up-mas_parent_enum-and-rename-to-mas_parent_type.patch
maple_tree-add-format-option-to-mt_dump.patch
maple_tree-convert-bug_on-to-mt_bug_on.patch
maple_tree-change-rcu-checks-to-warn_on-instead-of-bug_on.patch
maple_tree-convert-debug-code-to-use-mt_warn_on-and-mas_warn_on.patch

