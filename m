Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCB13B6BE5
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 18:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785521199; cv=none; b=aThU10QkKXkgVb8sRdeIP+8PiDVT5MuBxx0tmq4XQk3ZZnbOb65OUBhAVEzEp1pcZ63A+1Js9AEUrD8zl4NxuFQvqWVftP9OtN7jxO16aJMoKO1vcHvmd+CZyQQRXbSUEwPjNmCjXgIWCjkxnOs2Sdfi7q2vbaoB+O6sVx4gTJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785521199; c=relaxed/simple;
	bh=OEoXAihKHyT2YXZezaz45pfdS4+TfAsqNjO+dGVQ7Og=;
	h=Date:To:From:Subject:Message-Id; b=r57UyMs+aavRqGIzC0oFb20tXg7cFtdN5MazHChZ0tsw1VHrxcHbe2pBmSKPW1MV9B5pjbHxN6mY1wbU275kbiZaENN8G8o4LYZLzg5pb1/u7668W66n2bWvzpczZtxfuvHSj4Ek6ERoMs31NP1RCp505kyPeRZA5PLSPj9pseA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BYEPpjTq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BYEPpjTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF201F00AC4;
	Fri, 31 Jul 2026 18:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785521198;
	bh=hDV37jOkcyVRN79OjQJWhyzdUTKPg/vAQGOh8cRjmBo=;
	h=Date:To:From:Subject;
	b=BYEPpjTqugxYrJPi2TZWyDF5UfBiSzkrRWa1g2g9ZxWPuGZ9LYq4hy6BNxo5gx7uA
	 PXwBJzLLYzThmp3eGxWBITM+DA9UR90vNnMo61VCr6r6X27c2kIBDMb4Os+JgMrXHq
	 /kPSHCg+i+nNvAXxaIwVFxTsh2walVhYx2UxObLM=
Date: Fri, 31 Jul 2026 11:06:37 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-kconfig-drop-arch_want_numa_variable_locality.patch added to mm-new branch
Message-Id: <20260731180638.2FF201F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init/Kconfig: drop ARCH_WANT_NUMA_VARIABLE_LOCALITY
has been added to the -mm mm-new branch.  Its filename is
     init-kconfig-drop-arch_want_numa_variable_locality.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-kconfig-drop-arch_want_numa_variable_locality.patch

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
Subject: init/Kconfig: drop ARCH_WANT_NUMA_VARIABLE_LOCALITY
Date: Sun, 10 May 2026 16:55:43 +0300

sh was the only architecture that selected ARCH_WANT_NUMA_VARIABLE_LOCALITY.

With NUMA support on sh gone, there is no need in this configuration
option.

Remove it.

Link: https://lore.kernel.org/20260510135546.13554-8-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    7 -------
 1 file changed, 7 deletions(-)

--- a/init/Kconfig~init-kconfig-drop-arch_want_numa_variable_locality
+++ a/init/Kconfig
@@ -1011,17 +1011,10 @@ config CC_STRINGOP_OVERFLOW
 config ARCH_SUPPORTS_INT128
 	bool
 
-# For architectures that (ab)use NUMA to represent different memory regions
-# all cpu-local but of different latencies, such as SuperH.
-#
-config ARCH_WANT_NUMA_VARIABLE_LOCALITY
-	bool
-
 config NUMA_BALANCING
 	bool "Memory placement aware NUMA scheduler"
 	depends on ARCH_SUPPORTS_NUMA_BALANCING
 	depends on ARCH_HAS_PTE_PROTNONE
-	depends on !ARCH_WANT_NUMA_VARIABLE_LOCALITY
 	depends on SMP && NUMA_MIGRATION && !PREEMPT_RT
 	help
 	  This option adds support for automatic NUMA aware memory/task placement.
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

