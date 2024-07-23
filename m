Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690DE130AC8
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 02:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721701773; cv=none; b=CySFlP4oOYVhP/hCAY2dNGDa99R7vevJtmhwr7Z2eIt6pHCuN/8eRTJAPsuov0i76mFmXPM0YBVIiiEXVirE7ySYdZIyLBTyBS3e8dsCtPOoVLR6GRGhYdHSt6sbIGqaZheNj2pmRTJJ/J+aiwhezDpZpaalMAk1tmqS/EIlv5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721701773; c=relaxed/simple;
	bh=2ylVzgpZF0YvcgZPxyIqOPmHMCQrJDiSXPCgiUuvmBk=;
	h=Date:To:From:Subject:Message-Id; b=u2S6tUtLE0KZJqE+ANrFkchPjUpr/5TkJmmJf72uBuDF9eCv2ZS31j/2Q9r4shpW2PGmjKeZBlRtut/iThM1i/j2a5l16xYJyN1jJqV3T8/NIVsBwQb8c16pDxmQE+KAjBHIgbDpWl1fLF9qEBJHePdo05WrVXCLyQuAyNm6JI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lerg2Jn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lerg2Jn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAA3C116B1;
	Tue, 23 Jul 2024 02:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721701773;
	bh=2ylVzgpZF0YvcgZPxyIqOPmHMCQrJDiSXPCgiUuvmBk=;
	h=Date:To:From:Subject:From;
	b=lerg2Jn7coMHorY4P0tYVs/WLxrQIUjwL1DUN1fRuUvDspoHETFJ2tWWa/XTHdv2R
	 XNNhP3oq+RdlEhHoDkqGT2supXrq2fSLUSRKgsJxxBWBoaiOksFxuNztw8GHRhJlAT
	 d12YJ+KIww9N7jKDhcCIUOnyq3V/YVb5ealZrpw4=
Date: Mon, 22 Jul 2024 19:29:32 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch added to mm-nonmm-unstable branch
Message-Id: <20240723022933.3CAA3C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xz: use 128 MiB dictionary and force single-threaded mode
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch

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
Subject: xz: use 128 MiB dictionary and force single-threaded mode
Date: Sun, 21 Jul 2024 16:36:28 +0300

This only affects kernel image compression, not any other xz usage.

Desktop kernels on x86-64 are already around 60 MiB.  Using a dictionary
larger than 32 MiB should have no downsides nowadays as anyone building
the kernel should have plenty of RAM.  128 MiB dictionary needs 1346 MiB
of RAM with xz versions 5.0.x - 5.6.x in single-threaded mode.  On archs
that use xz_wrap.sh, kernel decompression is done in single-call mode so a
larger dictionary doesn't affect boot-time memory requirements.

xz >= 5.6.0 uses multithreaded mode by default which compresses slightly
worse than single-threaded mode.  Kernel compression rarely used more than
one thread anyway because with 32 MiB dictionary size the default block
size was 96 MiB in multithreaded mode.  So only a single thread was used
anyway unless the kernel was over 96 MiB.

Comparison to CONFIG_KERNEL_LZMA: It uses "lzma -9" which mapped to 32 MiB
dictionary in LZMA Utils 4.32.7 (the final release in 2008).  Nowadays the
lzma tool on most systems is from XZ Utils where -9 maps to 64 MiB
dictionary.  So using a 32 MiB dictionary with CONFIG_KERNEL_XZ may have
compressed big kernels slightly worse than the old LZMA option.

Comparison to CONFIG_KERNEL_ZSTD: zstd uses 128 MiB dictionary.

Link: https://lkml.kernel.org/r/20240721133633.47721-14-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Sam James <sam@gentoo.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jubin Zhong <zhongjubin@huawei.com>
Cc: Jules Maselbas <jmaselbas@zdiv.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rui Li <me@lirui.org>
Cc: Simon Glass <sjg@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/xz_wrap.sh |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/scripts/xz_wrap.sh~xz-use-128-mib-dictionary-and-force-single-threaded-mode
+++ a/scripts/xz_wrap.sh
@@ -16,4 +16,15 @@ case $SRCARCH in
 	sparc)          BCJ=--sparc ;;
 esac
 
-exec $XZ --check=crc32 $BCJ --lzma2=$LZMA2OPTS,dict=32MiB
+# Use single-threaded mode because it compresses a little better
+# (and uses less RAM) than multithreaded mode.
+#
+# For the best compression, the dictionary size shouldn't be
+# smaller than the uncompressed kernel. 128 MiB dictionary
+# needs less than 1400 MiB of RAM in single-threaded mode.
+#
+# On the archs that use this script to compress the kernel,
+# decompression in the preboot code is done in single-call mode.
+# Thus the dictionary size doesn't affect the memory requirements
+# of the preboot decompressor at all.
+exec $XZ --check=crc32 --threads=1 $BCJ --lzma2=$LZMA2OPTS,dict=128MiB
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

