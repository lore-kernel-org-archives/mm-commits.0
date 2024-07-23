Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2814E130AC8
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 02:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721701780; cv=none; b=p+fqcbytTskLs8c066arSdSaL7Q0lmdOzpyNcvSHyNnfsiYf1/+NRyATAFe+eNaFcWMGIW6ETES1ErIJex22LfKOBqIZ2M4p3ME1SShdfXraBlWVJsfvEZhroQNUSrNEu4PDd9qcoKs/5OcaWiORh9vS0zLyH39pG+sq0MlZxYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721701780; c=relaxed/simple;
	bh=84v33rKOcpp3vM2hnJnlVXgTvn0vvUZvZfBTFLgPFZE=;
	h=Date:To:From:Subject:Message-Id; b=fTiBbRaXoYfqkUkFk2+QrqMAWXgy79UBXYTJAWG1KQ/wIGPzUJW9sB5QxhQjzSbamnJkunfzMXvnu7xj69c/GUK6s/EOOMYoV5S2cUSmuQ7pU7m19yzJxLK8B7NUHBHm6PxmLD/yVGEYZvVKRGhGW0LMbn/Z74dxDxeXrRF3/DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QyB1OhiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QyB1OhiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F92C116B1;
	Tue, 23 Jul 2024 02:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721701780;
	bh=84v33rKOcpp3vM2hnJnlVXgTvn0vvUZvZfBTFLgPFZE=;
	h=Date:To:From:Subject:From;
	b=QyB1OhiHCKGhgkZhoRMDuiVdBJt4Q2zsFvpiVo4nsiV+rzgw1bxgpujASXz8s7Z3Q
	 EtuNfwtu8b+gPq82w94TK5Qq1wuW4EC44vpN15becGvYsoyKwUPlWiNtiyyFudIM6s
	 YD/JR29WpPOP5fcq2DRZfyjpgf/w83JIGvVKQZ1Y=
Date: Mon, 22 Jul 2024 19:29:39 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-boot-add-imagexz-support.patch added to mm-nonmm-unstable branch
Message-Id: <20240723022939.F3F92C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: boot: add Image.xz support
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     riscv-boot-add-imagexz-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-boot-add-imagexz-support.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
@@ -65,6 +65,9 @@ $(obj)/Image.lzo: $(obj)/Image FORCE
 $(obj)/Image.zst: $(obj)/Image FORCE
 	$(call if_changed,zstd)
 
+$(obj)/Image.xz: $(obj)/Image FORCE
+	$(call if_changed,xzkern)
+
 $(obj)/loader.bin: $(obj)/loader FORCE
 	$(call if_changed,objcopy)
 
--- a/arch/riscv/Kconfig~riscv-boot-add-imagexz-support
+++ a/arch/riscv/Kconfig
@@ -153,6 +153,7 @@ config RISCV
 	select HAVE_KERNEL_LZO if !XIP_KERNEL && !EFI_ZBOOT
 	select HAVE_KERNEL_UNCOMPRESSED if !XIP_KERNEL && !EFI_ZBOOT
 	select HAVE_KERNEL_ZSTD if !XIP_KERNEL && !EFI_ZBOOT
+	select HAVE_KERNEL_XZ if !XIP_KERNEL && !EFI_ZBOOT
 	select HAVE_KPROBES if !XIP_KERNEL
 	select HAVE_KPROBES_ON_FTRACE if !XIP_KERNEL
 	select HAVE_KRETPROBES if !XIP_KERNEL
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

maintainers-add-xz-embedded-maintainer.patch
licenses-add-0bsd-license-text.patch
xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd.patch
xz-fix-comments-and-coding-style.patch
xz-fix-kernel-doc-formatting-errors-in-xzh.patch
xz-improve-the-microlzma-kernel-doc-in-xzh.patch
xz-documentation-staging-xzrst-revise-thoroughly.patch
docs-add-xz_extern-to-c_id_attributes.patch
xz-cleanup-crc32-edits-from-2018.patch
xz-optimize-for-loop-conditions-in-the-bcj-decoders.patch
xz-add-arm64-bcj-filter.patch
xz-add-risc-v-bcj-filter.patch
xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch
xz-adjust-arch-specific-options-for-better-kernel-compression.patch
arm64-boot-add-imagexz-support.patch
riscv-boot-add-imagexz-support.patch

