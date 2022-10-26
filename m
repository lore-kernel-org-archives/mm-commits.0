Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97DDDECDFA1
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 03:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbiJZD13 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Oct 2022 23:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbiJZD1S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2022 23:27:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7287E01E
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 20:27:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B171B81EED
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 03:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBC0C433B5;
        Wed, 26 Oct 2022 03:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666754818;
        bh=gV1xJUfVUn0KKlCd7Aqx8WMNXB+0ap/9V7GFBXVyXP8=;
        h=Date:To:From:Subject:From;
        b=Ky3JvJ9BhsOULnTy1l/WsQINGXJf2c+Fuo+RZpO0wi8KdqsPN8Xw8qCzVxgIYx6uI
         R45IZy0A3+BTysT/C++hUsnRD0uH7aiolxXkhYX/SHGkhPzO6YjklVznUlNCfIdpqh
         X7we9ID8JRmdgeQI7T6OTLLgebCh6HF1En6D/otc=
Date:   Tue, 25 Oct 2022 20:26:56 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-mms-rss-stats-into-percpu_counter.patch added to mm-unstable branch
Message-Id: <20221026032657.CEBC0C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert mm's rss stats into percpu_counter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-mms-rss-stats-into-percpu_counter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-mms-rss-stats-into-percpu_counter.patch

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
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: convert mm's rss stats into percpu_counter
Date: Mon, 24 Oct 2022 05:28:41 +0000

Currently mm_struct maintains rss_stats which are updated on page fault
and the unmapping codepaths.  For page fault codepath the updates are
cached per thread with the batch of TASK_RSS_EVENTS_THRESH which is 64. 
The reason for caching is performance for multithreaded applications
otherwise the rss_stats updates may become hotspot for such applications.

However this optimization comes with the cost of error margin in the rss
stats.  The rss_stats for applications with large number of threads can be
very skewed.  At worst the error margin is (nr_threads * 64) and we have a
lot of applications with 100s of threads, so the error margin can be very
high.  Internally we had to reduce TASK_RSS_EVENTS_THRESH to 32.

Recently we started seeing the unbounded errors for rss_stats for specific
applications which use TCP rx0cp.  It seems like vm_insert_pages()
codepath does not sync rss_stats at all.

This patch converts the rss_stats into percpu_counter to convert the error
margin from (nr_threads * 64) to approximately (nr_cpus ^ 2).  However
this conversion enable us to get the accurate stats for situations where
accuracy is more important than the cpu cost.

This patch does not make such tradeoffs - we can just use
percpu_counter_add_local() for the updates and percpu_counter_sum() (or
percpu_counter_sync() + percpu_counter_read) for the readers.  At the
moment the readers are either procfs interface, oom_killer and memory
reclaim which I think are not performance critical and should be ok with
slow read.  However I think we can make that change in a separate patch.

Link: https://lkml.kernel.org/r/20221024052841.3291983-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-convert-mms-rss-stats-into-percpu_counter
+++ a/include/linux/mm.h
@@ -2001,40 +2001,30 @@ static inline bool get_user_page_fast_on
  */
 static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
 {
-	long val = atomic_long_read(&mm->rss_stat.count[member]);
-
-#ifdef SPLIT_RSS_COUNTING
-	/*
-	 * counter is updated in asynchronous manner and may go to minus.
-	 * But it's never be expected number for users.
-	 */
-	if (val < 0)
-		val = 0;
-#endif
-	return (unsigned long)val;
+	return percpu_counter_read_positive(&mm->rss_stat[member]);
 }
 
-void mm_trace_rss_stat(struct mm_struct *mm, int member, long count);
+void mm_trace_rss_stat(struct mm_struct *mm, int member);
 
 static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
 {
-	long count = atomic_long_add_return(value, &mm->rss_stat.count[member]);
+	percpu_counter_add(&mm->rss_stat[member], value);
 
-	mm_trace_rss_stat(mm, member, count);
+	mm_trace_rss_stat(mm, member);
 }
 
 static inline void inc_mm_counter(struct mm_struct *mm, int member)
 {
-	long count = atomic_long_inc_return(&mm->rss_stat.count[member]);
+	percpu_counter_inc(&mm->rss_stat[member]);
 
-	mm_trace_rss_stat(mm, member, count);
+	mm_trace_rss_stat(mm, member);
 }
 
 static inline void dec_mm_counter(struct mm_struct *mm, int member)
 {
-	long count = atomic_long_dec_return(&mm->rss_stat.count[member]);
+	percpu_counter_dec(&mm->rss_stat[member]);
 
-	mm_trace_rss_stat(mm, member, count);
+	mm_trace_rss_stat(mm, member);
 }
 
 /* Optimized variant when page is already known not to be PageAnon */
--- a/include/linux/mm_types.h~mm-convert-mms-rss-stats-into-percpu_counter
+++ a/include/linux/mm_types.h
@@ -18,6 +18,7 @@
 #include <linux/page-flags-layout.h>
 #include <linux/workqueue.h>
 #include <linux/seqlock.h>
+#include <linux/percpu_counter.h>
 
 #include <asm/mmu.h>
 
@@ -626,11 +627,7 @@ struct mm_struct {
 
 		unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
 
-		/*
-		 * Special counters, in some configurations protected by the
-		 * page_table_lock, in other configurations by being atomic.
-		 */
-		struct mm_rss_stat rss_stat;
+		struct percpu_counter rss_stat[NR_MM_COUNTERS];
 
 		struct linux_binfmt *binfmt;
 
--- a/include/linux/mm_types_task.h~mm-convert-mms-rss-stats-into-percpu_counter
+++ a/include/linux/mm_types_task.h
@@ -36,19 +36,6 @@ enum {
 	NR_MM_COUNTERS
 };
 
-#if USE_SPLIT_PTE_PTLOCKS && defined(CONFIG_MMU)
-#define SPLIT_RSS_COUNTING
-/* per-thread cached information, */
-struct task_rss_stat {
-	int events;	/* for synchronization threshold */
-	int count[NR_MM_COUNTERS];
-};
-#endif /* USE_SPLIT_PTE_PTLOCKS */
-
-struct mm_rss_stat {
-	atomic_long_t count[NR_MM_COUNTERS];
-};
-
 struct page_frag {
 	struct page *page;
 #if (BITS_PER_LONG > 32) || (PAGE_SIZE >= 65536)
--- a/include/linux/percpu_counter.h~mm-convert-mms-rss-stats-into-percpu_counter
+++ a/include/linux/percpu_counter.h
@@ -13,7 +13,6 @@
 #include <linux/threads.h>
 #include <linux/percpu.h>
 #include <linux/types.h>
-#include <linux/gfp.h>
 
 /* percpu_counter batch for local add or sub */
 #define PERCPU_COUNTER_LOCAL_BATCH	INT_MAX
--- a/include/linux/sched.h~mm-convert-mms-rss-stats-into-percpu_counter
+++ a/include/linux/sched.h
@@ -870,9 +870,6 @@ struct task_struct {
 	struct mm_struct		*mm;
 	struct mm_struct		*active_mm;
 
-#ifdef SPLIT_RSS_COUNTING
-	struct task_rss_stat		rss_stat;
-#endif
 	int				exit_state;
 	int				exit_code;
 	int				exit_signal;
--- a/include/trace/events/kmem.h~mm-convert-mms-rss-stats-into-percpu_counter
+++ a/include/trace/events/kmem.h
@@ -346,10 +346,9 @@ TRACE_MM_PAGES
 TRACE_EVENT(rss_stat,
 
 	TP_PROTO(struct mm_struct *mm,
-		int member,
-		long count),
+		int member),
 
-	TP_ARGS(mm, member, count),
+	TP_ARGS(mm, member),
 
 	TP_STRUCT__entry(
 		__field(unsigned int, mm_id)
@@ -362,7 +361,8 @@ TRACE_EVENT(rss_stat,
 		__entry->mm_id = mm_ptr_to_hash(mm);
 		__entry->curr = !!(current->mm == mm);
 		__entry->member = member;
-		__entry->size = (count << PAGE_SHIFT);
+		__entry->size = (percpu_counter_sum_positive(&mm->rss_stat[member])
+							    << PAGE_SHIFT);
 	),
 
 	TP_printk("mm_id=%u curr=%d type=%s size=%ldB",
--- a/kernel/fork.c~mm-convert-mms-rss-stats-into-percpu_counter
+++ a/kernel/fork.c
@@ -753,7 +753,7 @@ static void check_mm(struct mm_struct *m
 			 "Please make sure 'struct resident_page_types[]' is updated as well");
 
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
-		long x = atomic_long_read(&mm->rss_stat.count[i]);
+		long x = percpu_counter_sum(&mm->rss_stat[i]);
 
 		if (unlikely(x))
 			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld\n",
@@ -779,6 +779,8 @@ static void check_mm(struct mm_struct *m
  */
 void __mmdrop(struct mm_struct *mm)
 {
+	int i;
+
 	BUG_ON(mm == &init_mm);
 	WARN_ON_ONCE(mm == current->mm);
 	WARN_ON_ONCE(mm == current->active_mm);
@@ -788,6 +790,9 @@ void __mmdrop(struct mm_struct *mm)
 	check_mm(mm);
 	put_user_ns(mm->user_ns);
 	mm_pasid_drop(mm);
+
+	for (i = 0; i < NR_MM_COUNTERS; i++)
+		percpu_counter_destroy(&mm->rss_stat[i]);
 	free_mm(mm);
 }
 EXPORT_SYMBOL_GPL(__mmdrop);
@@ -1107,6 +1112,8 @@ static void mm_init_uprobes_state(struct
 static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	struct user_namespace *user_ns)
 {
+	int i;
+
 	mt_init_flags(&mm->mm_mt, MM_MT_FLAGS);
 	mt_set_external_lock(&mm->mm_mt, &mm->mmap_lock);
 	atomic_set(&mm->mm_users, 1);
@@ -1148,10 +1155,17 @@ static struct mm_struct *mm_init(struct
 	if (init_new_context(p, mm))
 		goto fail_nocontext;
 
+	for (i = 0; i < NR_MM_COUNTERS; i++)
+		if (percpu_counter_init(&mm->rss_stat[i], 0, GFP_KERNEL_ACCOUNT))
+			goto fail_pcpu;
+
 	mm->user_ns = get_user_ns(user_ns);
 	lru_gen_init_mm(mm);
 	return mm;
 
+fail_pcpu:
+	while (i > 0)
+		percpu_counter_destroy(&mm->rss_stat[--i]);
 fail_nocontext:
 	mm_free_pgd(mm);
 fail_nopgd:
--- a/mm/memory.c~mm-convert-mms-rss-stats-into-percpu_counter
+++ a/mm/memory.c
@@ -162,58 +162,11 @@ static int __init init_zero_pfn(void)
 }
 early_initcall(init_zero_pfn);
 
-void mm_trace_rss_stat(struct mm_struct *mm, int member, long count)
+void mm_trace_rss_stat(struct mm_struct *mm, int member)
 {
-	trace_rss_stat(mm, member, count);
+	trace_rss_stat(mm, member);
 }
 
-#if defined(SPLIT_RSS_COUNTING)
-
-void sync_mm_rss(struct mm_struct *mm)
-{
-	int i;
-
-	for (i = 0; i < NR_MM_COUNTERS; i++) {
-		if (current->rss_stat.count[i]) {
-			add_mm_counter(mm, i, current->rss_stat.count[i]);
-			current->rss_stat.count[i] = 0;
-		}
-	}
-	current->rss_stat.events = 0;
-}
-
-static void add_mm_counter_fast(struct mm_struct *mm, int member, int val)
-{
-	struct task_struct *task = current;
-
-	if (likely(task->mm == mm))
-		task->rss_stat.count[member] += val;
-	else
-		add_mm_counter(mm, member, val);
-}
-#define inc_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member, 1)
-#define dec_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member, -1)
-
-/* sync counter once per 64 page faults */
-#define TASK_RSS_EVENTS_THRESH	(64)
-static void check_sync_rss_stat(struct task_struct *task)
-{
-	if (unlikely(task != current))
-		return;
-	if (unlikely(task->rss_stat.events++ > TASK_RSS_EVENTS_THRESH))
-		sync_mm_rss(task->mm);
-}
-#else /* SPLIT_RSS_COUNTING */
-
-#define inc_mm_counter_fast(mm, member) inc_mm_counter(mm, member)
-#define dec_mm_counter_fast(mm, member) dec_mm_counter(mm, member)
-
-static void check_sync_rss_stat(struct task_struct *task)
-{
-}
-
-#endif /* SPLIT_RSS_COUNTING */
-
 /*
  * Note: this doesn't free the actual pages themselves. That
  * has been handled earlier when unmapping all the memory regions.
@@ -1858,7 +1811,7 @@ static int insert_page_into_pte_locked(s
 		return -EBUSY;
 	/* Ok, finally just insert the thing.. */
 	get_page(page);
-	inc_mm_counter_fast(vma->vm_mm, mm_counter_file(page));
+	inc_mm_counter(vma->vm_mm, mm_counter_file(page));
 	page_add_file_rmap(page, vma, false);
 	set_pte_at(vma->vm_mm, addr, pte, mk_pte(page, prot));
 	return 0;
@@ -3154,12 +3107,11 @@ static vm_fault_t wp_page_copy(struct vm
 	if (likely(pte_same(*vmf->pte, vmf->orig_pte))) {
 		if (old_page) {
 			if (!PageAnon(old_page)) {
-				dec_mm_counter_fast(mm,
-						mm_counter_file(old_page));
-				inc_mm_counter_fast(mm, MM_ANONPAGES);
+				dec_mm_counter(mm, mm_counter_file(old_page));
+				inc_mm_counter(mm, MM_ANONPAGES);
 			}
 		} else {
-			inc_mm_counter_fast(mm, MM_ANONPAGES);
+			inc_mm_counter(mm, MM_ANONPAGES);
 		}
 		flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
 		entry = mk_pte(new_page, vma->vm_page_prot);
@@ -3966,8 +3918,8 @@ vm_fault_t do_swap_page(struct vm_fault
 	if (should_try_to_free_swap(folio, vma, vmf->flags))
 		folio_free_swap(folio);
 
-	inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
-	dec_mm_counter_fast(vma->vm_mm, MM_SWAPENTS);
+	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
+	dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
 	pte = mk_pte(page, vma->vm_page_prot);
 
 	/*
@@ -4146,7 +4098,7 @@ static vm_fault_t do_anonymous_page(stru
 		return handle_userfault(vmf, VM_UFFD_MISSING);
 	}
 
-	inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
+	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, vmf->address);
 	lru_cache_add_inactive_or_unevictable(page, vma);
 setpte:
@@ -4336,11 +4288,11 @@ void do_set_pte(struct vm_fault *vmf, st
 		entry = pte_mkuffd_wp(pte_wrprotect(entry));
 	/* copy-on-write page */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
-		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
+		inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
 		page_add_new_anon_rmap(page, vma, addr);
 		lru_cache_add_inactive_or_unevictable(page, vma);
 	} else {
-		inc_mm_counter_fast(vma->vm_mm, mm_counter_file(page));
+		inc_mm_counter(vma->vm_mm, mm_counter_file(page));
 		page_add_file_rmap(page, vma, false);
 	}
 	set_pte_at(vma->vm_mm, addr, vmf->pte, entry);
@@ -5192,9 +5144,6 @@ vm_fault_t handle_mm_fault(struct vm_are
 	count_vm_event(PGFAULT);
 	count_memcg_event_mm(vma->vm_mm, PGFAULT);
 
-	/* do counter updates before entering really critical section. */
-	check_sync_rss_stat(current);
-
 	if (!arch_vma_access_permitted(vma, flags & FAULT_FLAG_WRITE,
 					    flags & FAULT_FLAG_INSTRUCTION,
 					    flags & FAULT_FLAG_REMOTE))
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-convert-mms-rss-stats-into-percpu_counter.patch

