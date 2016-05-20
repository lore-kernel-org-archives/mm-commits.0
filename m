From: akpm@linux-foundation.org
Subject: [merged] mm-mempolicyc-offset_il_node-document-and-clarify.patch
 removed from -mm tree
Date: Fri, 20 May 2016 14:04:39 -0700
Message-ID: <573f7be7.0dOABuS7qBntUFa0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbcETVEk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:04:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, js1304@gmail.com, lauraa@codeaurora.org, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c:offset_il_node() document and clarify
has been removed from the -mm tree.  Its filename was
     mm-mempolicyc-offset_il_node-document-and-clarify.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/mempolicy.c:offset_il_node() document and clarify

This code was pretty obscure and was relying upon obscure side-effects of
next_node(-1, ...) and was relying upon NUMA_NO_NODE being equal to -1.

Clean that all up and document the function's intent.

Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicyc-offset_il_node-document-and-clarify mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-offset_il_node-document-and-clarify
+++ a/mm/mempolicy.c
@@ -1758,23 +1758,25 @@ unsigned int mempolicy_slab_node(void)
 	}
 }
 
-/* Do static interleaving for a VMA with known offset. */
+/*
+ * Do static interleaving for a VMA with known offset @n.  Returns the n'th
+ * node in pol->v.nodes (starting from n=0), wrapping around if n exceeds the
+ * number of present nodes.
+ */
 static unsigned offset_il_node(struct mempolicy *pol,
-		struct vm_area_struct *vma, unsigned long off)
+			       struct vm_area_struct *vma, unsigned long n)
 {
 	unsigned nnodes = nodes_weight(pol->v.nodes);
 	unsigned target;
-	int c;
-	int nid = NUMA_NO_NODE;
+	int i;
+	int nid;
 
 	if (!nnodes)
 		return numa_node_id();
-	target = (unsigned int)off % nnodes;
-	c = 0;
-	do {
+	target = (unsigned int)n % nnodes;
+	nid = first_node(pol->v.nodes);
+	for (i = 0; i < target; i++)
 		nid = next_node(nid, pol->v.nodes);
-		c++;
-	} while (c <= target);
 	return nid;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
mm-oom-protect-costly-allocations-some-more-for-config_compaction-checkpatch-fixes.patch
vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix.patch
mm-compact-fix-zoneindex-in-compact-fix.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch
allocate-idle-task-for-a-cpu-always-on-its-local-node-fix.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

