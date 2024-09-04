Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C896BB39
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423436; cv=none; b=VWMVoxP7NMhQ92cs7jxhs3c8zeDXtkejut7nZX5SKIOWkDA8ZCfe5hY0DdHxcnx06Yk41okHx1h2bpCgIv2OUGxHHSl/kzpGH3SUp/T8QR3XGbHKRQM3BvQKnAoh5e6n+CtGc1d/tr/wlzamN7zpsmgFByXKhl5shLQse4vCz0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423436; c=relaxed/simple;
	bh=5aZnScrVl4mzw49Cuu3lRm3AmwxCBxjzWHzhp6Wh8YA=;
	h=Date:To:From:Subject:Message-Id; b=dP0Rb6TXrcUa1g4oqEGee0NRZzdqw6Ci0YhbY25KbfFuzv3K7r6Sk50WEmRClWulzmdhtrMpJpE33OZ1HMDMdhWglgxFLxdWBCCXtKaSpBCR7rffbQjwb6cRUwzMtoxA5FRmsAPauhEDHPXnxHfzcrWTkdcuDg34F/tDtnUOh0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l4jx9L+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l4jx9L+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6432DC4CEC2;
	Wed,  4 Sep 2024 04:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423436;
	bh=5aZnScrVl4mzw49Cuu3lRm3AmwxCBxjzWHzhp6Wh8YA=;
	h=Date:To:From:Subject:From;
	b=l4jx9L+WwtmGqiDKCi8y67CGEi7LLR6j+tphcX/Lza161+GFqNB9qZ+OrHgrK34XK
	 9JrDBveURkb1hWpDWz5t5D+Z+6U31ACghmrT9T5VO5EDvv/L7LsJWkLxwfGQPIrBXS
	 M+2t7ZIQzkhN9ThEOJvXvaWuByYyCmvclnBvc00c=
Date: Tue, 03 Sep 2024 21:17:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-numa_emu-use-a-helper-function-to-get-max_dma32_pfn.patch removed from -mm tree
Message-Id: <20240904041716.6432DC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/numa_emu: use a helper function to get MAX_DMA32_PFN
has been removed from the -mm tree.  Its filename was
     x86-numa_emu-use-a-helper-function-to-get-max_dma32_pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: x86/numa_emu: use a helper function to get MAX_DMA32_PFN
Date: Wed, 7 Aug 2024 09:40:59 +0300

This is required to make numa emulation code architecture independent so
that it can be moved to generic code in following commits.

Link: https://lkml.kernel.org/r/20240807064110.1003856-16-rppt@kernel.org
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

 arch/x86/include/asm/numa.h  |    1 +
 arch/x86/mm/numa.c           |    5 +++++
 arch/x86/mm/numa_emulation.c |    4 ++--
 3 files changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/numa.h~x86-numa_emu-use-a-helper-function-to-get-max_dma32_pfn
+++ a/arch/x86/include/asm/numa.h
@@ -74,6 +74,7 @@ void debug_cpumask_set_cpu(int cpu, int
 int numa_emu_cmdline(char *str);
 void __init numa_emu_update_cpu_to_node(int *emu_nid_to_phys,
 					unsigned int nr_emu_nids);
+u64 __init numa_emu_dma_end(void);
 #else /* CONFIG_NUMA_EMU */
 static inline int numa_emu_cmdline(char *str)
 {
--- a/arch/x86/mm/numa.c~x86-numa_emu-use-a-helper-function-to-get-max_dma32_pfn
+++ a/arch/x86/mm/numa.c
@@ -872,6 +872,11 @@ void __init numa_emu_update_cpu_to_node(
 		__apicid_to_node[i] = j < nr_emu_nids ? j : 0;
 	}
 }
+
+u64 __init numa_emu_dma_end(void)
+{
+	return PFN_PHYS(MAX_DMA32_PFN);
+}
 #endif /* CONFIG_NUMA_EMU */
 
 #ifdef CONFIG_NUMA_KEEP_MEMINFO
--- a/arch/x86/mm/numa_emulation.c~x86-numa_emu-use-a-helper-function-to-get-max_dma32_pfn
+++ a/arch/x86/mm/numa_emulation.c
@@ -128,7 +128,7 @@ static int __init split_nodes_interleave
 	 */
 	while (!nodes_empty(physnode_mask)) {
 		for_each_node_mask(i, physnode_mask) {
-			u64 dma32_end = PFN_PHYS(MAX_DMA32_PFN);
+			u64 dma32_end = numa_emu_dma_end();
 			u64 start, limit, end;
 			int phys_blk;
 
@@ -275,7 +275,7 @@ static int __init split_nodes_size_inter
 	 */
 	while (!nodes_empty(physnode_mask)) {
 		for_each_node_mask(i, physnode_mask) {
-			u64 dma32_end = PFN_PHYS(MAX_DMA32_PFN);
+			u64 dma32_end = numa_emu_dma_end();
 			u64 start, limit, end;
 			int phys_blk;
 
_

Patches currently in -mm which might be from rppt@kernel.org are


