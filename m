Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59A9333439
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 18:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767809450; cv=none; b=RRBVpGI8CmFMuBdiQMkGl/WeeUZJXtdlrCq6LChn+4uFRlFIl1/xbbZ/qQ+heoSAQWdWW4nAQcvbNTBpSRzfOTBOk3xSByX+CamIUOPp2FP0zBHt5OE1Yht0Tuav6EDjC0jMV+pOhCC/3ZONw6bhBP76oDkAN/bu4Mj+r6TJIj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767809450; c=relaxed/simple;
	bh=virbgGCErv4+BaDJSW3XSwOox0AIbn3W24LVjdHqb/o=;
	h=Date:To:From:Subject:Message-Id; b=hbRs5gWj+EhMYkMSJqH9J11IX7IsdeTtTLXF+B1HIk8QS462bJRswbLhjcRp/326ACjtR+8yj6yY+8DtylQz8EuQl2mFWTxSM77b//XjsqCJj6/Ezw8+5ExFl5tir9nGb/2MD0+r3kdjgNWSvSxAtMYcey+KrlEiIJPsiSIx/rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M2/2jwib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M2/2jwib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87BCC4CEF1;
	Wed,  7 Jan 2026 18:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767809449;
	bh=virbgGCErv4+BaDJSW3XSwOox0AIbn3W24LVjdHqb/o=;
	h=Date:To:From:Subject:From;
	b=M2/2jwibOFUwvFX1Qzotc6BBgADVV3sOWXl2t3uOhm7jVnLE0hqgV8syG0kH6KUWv
	 saxR63Ky30qDAih2QI3eEys9rvn+ZjKxw5kpdPyqRLGX4/xz9TV9YVCu/PfC9F29kW
	 mxCyso/r/gc+wz9s9/BXwYGrq7/wiftLj2aKwslU=
Date: Wed, 07 Jan 2026 10:10:49 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,rppt@kernel.org,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizhe.67@bytedance.com,Liam.Howlett@oracle.com,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@redhat.com,david@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-folio_zero_user-clear-page-ranges.patch added to mm-unstable branch
Message-Id: <20260107181049.A87BCC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: folio_zero_user: clear page ranges
has been added to the -mm mm-unstable branch.  Its filename is
     mm-folio_zero_user-clear-page-ranges.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-folio_zero_user-clear-page-ranges.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: mm: folio_zero_user: clear page ranges
Date: Tue, 6 Jan 2026 23:20:08 -0800

Use batch clearing in clear_contig_highpages() instead of clearing a
single page at a time.  Exposing larger ranges enables the processor to
optimize based on extent.

To do this we just switch to using clear_user_highpages() which would in
turn use clear_user_pages() or clear_pages().

Batched clearing, when running under non-preemptible models, however, has
latency considerations.  In particular, we need periodic invocations of
cond_resched() to keep to reasonable preemption latencies.  This is a
problem because the clearing primitives do not, or might not be able to,
call cond_resched() to check if preemption is needed.

So, limit the worst case preemption latency by doing the clearing in units
of no more than PROCESS_PAGES_NON_PREEMPT_BATCH pages.  (Preemptible
models already define away most of cond_resched(), so the batch size is
ignored when running under those.)

PROCESS_PAGES_NON_PREEMPT_BATCH: for architectures with "fast" clear-pages
(ones that define clear_pages()), we define it as 32MB worth of pages. 
This is meant to be large enough to allow the processor to optimize the
operation and yet small enough that we see reasonable preemption latency
for when this optimization is not possible (ex.  slow microarchitectures,
memory bandwidth saturation.)

This specific value also allows for a cacheline allocation elision
optimization (which might help unrelated applications by not evicting
potentially useful cache lines) that kicks in recent generations of AMD
Zen processors at around LLC-size (32MB is a typical size).

At the same time 32MB is small enough that even with poor clearing
bandwidth (say ~10GBps), time to clear 32MB should be well below the
scheduler's default warning threshold
(sysctl_resched_latency_warn_ms=100).

"Slow" architectures (don't have clear_pages()) will continue to use the
base value (single page).

Performance
==

Testing a demand fault workload shows a decent improvement in bandwidth
with pg-sz=1GB.  Bandwidth with pg-sz=2MB stays flat.

 $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5

                   contiguous-pages       batched-pages
                   (GBps +- %stdev)      (GBps +- %stdev)

   pg-sz=2MB       23.58 +- 1.95%        25.34 +- 1.18%       +  7.50%  preempt=*

   pg-sz=1GB       25.09 +- 0.79%        39.22 +- 2.32%       + 56.31%  preempt=none|voluntary
   pg-sz=1GB       25.71 +- 0.03%        52.73 +- 0.20% [#]   +110.16%  preempt=full|lazy

 [#] We perform much better with preempt=full|lazy because, not
  needing explicit invocations of cond_resched() we can clear the
  full extent (pg-sz=1GB) as a single unit which the processor
  can optimize for.

 (Unless otherwise noted, all numbers are on AMD Genoa (EPYC 9J13);
  region-size=64GB, local node; 2.56 GHz, boost=0.)

Analysis
==

pg-sz=1GB: the improvement we see falls in two buckets depending on the
batch size in use.

For batch-size=32MB the number of cachelines allocated (L1-dcache-loads)
-- which stay relatively flat for smaller batches, start to drop off
because cacheline allocation elision kicks in.  And as can be seen below,
at batch-size=1GB, we stop allocating cachelines almost entirely.  (Not
visible here but from testing with intermediate sizes, the allocation
change kicks in only at batch-size=32MB and ramps up from there.)

 contigous-pages       6,949,417,798      L1-dcache-loads                  #  883.599 M/sec                       ( +-  0.01% )  (35.75%)
                       3,226,709,573      L1-dcache-load-misses            #   46.43% of all L1-dcache accesses   ( +-  0.05% )  (35.75%)

    batched,32MB       2,290,365,772      L1-dcache-loads                  #  471.171 M/sec                       ( +-  0.36% )  (35.72%)
                       1,144,426,272      L1-dcache-load-misses            #   49.97% of all L1-dcache accesses   ( +-  0.58% )  (35.70%)

    batched,1GB           63,914,157      L1-dcache-loads                  #   17.464 M/sec                       ( +-  8.08% )  (35.73%)
                          22,074,367      L1-dcache-load-misses            #   34.54% of all L1-dcache accesses   ( +- 16.70% )  (35.70%)

The dropoff is also visible in L2 prefetch hits (miss numbers are
on similar lines):

 contiguous-pages      3,464,861,312      l2_pf_hit_l2.all                 #  437.722 M/sec                       ( +-  0.74% )  (15.69%)

   batched,32MB          883,750,087      l2_pf_hit_l2.all                 #  181.223 M/sec                       ( +-  1.18% )  (15.71%)

    batched,1GB            8,967,943      l2_pf_hit_l2.all                 #    2.450 M/sec                       ( +- 17.92% )  (15.77%)

This largely decouples the frontend from the backend since the clearing
operation does not need to wait on loads from memory (we still need
cacheline ownership but that's a shorter path).  This is most visible if
we rerun the test above with (boost=1, 3.66 GHz).

 $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5

                   contiguous-pages       batched-pages
                   (GBps +- %stdev)      (GBps +- %stdev)

   pg-sz=2MB       26.08 +- 1.72%        26.13 +- 0.92%           -     preempt=*

   pg-sz=1GB       26.99 +- 0.62%        48.85 +- 2.19%       + 80.99%  preempt=none|voluntary
   pg-sz=1GB       27.69 +- 0.18%        75.18 +- 0.25%       +171.50%  preempt=full|lazy

Comparing the batched-pages numbers from the boost=0 ones and these: for a
clock-speed gain of 42% we gain 24.5% for batch-size=32MB and 42.5% for
batch-size=1GB.  In comparison the baseline contiguous-pages case and both
the pg-sz=2MB ones are largely backend bound so gain no more than ~10%.

Other platforms tested, Intel Icelakex (Oracle X9) and ARM64 Neoverse-N1
(Ampere Altra) both show an improvement of ~35% for pg-sz=2MB|1GB.  The
first goes from around 8GBps to 11GBps and the second from 32GBps to 44
GBPs.

Link: https://lkml.kernel.org/r/20260107072009.1615991-8-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konrad Rzessutek Wilk <konrad.wilk@oracle.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Raghavendra K T <raghavendra.kt@amd.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   35 +++++++++++++++++++++++++++++++++++
 mm/memory.c        |   18 +++++++++++++++---
 2 files changed, 50 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-folio_zero_user-clear-page-ranges
+++ a/include/linux/mm.h
@@ -4204,6 +4204,15 @@ static inline void clear_page_guard(stru
  * mapped to user space.
  *
  * Does absolutely no exception handling.
+ *
+ * Note that even though the clearing operation is preemptible, clear_pages()
+ * does not (and on architectures where it reduces to a few long-running
+ * instructions, might not be able to) call cond_resched() to check if
+ * rescheduling is required.
+ *
+ * When running under preemptible models this is not a problem. Under
+ * cooperatively scheduled models, however, the caller is expected to
+ * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
  */
 static inline void clear_pages(void *addr, unsigned int npages)
 {
@@ -4214,6 +4223,32 @@ static inline void clear_pages(void *add
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
+ * With a value of 32MB and assuming a memory bandwidth of ~10GBps, this should
+ * result in worst case preemption latency of around 3ms when clearing pages.
+ *
+ * (See comment above clear_pages() for why preemption latency is a concern
+ * here.)
+ */
+#define PROCESS_PAGES_NON_PREEMPT_BATCH		(32 << (20 - PAGE_SHIFT))
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
--- a/mm/memory.c~mm-folio_zero_user-clear-page-ranges
+++ a/mm/memory.c
@@ -7240,13 +7240,25 @@ static inline int process_huge_page(
 static void clear_contig_highpages(struct page *page, unsigned long addr,
 				   unsigned int nr_pages)
 {
-	unsigned int i;
+	unsigned int i, unit, count;
 
 	might_sleep();
-	for (i = 0; i < nr_pages; i++) {
+	/*
+	 * When clearing we want to operate on the largest extent possible since
+	 * that allows for extent based architecture specific optimizations.
+	 *
+	 * However, since the clearing interfaces (clear_user_highpages(),
+	 * clear_user_pages(), clear_pages()), do not call cond_resched(), we
+	 * limit the batch size when running under non-preemptible scheduling
+	 * models.
+	 */
+	unit = preempt_model_preemptible() ? nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
+
+	for (i = 0; i < nr_pages; i += count) {
 		cond_resched();
 
-		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
+		count = min(unit, nr_pages - i);
+		clear_user_highpages(page + i, addr + i * PAGE_SIZE, count);
 	}
 }
 
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

mm-introduce-clear_pages-and-clear_user_pages.patch
highmem-introduce-clear_user_highpages.patch
x86-mm-simplify-clear_page_.patch
x86-clear_page-introduce-clear_pages.patch
mm-folio_zero_user-clear-pages-sequentially.patch
mm-folio_zero_user-clear-page-ranges.patch
mm-folio_zero_user-cache-neighbouring-pages.patch

