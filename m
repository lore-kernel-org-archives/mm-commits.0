Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E1122156B
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 02:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765853379; cv=none; b=R0yUtFObOHfvsV8gfImymjmTszO4ZFR/zVBlPfefh/h9LdZzLiOSbyoNVlXzcc028TsALI4dDNmvk1V9/y7yjvDEoKkBk9vZCGlQ3vbiB9myGU0ko8GDwJml5CZiXalMi6SPR3/5qFmB11FGcqqmQF9xr6a3YJt5SziApJdxn8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765853379; c=relaxed/simple;
	bh=gBhY7cWWpfID8mBttuGsQKF9j+1tSj8r6tTKHOZ0RsU=;
	h=Date:To:From:Subject:Message-Id; b=SX6wJx99SwReA3seq3O7srUhRiuWdS0UsJiRLy2awTMom7niEmX4/YAVY9ZKoanwbS4YwVhJxjSPHzXohcfSl/GIGhMz+yZCYKOfqp6G9v0+cqmhg4eX0iDyFCbHDraiQzHG7OXJZ0mJ87Tc7mgCIFIH05HcAkZmlC52GxhR14o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hVs+gCfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hVs+gCfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15735C4CEF5;
	Tue, 16 Dec 2025 02:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765853379;
	bh=gBhY7cWWpfID8mBttuGsQKF9j+1tSj8r6tTKHOZ0RsU=;
	h=Date:To:From:Subject:From;
	b=hVs+gCfwnTwgwbAmfZFeQTBiy2pjAGEpFE96gimDDuunu/XOhd70/ZBItJEWRF7uw
	 iBqGapg5QJtI70sx4hP8iHqRQC3W2su14tgJIPHt2tDDZt1408lk1Uq6VSNoC1PU5i
	 hqbz5szHwQtOHtD14W5FoeU/+6NBhBuw1LgdwB/E=
Date: Mon, 15 Dec 2025 18:49:38 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,luto@kernel.org,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@redhat.com,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-folio_zero_user-support-clearing-page-ranges.patch added to mm-new branch
Message-Id: <20251216024939.15735C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, folio_zero_user: support clearing page ranges
has been added to the -mm mm-new branch.  Its filename is
     mm-folio_zero_user-support-clearing-page-ranges.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-folio_zero_user-support-clearing-page-ranges.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: mm, folio_zero_user: support clearing page ranges
Date: Mon, 15 Dec 2025 12:49:21 -0800

Clear contiguous page ranges in folio_zero_user() instead of clearing a
single page at a time.  Exposing larger ranges enables extent based
processor optimizations.

However, because the underlying clearing primitives do not, or might not
be able to check to call cond_resched() to check if preemption is
required, limit the worst case preemption latency by doing the clearing in
no more than PROCESS_PAGES_NON_PREEMPT_BATCH units.

For architectures that define clear_pages(), we assume that the clearing
is fast and define PROCESS_PAGES_NON_PREEMPT_BATCH as 8MB worth of pages. 
This should be large enough to allow the processor to optimize the
operation and yet small enough that we see reasonable preemption latency
for when this optimization is not possible (ex.  slow microarchitectures,
memory bandwidth saturation.)

Architectures that don't define clear_pages() will continue to use the
base value (single page).  And, preemptible models don't need invocations
of cond_resched() so don't care about the batch size.

The resultant performance depends on the kinds of optimizations available
to the CPU for the region size being cleared.  Two classes of
optimizations:

  - clearing iteration costs are amortized over a range larger
    than a single page.
  - cacheline allocation elision (seen on AMD Zen models).

Testing a demand fault workload shows an improved baseline from the first
optimization and a larger improvement when the region being cleared is
large enough for the second optimization.

AMD Milan (EPYC 7J13, boost=0, region=64GB on the local NUMA node):

  $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5

                    page-at-a-time     contiguous clearing      change

                  (GB/s  +- %stdev)     (GB/s  +- %stdev)

   pg-sz=2MB       12.92  +- 2.55%        17.03  +-  0.70%       + 31.8%	preempt=*

   pg-sz=1GB       17.14  +- 2.27%        18.04  +-  1.05%       +  5.2%	preempt=none|voluntary
   pg-sz=1GB       17.26  +- 1.24%        42.17  +-  4.21% [#]   +144.3%	preempt=full|lazy

 [#] Notice that we perform much better with preempt=full|lazy. As
  mentioned above, preemptible models not needing explicit invocations
  of cond_resched() allow clearing of the full extent (1GB) as a
  single unit.
  In comparison the maximum extent used for preempt=none|voluntary is
  PROCESS_PAGES_NON_PREEMPT_BATCH (8MB).

  The larger extent allows the processor to elide cacheline
  allocation (on Milan the threshold is LLC-size=32MB.)

Also as mentioned earlier, the baseline improvement is not specific to AMD
Zen platforms.  Intel Icelakex (pg-sz=2MB|1GB) sees a similar improvement
as the Milan pg-sz=2MB workload above (~30%).

Link: https://lkml.kernel.org/r/20251215204922.475324-8-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konrad Rzessutek Wilk <konrad.wilk@oracle.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   38 ++++++++++++++++++++++++++++++++++-
 mm/memory.c        |   46 +++++++++++++++++++++++--------------------
 2 files changed, 62 insertions(+), 22 deletions(-)

--- a/include/linux/mm.h~mm-folio_zero_user-support-clearing-page-ranges
+++ a/include/linux/mm.h
@@ -4236,7 +4236,6 @@ static inline void clear_page_guard(stru
 				unsigned int order) {}
 #endif	/* CONFIG_DEBUG_PAGEALLOC */
 
-#ifndef clear_pages
 /**
  * clear_pages() - clear a page range for kernel-internal use.
  * @addr: start address
@@ -4246,7 +4245,18 @@ static inline void clear_page_guard(stru
  * mapped to user space.
  *
  * Does absolutely no exception handling.
+ *
+ * Note that even though the clearing operation is preemptible, clear_pages()
+ * does not (and on architectures where it reduces to a few long-running
+ * instructions, might not be able to) call cond_resched() to check if
+ * rescheduling is required.
+ *
+ * When running under preemptible models this is fine, since clear_pages(),
+ * even when reduced to long-running instructions, is preemptible.
+ * Under cooperatively scheduled models, however, the caller is expected to
+ * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
  */
+#ifndef clear_pages
 static inline void clear_pages(void *addr, unsigned int npages)
 {
 	do {
@@ -4256,6 +4266,32 @@ static inline void clear_pages(void *add
 }
 #endif
 
+#ifndef PROCESS_PAGES_NON_PREEMPT_BATCH
+#ifdef clear_pages
+/*
+ * The architecture defines clear_pages(), and we assume that it is
+ * generally "fast". So choose a batch size large enough to allow the processor
+ * headroom for optimizing the operation and yet small enough that we see
+ * reasonable preemption latency for when this optimization is not possible
+ * (ex. slow microarchitectures, memory bandwidth saturation.)
+ *
+ * With a value of 8MB and assuming a memory bandwidth of ~10GBps, this should
+ * result in worst case preemption latency of around 1ms when clearing pages.
+ *
+ * (See comment above clear_pages() for why preemption latency is a concern
+ * here.)
+ */
+#define PROCESS_PAGES_NON_PREEMPT_BATCH		(8 << (20 - PAGE_SHIFT))
+#else /* !clear_pages */
+/*
+ * The architecture does not provide a clear_pages() implementation. Assume
+ * that clear_page() -- which clear_pages() will fallback to -- is relatively
+ * slow and choose a small value for PROCESS_PAGES_NON_PREEMPT_BATCH.
+ */
+#define PROCESS_PAGES_NON_PREEMPT_BATCH		1
+#endif
+#endif
+
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
 extern int in_gate_area_no_mm(unsigned long addr);
--- a/mm/memory.c~mm-folio_zero_user-support-clearing-page-ranges
+++ a/mm/memory.c
@@ -7237,40 +7237,44 @@ static inline int process_huge_page(
 	return 0;
 }
 
-static void clear_gigantic_page(struct folio *folio, unsigned long addr_hint,
-				unsigned int nr_pages)
+static void clear_contig_highpages(struct page *page, unsigned long addr,
+				   unsigned int npages)
 {
-	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(folio));
-	int i;
+	unsigned int i, count, unit;
 
-	might_sleep();
-	for (i = 0; i < nr_pages; i++) {
-		cond_resched();
-		clear_user_highpage(folio_page(folio, i), addr + i * PAGE_SIZE);
-	}
-}
+	/*
+	 * When clearing we want to operate on the largest extent possible since
+	 * that allows for extent based architecture specific optimizations.
+	 *
+	 * However, since the clearing interfaces (clear_user_highpages(),
+	 * clear_user_pages(), clear_pages()), do not call cond_resched(), we
+	 * limit the batch size when running under non-preemptible scheduling
+	 * models.
+	 */
+	unit = preempt_model_preemptible() ? npages : PROCESS_PAGES_NON_PREEMPT_BATCH;
 
-static int clear_subpage(unsigned long addr, int idx, void *arg)
-{
-	struct folio *folio = arg;
+	for (i = 0; i < npages; i += count) {
+		cond_resched();
 
-	clear_user_highpage(folio_page(folio, idx), addr);
-	return 0;
+		count = min(unit, npages - i);
+		clear_user_highpages(page + i,
+				     addr + i * PAGE_SIZE, count);
+	}
 }
 
 /**
  * folio_zero_user - Zero a folio which will be mapped to userspace.
  * @folio: The folio to zero.
- * @addr_hint: The address will be accessed or the base address if uncelar.
+ * @addr_hint: The address accessed by the user or the base address.
+ *
+ * Uses architectural support to clear page ranges.
  */
 void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
-	unsigned int nr_pages = folio_nr_pages(folio);
+	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
 
-	if (unlikely(nr_pages > MAX_ORDER_NR_PAGES))
-		clear_gigantic_page(folio, addr_hint, nr_pages);
-	else
-		process_huge_page(addr_hint, nr_pages, clear_subpage, folio);
+	clear_contig_highpages(folio_page(folio, 0),
+				base_addr, folio_nr_pages(folio));
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

highmem-introduce-clear_user_highpages.patch
mm-introduce-clear_pages-and-clear_user_pages.patch
highmem-do-range-clearing-in-clear_user_highpages.patch
x86-mm-simplify-clear_page_.patch
x86-clear_page-introduce-clear_pages.patch
mm-folio_zero_user-support-clearing-page-ranges.patch
mm-folio_zero_user-cache-neighbouring-pages.patch

