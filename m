From: akpm@linux-foundation.org
Subject: [merged]
 percpu-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:29 -0800
Message-ID: <54e2501d.kwZPuBWY1bIiIHhV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbbBPURF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, cl@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: percpu: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     percpu-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: percpu: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/percpu.c~percpu-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks mm/percpu.c
--- a/mm/percpu.c~percpu-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/mm/percpu.c
@@ -1528,7 +1528,6 @@ static void pcpu_dump_alloc_info(const c
 int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 				  void *base_addr)
 {
-	static char cpus_buf[4096] __initdata;
 	static int smap[PERCPU_DYNAMIC_EARLY_SLOTS] __initdata;
 	static int dmap[PERCPU_DYNAMIC_EARLY_SLOTS] __initdata;
 	size_t dyn_size = ai->dyn_size;
@@ -1541,12 +1540,11 @@ int __init pcpu_setup_first_chunk(const
 	int *unit_map;
 	int group, unit, i;
 
-	cpumask_scnprintf(cpus_buf, sizeof(cpus_buf), cpu_possible_mask);
