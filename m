Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E747134AB
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 18:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722710559; cv=none; b=aqrna/m3KXp2MjnjqLabKzLDrD+F+F2AEIhumVNBgT4eNj4GtvYiyURPFwXkL0ljhFCUy/VuGg2E6Thb8w04sOod4hrSmFSDiXrVdGTXPckIkl0ENygsOv6A347ABwV20qLItoyKVT2MB+sEkVxZtz+TWa8YPkcKaVLLu+iX474=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722710559; c=relaxed/simple;
	bh=TzhKF36oERdfIpUOiWQQeDzstSGrOqJI9H3TV0hNX6I=;
	h=Date:To:From:Subject:Message-Id; b=GWx6PkG08mH/XnD3d8+UJlCrFIQcEn6ezfXZuLs1HQWq4NBF71vRvZ+HGKxcJCZjDUB7XRbCZql1RVLfcY9V6mEU92zmEtgsIVdNEzOieXKi9SiUzIhw9bImWKRedASn91XrsrFC7yKtXni5Rn/OzXEFHWERBVVrX9KEtJ34PGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jb4jxWEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jb4jxWEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D040EC116B1;
	Sat,  3 Aug 2024 18:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722710558;
	bh=TzhKF36oERdfIpUOiWQQeDzstSGrOqJI9H3TV0hNX6I=;
	h=Date:To:From:Subject:From;
	b=jb4jxWEO6v1tGOHZ2tvg67jI6hu3CSwtCECKih+hi6WtvcC2AolaiWg8xo7ybRK8c
	 EOJkqNV043fvAqSuRb4csP1+yo6Y+VLiXlSE/BeppnP0iADhmSwlPxkuIHJJ+3Axr3
	 /YaD6W1K275zfeDBSTveOaG+prxurOFWMOkIx9jw=
Date: Sat, 03 Aug 2024 11:42:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-numa-move-fake_node_-defines-to-numa_emu.patch added to mm-unstable branch
Message-Id: <20240803184238.D040EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/numa: move FAKE_NODE_* defines to numa_emu
has been added to the -mm mm-unstable branch.  Its filename is
     x86-numa-move-fake_node_-defines-to-numa_emu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-numa-move-fake_node_-defines-to-numa_emu.patch

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
Subject: x86/numa: move FAKE_NODE_* defines to numa_emu
Date: Thu, 1 Aug 2024 09:08:12 +0300

The definitions of FAKE_NODE_MIN_SIZE and FAKE_NODE_MIN_HASH_MASK are only
used by numa emulation code, make them local to
arch/x86/mm/numa_emulation.c

Link: https://lkml.kernel.org/r/20240801060826.559858-13-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> [arm64 + CXL via QEMU]
Tested-by: Zi Yan <ziy@nvidia.com>	[x86_64 and arm64]
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/numa.h  |    2 --
 arch/x86/mm/numa_emulation.c |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/numa.h~x86-numa-move-fake_node_-defines-to-numa_emu
+++ a/arch/x86/include/asm/numa.h
@@ -71,8 +71,6 @@ void debug_cpumask_set_cpu(int cpu, int
 #endif
 
 #ifdef CONFIG_NUMA_EMU
-#define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
-#define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
 int numa_emu_cmdline(char *str);
 #else /* CONFIG_NUMA_EMU */
 static inline int numa_emu_cmdline(char *str)
--- a/arch/x86/mm/numa_emulation.c~x86-numa-move-fake_node_-defines-to-numa_emu
+++ a/arch/x86/mm/numa_emulation.c
@@ -10,6 +10,9 @@
 
 #include "numa_internal.h"
 
+#define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
+#define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
+
 static int emu_nid_to_phys[MAX_NUMNODES];
 static char *emu_cmdline __initdata;
 
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

