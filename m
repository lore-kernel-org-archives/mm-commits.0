Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C213523BE
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248778; cv=none; b=PzICIdeUxcuEqHfncrTQpHOfF9YjuOmAXFEIe31qpgVE4B0WGVSsefKYifcTJXGnCjZ4/eSGHB8pxidxfsHGf1Bq3qca4Hl73gF8l1zNgz0tqD4O4fUWBhIinMv38Xc+IRZgRXXZBF7JAKBfotE3qVsmmnxAQzr4eIabo8ktQKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248778; c=relaxed/simple;
	bh=kQCXwuMs83N0a1atr9TIr6ZIS5vQGpePv+o1gFGonBE=;
	h=Date:To:From:Subject:Message-Id; b=WPN2AhO5prMKQQBL8MIYdEI5iCu71eEMuxww2XUt6ocNLEu7BTryeyRc1rzNv1VNqTw+qJNec1wHGycuLgYP3dBMgS9cdleTw75Alvn5KGquys5f+6yI42a1Rb7I03M/mL7nzSzvRf/43F4CZRby/6K7yXR5ododMYovQqqb2hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rtApFsY3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtApFsY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F28C4CEC2;
	Mon,  2 Sep 2024 03:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248778;
	bh=kQCXwuMs83N0a1atr9TIr6ZIS5vQGpePv+o1gFGonBE=;
	h=Date:To:From:Subject:From;
	b=rtApFsY3PvvJzqhV20D1PIS/WaXScBKg3GNOcUhyyYfQN7J6jy/MdYX+gR7FB88VP
	 pOx57Qha+aLE5LnSLN1r0xuaci89sXO9ADnP2kYbetZLz9A0nqLCDugdG672TA9cZZ
	 0f6WBELwLWNj135kHfUMu0GE28SpFkQaZqNqiO0M=
Date: Sun, 01 Sep 2024 20:46:18 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] riscv-boot-add-imagexz-support.patch removed from -mm tree
Message-Id: <20240902034618.90F28C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: boot: add Image.xz support
has been removed from the -mm tree.  Its filename was
     riscv-boot-add-imagexz-support.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: riscv: boot: add Image.xz support
Date: Sun, 21 Jul 2024 16:36:31 +0300

The Image.* targets existed for other compressors already.  Bootloader
support is needed for decompression.

This is for CONFIG_EFI_ZBOOT=n. With CONFIG_EFI_ZBOOT=y, XZ was already
available.

Comparision with Linux 6.10 RV64GC tinyconfig (in KiB):

    1027 Image
     594 Image.gz
     541 Image.zst
     510 Image.lzma
     474 Image.xz

Link: https://lkml.kernel.org/r/20240721133633.47721-17-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Jules Maselbas <jmaselbas@zdiv.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jubin Zhong <zhongjubin@huawei.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rui Li <me@lirui.org>
Cc: Sam James <sam@gentoo.org>
Cc: Simon Glass <sjg@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig       |    1 +
 arch/riscv/Makefile      |    6 ++++--
 arch/riscv/boot/Makefile |    3 +++
 3 files changed, 8 insertions(+), 2 deletions(-)

--- a/arch/riscv/boot/Makefile~riscv-boot-add-imagexz-support
+++ a/arch/riscv/boot/Makefile
@@ -64,6 +64,9 @@ $(obj)/Image.lzo: $(obj)/Image FORCE
 $(obj)/Image.zst: $(obj)/Image FORCE
 	$(call if_changed,zstd)
 
+$(obj)/Image.xz: $(obj)/Image FORCE
+	$(call if_changed,xzkern)
+
 $(obj)/loader.bin: $(obj)/loader FORCE
 	$(call if_changed,objcopy)
 
--- a/arch/riscv/Kconfig~riscv-boot-add-imagexz-support
+++ a/arch/riscv/Kconfig
@@ -156,6 +156,7 @@ config RISCV
 	select HAVE_KERNEL_LZO if !XIP_KERNEL && !EFI_ZBOOT
 	select HAVE_KERNEL_UNCOMPRESSED if !XIP_KERNEL && !EFI_ZBOOT
 	select HAVE_KERNEL_ZSTD if !XIP_KERNEL && !EFI_ZBOOT
+	select HAVE_KERNEL_XZ if !XIP_KERNEL && !EFI_ZBOOT
 	select HAVE_KPROBES if !XIP_KERNEL
 	select HAVE_KRETPROBES if !XIP_KERNEL
 	# https://github.com/ClangBuiltLinux/linux/issues/1881
--- a/arch/riscv/Makefile~riscv-boot-add-imagexz-support
+++ a/arch/riscv/Makefile
@@ -159,6 +159,7 @@ boot-image-$(CONFIG_KERNEL_LZ4)		:= Imag
 boot-image-$(CONFIG_KERNEL_LZMA)	:= Image.lzma
 boot-image-$(CONFIG_KERNEL_LZO)		:= Image.lzo
 boot-image-$(CONFIG_KERNEL_ZSTD)	:= Image.zst
+boot-image-$(CONFIG_KERNEL_XZ)		:= Image.xz
 ifdef CONFIG_RISCV_M_MODE
 boot-image-$(CONFIG_ARCH_CANAAN)	:= loader.bin
 endif
@@ -183,12 +184,12 @@ endif
 vdso-install-y			+= arch/riscv/kernel/vdso/vdso.so.dbg
 vdso-install-$(CONFIG_COMPAT)	+= arch/riscv/kernel/compat_vdso/compat_vdso.so.dbg
 
-BOOT_TARGETS := Image Image.gz Image.bz2 Image.lz4 Image.lzma Image.lzo Image.zst loader loader.bin xipImage vmlinuz.efi
+BOOT_TARGETS := Image Image.gz Image.bz2 Image.lz4 Image.lzma Image.lzo Image.zst Image.xz loader loader.bin xipImage vmlinuz.efi
 
 all:	$(notdir $(KBUILD_IMAGE))
 
 loader.bin: loader
-Image.gz Image.bz2 Image.lz4 Image.lzma Image.lzo Image.zst loader xipImage vmlinuz.efi: Image
+Image.gz Image.bz2 Image.lz4 Image.lzma Image.lzo Image.zst Image.xz loader xipImage vmlinuz.efi: Image
 
 $(BOOT_TARGETS): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
@@ -225,6 +226,7 @@ define archhelp
   echo  '  Image.lzma	- Compressed kernel image (arch/riscv/boot/Image.lzma)'
   echo  '  Image.lzo	- Compressed kernel image (arch/riscv/boot/Image.lzo)'
   echo  '  Image.zst	- Compressed kernel image (arch/riscv/boot/Image.zst)'
+  echo  '  Image.xz	- Compressed kernel image (arch/riscv/boot/Image.xz)'
   echo  '  vmlinuz.efi	- Compressed EFI kernel image (arch/riscv/boot/vmlinuz.efi)'
   echo  '		  Default when CONFIG_EFI_ZBOOT=y'
   echo  '  xipImage	- Execute-in-place kernel image (arch/riscv/boot/xipImage)'
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are


