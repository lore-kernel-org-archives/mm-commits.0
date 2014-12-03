From: akpm@linux-foundation.org
Subject: [merged]
 slab-fix-nodeid-bounds-check-for-non-contiguous-node-ids.patch removed from -mm tree
Date: Wed, 03 Dec 2014 13:29:53 -0800
Message-ID: <547f80d1.RTzjp1ZchdjtMTlk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaLCV3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2014 16:29:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulus@samba.org, cl@linux.com, iamjoonsoo.kim@lge.com, isimatu.yasuaki@jp.fujitsu.com, penberg@kernel.org, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: fix nodeid bounds check for non-contiguous node IDs
has been removed from the -mm tree.  Its filename was
     slab-fix-nodeid-bounds-check-for-non-contiguous-node-ids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paul Mackerras <paulus@samba.org>
Subject: slab: fix nodeid bounds check for non-contiguous node IDs

The bounds check for nodeid in ____cache_alloc_node gives false positives
on machines where the node IDs are not contiguous, leading to a panic at
boot time.  For example, on a POWER8 machine the node IDs are typically 0,
1, 16 and 17.  This means that num_online_nodes() returns 4, so when
____cache_alloc_node is called with nodeid = 16 the VM_BUG_ON triggers,
like this:

kernel BUG at /home/paulus/kernel/kvm/mm/slab.c:3079!
Oops: Exception in kernel mode, sig: 5 [#1]
SMP NR_CPUS=1024 NUMA PowerNV
Modules linked in:
CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc5-kvm+ #17
task: c0000000013ba230 ti: c000000001494000 task.ti: c000000001494000
NIP: c000000000264f6c LR: c000000000264f5c CTR: 0000000000000000
REGS: c0000000014979a0 TRAP: 0700   Not tainted  (3.18.0-rc5-kvm+)
MSR: 9000000002021032 <SF,HV,VEC,ME,IR,DR,RI>  CR: 28000448  XER: 20000000
CFAR: c00000000047e978 SOFTE: 0
GPR00: c000000000264f5c c000000001497c20 c000000001499d48 0000000000000004
GPR04: 0000000000000100 0000000000000010 0000000000000068 ffffffffffffffff
GPR08: 0000000000000000 0000000000000001 00000000082d0000 c000000000cca5a8
GPR12: 0000000048000448 c00000000fda0000 000001003bd44ff0 0000000010020578
GPR16: 000001003bd44ff8 000001003bd45000 0000000000000001 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000010
GPR24: c000000ffe000080 c000000000c824ec 0000000000000068 c000000ffe000080
GPR28: 0000000000000010 c000000ffe000080 0000000000000010 0000000000000000
NIP [c000000000264f6c] .____cache_alloc_node+0x6c/0x270
LR [c000000000264f5c] .____cache_alloc_node+0x5c/0x270
Call Trace:
[c000000001497c20] [c000000000264f5c] .____cache_alloc_node+0x5c/0x270 (unreliable)
[c000000001497cf0] [c00000000026552c] .kmem_cache_alloc_node_trace+0xdc/0x360
[c000000001497dc0] [c000000000c824ec] .init_list+0x3c/0x128
[c000000001497e50] [c000000000c827b4] .kmem_cache_init+0x1dc/0x258
[c000000001497ef0] [c000000000c54090] .start_kernel+0x2a0/0x568
[c000000001497f90] [c000000000008c6c] start_here_common+0x20/0xa8
Instruction dump:
7c7d1b78 7c962378 4bda4e91 60000000 3c620004 38800100 386370d8 48219959
60000000 7f83e000 7d301026 5529effe <0b090000> 393c0010 79291f24 7d3d4a14

To fix this, we instead compare the nodeid with MAX_NUMNODES, and
additionally make sure it isn't negative (since nodeid is an int).  The
check is there mainly to protect the array dereference in the get_node()
call in the next line, and the array being dereferenced is of size
MAX_NUMNODES.  If the nodeid is in range but invalid (for example if the
node is off-line), the BUG_ON in the next line will catch that.

Fixes: 14e50c6a9bc2 ("mm: slab: Verify the nodeid passed to ____cache_alloc_node")
Signed-off-by: Paul Mackerras <paulus@samba.org>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~slab-fix-nodeid-bounds-check-for-non-contiguous-node-ids mm/slab.c
--- a/mm/slab.c~slab-fix-nodeid-bounds-check-for-non-contiguous-node-ids
+++ a/mm/slab.c
@@ -3076,7 +3076,7 @@ static void *____cache_alloc_node(struct
 	void *obj;
 	int x;
 
-	VM_BUG_ON(nodeid > num_online_nodes());
+	VM_BUG_ON(nodeid < 0 || nodeid >= MAX_NUMNODES);
 	n = get_node(cachep, nodeid);
 	BUG_ON(!n);
 
_

Patches currently in -mm which might be from paulus@samba.org are

origin.patch
linux-next.patch

