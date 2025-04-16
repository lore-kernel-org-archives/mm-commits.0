Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D2A20E007
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 01:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744766139; cv=none; b=IKcIdS4Sg1AcCe5YcxK03LD1pScdMshJcE6ivDLqCsgun5soiQnAgxPAnoUm/Z3Qh9w2joJBphHxYHCix07AmMNpYMQo73I/QLR9Y173yhYje2cGKS93wj1ZWofXTZwVawoba4OTNBWYN770/LphrYBocChq11KQt5oNNJjn6kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744766139; c=relaxed/simple;
	bh=snlCVEtwvdVESQ0FShbzoVCPp4rf22GWciUIIxv23mA=;
	h=Date:To:From:Subject:Message-Id; b=tj848VLLhjEcqTb2zkhr42dBpKaOyK+TToc77mczCsQ9PR22tsqhTjMFUQTeFrbZi7Sy51iPVmGXnMQdu7FuCouyMKCslzUY9Ron98OvaHdLD1oDZ4DVLx5BZJRci0zbA5bfxYjII8HiSscc+QV5XiQCOTNUO3z5AzjiMSxRhMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PkWKWFSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PkWKWFSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE5CC4CEE7;
	Wed, 16 Apr 2025 01:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744766138;
	bh=snlCVEtwvdVESQ0FShbzoVCPp4rf22GWciUIIxv23mA=;
	h=Date:To:From:Subject:From;
	b=PkWKWFSW9DYzFqnmmghMHQ5vMf/Dfpg3TIDjBYqbK8wVHbimRdNhCF5zXZ5RQI4tf
	 uOwHAwp2TTNoPoXnApWJIXWzwoj+QUhiruw9pQ+IIELR3wG3HTE3UVoFtOx6GKHcqK
	 6f6B3jWy4dCuhT2oexuUEecZTP6RH/GGLjHVVq20=
Date: Tue, 15 Apr 2025 18:15:37 -0700
To: mm-commits@vger.kernel.org,xry111@xry111.site,thomas.weissschuh@linutronix.de,tglx@linutronix.de,niecheng1@uniontech.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kernel@xen0n.name,jeffxu@chromium.org,jason@zx2c4.com,hca@linux.ibm.com,guanwentao@uniontech.com,corbet@lwn.net,chenhuacai@kernel.org,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mseal-sysmap-enable-loongarch.patch added to mm-unstable branch
Message-Id: <20250416011538.3EE5CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mseal sysmap: enable LoongArch
has been added to the -mm mm-unstable branch.  Its filename is
     mseal-sysmap-enable-loongarch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mseal-sysmap-enable-loongarch.patch

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
From: WangYuli <wangyuli@uniontech.com>
Subject: mseal sysmap: enable LoongArch
Date: Tue, 15 Apr 2025 23:39:03 +0800

Provide support for CONFIG_MSEAL_SYSTEM_MAPPINGS on LoongArch, covering
the vdso.

Link: https://lore.kernel.org/all/25bad37f-273e-4626-999c-e1890be96182@lucifer.local/
Link: https://lkml.kernel.org/r/648AB3031B5618C0+20250415153903.570662-1-wangyuli@uniontech.com
Signed-off-by: Yuli Wang <wangyuli@uniontech.com>
Tested-by: Yuli Wang <wangyuli@uniontech.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Jeff Xu <jeffxu@chromium.org>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Cheng Nie <niecheng1@uniontech.com>
Cc: Guan Wentao <guanwentao@uniontech.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/features/core/mseal_sys_mappings/arch-support.txt |    2 +-
 Documentation/userspace-api/mseal.rst                           |    2 +-
 arch/loongarch/Kconfig                                          |    1 +
 arch/loongarch/kernel/vdso.c                                    |    4 +++-
 4 files changed, 6 insertions(+), 3 deletions(-)

--- a/arch/loongarch/Kconfig~mseal-sysmap-enable-loongarch
+++ a/arch/loongarch/Kconfig
@@ -69,6 +69,7 @@ config LOONGARCH
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
 	select ARCH_SUPPORTS_LTO_CLANG
 	select ARCH_SUPPORTS_LTO_CLANG_THIN
+	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_RT
 	select ARCH_USE_BUILTIN_BSWAP
--- a/arch/loongarch/kernel/vdso.c~mseal-sysmap-enable-loongarch
+++ a/arch/loongarch/kernel/vdso.c
@@ -105,7 +105,9 @@ int arch_setup_additional_pages(struct l
 
 	vdso_addr = data_addr + VVAR_SIZE;
 	vma = _install_special_mapping(mm, vdso_addr, info->size,
-				       VM_READ | VM_EXEC | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC,
+				       VM_READ | VM_EXEC |
+				       VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC |
+				       VM_SEALED_SYSMAP,
 				       &info->code_mapping);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
--- a/Documentation/features/core/mseal_sys_mappings/arch-support.txt~mseal-sysmap-enable-loongarch
+++ a/Documentation/features/core/mseal_sys_mappings/arch-support.txt
@@ -12,7 +12,7 @@
     |       arm64: |  ok  |
     |        csky: |  N/A |
     |     hexagon: |  N/A |
-    |   loongarch: | TODO |
+    |   loongarch: |  ok  |
     |        m68k: |  N/A |
     |  microblaze: |  N/A |
     |        mips: | TODO |
--- a/Documentation/userspace-api/mseal.rst~mseal-sysmap-enable-loongarch
+++ a/Documentation/userspace-api/mseal.rst
@@ -144,7 +144,7 @@ Use cases
   architecture.
 
   The following architectures currently support this feature: x86-64, arm64,
-  and s390.
+  loongarch and s390.
 
   WARNING: This feature breaks programs which rely on relocating
   or unmapping system mappings. Known broken software at the time
_

Patches currently in -mm which might be from wangyuli@uniontech.com are

mseal-sysmap-enable-loongarch.patch
ocfs2-o2net_idle_timer-rename-del_timer_sync-in-comment.patch

