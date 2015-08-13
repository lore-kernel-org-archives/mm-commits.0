From: akpm@linux-foundation.org
Subject: +
 lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel.patch added
 to -mm tree
Date: Thu, 13 Aug 2015 14:03:41 -0700
Message-ID: <55cd062d.qxQv56vyceit/0Nk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbbHMVDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Aug 2015 17:03:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, acourbot@nvidia.com, hpa@zytor.com, mingo@redhat.com, stable@vger.kernel.org, swarren@wwwdotorg.org, tglx@linutronix.de, tixy@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/decompressors: use real out buf size for gunzip with kernel
has been added to the -mm tree.  Its filename is
     lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: lib/decompressors: use real out buf size for gunzip with kernel

When loading x86 64bit kernel above 4GiB with patched grub2, got kernel
gunzip error.

| early console in decompress_kernel
| decompress_kernel:
|       input: [0x807f2143b4-0x807ff61aee]
|      output: [0x807cc00000-0x807f3ea29b] 0x027ea29c: output_len
| boot via startup_64
| KASLR using RDTSC...
|  new output: [0x46fe000000-0x470138cfff] 0x0338d000: output_run_size
|  decompress: [0x46fe000000-0x47007ea29b] <=== [0x807f2143b4-0x807ff61aee]
|
| Decompressing Linux... gz...
|
| uncompression error
|
| -- System halted

the new buffer is at 0x46fe000000ULL, decompressor_gzip is using
0xffffffb901ffffff as out_len.  gunzip in lib/zlib_inflate/inflate.c cap
that len to 0x01ffffff and decompress fails later.

We could hit this problem with crashkernel booting that uses kexec
loading kernel above 4GiB.

We have decompress_* support:
    1. inbuf[]/outbuf[] for kernel preboot.
    2. inbuf[]/flush() for initramfs
    3. fill()/flush() for initrd.
This bug only affect kernel preboot path that use outbuf[].

Add __decompress and take real out_buf_len for gunzip instead of guessing
wrong buf size.

Fixes: 1431574a1c4 (lib/decompressors: fix "no limit" output buffer length)
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>
Cc: Jon Medhurst <tixy@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/compressed/misc.c |    3 +-
 lib/decompress_bunzip2.c        |    9 ++++++
 lib/decompress_inflate.c        |   40 ++++++++++++++++++++++++++----
 lib/decompress_unlz4.c          |   10 +++++++
 lib/decompress_unlzma.c         |   10 +++++++
 lib/decompress_unlzo.c          |   22 +++++++++++++++-
 lib/decompress_unxz.c           |   21 +++++++++++++++
 7 files changed, 107 insertions(+), 8 deletions(-)

diff -puN arch/x86/boot/compressed/misc.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel arch/x86/boot/compressed/misc.c
--- a/arch/x86/boot/compressed/misc.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel
+++ a/arch/x86/boot/compressed/misc.c
@@ -424,7 +424,8 @@ asmlinkage __visible void *decompress_ke
 #endif
 
 	debug_putstr("\nDecompressing Linux... ");
-	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
+	__decompress(input_data, input_len, NULL, NULL, output, output_len,
+			NULL, error);
 	parse_elf(output);
 	/*
 	 * 32-bit always performs relocations. 64-bit relocations are only
diff -puN lib/decompress_bunzip2.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel lib/decompress_bunzip2.c
--- a/lib/decompress_bunzip2.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel
+++ a/lib/decompress_bunzip2.c
@@ -752,4 +752,13 @@ STATIC int INIT decompress(unsigned char
 {
 	return bunzip2(buf, len - 4, fill, flush, outbuf, pos, error);
 }
+STATIC int INIT __decompress(unsigned char *buf, long len,
+			long (*fill)(void*, unsigned long),
+			long (*flush)(void*, unsigned long),
+			unsigned char *outbuf, long olen,
+			long *pos,
+			void (*error)(char *x))
+{
+	return bunzip2(buf, len - 4, fill, flush, outbuf, pos, error);
+}
 #endif
diff -puN lib/decompress_inflate.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel lib/decompress_inflate.c
--- a/lib/decompress_inflate.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel
+++ a/lib/decompress_inflate.c
@@ -1,4 +1,5 @@
 #ifdef STATIC
+#define PREBOOT
 /* Pre-boot environment: included */
 
 /* prevent inclusion of _LINUX_KERNEL_H in pre-boot environment: lots
@@ -33,23 +34,23 @@ static long INIT nofill(void *buffer, un
 }
 
 /* Included from initramfs et al code */
-STATIC int INIT gunzip(unsigned char *buf, long len,
+STATIC int INIT __gunzip(unsigned char *buf, long len,
 		       long (*fill)(void*, unsigned long),
 		       long (*flush)(void*, unsigned long),
-		       unsigned char *out_buf,
+		       unsigned char *out_buf, long out_len,
 		       long *pos,
 		       void(*error)(char *x)) {
 	u8 *zbuf;
 	struct z_stream_s *strm;
 	int rc;
-	size_t out_len;
 
 	rc = -1;
 	if (flush) {
 		out_len = 0x8000; /* 32 K */
 		out_buf = malloc(out_len);
 	} else {
-		out_len = ((size_t)~0) - (size_t)out_buf; /* no limit */
+		if (!out_len)
+			out_len = ((size_t)~0) - (size_t)out_buf; /* no limit */
 	}
 	if (!out_buf) {
 		error("Out of memory while allocating output buffer");
@@ -181,4 +182,33 @@ gunzip_nomem1:
 	return rc; /* returns Z_OK (0) if successful */
 }
 
-#define decompress gunzip
+STATIC int INIT gunzip(unsigned char *buf, long len,
+		       long (*fill)(void*, unsigned long),
+		       long (*flush)(void*, unsigned long),
+		       unsigned char *out_buf,
+		       long *pos,
+		       void (*error)(char *x))
+{
+	return __gunzip(buf, len, fill, flush, out_buf, 0, pos, error);
+}
+
+#ifdef PREBOOT
+STATIC int INIT decompress(unsigned char *buf, long len,
+			   long (*fill)(void*, unsigned long),
+			   long (*flush)(void*, unsigned long),
+			   unsigned char *out_buf,
+			   long *pos,
+			   void (*error)(char *x))
+{
+	return gunzip(buf, len, fill, flush, out_buf, pos, error);
+}
+STATIC int INIT __decompress(unsigned char *buf, long len,
+			   long (*fill)(void*, unsigned long),
+			   long (*flush)(void*, unsigned long),
+			   unsigned char *out_buf, long out_len,
+			   long *pos,
+			   void (*error)(char *x))
+{
+	return __gunzip(buf, len, fill, flush, out_buf, out_len, pos, error);
+}
+#endif
diff -puN lib/decompress_unlz4.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel lib/decompress_unlz4.c
--- a/lib/decompress_unlz4.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel
+++ a/lib/decompress_unlz4.c
@@ -206,4 +206,14 @@ STATIC int INIT decompress(unsigned char
 {
 	return unlz4(buf, in_len - 4, fill, flush, output, posp, error);
 }
+STATIC int INIT __decompress(unsigned char *buf, long in_len,
+			      long (*fill)(void*, unsigned long),
+			      long (*flush)(void*, unsigned long),
+			      unsigned char *output, long out_len,
+			      long *posp,
+			      void (*error)(char *x)
+	)
+{
+	return unlz4(buf, in_len - 4, fill, flush, output, posp, error);
+}
 #endif
diff -puN lib/decompress_unlzma.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel lib/decompress_unlzma.c
--- a/lib/decompress_unlzma.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel
+++ a/lib/decompress_unlzma.c
@@ -677,4 +677,14 @@ STATIC int INIT decompress(unsigned char
 {
 	return unlzma(buf, in_len - 4, fill, flush, output, posp, error);
 }
+STATIC int INIT __decompress(unsigned char *buf, long in_len,
+			      long (*fill)(void*, unsigned long),
+			      long (*flush)(void*, unsigned long),
+			      unsigned char *output, long out_len,
+			      long *posp,
+			      void (*error)(char *x)
+	)
+{
+	return unlzma(buf, in_len - 4, fill, flush, output, posp, error);
+}
 #endif
diff -puN lib/decompress_unlzo.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel lib/decompress_unlzo.c
--- a/lib/decompress_unlzo.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel
+++ a/lib/decompress_unlzo.c
@@ -31,6 +31,7 @@
  */
 
 #ifdef STATIC
+#define PREBOOT
 #include "lzo/lzo1x_decompress_safe.c"
 #else
 #include <linux/decompress/unlzo.h>
@@ -287,4 +288,23 @@ exit:
 	return ret;
 }
 
-#define decompress unlzo
+#ifdef PREBOOT
+STATIC int INIT decompress(unsigned char *buf, long len,
+			   long (*fill)(void*, unsigned long),
+			   long (*flush)(void*, unsigned long),
+			   unsigned char *out_buf,
+			   long *pos,
+			   void (*error)(char *x))
+{
+	return unlzo(buf, len, fill, flush, out_buf, pos, error);
+}
+STATIC int INIT __decompress(unsigned char *buf, long len,
+			   long (*fill)(void*, unsigned long),
+			   long (*flush)(void*, unsigned long),
+			   unsigned char *out_buf, long olen,
+			   long *pos,
+			   void (*error)(char *x))
+{
+	return unlzo(buf, len, fill, flush, out_buf, pos, error);
+}
+#endif
diff -puN lib/decompress_unxz.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel lib/decompress_unxz.c
--- a/lib/decompress_unxz.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel
+++ a/lib/decompress_unxz.c
@@ -394,4 +394,23 @@ error_alloc_state:
  * This macro is used by architecture-specific files to decompress
  * the kernel image.
  */
-#define decompress unxz
+#ifdef XZ_PREBOOT
+STATIC int INIT decompress(unsigned char *buf, long len,
+			   long (*fill)(void*, unsigned long),
+			   long (*flush)(void*, unsigned long),
+			   unsigned char *out_buf,
+			   long *pos,
+			   void (*error)(char *x))
+{
+	return unxz(buf, len, fill, flush, out_buf, pos, error);
+}
+STATIC int INIT __decompress(unsigned char *buf, long len,
+			   long (*fill)(void*, unsigned long),
+			   long (*flush)(void*, unsigned long),
+			   unsigned char *out_buf, long olen,
+			   long *pos,
+			   void (*error)(char *x))
+{
+	return unxz(buf, len, fill, flush, out_buf, pos, error);
+}
+#endif
_

Patches currently in -mm which might be from yinghai@kernel.org are

mm-add-utility-for-early-copy-from-unmapped-ram.patch
arm64-support-initrd-outside-kernel-linear-map.patch
x86-use-generic-early-mem-copy.patch
x86-use-generic-early-mem-copy-fix.patch
lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel.patch
linux-next.patch

