From: akpm@linux-foundation.org
Subject: [merged]
 partial-revert-of-81c98869faa5-kthread-ensure-locality-of-task_struct-allocations.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:48 -0700
Message-ID: <543c1788.pBoOUK166OydiBW2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbaJMSSs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@linux.vnet.ibm.com, anton@samba.org, benh@kernel.crashing.org, cl@linux.com, hanpt@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com, liwanp@linux.vnet.ibm.com, mpe@ellerman.id.au, paulus@samba.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kthread.c: partial revert of 81c98869faa5 ("kthread: ensure locality of task_struct allocations")
has been removed from the -mm tree.  Its filename was
     partial-revert-of-81c98869faa5-kthread-ensure-locality-of-task_struct-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: kernel/kthread.c: partial revert of 81c98869faa5 ("kthread: ensure locality of task_struct allocations")

After discussions with Tejun, we don't want to spread the use of
cpu_to_mem() (and thus knowledge of allocators/NUMA topology details) into
callers, but would rather ensure the callees correctly handle memoryless
nodes.  With the previous patches ("topology: add support for
node_to_mem_node() to determine the fallback node" and "slub: fallback to
node_to_mem_node() node if allocating on memoryless node") adding and
using node_to_mem_node(), we can safely undo part of the change to the
kthread logic from 81c98869faa5.

Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Han Pingtian <hanpt@linux.vnet.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Anton Blanchard <anton@samba.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kthread.c~partial-revert-of-81c98869faa5-kthread-ensure-locality-of-task_struct-allocations kernel/kthread.c
--- a/kernel/kthread.c~partial-revert-of-81c98869faa5-kthread-ensure-locality-of-task_struct-allocations
+++ a/kernel/kthread.c
@@ -369,7 +369,7 @@ struct task_struct *kthread_create_on_cp
 {
 	struct task_struct *p;
 
-	p = kthread_create_on_node(threadfn, data, cpu_to_mem(cpu), namefmt,
+	p = kthread_create_on_node(threadfn, data, cpu_to_node(cpu), namefmt,
 				   cpu);
 	if (IS_ERR(p))
 		return p;
_

Patches currently in -mm which might be from nacc@linux.vnet.ibm.com are

origin.patch

