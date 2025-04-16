Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE2F28E3F
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 23:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744845292; cv=none; b=n1AzcBkWMntFI1xKWEwaU/FcwdajRh2nu0+xdmZcRH6o912I5t0zvbi+/vlsa9sTAje2PxlEOiozQBbD6zGT7E/7B1Ebo3e1CV3k0rh0JBX/KPHnCAFsWagCH8t5FePch92KvEHw4gzOoACATREse8vwh53Tc3iKI6HXKyEX6vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744845292; c=relaxed/simple;
	bh=2zTaLclZ4xU3v0o41j3FIZDTJDJYge8RX/Q+sQQ6K/k=;
	h=Date:To:From:Subject:Message-Id; b=IyWNOXVVSxg/as8s+9Y9mCjCzh0jJ1twh8X93XE9gGtJj0me0n905gqWlSEc+myzNOgXr+eLiV8Av+qZF1vnoVA3ICXTU5anhbMOXN0kBGJDztsLoEc24bnp8DA4RQxlMPCBSH+4HxZ6b/PSpjboUCTffEQNgir0ic9rodc6uOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gcXGAU5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gcXGAU5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01833C4CEE2;
	Wed, 16 Apr 2025 23:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744845292;
	bh=2zTaLclZ4xU3v0o41j3FIZDTJDJYge8RX/Q+sQQ6K/k=;
	h=Date:To:From:Subject:From;
	b=gcXGAU5/AmuSUnmuDDKyKk3QGH0ARPOB2KlE/WVikEdK8SPQlXl9CVpNXn2yl5twM
	 NltgYw1ng7nXRVX1bKyzVgrW9KK5Ts5GLFRnJqMaQj54rIqHWIa2/M8KTGEhCqCh5N
	 hNNo+zcOM+C5VcXkaQ41rtR2NZOarjWvrdX6yhso=
Date: Wed, 16 Apr 2025 16:14:51 -0700
To: mm-commits@vger.kernel.org,xry111@xry111.site,thomas.weissschuh@linutronix.de,tglx@linutronix.de,niecheng1@uniontech.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kernel@xen0n.name,jeffxu@chromium.org,jason@zx2c4.com,hca@linux.ibm.com,guanwentao@uniontech.com,corbet@lwn.net,chenhuacai@kernel.org,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mseal-sysmap-enable-loongarch.patch removed from -mm tree
Message-Id: <20250416231452.01833C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mseal sysmap: enable LoongArch
has been removed from the -mm tree.  Its filename was
     mseal-sysmap-enable-loongarch.patch

This patch was dropped because it is obsolete

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

ocfs2-o2net_idle_timer-rename-del_timer_sync-in-comment.patch

