Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA40134CD2
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 22:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711060176; cv=none; b=NX2XcYcdeUCrr0Q/bLZFz2/DpHiZAPw1X7RK32bGAa3CRWi7mJ3D3kGTH1z/wM7p6J3QscO0F0ZBD3E+9NeZ3Gom2b3G79rcW2LE9g5q9/bMbmbQSKmF60LYg/Nu3IkLasvDAhsqstRH1IoP7itjEXpZaV8J3/T9b99j/3Gm01c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711060176; c=relaxed/simple;
	bh=opzSWBmOoLD+Crfq9j4MSi/logG0zDmpEcTCQYsy9CE=;
	h=Date:To:From:Subject:Message-Id; b=jm5V60DH2x2IWanauYDjXL1W38zjb8pC5xEMwR+7PfSUt9Xji9rSumJQfIIe90GdupPlFwGEHwBdYM/xyzr+0dW6wIAF8aL3qjZSTT5JurAUg333jqqQWXo9+L9HngSHK4whUwQLIJSLjm/N8l2Y46cV6HS/cFypsljQTshT16U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vF/mvI0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vF/mvI0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B5AC433C7;
	Thu, 21 Mar 2024 22:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711060175;
	bh=opzSWBmOoLD+Crfq9j4MSi/logG0zDmpEcTCQYsy9CE=;
	h=Date:To:From:Subject:From;
	b=vF/mvI0UqzeUMcj4fSBuRZBQx7shE88s6nvb6nibqHcPd5STCdezy+S+PAmAo0w66
	 BhqLo8ey4iOmA7CMl8LeoBOBLZv2kxHFON89HvfGZDdRryEP2kjbOQcJtpUsejnvfz
	 we1sCHOXKSe/tPgWj36AjQ/XhhevDzdX2BYMJWSY=
Date: Thu, 21 Mar 2024 15:29:35 -0700
To: mm-commits@vger.kernel.org,jiat0218@gmail.com,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xz-documentation-staging-xzrst-revise-thoroughly.patch added to mm-nonmm-unstable branch
Message-Id: <20240321222935.87B5AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xz: documentation/staging/xz.rst: revise thoroughly
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xz-documentation-staging-xzrst-revise-thoroughly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xz-documentation-staging-xzrst-revise-thoroughly.patch

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
Subject: xz: documentation/staging/xz.rst: revise thoroughly
Date: Wed, 20 Mar 2024 20:38:37 +0200

Add SPDX license identifier.

Omit xz_dec_test info. That isn't relevant to developers of non-XZ code.

Revise the docs about xzkern and add xzkern_with_size. The latter was
added to scripts/Makefile.lib in the commit 7ce7e984ab2b218d ("kbuild:
rename cmd_{bzip2,lzma,lzo,lz4,xzkern,zstd22}").

Omit contact info as MAINTAINERS has it.

Omit other info that is outdated or not relevant in the kernel context.

Link: https://lkml.kernel.org/r/20240320183846.19475-5-lasse.collin@tukaani.org
Co-developed-by: Jia Tan <jiat0218@gmail.com>
Signed-off-by: Jia Tan <jiat0218@gmail.com>
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/staging/xz.rst |  128 +++++++++++----------------------
 1 file changed, 45 insertions(+), 83 deletions(-)

--- a/Documentation/staging/xz.rst~xz-documentation-staging-xzrst-revise-thoroughly
+++ a/Documentation/staging/xz.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: 0BSD
+
 ============================
 XZ data compression in Linux
 ============================
@@ -6,21 +8,17 @@ Introduction
 ============
 
 XZ is a general purpose data compression format with high compression
-ratio and relatively fast decompression. The primary compression
-algorithm (filter) is LZMA2. Additional filters can be used to improve
-compression ratio even further. E.g. Branch/Call/Jump (BCJ) filters
-improve compression ratio of executable data.
-
-The XZ decompressor in Linux is called XZ Embedded. It supports
-the LZMA2 filter and optionally also BCJ filters. CRC32 is supported
-for integrity checking. The home page of XZ Embedded is at
-<https://tukaani.org/xz/embedded.html>, where you can find the
-latest version and also information about using the code outside
-the Linux kernel.
+ratio. The XZ decompressor in Linux is called XZ Embedded. It supports
+the LZMA2 filter and optionally also Branch/Call/Jump (BCJ) filters
+for executable code. CRC32 is supported for integrity checking. The
+home page of XZ Embedded is at <https://xz.tukaani.org/xz-embedded/>.
+There you can find the latest version which includes a few optional
+extra features that aren't required in the Linux kernel and information
+about using the code outside the Linux kernel.
 
 For userspace, XZ Utils provide a zlib-like compression library
 and a gzip-like command line tool. XZ Utils can be downloaded from
-<https://tukaani.org/xz/>.
+<https://xz.tukaani.org/xz-utils/>.
 
 XZ related components in the kernel
 ===================================
@@ -29,29 +27,24 @@ The xz_dec module provides XZ decompress
 to buffer) and multi-call (stateful) APIs. The usage of the xz_dec
 module is documented in include/linux/xz.h.
 
-The xz_dec_test module is for testing xz_dec. xz_dec_test is not
-useful unless you are hacking the XZ decompressor. xz_dec_test
-allocates a char device major dynamically to which one can write
-.xz files from userspace. The decompressed output is thrown away.
-Keep an eye on dmesg to see diagnostics printed by xz_dec_test.
-See the xz_dec_test source code for the details.
-
 For decompressing the kernel image, initramfs, and initrd, there
 is a wrapper function in lib/decompress_unxz.c. Its API is the
 same as in other decompress_*.c files, which is defined in
 include/linux/decompress/generic.h.
 
-scripts/xz_wrap.sh is a wrapper for the xz command line tool found
-from XZ Utils. The wrapper sets compression options to values suitable
-for compressing the kernel image.
-
-For kernel makefiles, two commands are provided for use with
-$(call if_needed). The kernel image should be compressed with
-$(call if_needed,xzkern) which will use a BCJ filter and a big LZMA2
-dictionary. It will also append a four-byte trailer containing the
-uncompressed size of the file, which is needed by the boot code.
-Other things should be compressed with $(call if_needed,xzmisc)
-which will use no BCJ filter and 1 MiB LZMA2 dictionary.
+For kernel makefiles, three commands are provided for use with
+$(call if_changed). They require the xz tool from XZ Utils.
+
+  - $(call if_changed,xzkern) is for compressing the kernel image.
+    It runs the script scripts/xz_wrap.sh which uses arch-optimized
+    options and a big LZMA2 dictionary.
+
+  - $(call if_changed,xzkern_with_size) is like xzkern above but this
+    also appends a four-byte trailer containing the uncompressed size
+    of the file, which is needed by the boot code on some archs.
+
+  - Other things can be compressed with $(call if_needed,xzmisc)
+    which will use no BCJ filter and 1 MiB LZMA2 dictionary.
 
 Notes on compression options
 ============================
@@ -61,7 +54,7 @@ CRC32, make sure that you don't use some
 when encoding files that are supposed to be decoded by the kernel. With
 liblzma, you need to use either LZMA_CHECK_NONE or LZMA_CHECK_CRC32
 when encoding. With the xz command line tool, use --check=none or
---check=crc32.
+--check=crc32 to override the default --check=crc64.
 
 Using CRC32 is strongly recommended unless there is some other layer
 which will verify the integrity of the uncompressed data anyway.
@@ -71,57 +64,26 @@ by the decoder; you can only change the
 disable it) for the actual uncompressed data.
 
 In userspace, LZMA2 is typically used with dictionary sizes of several
-megabytes. The decoder needs to have the dictionary in RAM, thus big
-dictionaries cannot be used for files that are intended to be decoded
-by the kernel. 1 MiB is probably the maximum reasonable dictionary
-size for in-kernel use (maybe more is OK for initramfs). The presets
-in XZ Utils may not be optimal when creating files for the kernel,
-so don't hesitate to use custom settings. Example::
-
-	xz --check=crc32 --lzma2=dict=512KiB inputfile
-
-An exception to above dictionary size limitation is when the decoder
-is used in single-call mode. Decompressing the kernel itself is an
-example of this situation. In single-call mode, the memory usage
-doesn't depend on the dictionary size, and it is perfectly fine to
-use a big dictionary: for maximum compression, the dictionary should
-be at least as big as the uncompressed data itself.
+megabytes. The decoder needs to have the dictionary in RAM:
 
-Future plans
-============
+  - In multi-call mode the dictionary is allocated as part of the
+    decoder state. The reasonable maximum dictionary size for in-kernel
+    use will depend on the target hardware: a few megabytes should be
+    fine for desktop systems while 64 KiB to 1 MiB might be more
+    appropriate on some embedded systems.
+
+  - In single-call mode the output buffer is used as the dictionary
+    buffer. That is, the size of the dictionary doesn't affect the
+    decompressor memory usage at all. Only the base data structures
+    are allocated which take a little less than 30 KiB of memory.
+    For the best compression, the dictionary should be at least
+    as big as the uncompressed data. A notable example of single-call
+    mode is decompressing the kernel itself (except on PowerPC).
+
+The compression presets in XZ Utils may not be optimal when creating
+files for the kernel, so don't hesitate to use custom settings to,
+for example, set the dictionary size. Also, xz may produce a smaller
+file in single-threaded mode so setting that explicitly is recommended.
+Example::
 
-Creating a limited XZ encoder may be considered if people think it is
-useful. LZMA2 is slower to compress than e.g. Deflate or LZO even at
-the fastest settings, so it isn't clear if LZMA2 encoder is wanted
-into the kernel.
-
-Support for limited random-access reading is planned for the
-decompression code. I don't know if it could have any use in the
-kernel, but I know that it would be useful in some embedded projects
-outside the Linux kernel.
-
-Conformance to the .xz file format specification
-================================================
-
-There are a couple of corner cases where things have been simplified
-at expense of detecting errors as early as possible. These should not
-matter in practice all, since they don't cause security issues. But
-it is good to know this if testing the code e.g. with the test files
-from XZ Utils.
-
-Reporting bugs
-==============
-
-Before reporting a bug, please check that it's not fixed already
-at upstream. See <https://tukaani.org/xz/embedded.html> to get the
-latest code.
-
-Report bugs to <lasse.collin@tukaani.org> or visit #tukaani on
-Freenode and talk to Larhzu. I don't actively read LKML or other
-kernel-related mailing lists, so if there's something I should know,
-you should email to me personally or use IRC.
-
-Don't bother Igor Pavlov with questions about the XZ implementation
-in the kernel or about XZ Utils. While these two implementations
-include essential code that is directly based on Igor Pavlov's code,
-these implementations aren't maintained nor supported by him.
+    xz --threads=1 --check=crc32 --lzma2=dict=512KiB inputfile
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

