Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC5EDDAD;
	Thu, 28 Nov 2024 00:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732754236; cv=none; b=arMeSwYJv4swqm7R/POL52rm8hIvUAAAtRQzzt53fplh2VXkUT1hMcb9yZdcgyIOPuHARdczBc2H7R31sa3CQX5YDER1TH/Q/H+RZNy6dro8luLJk8R5TIFwPc+z2hP2DvIV9orkaQJSQAleug0GdfxkMEeM5rUR8QT3kfWzx9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732754236; c=relaxed/simple;
	bh=FWHjqHt/5UePxj/CY/LBmx5HEwRp8/OhCi4uBmLQAc8=;
	h=Date:To:From:Subject:Message-Id; b=iwFOtg6rmDDs5n1V4dIeRugfq32UG49w6U5PGeWT8UMO4bAXRcIi7H5fvNgV4wRzSYaaPl+Rx1AHc8Ooa/WwYuxm+OP7/btgNnXTuqmol/rlwnLorLOsFAxXl7IiQmhmX/QtX/PVVvJo2ij93FAR9r8qmG8GmarShijt8ZffQ2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kMpkGrp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kMpkGrp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6071C4CECC;
	Thu, 28 Nov 2024 00:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732754235;
	bh=FWHjqHt/5UePxj/CY/LBmx5HEwRp8/OhCi4uBmLQAc8=;
	h=Date:To:From:Subject:From;
	b=kMpkGrp1jfsoKUswDdbuDyBjZLMisaDcWwkUOCdn8ABa5p/ozEVn++3Drgq+MohJH
	 ink4ZGo7FDX1jvV1PYux+AVEJWac+98sy50CciGkcIBWFKktmEFfgMMdOenoKwE2AF
	 DPjpIbnCc6p36YtWx0J7eA+UH4twbL+RdHcHakL8=
Date: Wed, 27 Nov 2024 16:37:15 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,stable@vger.kernel.org,rppt@kernel.org,david@redhat.com,dan.j.williams@intel.com,catalin.marinas@arm.com,maz@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch_numa-restore-nid-checks-before-registering-a-memblock-with-a-node.patch added to mm-hotfixes-unstable branch
Message-Id: <20241128003715.B6071C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch_numa: restore nid checks before registering a memblock with a node
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     arch_numa-restore-nid-checks-before-registering-a-memblock-with-a-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch_numa-restore-nid-checks-before-registering-a-memblock-with-a-node.patch

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
From: Marc Zyngier <maz@kernel.org>
Subject: arch_numa: restore nid checks before registering a memblock with a node
Date: Wed, 27 Nov 2024 19:30:00 +0000

Commit 767507654c22 ("arch_numa: switch over to numa_memblks")
significantly cleaned up the NUMA registration code, but also dropped a
significant check that was refusing to accept to configure a memblock with
an invalid nid.

On "quality hardware" such as my ThunderX machine, this results
in a kernel that dies immediately:

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x431f0a10]
[    0.000000] Linux version 6.12.0-00013-g8920d74cf8db (maz@valley-girl) (gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40) #3872 SMP PREEMPT Wed Nov 27 15:25:49 GMT 2024
[    0.000000] KASLR disabled due to lack of seed
[    0.000000] Machine model: Cavium ThunderX CN88XX board
[    0.000000] efi: EFI v2.4 by American Megatrends
[    0.000000] efi: ESRT=0xffce0ff18 SMBIOS 3.0=0xfffb0000 ACPI 2.0=0xffec60000 MEMRESERVE=0xffc905d98
[    0.000000] esrt: Reserving ESRT space from 0x0000000ffce0ff18 to 0x0000000ffce0ff50.
[    0.000000] earlycon: pl11 at MMIO 0x000087e024000000 (options '115200n8')
[    0.000000] printk: legacy bootconsole [pl11] enabled
[    0.000000] NODE_DATA(0) allocated [mem 0xff6754580-0xff67566bf]
[    0.000000] Unable to handle kernel paging request at virtual address 0000000000001d40
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
[    0.000000] [0000000000001d40] user address but active_mm is swapper
[    0.000000] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.12.0-00013-g8920d74cf8db #3872
[    0.000000] Hardware name: Cavium ThunderX CN88XX board (DT)
[    0.000000] pstate: a00000c5 (NzCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.000000] pc : sparse_init_nid+0x54/0x428
[    0.000000] lr : sparse_init+0x118/0x240
[    0.000000] sp : ffff800081da3cb0
[    0.000000] x29: ffff800081da3cb0 x28: 0000000fedbab10c x27: 0000000000000001
[    0.000000] x26: 0000000ffee250f8 x25: 0000000000000001 x24: ffff800082102cd0
[    0.000000] x23: 0000000000000001 x22: 0000000000000000 x21: 00000000001fffff
[    0.000000] x20: 0000000000000001 x19: 0000000000000000 x18: ffffffffffffffff
[    0.000000] x17: 0000000001b00000 x16: 0000000ffd130000 x15: 0000000000000000
[    0.000000] x14: 00000000003e0000 x13: 00000000000001c8 x12: 0000000000000014
[    0.000000] x11: ffff800081e82860 x10: ffff8000820fb2c8 x9 : ffff8000820fb490
[    0.000000] x8 : 0000000000ffed20 x7 : 0000000000000014 x6 : 00000000001fffff
[    0.000000] x5 : 00000000ffffffff x4 : 0000000000000000 x3 : 0000000000000000
[    0.000000] x2 : 0000000000000000 x1 : 0000000000000040 x0 : 0000000000000007
[    0.000000] Call trace:
[    0.000000]  sparse_init_nid+0x54/0x428
[    0.000000]  sparse_init+0x118/0x240
[    0.000000]  bootmem_init+0x70/0x1c8
[    0.000000]  setup_arch+0x184/0x270
[    0.000000]  start_kernel+0x74/0x670
[    0.000000]  __primary_switched+0x80/0x90
[    0.000000] Code: f865d804 d37df060 cb030000 d2800003 (b95d4084)
[    0.000000] ---[ end trace 0000000000000000 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---

while previous kernel versions were able to recognise how brain-damaged
the machine is, and only build a fake node.

Restoring the check brings back some sanity and a "working" system.

Link: https://lkml.kernel.org/r/20241127193000.3702637-1-maz@kernel.org
Fixes: 767507654c22 ("arch_numa: switch over to numa_memblks")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/arch_numa.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/base/arch_numa.c~arch_numa-restore-nid-checks-before-registering-a-memblock-with-a-node
+++ a/drivers/base/arch_numa.c
@@ -207,7 +207,21 @@ static void __init setup_node_data(int n
 static int __init numa_register_nodes(void)
 {
 	int nid;
+	struct memblock_region *mblk;
 
+	/* Check that valid nid is set to memblks */
+	for_each_mem_region(mblk) {
+		int mblk_nid = memblock_get_region_node(mblk);
+		phys_addr_t start = mblk->base;
+		phys_addr_t end = mblk->base + mblk->size - 1;
+
+		if (mblk_nid == NUMA_NO_NODE || mblk_nid >= MAX_NUMNODES) {
+			pr_warn("Warning: invalid memblk node %d [mem %pap-%pap]\n",
+				mblk_nid, &start, &end);
+			return -EINVAL;
+		}
+	}
+ 
 	/* Finally register nodes. */
 	for_each_node_mask(nid, numa_nodes_parsed) {
 		unsigned long start_pfn, end_pfn;
_

Patches currently in -mm which might be from maz@kernel.org are

arch_numa-restore-nid-checks-before-registering-a-memblock-with-a-node.patch

