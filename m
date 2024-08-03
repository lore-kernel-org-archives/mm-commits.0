Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDF5134AB
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 18:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722710556; cv=none; b=TX92GszA7JWcUltw3OGFPs4CPbOsEbdkMjfRqt+YWY/9RKSmGG8KTaq/uTB1hD1XElfqurfv3W6nT+K5hS/QbPMKXRKG/Td/YFWGxu4NY3e3COgJzKQC0B7tOXeLEDRx1cdN5V7iMhEPT5l4inUFPoXWkaCnL5EE77UIPuy6hgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722710556; c=relaxed/simple;
	bh=yvGI/hpTpuDl/ciCJ2N9Vn+bVQ9XG2MrnUYPEezXz0A=;
	h=Date:To:From:Subject:Message-Id; b=Z/rtx7O9Gp0yDq1VzSTkvYMC0MOLm8BIJ9Au/7AKqXHUvfxssShAJ/1bRZUdMf6bO2Cx1JyPGIMm4xtguJKuR/5N4TnxgYutWW2gMnCpwCVQUli8FkMjG/XVYDPq59nD0B0mqIB8EjjrC6b12zKZqa6dkZ8zulLPLfGnLg/Vu60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r1Zz2E+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r1Zz2E+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC30C116B1;
	Sat,  3 Aug 2024 18:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722710556;
	bh=yvGI/hpTpuDl/ciCJ2N9Vn+bVQ9XG2MrnUYPEezXz0A=;
	h=Date:To:From:Subject:From;
	b=r1Zz2E+42qIt/qw9KPNv1Mn0V2DlTkjjE4xIFAy+W4Q3Fl7aEVuu/m23Tvds97ICi
	 nMP7p7/8dHpgxOndZ7ZzfZV61iwZ7XOaae8LclKW84SsvPg699HqRuOOe+/CElvvR6
	 qcgcs0C6BRiSmV06aoVGHx/0urRhs+R5bGl4pDYs=
Date: Sat, 03 Aug 2024 11:42:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-numa-use-get_pfn_range_for_nid-to-verify-that-node-spans-memory.patch added to mm-unstable branch
Message-Id: <20240803184236.8CC30C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/numa: use get_pfn_range_for_nid to verify that node spans memory
has been added to the -mm mm-unstable branch.  Its filename is
     x86-numa-use-get_pfn_range_for_nid-to-verify-that-node-spans-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-numa-use-get_pfn_range_for_nid-to-verify-that-node-spans-memory.patch

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
Subject: x86/numa: use get_pfn_range_for_nid to verify that node spans memory
Date: Thu, 1 Aug 2024 09:08:11 +0300

Instead of looping over numa_meminfo array to detect node's start and end
addresses use get_pfn_range_for_init().

This is shorter and make it easier to lift numa_memblks to generic code.

Link: https://lkml.kernel.org/r/20240801060826.559858-12-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Zi Yan <ziy@nvidia.com>	[x86_64 and arm64]
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/arch/x86/mm/numa.c~x86-numa-use-get_pfn_range_for_nid-to-verify-that-node-spans-memory
+++ a/arch/x86/mm/numa.c
@@ -521,17 +521,10 @@ static int __init numa_register_memblks(
 
 	/* Finally register nodes. */
 	for_each_node_mask(nid, node_possible_map) {
-		u64 start = PFN_PHYS(max_pfn);
-		u64 end = 0;
+		unsigned long start_pfn, end_pfn;
 
-		for (i = 0; i < mi->nr_blks; i++) {
-			if (nid != mi->blk[i].nid)
-				continue;
-			start = min(mi->blk[i].start, start);
-			end = max(mi->blk[i].end, end);
-		}
-
-		if (start >= end)
+		get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
+		if (start_pfn >= end_pfn)
 			continue;
 
 		alloc_node_data(nid);
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

