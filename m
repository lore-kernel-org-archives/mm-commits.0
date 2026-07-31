Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8156834D384
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 18:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785521203; cv=none; b=Zo9z4v51CBOrWsUKNj92PW9l3BOsKFoyPbozWc/vlMzhAQMg098TRTuJp+Nem+2QpKTM5Fsk3kTOeRidOtcEddVUcNBX27kmafRSMqWcaJrizaGa7MrS9+hXR8ZFhj+yxByeTzV3JrSbAGdFRSIyA9SQDYn1r0ooDNBGHfr0Bss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785521203; c=relaxed/simple;
	bh=uu3G3kV5djcwBmRnvyG7P5iy/BBQEwrIDI4G2mdSuSM=;
	h=Date:To:From:Subject:Message-Id; b=f62TmzCIvTDrGIg7cBgMTWIO9q5GViuaYEEOAmMbWHMCtW76OWjonJAkrvut6K3sKfvnxxSacOiNoINvSPuMkXmmyGwIvbwlZYfff30erP9qM/29IQKJo39EYanKntjpyiXSUnhsICzpVBoKOUyHQWM7W6DxXS1nXrC6VXZ2kI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NFwlpPGf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NFwlpPGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036C81F00AC4;
	Fri, 31 Jul 2026 18:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785521202;
	bh=DWZndKAHCrf6KqdCLqMB1fhWTNO8MV/bTa7ryBWC1sc=;
	h=Date:To:From:Subject;
	b=NFwlpPGf7c7gMEzeOdOgktedXsr7bFs5CF10rjSAMnV3RU3pijy6+E6qAoJyAiUcK
	 I5JrVLunYuvFx+Z4J2ZzyiZUphrHr8HdEH8EF5YRMrOFRQ/M+l+Koo0KVJtQwo1/WV
	 KzPdD8hbXbGZv+/arbbSoJ9RWmuqdEPnyNeOowkE=
Date: Fri, 31 Jul 2026 11:06:41 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-remove-sparsemem-related-entries-from-kconfig.patch added to mm-new branch
Message-Id: <20260731180642.036C81F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh: remove SPARSEMEM related entries from Kconfig
has been added to the -mm mm-new branch.  Its filename is
     sh-remove-sparsemem-related-entries-from-kconfig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-remove-sparsemem-related-entries-from-kconfig.patch

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
Subject: sh: remove SPARSEMEM related entries from Kconfig
Date: Sun, 10 May 2026 16:55:45 +0300

Without NUMA support, SPARSEMEM related configuration options only create
unnecessary overhead.

Remove them.

Link: https://lore.kernel.org/20260510135546.13554-10-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/Kconfig    |    6 ------
 arch/sh/mm/Kconfig |   10 ----------
 2 files changed, 16 deletions(-)

--- a/arch/sh/Kconfig~sh-remove-sparsemem-related-entries-from-kconfig
+++ a/arch/sh/Kconfig
@@ -386,7 +386,6 @@ config CPU_SUBTYPE_SH7723
 	select CPU_SH4A
 	select CPU_SHX2
 	select ARCH_SHMOBILE
-	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_SH_CMT
 	select PINCTRL
 	help
@@ -397,7 +396,6 @@ config CPU_SUBTYPE_SH7724
 	select CPU_SH4A
 	select CPU_SHX2
 	select ARCH_SHMOBILE
-	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_SH_CMT
 	select PINCTRL
 	help
@@ -438,7 +436,6 @@ config CPU_SUBTYPE_SH7785
 	bool "Support SH7785 processor"
 	select CPU_SH4A
 	select CPU_SHX2
-	select ARCH_SPARSEMEM_ENABLE
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7786
@@ -472,7 +469,6 @@ config CPU_SUBTYPE_SH7722
 	select CPU_SH4AL_DSP
 	select CPU_SHX2
 	select ARCH_SHMOBILE
-	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_SH_CMT
 	select PINCTRL
 
@@ -481,8 +477,6 @@ config CPU_SUBTYPE_SH7366
 	select CPU_SH4AL_DSP
 	select CPU_SHX2
 	select ARCH_SHMOBILE
-	select ARCH_SPARSEMEM_ENABLE
-	select SYS_SUPPORTS_NUMA
 	select SYS_SUPPORTS_SH_CMT
 
 endchoice
--- a/arch/sh/mm/Kconfig~sh-remove-sparsemem-related-entries-from-kconfig
+++ a/arch/sh/mm/Kconfig
@@ -115,16 +115,6 @@ config VSYSCALL
 config ARCH_FLATMEM_ENABLE
 	def_bool y
 
-config ARCH_SPARSEMEM_ENABLE
-	def_bool y
-	select SPARSEMEM_STATIC
-
-config ARCH_SPARSEMEM_DEFAULT
-	def_bool y
-
-config ARCH_SELECT_MEMORY_MODEL
-	def_bool y
-
 config IOREMAP_FIXED
        def_bool y
        depends on X2TLB
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

