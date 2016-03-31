From: akpm@linux-foundation.org
Subject: + mm-mempolicyc-offset_il_node-document-and-clarify.patch added
 to -mm tree
Date: Thu, 31 Mar 2016 14:01:45 -0700
Message-ID: <56fd9039.Es1C1QQLkwjD3yg3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113AbcCaVBq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2016 17:01:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, js1304@gmail.com, lauraa@codeaurora.org, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c:offset_il_node() document and clarify
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-offset_il_node-document-and-clarify.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicyc-offset_il_node-document-and-clarify.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicyc-offset_il_node-document-and-clarify.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/mempolicy.c:offset_il_node() document and clarify

This code was pretty obscure and was relying upon obscure side-effects of
next_node(-1, ...) and was relying upon NUMA_NO_NODE being equal to -1.

Clean that all up and document the function's intent.

Cc: Vlastimil Babka <vbabka@suse.cz>
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
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

