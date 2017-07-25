From: akpm@linux-foundation.org
Subject: + mm-always-flush-vma-ranges-affected-by-zap_page_range-v2.patch
 added to -mm tree
Date: Tue, 25 Jul 2017 13:12:59 -0700
Message-ID: <5977a64b.FA5KOn9WLyZCnooO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43514 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751483AbdGYUNA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2017 16:13:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, luto@kernel.org, mgorman@suse.de, nadav.amit@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: always flush VMA ranges affected by zap_page_range
has been added to the -mm tree.  Its filename is
     mm-always-flush-vma-ranges-affected-by-zap_page_range-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-always-flush-vma-ranges-affected-by-zap_page_range-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-always-flush-vma-ranges-affected-by-zap_page_range-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: always flush VMA ranges affected by zap_page_range

Nadav Amit report zap_page_range only specifies that the caller protect
the VMA list but does not specify whether it is held for read or write
with callers using either.  madvise holds mmap_sem for read meaning that a
parallel zap operation can unmap PTEs which are then potentially skipped
by madvise which potentially returns with stale TLB entries present. 
While the API could be extended, it would be a difficult API to use.  This
patch causes zap_page_range() to always consider flushing the full
affected range.  For small ranges or sparsely populated mappings, this may
result in one additional spurious TLB flush.  For larger ranges, it is
possible that the TLB has already been flushed and the overhead is
negligible.  Either way, this approach is safer overall and avoids stale
entries being present when madvise returns.

This can be illustrated with the following program provided by Nadav Amit
and slightly modified.  With the patch applied, it has an exit code of 0
indicating a stale TLB entry did not leak to userspace.

---8<---

volatile int sync_step = 0;
volatile char *p;

static inline unsigned long rdtsc()
{
	unsigned long hi, lo;
	__asm__ __volatile__ ("rdtsc" : "=a"(lo), "=d"(hi));
	 return lo | (hi << 32);
}

static inline void wait_rdtsc(unsigned long cycles)
{
	unsigned long tsc = rdtsc();

	while (rdtsc() - tsc < cycles);
}

void *big_madvise_thread(void *ign)
{
	sync_step = 1;
	while (sync_step != 2);
	madvise((void*)p, PAGE_SIZE * N_PAGES, MADV_DONTNEED);
}

int main(void)
{
	pthread_t aux_thread;

	p = mmap(0, PAGE_SIZE * N_PAGES, PROT_READ|PROT_WRITE,
		 MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);

	memset((void*)p, 8, PAGE_SIZE * N_PAGES);

	pthread_create(&aux_thread, NULL, big_madvise_thread, NULL);
	while (sync_step != 1);

	*p = 8;		// Cache in TLB
	sync_step = 2;
	wait_rdtsc(100000);
	madvise((void*)p, PAGE_SIZE, MADV_DONTNEED);
	printf("data: %d (%s)\n", *p, (*p == 8 ? "stale, broken" : "cleared, fine"));
	return *p == 8 ? -1 : 0;
}
---8<---

Link: http://lkml.kernel.org/r/20170725101230.5v7gvnjmcnkzzql3@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Nadav Amit <nadav.amit@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~mm-always-flush-vma-ranges-affected-by-zap_page_range-v2 mm/memory.c
--- a/mm/memory.c~mm-always-flush-vma-ranges-affected-by-zap_page_range-v2
+++ a/mm/memory.c
@@ -1485,8 +1485,20 @@ void zap_page_range(struct vm_area_struc
 	tlb_gather_mmu(&tlb, mm, start, end);
 	update_hiwater_rss(mm);
 	mmu_notifier_invalidate_range_start(mm, start, end);
-	for ( ; vma && vma->vm_start < end; vma = vma->vm_next)
+	for ( ; vma && vma->vm_start < end; vma = vma->vm_next) {
 		unmap_single_vma(&tlb, vma, start, end, NULL);
+
+		/*
+		 * zap_page_range does not specify whether mmap_sem should be
+		 * held for read or write. That allows parallel zap_page_range
+		 * operations to unmap a PTE and defer a flush meaning that
+		 * this call observes pte_none and fails to flush the TLB.
+		 * Rather than adding a complex API, ensure that no stale
+		 * TLB entries exist when this call returns.
+		 */
+		flush_tlb_range(vma, start, end);
+	}
+
 	mmu_notifier_invalidate_range_end(mm, start, end);
 	tlb_finish_mmu(&tlb, start, end);
 }
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-always-flush-vma-ranges-affected-by-zap_page_range-v2.patch

