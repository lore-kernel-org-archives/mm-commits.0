From: akpm@linux-foundation.org
Subject: [merged]
 slub-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:47 -0800
Message-ID: <54e2502f.BzCovQXIhS3vDgCy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbbBPU1n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:27:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, cl@linux.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     slub-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: slub: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* This is an equivalent conversion but the whole function should be
  converted to use scnprinf famiily of functions rather than
  performing custom output length predictions in multiple places.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff -puN mm/slub.c~slub-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks mm/slub.c
--- a/mm/slub.c~slub-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/mm/slub.c
@@ -4108,20 +4108,16 @@ static int list_locations(struct kmem_ca
 
 		if (num_online_cpus() > 1 &&
 				!cpumask_empty(to_cpumask(l->cpus)) &&
-				len < PAGE_SIZE - 60) {
-			len += sprintf(buf + len, " cpus=");
-			len += cpulist_scnprintf(buf + len,
-						 PAGE_SIZE - len - 50,
-						 to_cpumask(l->cpus));
-		}
+				len < PAGE_SIZE - 60)
+			len += scnprintf(buf + len, PAGE_SIZE - len - 50,
+					 " cpus=%*pbl",
+					 cpumask_pr_args(to_cpumask(l->cpus)));
 
 		if (nr_online_nodes > 1 && !nodes_empty(l->nodes) &&
-				len < PAGE_SIZE - 60) {
-			len += sprintf(buf + len, " nodes=");
-			len += nodelist_scnprintf(buf + len,
-						  PAGE_SIZE - len - 50,
-						  l->nodes);
-		}
+				len < PAGE_SIZE - 60)
+			len += scnprintf(buf + len, PAGE_SIZE - len - 50,
+					 " nodes=%*pbl",
+					 nodemask_pr_args(&l->nodes));
 
 		len += sprintf(buf + len, "\n");
 	}
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

