Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4531C6B7
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 18:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722710590; cv=none; b=P8XcOYjOrIkN9Md7NnhlKFbuEKym+tEKlrEWWA1FZKfie5NgWTdM4ykHBVQnbwtbeV94Nz05qfOElNBwA8DvmnaCYPa6Psb1nDl8uMXUQBQOb37EAk441WzDwR16D4igyM38Rfpm9fsEkiZ+NbyZjoBNnjP+xujXyACMirFheNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722710590; c=relaxed/simple;
	bh=75YWcu675W4PGs0B63Qo4uQwEamXy4qEjarEcuWy8mA=;
	h=Date:To:From:Subject:Message-Id; b=AJ722DXMb2dBr47J8OQQIB4/8Zu57rr7WN9TuHCHCDhaRYeP8fbkfvComWkqplwStuDH9DmS8Hq/P87Uzl8vlq/f4SLzINPBm3cweQmWYCeS8HfTPe7WQV1RulSu01bZkiGual0iWdCHoQUX29DptfptgtKUDJ4XF0CQemRTz4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OoKccFxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OoKccFxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D65C116B1;
	Sat,  3 Aug 2024 18:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722710590;
	bh=75YWcu675W4PGs0B63Qo4uQwEamXy4qEjarEcuWy8mA=;
	h=Date:To:From:Subject:From;
	b=OoKccFxkP7DcaTY9ncApMyxIqDo/RSPTf/SOABE5tFYmQLVWtXDw3MH5mGSpvz6KA
	 mmhFVnc15sFIikVwFoCkO6zoF0s2LiUWf2vza9U2HbZjTX2c4eN4rtcaGGrV0Fmrfq
	 250HUJPssIYWRkZ614Pofe5Jjcql6cwjGtjnN44k=
Date: Sat, 03 Aug 2024 11:43:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-numa_memblks-introduce-numa_memblks_init.patch added to mm-unstable branch
Message-Id: <20240803184310.95D65C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: numa_memblks: introduce numa_memblks_init
has been added to the -mm mm-unstable branch.  Its filename is
     mm-numa_memblks-introduce-numa_memblks_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-numa_memblks-introduce-numa_memblks_init.patch

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
Subject: mm: numa_memblks: introduce numa_memblks_init
Date: Thu, 1 Aug 2024 09:08:20 +0300

Move most of x86::numa_init() to numa_memblks so that the latter will be
more self-contained.

With this numa_memblk data structures should not be exposed to the
architecture specific code.

Link: https://lkml.kernel.org/r/20240801060826.559858-21-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Zi Yan <ziy@nvidia.com>	[x86_64 and arm64]
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> [arm64 + CXL via QEMU]
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
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

 arch/x86/mm/numa.c           |   40 +++-----------------------------
 include/linux/numa_memblks.h |    3 ++
 mm/numa_memblks.c            |   41 +++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 36 deletions(-)

--- a/arch/x86/mm/numa.c~mm-numa_memblks-introduce-numa_memblks_init
+++ a/arch/x86/mm/numa.c
@@ -115,13 +115,9 @@ void __init setup_node_to_cpumask_map(vo
 	pr_debug("Node to cpumask map for %u nodes\n", nr_node_ids);
 }
 
-static int __init numa_register_memblks(struct numa_meminfo *mi)
+static int __init numa_register_nodes(void)
 {
-	int nid, err;
-
-	err = numa_register_meminfo(mi);
-	if (err)
-		return err;
+	int nid;
 
 	if (!memblock_validate_numa_coverage(SZ_1M))
 		return -EINVAL;
@@ -171,39 +167,11 @@ static int __init numa_init(int (*init_f
 	for (i = 0; i < MAX_LOCAL_APIC; i++)
 		set_apicid_to_node(i, NUMA_NO_NODE);
 
-	nodes_clear(numa_nodes_parsed);
-	nodes_clear(node_possible_map);
-	nodes_clear(node_online_map);
-	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
-	WARN_ON(memblock_set_node(0, ULLONG_MAX, &memblock.memory,
-				  NUMA_NO_NODE));
-	WARN_ON(memblock_set_node(0, ULLONG_MAX, &memblock.reserved,
-				  NUMA_NO_NODE));
-	/* In case that parsing SRAT failed. */
-	WARN_ON(memblock_clear_hotplug(0, ULLONG_MAX));
-	numa_reset_distance();
-
-	ret = init_func();
+	ret = numa_memblks_init(init_func, /* memblock_force_top_down */ true);
 	if (ret < 0)
 		return ret;
 
-	/*
-	 * We reset memblock back to the top-down direction
-	 * here because if we configured ACPI_NUMA, we have
-	 * parsed SRAT in init_func(). It is ok to have the
-	 * reset here even if we did't configure ACPI_NUMA
-	 * or acpi numa init fails and fallbacks to dummy
-	 * numa init.
-	 */
-	memblock_set_bottom_up(false);
-
-	ret = numa_cleanup_meminfo(&numa_meminfo);
-	if (ret < 0)
-		return ret;
-
-	numa_emulation(&numa_meminfo, numa_distance_cnt);
-
-	ret = numa_register_memblks(&numa_meminfo);
+	ret = numa_register_nodes();
 	if (ret < 0)
 		return ret;
 
--- a/include/linux/numa_memblks.h~mm-numa_memblks-introduce-numa_memblks_init
+++ a/include/linux/numa_memblks.h
@@ -34,6 +34,9 @@ int __init numa_register_meminfo(struct
 void __init numa_nodemask_from_meminfo(nodemask_t *nodemask,
 				       const struct numa_meminfo *mi);
 
+int __init numa_memblks_init(int (*init_func)(void),
+			     bool memblock_force_top_down);
+
 #ifdef CONFIG_NUMA_EMU
 int numa_emu_cmdline(char *str);
 void __init numa_emu_update_cpu_to_node(int *emu_nid_to_phys,
--- a/mm/numa_memblks.c~mm-numa_memblks-introduce-numa_memblks_init
+++ a/mm/numa_memblks.c
@@ -415,6 +415,47 @@ int __init numa_register_meminfo(struct
 	return 0;
 }
 
+int __init numa_memblks_init(int (*init_func)(void),
+			     bool memblock_force_top_down)
+{
+	int ret;
+
+	nodes_clear(numa_nodes_parsed);
+	nodes_clear(node_possible_map);
+	nodes_clear(node_online_map);
+	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
+	WARN_ON(memblock_set_node(0, ULLONG_MAX, &memblock.memory,
+				  NUMA_NO_NODE));
+	WARN_ON(memblock_set_node(0, ULLONG_MAX, &memblock.reserved,
+				  NUMA_NO_NODE));
+	/* In case that parsing SRAT failed. */
+	WARN_ON(memblock_clear_hotplug(0, ULLONG_MAX));
+	numa_reset_distance();
+
+	ret = init_func();
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * We reset memblock back to the top-down direction
+	 * here because if we configured ACPI_NUMA, we have
+	 * parsed SRAT in init_func(). It is ok to have the
+	 * reset here even if we did't configure ACPI_NUMA
+	 * or acpi numa init fails and fallbacks to dummy
+	 * numa init.
+	 */
+	if (memblock_force_top_down)
+		memblock_set_bottom_up(false);
+
+	ret = numa_cleanup_meminfo(&numa_meminfo);
+	if (ret < 0)
+		return ret;
+
+	numa_emulation(&numa_meminfo, numa_distance_cnt);
+
+	return numa_register_meminfo(&numa_meminfo);
+}
+
 static int __init cmp_memblk(const void *a, const void *b)
 {
 	const struct numa_memblk *ma = *(const struct numa_memblk **)a;
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

