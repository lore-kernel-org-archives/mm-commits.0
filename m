From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages-fix.patch removed from -mm tree
Date: Fri, 04 Sep 2015 15:31:00 -0700
Message-ID: <55ea1ba4.JdaFoaxDJ5Zsa9Eq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760190AbbIDWbB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:31:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: trace tlb flush after disabling preemption in try_to_unmap_flush
has been removed from the -mm tree.  Its filename was
     mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages-fix.patch

This patch was dropped because it was folded into mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages.patch

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
Reviewed-by: Michal Hocko <mhocko@suse.com>
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

mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages.patch

