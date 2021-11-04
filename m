Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37F8C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 01:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F6DB611C8
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 01:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbhKDBuU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Nov 2021 21:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231206AbhKDBuT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Nov 2021 21:50:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79DCB611C8;
        Thu,  4 Nov 2021 01:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635990462;
        bh=ZXDDGghFmuK1gH64CdcgvR8ca9CutpFSRQj9XewxWMs=;
        h=Date:From:To:Subject:From;
        b=aLpnEPFipH2TexXMV1SD6+uS9hs7SDxewmW1jB9sKjDvy2tmlIt5ouNVtkHuahuao
         I4BLO112RW05IqM5LgIxwrYA9Cn4n0xScuXRrdon/ov+LNMICuAqMfdqSKxoEdE/QP
         oacnevPd9UzaEUYG8v9qn5Jn68W2k/ffYbMfTU6s=
Date:   Wed, 03 Nov 2021 18:47:41 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-rejects.patch removed from -mm tree
Message-ID: <20211104014741.A-iiLlz6D%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/setup.c |    6 +--
 include/linux/migrate.h  |    6 +++
 include/linux/sched/mm.h |   28 +++++++-------
 kernel/exit.c            |   35 ------------------
 kernel/sched/core.c      |    6 ---
 lib/bootconfig.c         |   71 ++++++++++++++++++++++++++++++++-----
 6 files changed, 84 insertions(+), 68 deletions(-)

--- a/arch/s390/kernel/setup.c~linux-next-rejects
+++ a/arch/s390/kernel/setup.c
@@ -879,14 +879,12 @@ static void __init setup_randomness(void
 {
 	struct sysinfo_3_2_2 *vmms;
 
-	vmms = (struct sysinfo_3_2_2 *) memblock_phys_alloc(PAGE_SIZE,
-							    PAGE_SIZE);
+	vmms = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
 	if (!vmms)
 		panic("Failed to allocate memory for sysinfo structure\n");
-
 	if (stsi(vmms, 3, 2, 2) == 0 && vmms->count)
 		add_device_randomness(&vmms->vm, sizeof(vmms->vm[0]) * vmms->count);
-	memblock_phys_free((unsigned long)vmms, PAGE_SIZE);
+	memblock_free_ptr(vmms, PAGE_SIZE);
 }
 
 /*
--- a/include/linux/migrate.h~linux-next-rejects
+++ a/include/linux/migrate.h
@@ -42,6 +42,12 @@ extern int migrate_page_move_mapping(str
 		struct page *newpage, struct page *page, int extra_count);
 
 extern bool numa_demotion_enabled;
+
+void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
+void folio_migrate_copy(struct folio *newfolio, struct folio *folio);
+int folio_migrate_mapping(struct address_space *mapping,
+		struct folio *newfolio, struct folio *folio, int extra_count);
+
 #else
 
 static inline void putback_movable_pages(struct list_head *l) {}
--- a/include/linux/sched/mm.h~linux-next-rejects
+++ a/include/linux/sched/mm.h
@@ -56,20 +56,6 @@ static inline void mmgrab_lazy_tlb(struc
 		mmgrab(mm);
 }
 
-static inline void mmdrop_lazy_tlb(struct mm_struct *mm)
-{
-	if (IS_ENABLED(CONFIG_MMU_LAZY_TLB_REFCOUNT)) {
-		mmdrop(mm);
-	} else {
-		/*
-		 * mmdrop_lazy_tlb must provide a full memory barrier, see the
-		 * membarrier comment in finish_task_switch which relies on
-		 * this.
-		 */
-		smp_mb();
-	}
-}
-
 #ifdef CONFIG_PREEMPT_RT
 /*
  * RCU callback for delayed mm drop. Not strictly RCU, but call_rcu() is
@@ -99,6 +85,20 @@ static inline void mmdrop_sched(struct m
 }
 #endif
 
+static inline void mmdrop_lazy_tlb(struct mm_struct *mm)
+{
+	if (IS_ENABLED(CONFIG_MMU_LAZY_TLB_REFCOUNT)) {
+		mmdrop_sched(mm);
+	} else {
+		/*
+		 * mmdrop_lazy_tlb must provide a full memory barrier, see the
+		 * membarrier comment in finish_task_switch which relies on
+		 * this.
+		 */
+		smp_mb();
+	}
+}
+
 /**
  * mmget() - Pin the address space associated with a &struct mm_struct.
  * @mm: The address space to pin.
--- a/kernel/exit.c~linux-next-rejects
+++ a/kernel/exit.c
@@ -475,47 +475,12 @@ assign_new_owner:
 static void exit_mm(void)
 {
 	struct mm_struct *mm = current->mm;
-	struct core_state *core_state;
 
 	exit_mm_release(current, mm);
 	if (!mm)
 		return;
 	sync_mm_rss(mm);
-	/*
-	 * Serialize with any possible pending coredump.
-	 * We must hold mmap_lock around checking core_state
-	 * and clearing tsk->mm.  The core-inducing thread
-	 * will increment ->nr_threads for each thread in the
-	 * group with ->mm != NULL.
-	 */
 	mmap_read_lock(mm);
-	core_state = mm->core_state;
-	if (core_state) {
-		struct core_thread self;
-
-		mmap_read_unlock(mm);
-
-		self.task = current;
-		if (self.task->flags & PF_SIGNALED)
-			self.next = xchg(&core_state->dumper.next, &self);
-		else
-			self.task = NULL;
-		/*
-		 * Implies mb(), the result of xchg() must be visible
-		 * to core_state->dumper.
-		 */
-		if (atomic_dec_and_test(&core_state->nr_threads))
-			complete(&core_state->startup);
-
-		for (;;) {
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			if (!self.task) /* see coredump_finish() */
-				break;
-			freezable_schedule();
-		}
-		__set_current_state(TASK_RUNNING);
-		mmap_read_lock(mm);
-	}
 	mmgrab_lazy_tlb(mm);
 	BUG_ON(mm != current->active_mm);
 	/* more a memory barrier than a real lock */
--- a/kernel/sched/core.c~linux-next-rejects
+++ a/kernel/sched/core.c
@@ -4881,12 +4881,6 @@ static struct rq *finish_task_switch(str
 		if (prev->sched_class->task_dead)
 			prev->sched_class->task_dead(prev);
 
-		/*
-		 * Remove function-return probe instances associated with this
-		 * task and put them back on the free list.
-		 */
-		kprobe_flush_task(prev);
-
 		/* Task is done with its stack. */
 		put_task_stack(prev);
 
--- a/lib/bootconfig.c~linux-next-rejects
+++ a/lib/bootconfig.c
@@ -832,41 +832,94 @@ static int __init xbc_verify_tree(void)
 	return 0;
 }
 
+/* Need to setup xbc_data and xbc_nodes before call this. */
+static int __init xbc_parse_tree(void)
+{
+	char *p, *q;
+	int ret, c;
+
+	last_parent = NULL;
+	p = xbc_data;
+	do {
+		q = strpbrk(p, "{}=+;:\n#");
+		if (!q) {
+			p = skip_spaces(p);
+			if (*p != '\0')
+				ret = xbc_parse_error("No delimiter", p);
+			break;
+		}
+
+		c = *q;
+		*q++ = '\0';
+		switch (c) {
+		case ':':
+		case '+':
+			if (*q++ != '=') {
+				ret = xbc_parse_error(c == '+' ?
+						"Wrong '+' operator" :
+						"Wrong ':' operator",
+							q - 2);
+				break;
+			}
+			fallthrough;
+		case '=':
+			ret = xbc_parse_kv(&p, q, c);
+			break;
+		case '{':
+			ret = xbc_open_brace(&p, q);
+			break;
+		case '#':
+			q = skip_comment(q);
+			fallthrough;
+		case ';':
+		case '\n':
+			ret = xbc_parse_key(&p, q);
+			break;
+		case '}':
+			ret = xbc_close_brace(&p, q);
+			break;
+		}
+	} while (!ret);
+
+	return ret;
+}
+
 /**
- * xbc_destroy_all() - Clean up all parsed bootconfig
+ * xbc_exit() - Clean up all parsed bootconfig
  *
  * This clears all data structures of parsed bootconfig on memory.
  * If you need to reuse xbc_init() with new boot config, you can
  * use this.
  */
-void __init xbc_destroy_all(void)
+void __init xbc_exit(void)
 {
+	xbc_free_mem(xbc_data, xbc_data_size);
 	xbc_data = NULL;
 	xbc_data_size = 0;
 	xbc_node_num = 0;
-	memblock_free(xbc_nodes, sizeof(struct xbc_node) * XBC_NODE_MAX);
+	xbc_free_mem(xbc_nodes, sizeof(struct xbc_node) * XBC_NODE_MAX);
 	xbc_nodes = NULL;
 	brace_index = 0;
 }
 
 /**
  * xbc_init() - Parse given XBC file and build XBC internal tree
- * @buf: boot config text
+ * @data: The boot config text original data
+ * @size: The size of @data
  * @emsg: A pointer of const char * to store the error message
  * @epos: A pointer of int to store the error position
  *
- * This parses the boot config text in @buf. @buf must be a
- * null terminated string and smaller than XBC_DATA_MAX.
+ * This parses the boot config text in @data. @size must be smaller
+ * than XBC_DATA_MAX.
  * Return the number of stored nodes (>0) if succeeded, or -errno
  * if there is any error.
  * In error cases, @emsg will be updated with an error message and
  * @epos will be updated with the error position which is the byte offset
  * of @buf. If the error is not a parser error, @epos will be -1.
  */
-int __init xbc_init(char *buf, const char **emsg, int *epos)
+int __init xbc_init(const char *data, size_t size, const char **emsg, int *epos)
 {
-	char *p, *q;
-	int ret, c;
+	int ret;
 
 	if (epos)
 		*epos = -1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-move-kvmalloc-related-functions-to-slabh-fix.patch
mm-simplify-bdi-refcounting-fix-fix.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
delay-replace-kernelh-with-the-necessary-inclusions-fix.patch
generic-radix-tree-replace-kernelh-with-the-necessary-inclusions-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
revert-acct_reclaim_writeback-for-next.patch
linux-next-rejects-fix.patch
linux-next-git-rejects.patch
restore-acct_reclaim_writeback-for-folio.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

