From: akpm@linux-foundation.org
Subject: [merged] ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:37:41 -0800
Message-ID: <5283e315.gRcrADRh7sgQb11w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3KMUhl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liwanp@linux.vnet.ibm.com, joe@perches.com

Subject: [merged] ksm-remove-redundant-__gfp_zero-from-kcalloc.patch removed from -mm tree
To: joe@perches.com,liwanp@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:41 -0800


The patch titled
     Subject: ksm: remove redundant __GFP_ZERO from kcalloc
has been removed from the -mm tree.  Its filename was
     ksm-remove-redundant-__gfp_zero-from-kcalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ksm: remove redundant __GFP_ZERO from kcalloc

kcalloc returns zeroed memory.  There's no need to use this flag.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/ksm.c~ksm-remove-redundant-__gfp_zero-from-kcalloc mm/ksm.c
--- a/mm/ksm.c~ksm-remove-redundant-__gfp_zero-from-kcalloc
+++ a/mm/ksm.c
@@ -2309,8 +2309,8 @@ static ssize_t merge_across_nodes_store(
 			 * Allocate stable and unstable together:
 			 * MAXSMP NODES_SHIFT 10 will use 16kB.
 			 */
-			buf = kcalloc(nr_node_ids + nr_node_ids,
-				sizeof(*buf), GFP_KERNEL | __GFP_ZERO);
+			buf = kcalloc(nr_node_ids + nr_node_ids, sizeof(*buf),
+				      GFP_KERNEL);
 			/* Let us assume that RB_ROOT is NULL is zero */
 			if (!buf)
 				err = -ENOMEM;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
get_maintainerpl-incomplete-output.patch
linux-next.patch
seq_file-introduce-seq_setwidth-and-seq_pad.patch
seq_file-remove-%n-usage-from-seq_file-users.patch
vsprintf-ignore-%n-again.patch

