Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832325;
	b=nG22xudHDndSh4wTzm2m5KPMddwkkPqA0G9X7KUstki4y/e9vlnqQmZ2G58e/vj2rs3u
	 2SZvj9X/R59XROZLFDK5nxkEsnP5dSsR7I5litpF/VciXxupyBgP8zIxUSW0Eh+9aGZFo
	 J8bfn1s2k2qgZ6sUZXzafqNbCD9mTKOXv6ARAYrqAfhhsmEgvWJ/mvhlEWVpBL3myiAVa
	 MW59Nm8OJJTh4hexf7inZ+ECJYQ8bz48dhXGTZDyp08lAivhjObxich3hZ7Y+ArtdeVX9
	 LhC9Pn7n7Qtma7B9M1ucYbjPWZ47Ee6sFfQc2LbQA9fB5jb1ENsP3GAGPaK8GP1bQEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832325;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=retnuMx7bbamsNiBixcDoF2jM3xTZvVAm6oYXEcLfjQ=;
	b=G2dggY/X7ZfD11u5LbZ6w13S4hNOOuhmHkXK3UjKQTNtQFeOjbvRFjWLSOyuBntd/X6L
	 bAm8YIKA7Mgny8eNkcULDmP8YACWA568mhXoiCHrxgSvWhEgbRhrCgFBlauAfppfTG0JD
	 FnLI3hbZqkPECEH5VRk/ULUz1UpPzK0POOHn13X642v+yAmh77NpYPH/z3NJBwHY42M/H
	 XPEp2zbp/aZ9PVmDdqWzzFcHpapDLf/lAFyeeu2lEi3EwAZhHu1dpmyAIGLp1bCclzso/
	 aTfDZypwm8xqUp01kIZSacJFSuwZt4P+AHjkknMS45HVa6BQT2y98WEE5m6gC2gs4/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vzJ2Eyqr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0285E606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vzJ2Eyqr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EEC1F01828;
	Sat, 24 Oct 2026 08:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832324;
	bh=retnuMx7bbamsNiBixcDoF2jM3xTZvVAm6oYXEcLfjQ=;
	h=Date:To:From:Subject;
	b=vzJ2EyqrahezL7ZUtohb4FTqceBpcgBdLqFTJ3vRzI8XehnTjmbOyXn9qHNpzWuTJ
	 FFpftjKLzbeZpsugNrstacaFLNXRcrulnviXP7kVarrymiLSkPUr/yBSLmiiWUw+wP
	 Kn4QpTgfyDMhB0WEvbdLqFO7Ga8JDUXa7sGiT9SE=
Date: Sat, 24 Oct 2026 01:58:44 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-remove-config_numa-and-realted-configuration-options.patch removed from -mm tree
Message-Id: <20261024085844.C1EEC1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: sh: remove CONFIG_NUMA and related configuration options
has been removed from the -mm tree.  Its filename was
     sh-remove-config_numa-and-realted-configuration-options.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: sh: remove CONFIG_NUMA and related configuration options
Date: Sun, 10 May 2026 16:55:37 +0300

Patch series "sh: remove NUMA and SPARSEMEM support", v2.

NUMA support for SuperH was introduced a long time ago by commit
b241cb0c885e ("sh: Support for multiple nodes.")

	"... for boards with many different memory blocks that are
	 otherwise unused (SH7722/SH7785 URAM and so forth)"

In reality, this added 128K of memory on sh7722 and sh7785 and 256K on
shx3 at the expense of all the NUMA related code in the kernel.

For build of v7.0-rc7 with defconfig and the same configuration with
CONFIG_NUMA disabled, bloat-o-meter reports difference of ~76k.  Disabling
CONFIG_SPARSMEM on top increases the difference to ~94k.  And that's only
overhead in code and static data that does not take into the account data
structures allocated at run time.

And all this overhead has been there for nothing for almost 8 years
because since commit ac21fc2dcb40 ("sh: switch to NO_BOOTMEM") those
additional "nodes" could not be used by the core MM because the maximal
pfn for ZONE_NORMAL was cut out at the end of the normal memory.


This patch (of 10):

NUMA support for SuperH was introduced a long time ago by commit
b241cb0c885e ("sh: Support for multiple nodes.")

	"... for boards with many different memory blocks that are
	 otherwise unused (SH7722/SH7785 URAM and so forth)"

In reality, this added 128K of memory on sh7722 and sh7785 and 256K on
shx3 at the expense of all the NUMA related code in the kernel.

For build of v7.0-rc7 with defconfig and the same configuration with
CONFIG_NUMA disabled, bloat-o-meter reports difference of ~76k.  Disabling
CONFIG_SPARSMEM on top increases the difference to ~94k.  And that's only
overhead in code and static data that does not take into the account data
structures allocated at run time.

And all this overhead has been there for nothing for almost 8 years
because since commit ac21fc2dcb40 ("sh: switch to NO_BOOTMEM") those
additional "nodes" could not be used by the core MM because the maximal
pfn for ZONE_NORMAL was cut out at the end of the normal memory.

Start removing NUMA support on sh with removing CONFIG_NUMA and related
configuration options in arch/sh/Kconfig and arch/sh/mm/Kconfig.

Link: https://lore.kernel.org/20260510135546.13554-1-rppt@kernel.org
Link: https://lore.kernel.org/20260510135546.13554-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---

 arch/sh/Kconfig                   |    6 ------
 arch/sh/configs/migor_defconfig   |    1 -
 arch/sh/configs/sdk7786_defconfig |    1 -
 arch/sh/configs/se7722_defconfig  |    1 -
 arch/sh/configs/shx3_defconfig    |    1 -
 arch/sh/configs/ul2_defconfig     |    1 -
 arch/sh/mm/Kconfig                |   19 -------------------
 7 files changed, 30 deletions(-)

--- a/arch/sh/configs/migor_defconfig~sh-remove-config_numa-and-realted-configuration-options
+++ a/arch/sh/configs/migor_defconfig
@@ -9,7 +9,6 @@ CONFIG_MODULES=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_CPU_SUBTYPE_SH7722=y
 CONFIG_MEMORY_START=0x0c000000
-CONFIG_NUMA=y
 # CONFIG_MIGRATION is not set
 CONFIG_SH_MIGOR=y
 # CONFIG_SH_TIMER_CMT is not set
--- a/arch/sh/configs/sdk7786_defconfig~sh-remove-config_numa-and-realted-configuration-options
+++ a/arch/sh/configs/sdk7786_defconfig
@@ -41,7 +41,6 @@ CONFIG_CPU_SUBTYPE_SH7786=y
 CONFIG_MEMORY_START=0x40000000
 CONFIG_MEMORY_SIZE=0x20000000
 CONFIG_PMB=y
-CONFIG_NUMA=y
 CONFIG_HUGETLB_PAGE_SIZE_64MB=y
 CONFIG_KSM=y
 CONFIG_SH_STORE_QUEUES=y
--- a/arch/sh/configs/se7722_defconfig~sh-remove-config_numa-and-realted-configuration-options
+++ a/arch/sh/configs/se7722_defconfig
@@ -10,7 +10,6 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_CPU_SUBTYPE_SH7722=y
 CONFIG_MEMORY_START=0x0c000000
-CONFIG_NUMA=y
 CONFIG_SH_STORE_QUEUES=y
 CONFIG_SH_7722_SOLUTION_ENGINE=y
 # CONFIG_SH_TIMER_CMT is not set
--- a/arch/sh/configs/shx3_defconfig~sh-remove-config_numa-and-realted-configuration-options
+++ a/arch/sh/configs/shx3_defconfig
@@ -29,7 +29,6 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_CPU_SUBTYPE_SHX3=y
 CONFIG_MEMORY_START=0x0c000000
-CONFIG_NUMA=y
 CONFIG_PAGE_SIZE_64KB=y
 CONFIG_SH_STORE_QUEUES=y
 CONFIG_SH_X3PROTO=y
--- a/arch/sh/configs/ul2_defconfig~sh-remove-config_numa-and-realted-configuration-options
+++ a/arch/sh/configs/ul2_defconfig
@@ -10,7 +10,6 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_CPU_SUBTYPE_SH7366=y
 CONFIG_MEMORY_SIZE=0x01f00000
-CONFIG_NUMA=y
 # CONFIG_MIGRATION is not set
 # CONFIG_SH_DSP is not set
 # CONFIG_SH_TIMER_CMT is not set
--- a/arch/sh/Kconfig~sh-remove-config_numa-and-realted-configuration-options
+++ a/arch/sh/Kconfig
@@ -107,9 +107,6 @@ config SYS_SUPPORTS_APM_EMULATION
 config SYS_SUPPORTS_SMP
 	bool
 
-config SYS_SUPPORTS_NUMA
-	bool
-
 config STACKTRACE_SUPPORT
 	def_bool y
 
@@ -198,7 +195,6 @@ config CPU_SHX3
 	bool
 	select DMA_COHERENT
 	select SYS_SUPPORTS_SMP
-	select SYS_SUPPORTS_NUMA
 
 config ARCH_SHMOBILE
 	bool
@@ -444,7 +440,6 @@ config CPU_SUBTYPE_SH7785
 	select CPU_SH4A
 	select CPU_SHX2
 	select ARCH_SPARSEMEM_ENABLE
-	select SYS_SUPPORTS_NUMA
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7786
@@ -480,7 +475,6 @@ config CPU_SUBTYPE_SH7722
 	select CPU_SHX2
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
-	select SYS_SUPPORTS_NUMA
 	select SYS_SUPPORTS_SH_CMT
 	select PINCTRL
 
--- a/arch/sh/mm/Kconfig~sh-remove-config_numa-and-realted-configuration-options
+++ a/arch/sh/mm/Kconfig
@@ -112,27 +112,8 @@ config VSYSCALL
 	  For systems with an MMU that can afford to give up a page,
 	  (the default value) say Y.
 
-config NUMA
-	bool "Non-Uniform Memory Access (NUMA) Support"
-	depends on MMU && SYS_SUPPORTS_NUMA
-	select ARCH_WANT_NUMA_VARIABLE_LOCALITY
-	default n
-	help
-	  Some SH systems have many various memories scattered around
-	  the address space, each with varying latencies. This enables
-	  support for these blocks by binding them to nodes and allowing
-	  memory policies to be used for prioritizing and controlling
-	  allocation behaviour.
-
-config NODES_SHIFT
-	int
-	default "3" if CPU_SUBTYPE_SHX3
-	default "1"
-	depends on NUMA
-
 config ARCH_FLATMEM_ENABLE
 	def_bool y
-	depends on !NUMA
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
_

Patches currently in -mm which might be from rppt@kernel.org are


