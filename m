Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4552F34
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725421702; cv=none; b=B1KtUSC4mrF+rXI1GWNGgUMoNvcSQAxvgIC0aBn9oZqK8Fpr4zxldWDXKAdNg8npgfYKvFH9pRUqvSfJ1AudvyCPBSpP2Abef1hcT+w2HzRE3+GrGP7jLCfYA/KOxVtEwaBcWYvfU5N2nNkcxE5pj6Y+juxeFUbWcyuADaTaTHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725421702; c=relaxed/simple;
	bh=yY1A1SOxY5Ex3GGwSMzC/fP3jBSnTfmBif2bsUCEEVY=;
	h=Date:To:From:Subject:Message-Id; b=WAIyyaZOQpLFVFpnTI7AWfO6KVroAyWKevcjuQiCBO0fyh5OzHQ8KVELSBpPTVMQ0ky5qfsOoW1gPk3Vjo+2kfw0G0NK+t0iTPX5XF0UsX63upjfPcN++BBzf2bMc6JZy0//mA0lD75o7JfXoUwmiEKrSeUy0M5i9yCA7TXoLeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kxMrU8mP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kxMrU8mP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B4AC4CEC2;
	Wed,  4 Sep 2024 03:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725421701;
	bh=yY1A1SOxY5Ex3GGwSMzC/fP3jBSnTfmBif2bsUCEEVY=;
	h=Date:To:From:Subject:From;
	b=kxMrU8mPRiVNLj/VtyZRKD9KsiHvNAj+4jgN3L3LfM96xz6Ul1FvlhzLJTMunqZ1M
	 0cg2pT86zcuP6fPO5aLwpvXZPA3T5kgHVuP6yuU4knvdWifh+QqMFNASL0k9eV/ux4
	 R1VtYKn0D569NclXNvm41QSSWs4Nmw1YLcoiXbmg=
Date: Tue, 03 Sep 2024 20:48:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arch_numa-switch-over-to-numa_memblks-fix.patch removed from -mm tree
Message-Id: <20240904034821.A4B4AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch_numa-switch-over-to-numa_memblks-fix
has been removed from the -mm tree.  Its filename was
     arch_numa-switch-over-to-numa_memblks-fix.patch

This patch was dropped because it was folded into arch_numa-switch-over-to-numa_memblks.patch

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: arch_numa-switch-over-to-numa_memblks-fix
Date: Wed, 7 Aug 2024 21:18:24 +0300

fix section mismatch

Link: https://lkml.kernel.org/r/ZrO6cExVz1He_yPn@kernel.org
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
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
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
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

 include/asm-generic/numa.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/numa.h~arch_numa-switch-over-to-numa_memblks-fix
+++ a/include/asm-generic/numa.h
@@ -33,7 +33,7 @@ static inline const struct cpumask *cpum
 void __init arch_numa_init(void);
 int __init numa_add_memblk(int nodeid, u64 start, u64 end);
 void __init early_map_cpu_to_node(unsigned int cpu, int nid);
-int __init early_cpu_to_node(int cpu);
+int early_cpu_to_node(int cpu);
 void numa_store_cpu_info(unsigned int cpu);
 void numa_add_cpu(unsigned int cpu);
 void numa_remove_cpu(unsigned int cpu);
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
arch_numa-switch-over-to-numa_memblks-fix-2.patch
mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks.patch
mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks-fix.patch
docs-move-numa=fake-description-to-kernel-parameterstxt.patch

