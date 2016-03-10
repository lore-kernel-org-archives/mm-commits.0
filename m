From: akpm@linux-foundation.org
Subject: [merged]
 dma-mapping-to-avoid-oops-when-parameter-cpu_addr-is-null.patch removed
 from -mm tree
Date: Thu, 10 Mar 2016 10:58:21 -0800
Message-ID: <56e1c3cd.UzIzYvkZkE3unkUc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbcCJS6W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2016 13:58:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thunder.leizhen@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: avoid oops when parameter cpu_addr is null
has been removed from the -mm tree.  Its filename was
     dma-mapping-to-avoid-oops-when-parameter-cpu_addr-is-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: dma-mapping: avoid oops when parameter cpu_addr is null

To keep consistent with kfree, which tolerate ptr is NULL. We do this
because sometimes we may use goto statement, so that success and failure
case can share parts of the code. But unfortunately, dma_free_coherent
called with parameter cpu_addr is null will cause oops, such as showed
below:

Unable to handle kernel paging request at virtual address ffffffc020d3b2b8
pgd = ffffffc083a61000
[ffffffc020d3b2b8] *pgd=0000000000000000, *pud=0000000000000000
CPU: 4 PID: 1489 Comm: malloc_dma_1 Tainted: G           O    4.1.12 #1
Hardware name: ARM64 (DT)
task: ffffffc00d7d26c0 ti: ffffffc0837fc000 task.ti: ffffffc0837fc000
PC is at __dma_free_coherent.isra.10+0x74/0xc8
LR is at __dma_free+0x9c/0xb0
pc : [<ffffffc000214d10>] lr : [<ffffffc000214e00>] pstate: 80000145
sp : ffffffc0837ff700
x29: ffffffc0837ff700 x28: 0000000000000000
x27: 0000000000000000 x26: ffffffffffffffff
x25: ffffffc000d1b1d0 x24: ffffffffffffffff
x23: 0000000000a00000 x22: ffffffbfff5fffff
x21: 0000000000100000 x20: ffffffc2e21f7010
x19: ffffffffffffffff x18: 0000000000000000
x17: 0000007f9360a2b0 x16: ffffffc000541040
x15: ffffffffffffffff x14: ffffffffffffffff
x13: ffffffffffffffff x12: 0000000000000001
x11: 0000000000000068 x10: 0000000000000040
x9 : ffffffc000214e00 x8 : ffffffc2e54586b0
x7 : 0000000000000000 x6 : 0000000000000004
x5 : ffffffc000214d64 x4 : 0000000000000000
x3 : 0000000003ffffff x2 : 00000003ffffffff
x1 : 000fffffffffffff x0 : ffffffc000d3b2c0

Process malloc_dma_1 (pid: 1489, stack limit = 0xffffffc0837fc020)
Stack: (0xffffffc0837ff700 to 0xffffffc083800000)
f700: ffffffc0837ff730 ffffffc000214e00 0000000000100000 0000000000000000
f720: ffffffc2e21f7010 ffffffc0837ff7d0 ffffffc0837ff770 ffffffbffc1d6134
f740: ffffffc2e21f7010 00000000000001a0 0000000000000064 ffffffc0837ff7d0
f760: ffffffc000c9fa20 ffffffc0837ffaf0 ffffffc0837ffe10 ffffffc000239b0c
f780: ffffffc00d54a280 ffffffc000d1ef58 ffffffc000957163 ffffffc2e21f7000
[...]
Call trace:
[<ffffffc000214d10>] __dma_free_coherent.isra.10+0x74/0xc8
[<ffffffc000214e00>] __dma_free+0x9c/0xb0
[<ffffffbffc1d6134>] malloc_dma+0x104/0x158 [dma_alloc_coherent_mtmalloc]
[<ffffffc000239b0c>] kthread+0xec/0xfc

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/dma-mapping.h~dma-mapping-to-avoid-oops-when-parameter-cpu_addr-is-null include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-to-avoid-oops-when-parameter-cpu_addr-is-null
+++ a/include/linux/dma-mapping.h
@@ -386,7 +386,7 @@ static inline void dma_free_attrs(struct
 	if (dma_release_from_coherent(dev, get_order(size), cpu_addr))
 		return;
 
-	if (!ops->free)
+	if (!ops->free || !cpu_addr)
 		return;
 
 	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are


