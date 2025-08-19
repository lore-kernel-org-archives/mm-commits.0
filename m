Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84EC3054E4;
	Tue, 19 Aug 2025 22:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755642008; cv=none; b=NDKfo2zzQ6v60zsu9IdMqDsjRY1C536LVlNJ6ZnTb2kVnhTUIxSZEIkwHzcKPZ4DtTJ76OAwO009BPD+J2wjBFD1h9ZOVQyfscjOCTo0Esb5wp1RQIVIR0dAK7u8a5f61qcQqA0B1tYLL/OXwE1fYoU+FZVob0vRxDZZVLg4Pt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755642008; c=relaxed/simple;
	bh=amtZG8WQ1bxcO7LNmyzUOwbkw8Qx7NWEPSn7PF7VNrQ=;
	h=Date:To:From:Subject:Message-Id; b=s4NhRmOsInttEiDYnkUCq6P7IvRT++I7yQA0heWHPjQNVQ1lf6/QGPtEGknGHKROCZ7f9jQczf/L010/gjCk2ziiFhGI/c13uNO8P7W2GZi2zxtQ01iMNqKxsDCJMfVN2gxXjig1JAlC8fbw1Vp9NCXs1Xdx/TXB9F97vwVhv3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jLYh2YsV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jLYh2YsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7481DC19422;
	Tue, 19 Aug 2025 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755642007;
	bh=amtZG8WQ1bxcO7LNmyzUOwbkw8Qx7NWEPSn7PF7VNrQ=;
	h=Date:To:From:Subject:From;
	b=jLYh2YsVP0pgr2TPaNQh6WBCgr03ljDhMQp8irpkgu1qBRiAXhcEXiWfN16tuKx5a
	 9g9eqOb5MpHTq9LQj6RFllKzQ1G2Q0807VUvQ/awVu3trJOgJgMGLWin6L3CF9bc5d
	 bHtSzRXVOGevmDzD40Of9MWXVU1o3meIiuigmt7k=
Date: Tue, 19 Aug 2025 15:20:06 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,saravanak@google.com,rppt@kernel.org,robh@kernel.org,Jonathan.Cameron@huawei.com,david@redhat.com,dan.j.williams@intel.com,chenjun102@huawei.com,yintirui@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + of_numa-fix-uninitialized-memory-nodes-causing-kernel-panic.patch added to mm-hotfixes-unstable branch
Message-Id: <20250819222007.7481DC19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: of_numa: fix uninitialized memory nodes causing kernel panic
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     of_numa-fix-uninitialized-memory-nodes-causing-kernel-panic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/of_numa-fix-uninitialized-memory-nodes-causing-kernel-panic.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yin Tirui <yintirui@huawei.com>
Subject: of_numa: fix uninitialized memory nodes causing kernel panic
Date: Tue, 19 Aug 2025 15:55:10 +0800

When there are memory-only nodes (nodes without CPUs), these nodes are not
properly initialized, causing kernel panic during boot.

of_numa_init
	of_numa_parse_cpu_nodes
		node_set(nid, numa_nodes_parsed);
	of_numa_parse_memory_nodes

In of_numa_parse_cpu_nodes, numa_nodes_parsed gets updated only for nodes
containing CPUs.  Memory-only nodes should have been updated in
of_numa_parse_memory_nodes, but they weren't.

Subsequently, when free_area_init() attempts to access NODE_DATA() for
these uninitialized memory nodes, the kernel panics due to NULL pointer
dereference.

This can be reproduced on ARM64 QEMU with 1 CPU and 2 memory nodes:

qemu-system-aarch64 \
-cpu host -nographic \
-m 4G -smp 1 \
-machine virt,accel=kvm,gic-version=3,iommu=smmuv3 \
-object memory-backend-ram,size=2G,id=mem0 \
-object memory-backend-ram,size=2G,id=mem1 \
-numa node,nodeid=0,memdev=mem0 \
-numa node,nodeid=1,memdev=mem1 \
-kernel $IMAGE \
-hda $DISK \
-append "console=ttyAMA0 root=/dev/vda rw earlycon"

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x481fd010]
[    0.000000] Linux version 6.17.0-rc1-00001-gabb4b3daf18c-dirty (yintirui@local) (gcc (GCC) 12.3.1, GNU ld (GNU Binutils) 2.41) #52 SMP PREEMPT Mon Aug 18 09:49:40 CST 2025
[    0.000000] KASLR enabled
[    0.000000] random: crng init done
[    0.000000] Machine model: linux,dummy-virt
[    0.000000] efi: UEFI not found.
[    0.000000] earlycon: pl11 at MMIO 0x0000000009000000 (options '')
[    0.000000] printk: legacy bootconsole [pl11] enabled
[    0.000000] OF: reserved mem: Reserved memory: No reserved-memory node in the DT
[    0.000000] NODE_DATA(0) allocated [mem 0xbfffd9c0-0xbfffffff]
[    0.000000] node 1 must be removed before remove section 23
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000040000000-0x00000000ffffffff]
[    0.000000]   DMA32    empty
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000013fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000040000000-0x00000000bfffffff]
[    0.000000]   node   1: [mem 0x00000000c0000000-0x000000013fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000040000000-0x00000000bfffffff]
[    0.000000] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000a0
[    0.000000] Mem abort info:
[    0.000000]   ESR = 0x0000000096000004
[    0.000000]   EC = 0x25: DABT (current EL), IL = 32 bits
[    0.000000]   SET = 0, FnV = 0
[    0.000000]   EA = 0, S1PTW = 0
[    0.000000]   FSC = 0x04: level 0 translation fault
[    0.000000] Data abort info:
[    0.000000]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[    0.000000]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    0.000000]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[    0.000000] [00000000000000a0] user address but active_mm is swapper
[    0.000000] Internal error: Oops: 0000000096000004 [#1]  SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.17.0-rc1-00001-g760c6dabf762-dirty #54 PREEMPT
[    0.000000] Hardware name: linux,dummy-virt (DT)
[    0.000000] pstate: 800000c5 (Nzcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.000000] pc : free_area_init+0x50c/0xf9c
[    0.000000] lr : free_area_init+0x5c0/0xf9c
[    0.000000] sp : ffffa02ca0f33c00
[    0.000000] x29: ffffa02ca0f33cb0 x28: 0000000000000000 x27: 0000000000000000
[    0.000000] x26: 4ec4ec4ec4ec4ec5 x25: 00000000000c0000 x24: 00000000000c0000
[    0.000000] x23: 0000000000040000 x22: 0000000000000000 x21: ffffa02ca0f3b368
[    0.000000] x20: ffffa02ca14c7b98 x19: 0000000000000000 x18: 0000000000000002
[    0.000000] x17: 000000000000cacc x16: 0000000000000001 x15: 0000000000000001
[    0.000000] x14: 0000000080000000 x13: 0000000000000018 x12: 0000000000000002
[    0.000000] x11: ffffa02ca0fd4f00 x10: ffffa02ca14bab20 x9 : ffffa02ca14bab38
[    0.000000] x8 : 00000000000c0000 x7 : 0000000000000001 x6 : 0000000000000002
[    0.000000] x5 : 0000000140000000 x4 : ffffa02ca0f33c90 x3 : ffffa02ca0f33ca0
[    0.000000] x2 : ffffa02ca0f33c98 x1 : 0000000080000000 x0 : 0000000000000001
[    0.000000] Call trace:
[    0.000000]  free_area_init+0x50c/0xf9c (P)
[    0.000000]  bootmem_init+0x110/0x1dc
[    0.000000]  setup_arch+0x278/0x60c
[    0.000000]  start_kernel+0x70/0x748
[    0.000000]  __primary_switched+0x88/0x90
[    0.000000] Code: d503201f b98093e0 52800016 f8607a93 (f9405260)
[    0.000000] ---[ end trace 0000000000000000 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---

Link: https://lkml.kernel.org/r/20250819075510.2079961-1-yintirui@huawei.com
Fixes: 767507654c22 ("arch_numa: switch over to numa_memblks")
Signed-off-by: Yin Tirui <yintirui@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Chen Jun <chenjun102@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/of_numa.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/of/of_numa.c~of_numa-fix-uninitialized-memory-nodes-causing-kernel-panic
+++ a/drivers/of/of_numa.c
@@ -59,8 +59,11 @@ static int __init of_numa_parse_memory_n
 			r = -EINVAL;
 		}
 
-		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++)
+		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++) {
 			r = numa_add_memblk(nid, rsrc.start, rsrc.end + 1);
+			if (!r)
+				node_set(nid, numa_nodes_parsed);
+		}
 
 		if (!i || r) {
 			of_node_put(np);
_

Patches currently in -mm which might be from yintirui@huawei.com are

of_numa-fix-uninitialized-memory-nodes-causing-kernel-panic.patch

