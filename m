From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch removed
 from -mm tree
Date: Mon, 16 Feb 2015 12:16:49 -0800
Message-ID: <54e25031.9g7phYIQlPGIhk4X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbBPURZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     mm-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: mm: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/mempolicy.c~mm-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks mm/mempolicy.c
--- a/mm/mempolicy.c~mm-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/mm/mempolicy.c
@@ -2817,8 +2817,7 @@ void mpol_to_str(char *buffer, int maxle
 			p += snprintf(p, buffer + maxlen - p, "relative");
 	}
 
-	if (!nodes_empty(nodes)) {
-		p += snprintf(p, buffer + maxlen - p, ":");
-	 	p += nodelist_scnprintf(p, buffer + maxlen - p, nodes);
-	}
+	if (!nodes_empty(nodes))
+		p += scnprintf(p, buffer + maxlen - p, ":%*pbl",
+			       nodemask_pr_args(&nodes));
 }
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

