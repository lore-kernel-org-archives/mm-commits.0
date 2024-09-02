Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28001388
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248774; cv=none; b=YgYLkE/jyO0R/aQ9mhCtQqczlL7G55RD+vr7n/g0dtHTklKvhAeRKFx89Bm7ljKnpQM8bh7PtlpnKlp6AzdY+1UZrVrm6N/oODheOpXEC+XrpNbQrRms2Y1A2YwcEKTjUt3L1u0HTA0d4E5mL+meqS0BWdVzXAAEjZHTEHTvqY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248774; c=relaxed/simple;
	bh=CaVx3jwmAJu3lfoQpkzDDGBiFZDJopRrD0A9Txz5Vso=;
	h=Date:To:From:Subject:Message-Id; b=iSB1lMkyTo2+PcW1zch9hkQIiJRw44ZTrXLEMsxe0gkCBTfsRpOEqF6kqAl+LQlnkAh3AVi6urkHse2vCztCVHjP8lkv/nJA4aBWMkHlAkuGVdWxKbO052Mg340GcfwO2lSEe94/PhF6uX30JSGPhPAcryxjeQ8d4KWL189P3LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vJrxXX1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vJrxXX1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB53C4CEC2;
	Mon,  2 Sep 2024 03:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248774;
	bh=CaVx3jwmAJu3lfoQpkzDDGBiFZDJopRrD0A9Txz5Vso=;
	h=Date:To:From:Subject:From;
	b=vJrxXX1MjM4MYcKl5zGcybsW36a3ueK4MxSBjbfzX0Q2GNV4pMB5FH1Gvt7iWDq+B
	 FugUonO65fGxJyx2N5mNCXXeDQAF+xKG6Res8uYACRFYkYZ4mrw+N2kLqbDbk8mte9
	 +Hf1UuT00N7mgLMjilT9GoPE61ecmMfVvOM9UW+Q=
Date: Sun, 01 Sep 2024 20:46:13 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch removed from -mm tree
Message-Id: <20240902034614.3DB53C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xz: use 128 MiB dictionary and force single-threaded mode
has been removed from the -mm tree.  Its filename was
     xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


