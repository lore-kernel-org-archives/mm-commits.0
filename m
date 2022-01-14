Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC608C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiANWGk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiANWGk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:06:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4B5C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:06:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BA1462010
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24B7C36AE5;
        Fri, 14 Jan 2022 22:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197998;
        bh=QwuADMFxF9o4TXIv4wv/hsiVlOtlt58FZqXgCMff+ds=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qO6s/llrkLbjFM4vMcrJJSaWKx9HpBl965VAGU1PbyX24mROJ9MUGJqnJuuf/tT/C
         SZDW+HvjvQS2Nt6ItVBdWTwbmXS0wGdlVgu1yFg7yVvOlMxkNs5rGbYi8lEyTcd8nl
         E7ohGENeNg9cs60YRXW0ukeDCkylEthJCNx5jD5E=
Date:   Fri, 14 Jan 2022 14:06:37 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        corbet@lwn.net, dave.hansen@linux.intel.com, frederic@kernel.org,
        gthelen@google.com, hpa@zytor.com, hughd@google.com,
        jirislaby@kernel.org, keescook@chromium.org, linux-mm@kvack.org,
        masahiroy@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, peterz@infradead.org, pjt@google.com,
        rientjes@google.com, rppt@kernel.org, samitolvanen@google.com,
        songmuchun@bytedance.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, weixugc@google.com, will@kernel.org
Subject:  [patch 067/146] mm: page table check
Message-ID: <20220114220637.fzWDGOzsB%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm: page table check

Check user page table entries at the time they are added and removed.

Allows to synchronously catch memory corruption issues related to double
mapping.

When a pte for an anonymous page is added into page table, we verify that
this pte does not already point to a file backed page, and vice versa if
this is a file backed page that is being added we verify that this page
does not have an anonymous mapping

We also enforce that read-only sharing for anonymous pages is allowed
(i.e.  cow after fork).  All other sharing must be for file pages.

Page table check allows to protect and debug cases where "struct page"
metadata became corrupted for some reason.  For example, when refcnt or
mapcount become invalid.

Link: https://lkml.kernel.org/r/20211221154650.1047963-4-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/index.rst            |    1 
 Documentation/vm/page_table_check.rst |   56 ++++
 MAINTAINERS                           |    9 
 arch/Kconfig                          |    3 
 include/linux/page_table_check.h      |  147 +++++++++++++
 mm/Kconfig.debug                      |   24 ++
 mm/Makefile                           |    1 
 mm/page_alloc.c                       |    4 
 mm/page_ext.c                         |    4 
 mm/page_table_check.c                 |  270 ++++++++++++++++++++++++
 10 files changed, 519 insertions(+)

--- a/arch/Kconfig~mm-page-table-check
+++ a/arch/Kconfig
@@ -1297,6 +1297,9 @@ config HAVE_ARCH_PFN_VALID
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	bool
 
+config ARCH_SUPPORTS_PAGE_TABLE_CHECK
+	bool
+
 config ARCH_SPLIT_ARG64
 	bool
 	help
--- a/Documentation/vm/index.rst~mm-page-table-check
+++ a/Documentation/vm/index.rst
@@ -31,6 +31,7 @@ algorithms.  If you are looking for advi
    page_migration
    page_frags
    page_owner
+   page_table_check
    remap_file_pages
    slub
    split_page_table_lock
--- /dev/null
+++ a/Documentation/vm/page_table_check.rst
@@ -0,0 +1,56 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+.. _page_table_check:
+
+================
+Page Table Check
+================
+
+Introduction
+============
+
+Page table check allows to hardern the kernel by ensuring that some types of
+the memory corruptions are prevented.
+
+Page table check performs extra verifications at the time when new pages become
+accessible from the userspace by getting their page table entries (PTEs PMDs
+etc.) added into the table.
+
+In case of detected corruption, the kernel is crashed. There is a small
+performance and memory overhead associated with the page table check. Therefore,
+it is disabled by default, but can be optionally enabled on systems where the
+extra hardening outweighs the performance costs. Also, because page table check
+is synchronous, it can help with debugging double map memory corruption issues,
+by crashing kernel at the time wrong mapping occurs instead of later which is
+often the case with memory corruptions bugs.
+
+Double mapping detection logic
+==============================
+
++-------------------+-------------------+-------------------+------------------+
+| Current Mapping   | New mapping       | Permissions       | Rule             |
++===================+===================+===================+==================+
+| Anonymous         | Anonymous         | Read              | Allow            |
++-------------------+-------------------+-------------------+------------------+
+| Anonymous         | Anonymous         | Read / Write      | Prohibit         |
++-------------------+-------------------+-------------------+------------------+
+| Anonymous         | Named             | Any               | Prohibit         |
++-------------------+-------------------+-------------------+------------------+
+| Named             | Anonymous         | Any               | Prohibit         |
++-------------------+-------------------+-------------------+------------------+
+| Named             | Named             | Any               | Allow            |
++-------------------+-------------------+-------------------+------------------+
+
+Enabling Page Table Check
+=========================
+
+Build kernel with:
+
+- PAGE_TABLE_CHECK=y
+  Note, it can only be enabled on platforms where ARCH_SUPPORTS_PAGE_TABLE_CHECK
+  is available.
+
+- Boot with 'page_table_check=on' kernel parameter.
+
+Optionally, build kernel with PAGE_TABLE_CHECK_ENFORCED in order to have page
+table support without extra kernel parameter.
--- /dev/null
+++ a/include/linux/page_table_check.h
@@ -0,0 +1,147 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2021, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#ifndef __LINUX_PAGE_TABLE_CHECK_H
+#define __LINUX_PAGE_TABLE_CHECK_H
+
+#ifdef CONFIG_PAGE_TABLE_CHECK
+#include <linux/jump_label.h>
+
+extern struct static_key_true page_table_check_disabled;
+extern struct page_ext_operations page_table_check_ops;
+
+void __page_table_check_zero(struct page *page, unsigned int order);
+void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
+				  pte_t pte);
+void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
+				  pmd_t pmd);
+void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
+				  pud_t pud);
+void __page_table_check_pte_set(struct mm_struct *mm, unsigned long addr,
+				pte_t *ptep, pte_t pte);
+void __page_table_check_pmd_set(struct mm_struct *mm, unsigned long addr,
+				pmd_t *pmdp, pmd_t pmd);
+void __page_table_check_pud_set(struct mm_struct *mm, unsigned long addr,
+				pud_t *pudp, pud_t pud);
+
+static inline void page_table_check_alloc(struct page *page, unsigned int order)
+{
+	if (static_branch_likely(&page_table_check_disabled))
+		return;
+
+	__page_table_check_zero(page, order);
+}
+
+static inline void page_table_check_free(struct page *page, unsigned int order)
+{
+	if (static_branch_likely(&page_table_check_disabled))
+		return;
+
+	__page_table_check_zero(page, order);
+}
+
+static inline void page_table_check_pte_clear(struct mm_struct *mm,
+					      unsigned long addr, pte_t pte)
+{
+	if (static_branch_likely(&page_table_check_disabled))
+		return;
+
+	__page_table_check_pte_clear(mm, addr, pte);
+}
+
+static inline void page_table_check_pmd_clear(struct mm_struct *mm,
+					      unsigned long addr, pmd_t pmd)
+{
+	if (static_branch_likely(&page_table_check_disabled))
+		return;
+
+	__page_table_check_pmd_clear(mm, addr, pmd);
+}
+
+static inline void page_table_check_pud_clear(struct mm_struct *mm,
+					      unsigned long addr, pud_t pud)
+{
+	if (static_branch_likely(&page_table_check_disabled))
+		return;
+
+	__page_table_check_pud_clear(mm, addr, pud);
+}
+
+static inline void page_table_check_pte_set(struct mm_struct *mm,
+					    unsigned long addr, pte_t *ptep,
+					    pte_t pte)
+{
+	if (static_branch_likely(&page_table_check_disabled))
+		return;
+
+	__page_table_check_pte_set(mm, addr, ptep, pte);
+}
+
+static inline void page_table_check_pmd_set(struct mm_struct *mm,
+					    unsigned long addr, pmd_t *pmdp,
+					    pmd_t pmd)
+{
+	if (static_branch_likely(&page_table_check_disabled))
+		return;
+
+	__page_table_check_pmd_set(mm, addr, pmdp, pmd);
+}
+
+static inline void page_table_check_pud_set(struct mm_struct *mm,
+					    unsigned long addr, pud_t *pudp,
+					    pud_t pud)
+{
+	if (static_branch_likely(&page_table_check_disabled))
+		return;
+
+	__page_table_check_pud_set(mm, addr, pudp, pud);
+}
+
+#else
+
+static inline void page_table_check_alloc(struct page *page, unsigned int order)
+{
+}
+
+static inline void page_table_check_free(struct page *page, unsigned int order)
+{
+}
+
+static inline void page_table_check_pte_clear(struct mm_struct *mm,
+					      unsigned long addr, pte_t pte)
+{
+}
+
+static inline void page_table_check_pmd_clear(struct mm_struct *mm,
+					      unsigned long addr, pmd_t pmd)
+{
+}
+
+static inline void page_table_check_pud_clear(struct mm_struct *mm,
+					      unsigned long addr, pud_t pud)
+{
+}
+
+static inline void page_table_check_pte_set(struct mm_struct *mm,
+					    unsigned long addr, pte_t *ptep,
+					    pte_t pte)
+{
+}
+
+static inline void page_table_check_pmd_set(struct mm_struct *mm,
+					    unsigned long addr, pmd_t *pmdp,
+					    pmd_t pmd)
+{
+}
+
+static inline void page_table_check_pud_set(struct mm_struct *mm,
+					    unsigned long addr, pud_t *pudp,
+					    pud_t pud)
+{
+}
+
+#endif /* CONFIG_PAGE_TABLE_CHECK */
+#endif /* __LINUX_PAGE_TABLE_CHECK_H */
--- a/MAINTAINERS~mm-page-table-check
+++ a/MAINTAINERS
@@ -14387,6 +14387,15 @@ F:	include/net/page_pool.h
 F:	include/trace/events/page_pool.h
 F:	net/core/page_pool.c
 
+PAGE TABLE CHECK
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+M:	Andrew Morton <akpm@linux-foundation.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	Documentation/vm/page_table_check.rst
+F:	include/linux/page_table_check.h
+F:	mm/page_table_check.c
+
 PANASONIC LAPTOP ACPI EXTRAS DRIVER
 M:	Kenneth Chan <kenneth.t.chan@gmail.com>
 L:	platform-driver-x86@vger.kernel.org
--- a/mm/Kconfig.debug~mm-page-table-check
+++ a/mm/Kconfig.debug
@@ -62,6 +62,30 @@ config PAGE_OWNER
 
 	  If unsure, say N.
 
+config PAGE_TABLE_CHECK
+	bool "Check for invalid mappings in user page tables"
+	depends on ARCH_SUPPORTS_PAGE_TABLE_CHECK
+	select PAGE_EXTENSION
+	help
+	  Check that anonymous page is not being mapped twice with read write
+	  permissions. Check that anonymous and file pages are not being
+	  erroneously shared. Since the checking is performed at the time
+	  entries are added and removed to user page tables, leaking, corruption
+	  and double mapping problems are detected synchronously.
+
+	  If unsure say "n".
+
+config PAGE_TABLE_CHECK_ENFORCED
+	bool "Enforce the page table checking by default"
+	depends on PAGE_TABLE_CHECK
+	help
+	  Always enable page table checking.  By default the page table checking
+	  is disabled, and can be optionally enabled via page_table_check=on
+	  kernel parameter. This config enforces that page table check is always
+	  enabled.
+
+	  If unsure say "n".
+
 config PAGE_POISONING
 	bool "Poison pages after freeing"
 	help
--- a/mm/Makefile~mm-page-table-check
+++ a/mm/Makefile
@@ -112,6 +112,7 @@ obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += e
 obj-$(CONFIG_CMA)	+= cma.o
 obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
+obj-$(CONFIG_PAGE_TABLE_CHECK) += page_table_check.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
 obj-$(CONFIG_SECRETMEM) += secretmem.o
 obj-$(CONFIG_CMA_SYSFS) += cma_sysfs.o
--- a/mm/page_alloc.c~mm-page-table-check
+++ a/mm/page_alloc.c
@@ -63,6 +63,7 @@
 #include <linux/sched/rt.h>
 #include <linux/sched/mm.h>
 #include <linux/page_owner.h>
+#include <linux/page_table_check.h>
 #include <linux/kthread.h>
 #include <linux/memcontrol.h>
 #include <linux/ftrace.h>
@@ -1307,6 +1308,7 @@ static __always_inline bool free_pages_p
 		if (memcg_kmem_enabled() && PageMemcgKmem(page))
 			__memcg_kmem_uncharge_page(page, order);
 		reset_page_owner(page, order);
+		page_table_check_free(page, order);
 		return false;
 	}
 
@@ -1346,6 +1348,7 @@ static __always_inline bool free_pages_p
 	page_cpupid_reset_last(page);
 	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	reset_page_owner(page, order);
+	page_table_check_free(page, order);
 
 	if (!PageHighMem(page)) {
 		debug_check_no_locks_freed(page_address(page),
@@ -2420,6 +2423,7 @@ inline void post_alloc_hook(struct page
 	}
 
 	set_page_owner(page, order, gfp_flags);
+	page_table_check_alloc(page, order);
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
--- a/mm/page_ext.c~mm-page-table-check
+++ a/mm/page_ext.c
@@ -8,6 +8,7 @@
 #include <linux/kmemleak.h>
 #include <linux/page_owner.h>
 #include <linux/page_idle.h>
+#include <linux/page_table_check.h>
 
 /*
  * struct page extension
@@ -75,6 +76,9 @@ static struct page_ext_operations *page_
 #if defined(CONFIG_PAGE_IDLE_FLAG) && !defined(CONFIG_64BIT)
 	&page_idle_ops,
 #endif
+#ifdef CONFIG_PAGE_TABLE_CHECK
+	&page_table_check_ops,
+#endif
 };
 
 unsigned long page_ext_size = sizeof(struct page_ext);
--- /dev/null
+++ a/mm/page_table_check.c
@@ -0,0 +1,270 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2021, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#include <linux/mm.h>
+#include <linux/page_table_check.h>
+
+#undef pr_fmt
+#define pr_fmt(fmt)	"page_table_check: " fmt
+
+struct page_table_check {
+	atomic_t anon_map_count;
+	atomic_t file_map_count;
+};
+
+static bool __page_table_check_enabled __initdata =
+				IS_ENABLED(CONFIG_PAGE_TABLE_CHECK_ENFORCED);
+
+DEFINE_STATIC_KEY_TRUE(page_table_check_disabled);
+EXPORT_SYMBOL(page_table_check_disabled);
+
+static int __init early_page_table_check_param(char *buf)
+{
+	if (!buf)
+		return -EINVAL;
+
+	if (strcmp(buf, "on") == 0)
+		__page_table_check_enabled = true;
+	else if (strcmp(buf, "off") == 0)
+		__page_table_check_enabled = false;
+
+	return 0;
+}
+
+early_param("page_table_check", early_page_table_check_param);
+
+static bool __init need_page_table_check(void)
+{
+	return __page_table_check_enabled;
+}
+
+static void __init init_page_table_check(void)
+{
+	if (!__page_table_check_enabled)
+		return;
+	static_branch_disable(&page_table_check_disabled);
+}
+
+struct page_ext_operations page_table_check_ops = {
+	.size = sizeof(struct page_table_check),
+	.need = need_page_table_check,
+	.init = init_page_table_check,
+};
+
+static struct page_table_check *get_page_table_check(struct page_ext *page_ext)
+{
+	BUG_ON(!page_ext);
+	return (void *)(page_ext) + page_table_check_ops.offset;
+}
+
+static inline bool pte_user_accessible_page(pte_t pte)
+{
+	return (pte_val(pte) & _PAGE_PRESENT) && (pte_val(pte) & _PAGE_USER);
+}
+
+static inline bool pmd_user_accessible_page(pmd_t pmd)
+{
+	return pmd_leaf(pmd) && (pmd_val(pmd) & _PAGE_PRESENT) &&
+		(pmd_val(pmd) & _PAGE_USER);
+}
+
+static inline bool pud_user_accessible_page(pud_t pud)
+{
+	return pud_leaf(pud) && (pud_val(pud) & _PAGE_PRESENT) &&
+		(pud_val(pud) & _PAGE_USER);
+}
+
+/*
+ * An enty is removed from the page table, decrement the counters for that page
+ * verify that it is of correct type and counters do not become negative.
+ */
+static void page_table_check_clear(struct mm_struct *mm, unsigned long addr,
+				   unsigned long pfn, unsigned long pgcnt)
+{
+	struct page_ext *page_ext;
+	struct page *page;
+	bool anon;
+	int i;
+
+	if (!pfn_valid(pfn))
+		return;
+
+	page = pfn_to_page(pfn);
+	page_ext = lookup_page_ext(page);
+	anon = PageAnon(page);
+
+	for (i = 0; i < pgcnt; i++) {
+		struct page_table_check *ptc = get_page_table_check(page_ext);
+
+		if (anon) {
+			BUG_ON(atomic_read(&ptc->file_map_count));
+			BUG_ON(atomic_dec_return(&ptc->anon_map_count) < 0);
+		} else {
+			BUG_ON(atomic_read(&ptc->anon_map_count));
+			BUG_ON(atomic_dec_return(&ptc->file_map_count) < 0);
+		}
+		page_ext = page_ext_next(page_ext);
+	}
+}
+
+/*
+ * A new enty is added to the page table, increment the counters for that page
+ * verify that it is of correct type and is not being mapped with a different
+ * type to a different process.
+ */
+static void page_table_check_set(struct mm_struct *mm, unsigned long addr,
+				 unsigned long pfn, unsigned long pgcnt,
+				 bool rw)
+{
+	struct page_ext *page_ext;
+	struct page *page;
+	bool anon;
+	int i;
+
+	if (!pfn_valid(pfn))
+		return;
+
+	page = pfn_to_page(pfn);
+	page_ext = lookup_page_ext(page);
+	anon = PageAnon(page);
+
+	for (i = 0; i < pgcnt; i++) {
+		struct page_table_check *ptc = get_page_table_check(page_ext);
+
+		if (anon) {
+			BUG_ON(atomic_read(&ptc->file_map_count));
+			BUG_ON(atomic_inc_return(&ptc->anon_map_count) > 1 && rw);
+		} else {
+			BUG_ON(atomic_read(&ptc->anon_map_count));
+			BUG_ON(atomic_inc_return(&ptc->file_map_count) < 0);
+		}
+		page_ext = page_ext_next(page_ext);
+	}
+}
+
+/*
+ * page is on free list, or is being allocated, verify that counters are zeroes
+ * crash if they are not.
+ */
+void __page_table_check_zero(struct page *page, unsigned int order)
+{
+	struct page_ext *page_ext = lookup_page_ext(page);
+	int i;
+
+	BUG_ON(!page_ext);
+	for (i = 0; i < (1 << order); i++) {
+		struct page_table_check *ptc = get_page_table_check(page_ext);
+
+		BUG_ON(atomic_read(&ptc->anon_map_count));
+		BUG_ON(atomic_read(&ptc->file_map_count));
+		page_ext = page_ext_next(page_ext);
+	}
+}
+
+void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
+				  pte_t pte)
+{
+	if (&init_mm == mm)
+		return;
+
+	if (pte_user_accessible_page(pte)) {
+		page_table_check_clear(mm, addr, pte_pfn(pte),
+				       PAGE_SIZE >> PAGE_SHIFT);
+	}
+}
+EXPORT_SYMBOL(__page_table_check_pte_clear);
+
+void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
+				  pmd_t pmd)
+{
+	if (&init_mm == mm)
+		return;
+
+	if (pmd_user_accessible_page(pmd)) {
+		page_table_check_clear(mm, addr, pmd_pfn(pmd),
+				       PMD_PAGE_SIZE >> PAGE_SHIFT);
+	}
+}
+EXPORT_SYMBOL(__page_table_check_pmd_clear);
+
+void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
+				  pud_t pud)
+{
+	if (&init_mm == mm)
+		return;
+
+	if (pud_user_accessible_page(pud)) {
+		page_table_check_clear(mm, addr, pud_pfn(pud),
+				       PUD_PAGE_SIZE >> PAGE_SHIFT);
+	}
+}
+EXPORT_SYMBOL(__page_table_check_pud_clear);
+
+void __page_table_check_pte_set(struct mm_struct *mm, unsigned long addr,
+				pte_t *ptep, pte_t pte)
+{
+	pte_t old_pte;
+
+	if (&init_mm == mm)
+		return;
+
+	old_pte = *ptep;
+	if (pte_user_accessible_page(old_pte)) {
+		page_table_check_clear(mm, addr, pte_pfn(old_pte),
+				       PAGE_SIZE >> PAGE_SHIFT);
+	}
+
+	if (pte_user_accessible_page(pte)) {
+		page_table_check_set(mm, addr, pte_pfn(pte),
+				     PAGE_SIZE >> PAGE_SHIFT,
+				     pte_write(pte));
+	}
+}
+EXPORT_SYMBOL(__page_table_check_pte_set);
+
+void __page_table_check_pmd_set(struct mm_struct *mm, unsigned long addr,
+				pmd_t *pmdp, pmd_t pmd)
+{
+	pmd_t old_pmd;
+
+	if (&init_mm == mm)
+		return;
+
+	old_pmd = *pmdp;
+	if (pmd_user_accessible_page(old_pmd)) {
+		page_table_check_clear(mm, addr, pmd_pfn(old_pmd),
+				       PMD_PAGE_SIZE >> PAGE_SHIFT);
+	}
+
+	if (pmd_user_accessible_page(pmd)) {
+		page_table_check_set(mm, addr, pmd_pfn(pmd),
+				     PMD_PAGE_SIZE >> PAGE_SHIFT,
+				     pmd_write(pmd));
+	}
+}
+EXPORT_SYMBOL(__page_table_check_pmd_set);
+
+void __page_table_check_pud_set(struct mm_struct *mm, unsigned long addr,
+				pud_t *pudp, pud_t pud)
+{
+	pud_t old_pud;
+
+	if (&init_mm == mm)
+		return;
+
+	old_pud = *pudp;
+	if (pud_user_accessible_page(old_pud)) {
+		page_table_check_clear(mm, addr, pud_pfn(old_pud),
+				       PUD_PAGE_SIZE >> PAGE_SHIFT);
+	}
+
+	if (pud_user_accessible_page(pud)) {
+		page_table_check_set(mm, addr, pud_pfn(pud),
+				     PUD_PAGE_SIZE >> PAGE_SHIFT,
+				     pud_write(pud));
+	}
+}
+EXPORT_SYMBOL(__page_table_check_pud_set);
_
