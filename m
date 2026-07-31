Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88C5307492
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 18:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785521178; cv=none; b=tqm4SQkBngzQttXHNCBuaVmLJxGw+NZeaEkiluW8j1QNMhmuJ9g6NNKokj2PnqzOKz30j64pIFKSjDdUi/rJb5h9ZCv7EM9PkdK3QWqUc3DzoGyO0GMyWs2C1fDtQruPraTUyw5pR/ddu+bFs3wzZL6q7oA/7P5re2LP8pjqS5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785521178; c=relaxed/simple;
	bh=gbhbDbK2hgB6vsQea+fDi6Cz57YK/v0+BfAkv1Gdev8=;
	h=Date:To:From:Subject:Message-Id; b=NxCy5LhqDL6V8zp202PUZZPq+aSTK5glhI5HaGSh7WUC+uWYJbqCp7kSuZ1xfDIlUmKdCZRAlNM83GMZDZf7/O1+3SJDg5e9wzLI/UKlDpUXaP1puMNckPPoopJVpYdZaxvuIAiPE3eVl3kIkl+UP8Q8/5eO51sidOMBn7aSnP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T0L1+k5d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T0L1+k5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4A71F00ACA;
	Fri, 31 Jul 2026 18:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785521174;
	bh=1XoqhEk8UnZwkvQgT0sEbws1o365Y86ZGQi8HMtrRe0=;
	h=Date:To:From:Subject;
	b=T0L1+k5dIm6zgOUOEvJWkKgZah1xf2aSwVD4Vrueq1P2AgRHEqsxRTpNdVhkIv2hm
	 4oS7qnGI6JqADRiy/Q5W+/sRZaj+UJBVvC5yaCl7W0iLq0aFx1i3KbrbFUKOixh+xj
	 HuYfzFXo7D1kcR70fIghxazkcqpgA6ZWbvwyHn1o=
Date: Fri, 31 Jul 2026 11:06:13 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-remove-config_numa-and-realted-configuration-options.patch added to mm-new branch
Message-Id: <20260731180614.5E4A71F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh: remove CONFIG_NUMA and related configuration options
has been added to the -mm mm-new branch.  Its filename is
     sh-remove-config_numa-and-realted-configuration-options.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-remove-config_numa-and-realted-configuration-options.patch

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
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
@@ -106,9 +106,6 @@ config SYS_SUPPORTS_APM_EMULATION
 config SYS_SUPPORTS_SMP
 	bool
 
-config SYS_SUPPORTS_NUMA
-	bool
-
 config STACKTRACE_SUPPORT
 	def_bool y
 
@@ -197,7 +194,6 @@ config CPU_SHX3
 	bool
 	select DMA_COHERENT
 	select SYS_SUPPORTS_SMP
-	select SYS_SUPPORTS_NUMA
 
 config ARCH_SHMOBILE
 	bool
@@ -443,7 +439,6 @@ config CPU_SUBTYPE_SH7785
 	select CPU_SH4A
 	select CPU_SHX2
 	select ARCH_SPARSEMEM_ENABLE
-	select SYS_SUPPORTS_NUMA
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7786
@@ -478,7 +473,6 @@ config CPU_SUBTYPE_SH7722
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

