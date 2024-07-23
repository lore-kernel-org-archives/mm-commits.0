Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819C0130AC8
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 02:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721701775; cv=none; b=ggJn0GsQVDX0REEe2z9bYU+J1SywVpYVD/OjgkaV2tqoNUjELtPL0sy0ajKHr/6YND5F+BB2JbE5SiNxMX/g7uEQi4Dfggm6C0DjQFgj7fgrAf9ryUWQpNsoaSKXtkPWLYpoh+nIAN9W64f8NXA6UYR2t5iiUG6nhxEOZC4HqLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721701775; c=relaxed/simple;
	bh=tFF29ih//PU5/VuUnRFPp1GG130TLabObTNo3CUE+hQ=;
	h=Date:To:From:Subject:Message-Id; b=KPoRFHU2YXL/ShRRLnRo3t/NQ8sNT3oufO8OxHeBDmTRtDnzMMORugNaLc3qq7n+TeMB+arYPuPEMv+jnnLu21SIOXmZKVSnqH72jEFhWjbu1/TnyOhrgwmH72eK5SIsNxpo+3msQVmwftKU6KrhbrvAWSp58NDD4dyHbd7kWyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h8qqTNh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h8qqTNh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F6CC116B1;
	Tue, 23 Jul 2024 02:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721701775;
	bh=tFF29ih//PU5/VuUnRFPp1GG130TLabObTNo3CUE+hQ=;
	h=Date:To:From:Subject:From;
	b=h8qqTNh43u4lPyTTmRYksqN0jvXtm9ulMubQnBMrr67zFP41G6oYPaX757e7PXCqw
	 zl4Bd6eKnu/JH5HbQ8gQXThH0oH0097vgQxqPSIWB8p0AsMmlusJigJMg61CqcNYSw
	 pYmeQfrb0cusSHLOocAKQnCPtnzwJfQ4C0XybQW0=
Date: Mon, 22 Jul 2024 19:29:34 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xz-adjust-arch-specific-options-for-better-kernel-compression.patch added to mm-nonmm-unstable branch
Message-Id: <20240723022935.52F6CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xz: adjust arch-specific options for better kernel compression
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xz-adjust-arch-specific-options-for-better-kernel-compression.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xz-adjust-arch-specific-options-for-better-kernel-compression.patch

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
Subject: xz: adjust arch-specific options for better kernel compression
Date: Sun, 21 Jul 2024 16:36:29 +0300

Use LZMA2 options that match the arch-specific alignment of instructions. 
This change reduces compressed kernel size 0-2 % depending on the arch. 
On 1-byte-aligned x86 it makes no difference and on 4-byte-aligned archs
it helps the most.

Use the ARM-Thumb filter for ARM-Thumb2 kernels.  This reduces compressed
kernel size about 5 %.[1] Previously such kernels were compressed using
the ARM filter which didn't do anything useful with ARM-Thumb2 code.

Add BCJ filter support for ARM64 and RISC-V.  Compared to unfiltered XZ or
plain LZMA, the compressed kernel size is reduced about 5 % on ARM64 and 7
% on RISC-V.  A new enough version of the xz tool is required: 5.4.0 for
ARM64 and 5.6.0 for RISC-V.  With an old xz version, a message is printed
to standard error and the kernel is compressed without the filter.

Update lib/decompress_unxz.c to match the changes to xz_wrap.sh.

Update the CONFIG_KERNEL_XZ help text in init/Kconfig:
  - Add the RISC-V and ARM64 filters.
  - Clarify that the PowerPC filter is for big endian only.
  - Omit IA-64.

Link: https://lore.kernel.org/lkml/1637379771-39449-1-git-send-email-zhongjubin@huawei.com/ [1]
Link: https://lkml.kernel.org/r/20240721133633.47721-15-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Sam James <sam@gentoo.org>
Cc: Simon Glass <sjg@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Jubin Zhong <zhongjubin@huawei.com>
Cc: Jules Maselbas <jmaselbas@zdiv.net>
Cc: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rui Li <me@lirui.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig          |    5 -
 lib/decompress_unxz.c |   14 +++
 scripts/xz_wrap.sh    |  142 ++++++++++++++++++++++++++++++++++++++--
 3 files changed, 152 insertions(+), 9 deletions(-)

--- a/init/Kconfig~xz-adjust-arch-specific-options-for-better-kernel-compression
+++ a/init/Kconfig
@@ -310,8 +310,9 @@ config KERNEL_XZ
 	  BCJ filters which can improve compression ratio of executable
 	  code. The size of the kernel is about 30% smaller with XZ in
 	  comparison to gzip. On architectures for which there is a BCJ
-	  filter (i386, x86_64, ARM, IA-64, PowerPC, and SPARC), XZ
-	  will create a few percent smaller kernel than plain LZMA.
+	  filter (i386, x86_64, ARM, ARM64, RISC-V, big endian PowerPC,
+	  and SPARC), XZ will create a few percent smaller kernel than
+	  plain LZMA.
 
 	  The speed is about the same as with LZMA: The decompression
 	  speed of XZ is better than that of bzip2 but worse than gzip
--- a/lib/decompress_unxz.c~xz-adjust-arch-specific-options-for-better-kernel-compression
+++ a/lib/decompress_unxz.c
@@ -126,11 +126,21 @@
 #ifdef CONFIG_X86
 #	define XZ_DEC_X86
 #endif
-#ifdef CONFIG_PPC
+#if defined(CONFIG_PPC) && defined(CONFIG_CPU_BIG_ENDIAN)
 #	define XZ_DEC_POWERPC
 #endif
 #ifdef CONFIG_ARM
-#	define XZ_DEC_ARM
+#	ifdef CONFIG_THUMB2_KERNEL
+#		define XZ_DEC_ARMTHUMB
+#	else
+#		define XZ_DEC_ARM
+#	endif
+#endif
+#ifdef CONFIG_ARM64
+#	define XZ_DEC_ARM64
+#endif
+#ifdef CONFIG_RISCV
+#	define XZ_DEC_RISCV
 #endif
 #ifdef CONFIG_SPARC
 #	define XZ_DEC_SPARC
--- a/scripts/xz_wrap.sh~xz-adjust-arch-specific-options-for-better-kernel-compression
+++ a/scripts/xz_wrap.sh
@@ -6,14 +6,146 @@
 #
 # Author: Lasse Collin <lasse.collin@tukaani.org>
 
+# This has specialized settings for the following archs. However,
+# XZ-compressed kernel isn't currently supported on every listed arch.
+#
+#   Arch        Align   Notes
+#   arm          2/4    ARM and ARM-Thumb2
+#   arm64         4
+#   csky          2
+#   loongarch     4
+#   mips         2/4    MicroMIPS is 2-byte aligned
+#   parisc        4
+#   powerpc       4     Uses its own wrapper for compressors instead of this.
+#   riscv        2/4
+#   s390          2
+#   sh            2
+#   sparc         4
+#   x86           1
+
+# A few archs use 2-byte or 4-byte aligned instructions depending on
+# the kernel config. This function is used to check if the relevant
+# config option is set to "y".
+is_enabled()
+{
+	grep -q "^$1=y$" include/config/auto.conf
+}
+
+# XZ_VERSION is needed to disable features that aren't available in
+# old XZ Utils versions.
+XZ_VERSION=$($XZ --robot --version) || exit
+XZ_VERSION=$(printf '%s\n' "$XZ_VERSION" | sed -n 's/^XZ_VERSION=//p')
+
+# Assume that no BCJ filter is available.
 BCJ=
-LZMA2OPTS=
 
+# Set the instruction alignment to 1, 2, or 4 bytes.
+#
+# Set the BCJ filter if one is available.
+# It must match the #ifdef usage in lib/decompress_unxz.c.
 case $SRCARCH in
-	x86)            BCJ=--x86 ;;
-	powerpc)        BCJ=--powerpc ;;
-	arm)            BCJ=--arm ;;
-	sparc)          BCJ=--sparc ;;
+	arm)
+		if is_enabled CONFIG_THUMB2_KERNEL; then
+			ALIGN=2
+			BCJ=--armthumb
+		else
+			ALIGN=4
+			BCJ=--arm
+		fi
+		;;
+
+	arm64)
+		ALIGN=4
+
+		# ARM64 filter was added in XZ Utils 5.4.0.
+		if [ "$XZ_VERSION" -ge 50040002 ]; then
+			BCJ=--arm64
+		else
+			echo "$0: Upgrading to xz >= 5.4.0" \
+				"would enable the ARM64 filter" \
+				"for better compression" >&2
+		fi
+		;;
+
+	csky)
+		ALIGN=2
+		;;
+
+	loongarch)
+		ALIGN=4
+		;;
+
+	mips)
+		if is_enabled CONFIG_CPU_MICROMIPS; then
+			ALIGN=2
+		else
+			ALIGN=4
+		fi
+		;;
+
+	parisc)
+		ALIGN=4
+		;;
+
+	powerpc)
+		ALIGN=4
+
+		# The filter is only for big endian instruction encoding.
+		if is_enabled CONFIG_CPU_BIG_ENDIAN; then
+			BCJ=--powerpc
+		fi
+		;;
+
+	riscv)
+		if is_enabled CONFIG_RISCV_ISA_C; then
+			ALIGN=2
+		else
+			ALIGN=4
+		fi
+
+		# RISC-V filter was added in XZ Utils 5.6.0.
+		if [ "$XZ_VERSION" -ge 50060002 ]; then
+			BCJ=--riscv
+		else
+			echo "$0: Upgrading to xz >= 5.6.0" \
+				"would enable the RISC-V filter" \
+				"for better compression" >&2
+		fi
+		;;
+
+	s390)
+		ALIGN=2
+		;;
+
+	sh)
+		ALIGN=2
+		;;
+
+	sparc)
+		ALIGN=4
+		BCJ=--sparc
+		;;
+
+	x86)
+		ALIGN=1
+		BCJ=--x86
+		;;
+
+	*)
+		echo "$0: Arch-specific tuning is missing for '$SRCARCH'" >&2
+
+		# Guess 2-byte-aligned instructions. Guessing too low
+		# should hurt less than guessing too high.
+		ALIGN=2
+		;;
+esac
+
+# Select the LZMA2 options matching the instruction alignment.
+case $ALIGN in
+	1)  LZMA2OPTS= ;;
+	2)  LZMA2OPTS=lp=1 ;;
+	4)  LZMA2OPTS=lp=2,lc=2 ;;
+	*)  echo "$0: ALIGN wrong or missing" >&2; exit 1 ;;
 esac
 
 # Use single-threaded mode because it compresses a little better
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

