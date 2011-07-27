From: akpm@linux-foundation.org
Subject: [merged] cpumask-alloc_cpumask_var-use-numa_no_node.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:54 -0700
Message-ID: <201107271927.p6RJRe78003231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754553Ab1G0T2C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     cpumask: alloc_cpumask_var() use NUMA_NO_NODE
has been removed from the -mm tree.  Its filename was
     cpumask-alloc_cpumask_var-use-numa_no_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpumask: alloc_cpumask_var() use NUMA_NO_NODE
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

NUMA_NO_NODE and numa_node_id() have different meanings.  NUMA_NO_NODE is
obviously the recommended fallback.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cpumask.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/cpumask.c~cpumask-alloc_cpumask_var-use-numa_no_node lib/cpumask.c
--- a/lib/cpumask.c~cpumask-alloc_cpumask_var-use-numa_no_node
+++ a/lib/cpumask.c
@@ -131,7 +131,7 @@ EXPORT_SYMBOL(zalloc_cpumask_var_node);
  */
 bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
 {
-	return alloc_cpumask_var_node(mask, flags, numa_node_id());
+	return alloc_cpumask_var_node(mask, flags, NUMA_NO_NODE);
 }
 EXPORT_SYMBOL(alloc_cpumask_var);
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
slab-use-numa_no_node.patch
kexec-remove-kmsg_dump_kexec.patch

