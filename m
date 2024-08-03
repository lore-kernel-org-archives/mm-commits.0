Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA127134AB
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 18:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722710528; cv=none; b=GZDGqPx1sSOOIwSsc7BMkdA+ugbySCIEwcRh3fdBuMqxAjccFZJzJe5uLBsqWNw8hfngulP05Jqe6SJzhaRjpJUhP3u73FjS7if0nqhurEprrh9EZeiyC3I5fyvaArLDxOw5uFXwy6KIc40AZs+9McTLrglvxzA+wrAQ8UD46qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722710528; c=relaxed/simple;
	bh=/l4agettmC3mfTZ4ihnjKIh1QGZzXYEooNVvFoJr5/k=;
	h=Date:To:From:Subject:Message-Id; b=WpJhh0GsiWjY4GlsArkC4Oc45ydytL8wkItyl4hT63RoH5+ohNMfV/9W/SXJvmCYGbE6uu4+SI34ZMbkjmGdakan3jLxTIvPS1qkCW4hKQliNfqMcfHLkEMkPib6i9hGK1GuVFEul07BPdJdGAEJ/d4h3rX0yyj4HuMBtER+GIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wpyYHTnZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wpyYHTnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E689C116B1;
	Sat,  3 Aug 2024 18:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722710528;
	bh=/l4agettmC3mfTZ4ihnjKIh1QGZzXYEooNVvFoJr5/k=;
	h=Date:To:From:Subject:From;
	b=wpyYHTnZcDF0fn+VfQBBLu4OD/2AUg70gEFz9sq05PyIysADlvqyF+A1SWwAZSmaM
	 eiKtWl4NcEdkUGm4Il+b+A0ka9acaMO5L1K4a1bDH6ABDpNGJpFOvL2/in4v25MtoJ
	 GuZBF4oV2rsjr8BJd8TMLGRmYvR03svBdzU+xiNw=
Date: Sat, 03 Aug 2024 11:42:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-loongson64-drop-have_arch_nodedata_extension.patch added to mm-unstable branch
Message-Id: <20240803184208.8E689C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MIPS: loongson64: drop HAVE_ARCH_NODEDATA_EXTENSION
has been added to the -mm mm-unstable branch.  Its filename is
     mips-loongson64-drop-have_arch_nodedata_extension.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-loongson64-drop-have_arch_nodedata_extension.patch

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
Subject: MIPS: loongson64: drop HAVE_ARCH_NODEDATA_EXTENSION
Date: Thu, 1 Aug 2024 09:08:06 +0300

Commit f8f9f21c7848 ("MIPS: Fix build error for loongson64 and sgi-ip27")
added HAVE_ARCH_NODEDATA_EXTENSION to loongson64 to silence a compilation
error that happened because loongson64 didn't define array of pg_data_t as
node_data like most other architectures did.

After rename of __node_data to node_data arch_alloc_nodedata() and
HAVE_ARCH_NODEDATA_EXTENSION can be dropped from loongson64.

Since it was the only user of HAVE_ARCH_NODEDATA_EXTENSION config option
also remove this option from arch/mips/Kconfig.

Link: https://lkml.kernel.org/r/20240801060826.559858-7-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> [arm64 + CXL via QEMU]
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
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
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig           |    4 ----
 arch/mips/loongson64/numa.c |   10 ----------
 2 files changed, 14 deletions(-)

--- a/arch/mips/Kconfig~mips-loongson64-drop-have_arch_nodedata_extension
+++ a/arch/mips/Kconfig
@@ -502,7 +502,6 @@ config MACH_LOONGSON64
 	select USE_OF
 	select BUILTIN_DTB
 	select PCI_HOST_GENERIC
-	select HAVE_ARCH_NODEDATA_EXTENSION if NUMA
 	help
 	  This enables the support of Loongson-2/3 family of machines.
 
@@ -2612,9 +2611,6 @@ config NUMA
 config SYS_SUPPORTS_NUMA
 	bool
 
-config HAVE_ARCH_NODEDATA_EXTENSION
-	bool
-
 config RELOCATABLE
 	bool "Relocatable kernel"
 	depends on SYS_SUPPORTS_RELOCATABLE
--- a/arch/mips/loongson64/numa.c~mips-loongson64-drop-have_arch_nodedata_extension
+++ a/arch/mips/loongson64/numa.c
@@ -198,13 +198,3 @@ void __init prom_init_numa_memory(void)
 	pr_info("CP0_PageGrain: CP0 5.1 (0x%x)\n", read_c0_pagegrain());
 	prom_meminit();
 }
-
-pg_data_t * __init arch_alloc_nodedata(int nid)
-{
-	return memblock_alloc(sizeof(pg_data_t), SMP_CACHE_BYTES);
-}
-
-void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
-{
-	node_data[nid] = pgdat;
-}
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-move-kernel-numac-to-mm.patch
mips-sgi-ip27-make-node_data-the-same-as-on-all-other-architectures.patch
mips-sgi-ip27-ensure-node_possible_map-only-contains-valid-nodes.patch
mips-sgi-ip27-drop-have_arch_nodedata_extension.patch
mips-loongson64-rename-__node_data-to-node_data.patch
mips-loongson64-drop-have_arch_nodedata_extension.patch
mm-drop-config_have_arch_nodedata_extension.patch
arch-mm-move-definition-of-node_data-to-generic-code.patch
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
mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks.patch
docs-move-numa=fake-description-to-kernel-parameterstxt.patch

