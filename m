Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3861474A2
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 20:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723064358; cv=none; b=T6jomb3tiiuuwQXhbD6lK7KAJUI7tq8hDmEBFG44aQseroioguifKU6ryJPvYzAdl7QcczfRSr7FmXQAQz4d0DmMFhtnmDby7HZGUpJ8gAYzsK2sFM/9odufGjaAFjP2ayouJOCLYimekO07Lks5vOwR2ueEYss14tdg04qnQ+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723064358; c=relaxed/simple;
	bh=K+FhN4szoZcSJ5JxBHggZ1UVamwH2/LeO+fh7ZEy6lk=;
	h=Date:To:From:Subject:Message-Id; b=nzveuYP7bn6RHvcGCs/dtT7hANAziMywkreSaEm3gLZ2VSClf5bLrhCNnWbVYImpujrTJagjndeXDL5ysqaDdNgknB9FlegwbAYZu/Jfv5CK9JlTC6PXeje1MUwprlOAqXI1A/gehcQKmki2sNzIZr0o+MY38cJOZ3f5Ybrf3l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aQkFEfxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aQkFEfxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F602C32781;
	Wed,  7 Aug 2024 20:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723064358;
	bh=K+FhN4szoZcSJ5JxBHggZ1UVamwH2/LeO+fh7ZEy6lk=;
	h=Date:To:From:Subject:From;
	b=aQkFEfxAsil0aRMFD93r0NpkpLAMmHbPfqKchEFGACeXSmlyl0gTAJuCjBb4TrHcV
	 drWFNtSnoK1XrhBZOdWP6qsMiUEetBw04fTdoi9sDsFZvX8hk8pdqUDP1mppAptwrR
	 Th4AmPy0yoBzRvoZ0zuhBArj56uhsJKAx3ffFH6g=
Date: Wed, 07 Aug 2024 13:59:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-numa-numa_addremove_cpu-make-cpu-parameter-unsigned.patch added to mm-unstable branch
Message-Id: <20240807205918.5F602C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/numa: numa_{add,remove}_cpu: make cpu parameter unsigned
has been added to the -mm mm-unstable branch.  Its filename is
     x86-numa-numa_addremove_cpu-make-cpu-parameter-unsigned.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-numa-numa_addremove_cpu-make-cpu-parameter-unsigned.patch

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
Subject: x86/numa: numa_{add,remove}_cpu: make cpu parameter unsigned
Date: Wed, 7 Aug 2024 09:41:00 +0300

CPU id cannot be negative.

Making it unsigned also aligns with declarations in
include/asm-generic/numa.h used by arm64 and riscv and allows sharing numa
emulation code with these architectures.

Link: https://lkml.kernel.org/r/20240807064110.1003856-17-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Zi Yan <ziy@nvidia.com> # for x86_64 and arm64
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> [arm64 + CXL via QEMU]
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
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
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/numa.h  |   10 +++++-----
 arch/x86/mm/numa.c           |   10 +++++-----
 arch/x86/mm/numa_emulation.c |   10 +++++-----
 3 files changed, 15 insertions(+), 15 deletions(-)

--- a/arch/x86/include/asm/numa.h~x86-numa-numa_addremove_cpu-make-cpu-parameter-unsigned
+++ a/arch/x86/include/asm/numa.h
@@ -54,20 +54,20 @@ static inline int numa_cpu_node(int cpu)
 extern void numa_set_node(int cpu, int node);
 extern void numa_clear_node(int cpu);
 extern void __init init_cpu_to_node(void);
-extern void numa_add_cpu(int cpu);
-extern void numa_remove_cpu(int cpu);
+extern void numa_add_cpu(unsigned int cpu);
+extern void numa_remove_cpu(unsigned int cpu);
 extern void init_gi_nodes(void);
 #else	/* CONFIG_NUMA */
 static inline void numa_set_node(int cpu, int node)	{ }
 static inline void numa_clear_node(int cpu)		{ }
 static inline void init_cpu_to_node(void)		{ }
-static inline void numa_add_cpu(int cpu)		{ }
-static inline void numa_remove_cpu(int cpu)		{ }
+static inline void numa_add_cpu(unsigned int cpu)	{ }
+static inline void numa_remove_cpu(unsigned int cpu)	{ }
 static inline void init_gi_nodes(void)			{ }
 #endif	/* CONFIG_NUMA */
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
-void debug_cpumask_set_cpu(int cpu, int node, bool enable);
+void debug_cpumask_set_cpu(unsigned int cpu, int node, bool enable);
 #endif
 
 #ifdef CONFIG_NUMA_EMU
--- a/arch/x86/mm/numa.c~x86-numa-numa_addremove_cpu-make-cpu-parameter-unsigned
+++ a/arch/x86/mm/numa.c
@@ -741,12 +741,12 @@ void __init init_cpu_to_node(void)
 #ifndef CONFIG_DEBUG_PER_CPU_MAPS
 
 # ifndef CONFIG_NUMA_EMU
-void numa_add_cpu(int cpu)
+void numa_add_cpu(unsigned int cpu)
 {
 	cpumask_set_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
 }
 
-void numa_remove_cpu(int cpu)
+void numa_remove_cpu(unsigned int cpu)
 {
 	cpumask_clear_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
 }
@@ -784,7 +784,7 @@ int early_cpu_to_node(int cpu)
 	return per_cpu(x86_cpu_to_node_map, cpu);
 }
 
-void debug_cpumask_set_cpu(int cpu, int node, bool enable)
+void debug_cpumask_set_cpu(unsigned int cpu, int node, bool enable)
 {
 	struct cpumask *mask;
 
@@ -816,12 +816,12 @@ static void numa_set_cpumask(int cpu, bo
 	debug_cpumask_set_cpu(cpu, early_cpu_to_node(cpu), enable);
 }
 
-void numa_add_cpu(int cpu)
+void numa_add_cpu(unsigned int cpu)
 {
 	numa_set_cpumask(cpu, true);
 }
 
-void numa_remove_cpu(int cpu)
+void numa_remove_cpu(unsigned int cpu)
 {
 	numa_set_cpumask(cpu, false);
 }
--- a/arch/x86/mm/numa_emulation.c~x86-numa-numa_addremove_cpu-make-cpu-parameter-unsigned
+++ a/arch/x86/mm/numa_emulation.c
@@ -514,7 +514,7 @@ no_emu:
 }
 
 #ifndef CONFIG_DEBUG_PER_CPU_MAPS
-void numa_add_cpu(int cpu)
+void numa_add_cpu(unsigned int cpu)
 {
 	int physnid, nid;
 
@@ -532,7 +532,7 @@ void numa_add_cpu(int cpu)
 			cpumask_set_cpu(cpu, node_to_cpumask_map[nid]);
 }
 
-void numa_remove_cpu(int cpu)
+void numa_remove_cpu(unsigned int cpu)
 {
 	int i;
 
@@ -540,7 +540,7 @@ void numa_remove_cpu(int cpu)
 		cpumask_clear_cpu(cpu, node_to_cpumask_map[i]);
 }
 #else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
-static void numa_set_cpumask(int cpu, bool enable)
+static void numa_set_cpumask(unsigned int cpu, bool enable)
 {
 	int nid, physnid;
 
@@ -560,12 +560,12 @@ static void numa_set_cpumask(int cpu, bo
 	}
 }
 
-void numa_add_cpu(int cpu)
+void numa_add_cpu(unsigned int cpu)
 {
 	numa_set_cpumask(cpu, true);
 }
 
-void numa_remove_cpu(int cpu)
+void numa_remove_cpu(unsigned int cpu)
 {
 	numa_set_cpumask(cpu, false);
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

