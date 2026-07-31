Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2EF3DC4DE
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 18:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785521189; cv=none; b=ifoIJBErOZOLoJSWTvYY0rQkK1odxEve6AvepuWISSKElB75n6qbY9pYfQjMuMDIaynorqxuWj8sng174v97uKNCwM8PxeHBrBIlryC6o3Bsp9NJXv8kRnhix2mxwsAaAvkmE+H/MpOXkKy/dz1mAyGw7dGdrI2LuadxnRH460c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785521189; c=relaxed/simple;
	bh=WazvZQaVkZvctCNzaAXgkuVtfn0MBNV/w9VSzPkAF1E=;
	h=Date:To:From:Subject:Message-Id; b=fDj9RrCm+a12DXj9wwjEXxmBgrko0/bdf0ytSomq91lNhP0PpMPsmc8yx0YIt0dDH6kZYcP7dR9TlbMSmKERer0AmxNXkllbaiRSczPyYStfFu1d1MXi0n6lSi8vpdoUvMuAYzAxS+JBus9AJi2RIA0sjJCkWsj77XRzMlcqngQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a393tqy5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a393tqy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DCF1F00AC4;
	Fri, 31 Jul 2026 18:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785521188;
	bh=Nm33LicLDrwVmpiq10IFK5HT7iZ2U/jQIUB2Lkg6Fqo=;
	h=Date:To:From:Subject;
	b=a393tqy56zEqc9DpjXve+gV78W8B6fc5WBH4g2UTnIiDvqsafhU/SxjtkY5Xaqsd0
	 jy/qVbOmoYehSSOdyW5/fmx3mmmFrQBnPLrk7v9hxADmd7UYWneKQ9Trub4IuCltd6
	 RiBULC44+/dorgWOmtBIzjz6QM/1myZoBDCnqAMs=
Date: Fri, 31 Jul 2026 11:06:27 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-drop-dead-code-guarded-by-ifdef-config_numa.patch added to mm-new branch
Message-Id: <20260731180627.E3DCF1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh: drop dead code guarded by #ifdef CONFIG_NUMA
has been added to the -mm mm-new branch.  Its filename is
     sh-drop-dead-code-guarded-by-ifdef-config_numa.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-drop-dead-code-guarded-by-ifdef-config_numa.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: sh: drop dead code guarded by #ifdef CONFIG_NUMA
Date: Sun, 10 May 2026 16:55:41 +0300

and NUMA-related comments.

Link: https://lore.kernel.org/20260510135546.13554-6-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/topology.h |   13 -------------
 arch/sh/kernel/setup.c         |    1 -
 arch/sh/kernel/topology.c      |   12 ------------
 arch/sh/kernel/vmcore_info.c   |    4 ----
 arch/sh/mm/sram.c              |    3 +--
 5 files changed, 1 insertion(+), 32 deletions(-)

--- a/arch/sh/include/asm/topology.h~sh-drop-dead-code-guarded-by-ifdef-config_numa
+++ a/arch/sh/include/asm/topology.h
@@ -2,19 +2,6 @@
 #ifndef _ASM_SH_TOPOLOGY_H
 #define _ASM_SH_TOPOLOGY_H
 
-#ifdef CONFIG_NUMA
-
-#define cpu_to_node(cpu)	((void)(cpu),0)
-
-#define cpumask_of_node(node)	((void)node, cpu_online_mask)
-
-#define pcibus_to_node(bus)	((void)(bus), -1)
-#define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ? \
-					cpu_all_mask : \
-					cpumask_of_node(pcibus_to_node(bus)))
-
-#endif
-
 #define mc_capable()    (1)
 
 const struct cpumask *cpu_coregroup_mask(int cpu);
--- a/arch/sh/kernel/setup.c~sh-drop-dead-code-guarded-by-ifdef-config_numa
+++ a/arch/sh/kernel/setup.c
@@ -227,7 +227,6 @@ void __init __add_active_range(unsigned
 	/*
 	 * Also make sure that there is a PMB mapping that covers this
 	 * range before we attempt to activate it, to avoid reset by MMU.
-	 * We can hit this path with NUMA or memory hot-add.
 	 */
 	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
 			 PAGE_KERNEL);
--- a/arch/sh/kernel/topology.c~sh-drop-dead-code-guarded-by-ifdef-config_numa
+++ a/arch/sh/kernel/topology.c
@@ -57,18 +57,6 @@ static int __init topology_init(void)
 			       __func__, i, ret);
 	}
 
-#if defined(CONFIG_NUMA) && !defined(CONFIG_SMP)
-	/*
-	 * In the UP case, make sure the CPU association is still
-	 * registered under each node. Without this, sysfs fails
-	 * to make the connection between nodes other than node0
-	 * and cpu0.
-	 */
-	for_each_online_node(i)
-		if (i != numa_node_id())
-			register_cpu_under_node(raw_smp_processor_id(), i);
-#endif
-
 	return 0;
 }
 subsys_initcall(topology_init);
--- a/arch/sh/kernel/vmcore_info.c~sh-drop-dead-code-guarded-by-ifdef-config_numa
+++ a/arch/sh/kernel/vmcore_info.c
@@ -5,10 +5,6 @@
 
 void arch_crash_save_vmcoreinfo(void)
 {
-#ifdef CONFIG_NUMA
-	VMCOREINFO_SYMBOL(node_data);
-	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
-#endif
 #ifdef CONFIG_X2TLB
 	VMCOREINFO_CONFIG(X2TLB);
 #endif
--- a/arch/sh/mm/sram.c~sh-drop-dead-code-guarded-by-ifdef-config_numa
+++ a/arch/sh/mm/sram.c
@@ -16,8 +16,7 @@
  * This provides a standard SRAM pool for tiny memories that can be
  * added either by the CPU or the platform code. Typical SRAM sizes
  * to be inserted in to the pool will generally be less than the page
- * size, with anything more reasonably sized handled as a NUMA memory
- * node.
+ * size.
  */
 struct gen_pool *sram_pool;
 
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-split-out-mm_init-and-memblock-declarations-from-internalh.patch
mm-split-out-mm_init-and-memblock-declarations-from-internalh-fix.patch
mm-split-out-sparse-declarations-from-internalh.patch
mm-split-out-vmalloc-declarations-from-internalh.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

