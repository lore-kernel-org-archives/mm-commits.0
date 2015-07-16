From: akpm@linux-foundation.org
Subject: +
 mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages-fix.patch added to -mm tree
Date: Thu, 16 Jul 2015 14:17:17 -0700
Message-ID: <55a81f5d.mwkprU5b89x7//s7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbbGPVRS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jul 2015 17:17:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: trace tlb flush after disabling preemption in try_to_unmap_flush
has been added to the -mm tree.  Its filename is
     mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: trace tlb flush after disabling preemption in try_to_unmap_flush

Commit "mm: send one IPI per CPU to TLB flush all entries after unmapping
pages" added a trace_tlb_flush() while preemption was still enabled. This
means that we'll access smp_processor_id() which in turn will get us quite
a few warnings.

Fix it by moving the trace to where the preemption is disabled, one line
down.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/rmap.c~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages-fix mm/rmap.c
--- a/mm/rmap.c~mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages-fix
+++ a/mm/rmap.c
@@ -613,9 +613,10 @@ void try_to_unmap_flush(void)
 	if (!tlb_ubc->flush_required)
 		return;
 
+	cpu = get_cpu();
+
 	trace_tlb_flush(TLB_REMOTE_SHOOTDOWN, -1UL);
 
-	cpu = get_cpu();
 	if (cpumask_test_cpu(cpu, &tlb_ubc->cpumask))
 		percpu_flush_tlb_batch_pages(&tlb_ubc->cpumask);
 
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

mm-cma_debug-fix-debugging-alloc-free-interface.patch
mm-cma_debug-correct-size-input-to-bitmap-function.patch
mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages-fix.patch
hfshfsplus-cache-pages-correctly-between-bnode_create-and-bnode_free.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

