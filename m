Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62AD145A07
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 20:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723064335; cv=none; b=sO6R+eY3s4cR9Ey04OwtgqO3pzu05t3MVsMPNzHYZZ3VWl3vC6biON53KxjfYkfCWkGmu+Y5QR02SUaKJUDuJwi4OoiuB9FANL62bjIxv7Cp7uth5koqJgdmLfkRDBlxoGsdfeb/VtGpwY2vy79eLbiuQNXBJYnfPd02KRe2k6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723064335; c=relaxed/simple;
	bh=qO3gBTbnUPW3ci0NnH2nCXy9n+XOvOtvoXiiAHeBuRI=;
	h=Date:To:From:Subject:Message-Id; b=XzNcydpyPR+xZ3MSv1YrTdltn6zN0vW6rQkmvSMs7RNY1mHxVFEDn1mbPRpu84KEA21Cl96zAYmTOfdytpUarG6hj8xbCSo0+WvMQr59dp1WEO+XhV9HOmyvWskq01UPsLtdAjIwUvXkUxDhBnpiqwvw1hex/GPMiylmO4uI+Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t6z1KiKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t6z1KiKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A25AC32781;
	Wed,  7 Aug 2024 20:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723064334;
	bh=qO3gBTbnUPW3ci0NnH2nCXy9n+XOvOtvoXiiAHeBuRI=;
	h=Date:To:From:Subject:From;
	b=t6z1KiKelQzkZxqBO9NVyPOV5ysB0wpDr9SWyZoKXAHWVysuJjm1Jg/Nhpyu8nv0b
	 zSVZDMazwrj4a3O3D74Fl05OVPZMf5kassdShFKKxZC1tdGgD/1A08SOWeiBNkXz71
	 t2Yx8U66pLWRfsXeMn5Z0H4mtI9v2gQ8LbW4liN4=
Date: Wed, 07 Aug 2024 13:58:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-loongson64-rename-__node_data-to-node_data.patch added to mm-unstable branch
Message-Id: <20240807205854.6A25AC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MIPS: loongson64: rename __node_data to node_data
has been added to the -mm mm-unstable branch.  Its filename is
     mips-loongson64-rename-__node_data-to-node_data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-loongson64-rename-__node_data-to-node_data.patch

This patch will later appear in the mm-unstable branch at
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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MIPS: loongson64: rename __node_data to node_data
Date: Wed, 7 Aug 2024 09:40:49 +0300

Make definition of node_data match other architectures.  This will allow
pulling declaration of node_data to the generic mm code in the following
commit.

Link: https://lkml.kernel.org/r/20240807064110.1003856-6-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> [arm64 + CXL via QEMU]
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Rob Herring (Arm) <robh@kernel.org>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/mach-loongson64/mmzone.h |    4 ++--
 arch/mips/loongson64/numa.c                    |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/mips/include/asm/mach-loongson64/mmzone.h~mips-loongson64-rename-__node_data-to-node_data
+++ a/arch/mips/include/asm/mach-loongson64/mmzone.h
@@ -14,9 +14,9 @@
 #define pa_to_nid(addr)  (((addr) & 0xf00000000000) >> NODE_ADDRSPACE_SHIFT)
 #define nid_to_addrbase(nid) ((unsigned long)(nid) << NODE_ADDRSPACE_SHIFT)
 
-extern struct pglist_data *__node_data[];
+extern struct pglist_data *node_data[];
 
-#define NODE_DATA(n)		(__node_data[n])
+#define NODE_DATA(n)		(node_data[n])
 
 extern void __init prom_init_numa_memory(void);
 
--- a/arch/mips/loongson64/numa.c~mips-loongson64-rename-__node_data-to-node_data
+++ a/arch/mips/loongson64/numa.c
@@ -29,8 +29,8 @@
 
 unsigned char __node_distances[MAX_NUMNODES][MAX_NUMNODES];
 EXPORT_SYMBOL(__node_distances);
-struct pglist_data *__node_data[MAX_NUMNODES];
-EXPORT_SYMBOL(__node_data);
+struct pglist_data *node_data[MAX_NUMNODES];
+EXPORT_SYMBOL(node_data);
 
 cpumask_t __node_cpumask[MAX_NUMNODES];
 EXPORT_SYMBOL(__node_cpumask);
@@ -107,7 +107,7 @@ static void __init node_mem_init(unsigne
 	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
 	if (tnid != node)
 		pr_info("NODE_DATA(%d) on node %d\n", node, tnid);
-	__node_data[node] = nd;
+	node_data[node] = nd;
 	NODE_DATA(node)->node_start_pfn = start_pfn;
 	NODE_DATA(node)->node_spanned_pages = end_pfn - start_pfn;
 
@@ -206,5 +206,5 @@ pg_data_t * __init arch_alloc_nodedata(i
 
 void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
 {
-	__node_data[nid] = pgdat;
+	node_data[nid] = pgdat;
 }
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-move-kernel-numac-to-mm.patch
mips-sgi-ip27-make-node_data-the-same-as-on-all-other-architectures.patch
mips-sgi-ip27-ensure-node_possible_map-only-contains-valid-nodes.patch
mips-sgi-ip27-drop-have_arch_nodedata_extension.patch
mips-loongson64-rename-__node_data-to-node_data.patch
mips-loongson64-drop-have_arch_nodedata_extension.patch
arch-mm-move-definition-of-node_data-to-generic-code.patch
mm-drop-config_have_arch_nodedata_extension.patch
arch-mm-pull-out-allocation-of-node_data-to-generic-code.patch
x86-numa-simplify-numa_distance-allocation.patch
x86-numa-use-get_pfn_range_for_nid-to-verify-that-node-spans-memory.patch
x86-numa-move-fake_node_-defines-to-numa_emu.patch
x86-numa_emu-simplify-allocation-of-phys_dist.patch
x86-numa_emu-split-__apicid_to_node-update-to-a-helper-function.patch
x86-numa_emu-use-a-helper-function-to-get-max_dma32_pfn.patch
x86-numa-numa_addremove_cpu-make-cpu-parameter-unsigned.patch
mm-introduce-numa_memblks.patch
mm-move-numa_distance-and-related-code-from-x86-to-numa_memblks.patch
mm-introduce-numa_emulation.patch
mm-numa_memblks-introduce-numa_memblks_init.patch
mm-numa_memblks-make-several-functions-and-variables-static.patch
mm-numa_memblks-use-memblock_startend_of_dram-when-sanitizing-meminfo.patch
of-numa-return-einval-when-no-numa-node-id-is-found.patch
arch_numa-switch-over-to-numa_memblks.patch
arch_numa-switch-over-to-numa_memblks-fix.patch
mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks.patch
docs-move-numa=fake-description-to-kernel-parameterstxt.patch

