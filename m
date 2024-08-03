Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39B919BB7
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 18:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722710523; cv=none; b=cyYrtAWDHd4Jk1zEIxVsO3JmuXQ81wmwwYC+uYpEA5uSZVbvmwyc0o0Kt+so7WsEScenWjb8ZJTz7+ajpAKDDR8ZJvnd8ux7tvvKramXyTpw382UqyQt3ly0TH89ZWD0yvSrFXUKaPxdOZgzcAwZ4tC3CzWLKmvXEgIZCeTDSxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722710523; c=relaxed/simple;
	bh=w/LA7QbRvpm75a5ip+K5fGmMCzoleF7fOp/eToUnOII=;
	h=Date:To:From:Subject:Message-Id; b=XzB3pxG6Rr12bziFbywmyVpBCw+jVdOsNePZrvovoZkoHXrwOrNEBr6lroErW9wdNGXpiVugwKyL5dU91JYoC5rUDYvDJiLMrCMeyIj2lkpjhC5k+sxYw+8r/Fa9oNAAR/5xgpAeGVfHE/5/IXvj1fC/G3b8LiC+mbEhCj85xbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t5oQEVta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t5oQEVta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68294C116B1;
	Sat,  3 Aug 2024 18:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722710523;
	bh=w/LA7QbRvpm75a5ip+K5fGmMCzoleF7fOp/eToUnOII=;
	h=Date:To:From:Subject:From;
	b=t5oQEVtaAdGglA2j1VqIsfOZpYI0+WhMZKoREm/m50lmTKJdzRGFUelk3KizjSljx
	 LB09HLseOV+50fceH/g6ftkvv1UlrKS5F816TBjHWkuBWzP2R/aBA4jGeBIY94hkjk
	 5qWO2SyGLM3Qwk0uJEq6PvrDEziDZtSlfdD0A4YE=
Date: Sat, 03 Aug 2024 11:42:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-sgi-ip27-drop-have_arch_nodedata_extension.patch added to mm-unstable branch
Message-Id: <20240803184203.68294C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MIPS: sgi-ip27: drop HAVE_ARCH_NODEDATA_EXTENSION
has been added to the -mm mm-unstable branch.  Its filename is
     mips-sgi-ip27-drop-have_arch_nodedata_extension.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-sgi-ip27-drop-have_arch_nodedata_extension.patch

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
Subject: MIPS: sgi-ip27: drop HAVE_ARCH_NODEDATA_EXTENSION
Date: Thu, 1 Aug 2024 09:08:04 +0300

Commit f8f9f21c7848 ("MIPS: Fix build error for loongson64 and sgi-ip27")
added HAVE_ARCH_NODEDATA_EXTENSION to sgi-ip27 to silence a compilation
error that happened because sgi-ip27 didn't define array of pg_data_t as
node_data like most other architectures did.

After addition of node_data array that matches other architectures and
after ensuring that offline nodes do not appear on node_possible_map, it
is safe to drop arch_alloc_nodedata() and HAVE_ARCH_NODEDATA_EXTENSION
from sgi-ip27.

Link: https://lkml.kernel.org/r/20240801060826.559858-5-rppt@kernel.org
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

 arch/mips/Kconfig                |    1 -
 arch/mips/sgi-ip27/ip27-memory.c |   10 ----------
 2 files changed, 11 deletions(-)

--- a/arch/mips/Kconfig~mips-sgi-ip27-drop-have_arch_nodedata_extension
+++ a/arch/mips/Kconfig
@@ -735,7 +735,6 @@ config SGI_IP27
 	select WAR_R10000_LLSC
 	select MIPS_L1_CACHE_SHIFT_7
 	select NUMA
-	select HAVE_ARCH_NODEDATA_EXTENSION
 	help
 	  This are the SGI Origin 200, Origin 2000 and Onyx 2 Graphics
 	  workstations.  To compile a Linux kernel that runs on these, say Y
--- a/arch/mips/sgi-ip27/ip27-memory.c~mips-sgi-ip27-drop-have_arch_nodedata_extension
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -426,13 +426,3 @@ void __init mem_init(void)
 	memblock_free_all();
 	setup_zero_pages();	/* This comes from node 0 */
 }
-
-pg_data_t * __init arch_alloc_nodedata(int nid)
-{
-	return memblock_alloc(sizeof(pg_data_t), SMP_CACHE_BYTES);
-}
-
-void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
-{
-	__node_data[nid] = (struct node_data *)pgdat;
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

