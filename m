From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-fix-bootmem-error-handling-in-pcpu_page_first_chunk.patch removed from
 -mm tree
Date: Thu, 26 Sep 2013 15:07:40 -0700
Message-ID: <5244b02c.3MvNXxsi+44RDuzc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab3IZWHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 18:07:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, cl@linux-foundation.org, holzheu@linux.vnet.ibm.com

Subject: [alternative-merged] mm-fix-bootmem-error-handling-in-pcpu_page_first_chunk.patch removed from -mm tree
To: holzheu@linux.vnet.ibm.com,cl@linux-foundation.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 15:07:40 -0700


The patch titled
     Subject: mm: fix bootmem error handling in pcpu_page_first_chunk()
has been removed from the -mm tree.  Its filename was
     mm-fix-bootmem-error-handling-in-pcpu_page_first_chunk.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: mm: fix bootmem error handling in pcpu_page_first_chunk()

If memory allocation in pcpu_embed_first_chunk() fails, the allocated
memory is not released correctly.  In the release loop also the
non-allocated elements are released which leads to the following kernel
BUG on systems with very little memory:

[    0.000000] kernel BUG at mm/bootmem.c:307!
[    0.000000] illegal operation: 0001 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.10.0 #22
[    0.000000] task: 0000000000a20ae0 ti: 0000000000a08000 task.ti: 0000000000a08000
[    0.000000] Krnl PSW : 0400000180000000 0000000000abda7a (__free+0x116/0x154)
[    0.000000]            R:0 T:1 IO:0 EX:0 Key:0 M:0 W:0 P:0 AS:0 CC:0 PM:0 EA:3
...
[    0.000000]  [<0000000000abdce2>] mark_bootmem_node+0xde/0xf0
[    0.000000]  [<0000000000abdd9c>] mark_bootmem+0xa8/0x118
[    0.000000]  [<0000000000abcbba>] pcpu_embed_first_chunk+0xe7a/0xf0c
[    0.000000]  [<0000000000abcc96>] setup_per_cpu_areas+0x4a/0x28c

To fix the problem now only allocated elements are released.  This then
leads to the correct kernel panic:

[    0.000000] Kernel panic - not syncing: Failed to initialize percpu areas.
...
[    0.000000] Call Trace:
[    0.000000] ([<000000000011307e>] show_trace+0x132/0x150)
[    0.000000]  [<0000000000113160>] show_stack+0xc4/0xd4
[    0.000000]  [<00000000007127dc>] dump_stack+0x74/0xd8
[    0.000000]  [<00000000007123fe>] panic+0xea/0x264
[    0.000000]  [<0000000000b14814>] setup_per_cpu_areas+0x5c/0x28c

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/percpu.c~mm-fix-bootmem-error-handling-in-pcpu_page_first_chunk mm/percpu.c
--- a/mm/percpu.c~mm-fix-bootmem-error-handling-in-pcpu_page_first_chunk
+++ a/mm/percpu.c
@@ -1705,9 +1705,12 @@ int __init pcpu_embed_first_chunk(size_t
 	goto out_free;
 
 out_free_areas:
-	for (group = 0; group < ai->nr_groups; group++)
+	for (group = 0; group < ai->nr_groups; group++) {
+		if (!areas[group])
+			continue;
 		free_fn(areas[group],
 			ai->groups[group].nr_units * ai->unit_size);
+	}
 out_free:
 	pcpu_free_alloc_info(ai);
 	if (areas)
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

linux-next.patch

