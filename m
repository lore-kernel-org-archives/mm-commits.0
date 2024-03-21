Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1891113667C
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 22:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711060190; cv=none; b=BqE0ZXeh63qiHfnG318coPK0QU4SEIiXDDjv3LeYUaf8RPHRq0/OvYdJfu8axEgX9hsZAQF2GJk1GN8+ZIAFF7E4E9E2/1cQtE83fIP/ty4R4OLZ1deL7DFhv1XCg0bUcTctEwrRY6bfcB9x9hhxyi1BP63FlJTx00c3jsyDrpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711060190; c=relaxed/simple;
	bh=ZRZUExAzMp+heeo6evaU0IsP7UcRK346Bm05DGQS5b0=;
	h=Date:To:From:Subject:Message-Id; b=SYUgYqKsho43Wz8lyhpkzoLQGw7UbFEObeTp8MWnBJTBSaaGQup1aQiV24yH7XRScr03n17LDEFDL5l0q2DX+Y/NHDlp4JnLBSgv8XQwj+WS1LV2SIiJitnkD00GuAKVOA8Z+LzmvPUVb7JgRGfl3+ra0im9HiLUGVs3XrYqHas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R8h2glmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R8h2glmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE512C433C7;
	Thu, 21 Mar 2024 22:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711060190;
	bh=ZRZUExAzMp+heeo6evaU0IsP7UcRK346Bm05DGQS5b0=;
	h=Date:To:From:Subject:From;
	b=R8h2glmd994g78DL66Op7e9w/0fcoXQJ8zTt64lD8Lo1uiQr8xy1IZ2i8xVzGAU37
	 PlOsUYYxaMZVmsfY+/0gpd3DI7EuQy0BiZgnqrCKTwZi4OLIUVIbjeWKovNNSVLMkL
	 fwt4up5QMpAMjBT6ShRRJ9R8IDlXBbrDfIJBoQ1s=
Date: Thu, 21 Mar 2024 15:29:49 -0700
To: mm-commits@vger.kernel.org,jiat0218@gmail.com,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch added to mm-nonmm-unstable branch
Message-Id: <20240321222949.DE512C433C7@smtp.kernel.org>
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
Date: Wed, 20 Mar 2024 20:38:43 +0200

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

Link: https://lkml.kernel.org/r/20240320183846.19475-11-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Jia Tan <jiat0218@gmail.com>
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

maintainers-add-xz-embedded-maintainers.patch
licenses-add-0bsd-license-text.patch
xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd.patch
xz-documentation-staging-xzrst-revise-thoroughly.patch
xz-fix-comments-and-coding-style.patch
xz-cleanup-crc32-edits-from-2018.patch
xz-optimize-for-loop-conditions-in-the-bcj-decoders.patch
xz-add-arm64-bcj-filter.patch
xz-add-risc-v-bcj-filter.patch
xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch
xz-adjust-arch-specific-options-for-better-kernel-compression.patch

