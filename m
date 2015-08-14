From: akpm@linux-foundation.org
Subject: +
 lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2.patch
 added to -mm tree
Date: Fri, 14 Aug 2015 13:08:59 -0700
Message-ID: <55ce4adb.8YEJUIPCa2y9aQpp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbbHNUJA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Aug 2015 16:09:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2
has been added to the -mm tree.  Its filename is
     lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2.patch

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
Subject: lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2

-v2: fix unused warning on sh/arm/m32r from Fengguang.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/compressed/decompress.c  |    2 +-
 arch/h8300/boot/compressed/misc.c      |    2 +-
 arch/m32r/boot/compressed/misc.c       |    3 ++-
 arch/mips/boot/compressed/decompress.c |    4 ++--
 arch/s390/boot/compressed/misc.c       |    2 +-
 arch/sh/boot/compressed/misc.c         |    2 +-
 arch/unicore32/boot/compressed/misc.c  |    4 ++--
 lib/decompress_bunzip2.c               |    9 ---------
 lib/decompress_inflate.c               |   13 ++-----------
 lib/decompress_unlz4.c                 |   10 ----------
 lib/decompress_unlzma.c                |   13 +------------
 lib/decompress_unlzo.c                 |    9 ---------
 lib/decompress_unxz.c                  |    9 ---------
 13 files changed, 13 insertions(+), 69 deletions(-)

diff -puN arch/arm/boot/compressed/decompress.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2 arch/arm/boot/compressed/decompress.c
--- a/arch/arm/boot/compressed/decompress.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2
+++ a/arch/arm/boot/compressed/decompress.c
@@ -57,5 +57,5 @@ extern char * strstr(const char * s1, co
 
 int do_decompress(u8 *input, int len, u8 *output, void (*error)(char *x))
 {
-	return decompress(input, len, NULL, NULL, output, NULL, error);
+	return __decompress(input, len, NULL, NULL, output, 0, NULL, error);
 }
diff -puN arch/h8300/boot/compressed/misc.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2 arch/h8300/boot/compressed/misc.c
--- a/arch/h8300/boot/compressed/misc.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2
+++ a/arch/h8300/boot/compressed/misc.c
@@ -70,5 +70,5 @@ void decompress_kernel(void)
 	free_mem_ptr = (unsigned long)&_end;
 	free_mem_end_ptr = free_mem_ptr + HEAP_SIZE;
 
-	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
+	__decompress(input_data, input_len, NULL, NULL, output, 0, NULL, error);
 }
diff -puN arch/m32r/boot/compressed/misc.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2 arch/m32r/boot/compressed/misc.c
--- a/arch/m32r/boot/compressed/misc.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2
+++ a/arch/m32r/boot/compressed/misc.c
@@ -86,6 +86,7 @@ decompress_kernel(int mmu_on, unsigned c
 	free_mem_end_ptr = free_mem_ptr + BOOT_HEAP_SIZE;
 
 	puts("\nDecompressing Linux... ");
-	decompress(input_data, input_len, NULL, NULL, output_data, NULL, error);
+	__decompress(input_data, input_len, NULL, NULL, output_data, 0,
+			NULL, error);
 	puts("done.\nBooting the kernel.\n");
 }
diff -puN arch/mips/boot/compressed/decompress.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2 arch/mips/boot/compressed/decompress.c
--- a/arch/mips/boot/compressed/decompress.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2
+++ a/arch/mips/boot/compressed/decompress.c
@@ -111,8 +111,8 @@ void decompress_kernel(unsigned long boo
 	puts("\n");
 
 	/* Decompress the kernel with according algorithm */
-	decompress((char *)zimage_start, zimage_size, 0, 0,
-		   (void *)VMLINUX_LOAD_ADDRESS_ULL, 0, error);
+	__decompress((char *)zimage_start, zimage_size, 0, 0,
+		   (void *)VMLINUX_LOAD_ADDRESS_ULL, 0, 0, error);
 
 	/* FIXME: should we flush cache here? */
 	puts("Now, booting the kernel...\n");
diff -puN arch/s390/boot/compressed/misc.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2 arch/s390/boot/compressed/misc.c
--- a/arch/s390/boot/compressed/misc.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2
+++ a/arch/s390/boot/compressed/misc.c
@@ -167,7 +167,7 @@ unsigned long decompress_kernel(void)
 #endif
 
 	puts("Uncompressing Linux... ");
-	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
+	__decompress(input_data, input_len, NULL, NULL, output, 0, NULL, error);
 	puts("Ok, booting the kernel.\n");
 	return (unsigned long) output;
 }
diff -puN arch/sh/boot/compressed/misc.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2 arch/sh/boot/compressed/misc.c
--- a/arch/sh/boot/compressed/misc.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2
+++ a/arch/sh/boot/compressed/misc.c
@@ -132,7 +132,7 @@ void decompress_kernel(void)
 
 	puts("Uncompressing Linux... ");
 	cache_control(CACHE_ENABLE);
-	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
+	__decompress(input_data, input_len, NULL, NULL, output, 0, NULL, error);
 	cache_control(CACHE_DISABLE);
 	puts("Ok, booting the kernel.\n");
 }
diff -puN arch/unicore32/boot/compressed/misc.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2 arch/unicore32/boot/compressed/misc.c
--- a/arch/unicore32/boot/compressed/misc.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2
+++ a/arch/unicore32/boot/compressed/misc.c
@@ -119,8 +119,8 @@ unsigned long decompress_kernel(unsigned
 	output_ptr = get_unaligned_le32(tmp);
 
 	arch_decomp_puts("Uncompressing Linux...");
-	decompress(input_data, input_data_end - input_data, NULL, NULL,
-			output_data, NULL, error);
+	__decompress(input_data, input_data_end - input_data, NULL, NULL,
+			output_data, 0, NULL, error);
 	arch_decomp_puts(" done, booting the kernel.\n");
 	return output_ptr;
 }
diff -puN lib/decompress_bunzip2.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2 lib/decompress_bunzip2.c
--- a/lib/decompress_bunzip2.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2
+++ a/lib/decompress_bunzip2.c
@@ -743,15 +743,6 @@ exit_0:
 }
 
 #ifdef PREBOOT
-STATIC int INIT decompress(unsigned char *buf, long len,
-			long (*fill)(void*, unsigned long),
-			long (*flush)(void*, unsigned long),
-			unsigned char *outbuf,
-			long *pos,
-			void(*error)(char *x))
-{
-	return bunzip2(buf, len - 4, fill, flush, outbuf, pos, error);
-}
 STATIC int INIT __decompress(unsigned char *buf, long len,
 			long (*fill)(void*, unsigned long),
 			long (*flush)(void*, unsigned long),
diff -puN lib/decompress_inflate.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2 lib/decompress_inflate.c
--- a/lib/decompress_inflate.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2
+++ a/lib/decompress_inflate.c
@@ -182,6 +182,7 @@ gunzip_nomem1:
 	return rc; /* returns Z_OK (0) if successful */
 }
 
+#ifndef PREBOOT
 STATIC int INIT gunzip(unsigned char *buf, long len,
 		       long (*fill)(void*, unsigned long),
 		       long (*flush)(void*, unsigned long),
@@ -191,17 +192,7 @@ STATIC int INIT gunzip(unsigned char *bu
 {
 	return __gunzip(buf, len, fill, flush, out_buf, 0, pos, error);
 }
-
-#ifdef PREBOOT
-STATIC int INIT decompress(unsigned char *buf, long len,
-			   long (*fill)(void*, unsigned long),
-			   long (*flush)(void*, unsigned long),
-			   unsigned char *out_buf,
-			   long *pos,
-			   void (*error)(char *x))
-{
-	return gunzip(buf, len, fill, flush, out_buf, pos, error);
-}
+#else
 STATIC int INIT __decompress(unsigned char *buf, long len,
 			   long (*fill)(void*, unsigned long),
 			   long (*flush)(void*, unsigned long),
diff -puN lib/decompress_unlz4.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2 lib/decompress_unlz4.c
--- a/lib/decompress_unlz4.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2
+++ a/lib/decompress_unlz4.c
@@ -196,16 +196,6 @@ exit_0:
 }
 
 #ifdef PREBOOT
-STATIC int INIT decompress(unsigned char *buf, long in_len,
-			      long (*fill)(void*, unsigned long),
-			      long (*flush)(void*, unsigned long),
-			      unsigned char *output,
-			      long *posp,
-			      void(*error)(char *x)
-	)
-{
-	return unlz4(buf, in_len - 4, fill, flush, output, posp, error);
-}
 STATIC int INIT __decompress(unsigned char *buf, long in_len,
 			      long (*fill)(void*, unsigned long),
 			      long (*flush)(void*, unsigned long),
diff -puN lib/decompress_unlzma.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2 lib/decompress_unlzma.c
--- a/lib/decompress_unlzma.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2
+++ a/lib/decompress_unlzma.c
@@ -667,23 +667,12 @@ exit_0:
 }
 
 #ifdef PREBOOT
-STATIC int INIT decompress(unsigned char *buf, long in_len,
-			      long (*fill)(void*, unsigned long),
-			      long (*flush)(void*, unsigned long),
-			      unsigned char *output,
-			      long *posp,
-			      void(*error)(char *x)
-	)
-{
-	return unlzma(buf, in_len - 4, fill, flush, output, posp, error);
-}
 STATIC int INIT __decompress(unsigned char *buf, long in_len,
 			      long (*fill)(void*, unsigned long),
 			      long (*flush)(void*, unsigned long),
 			      unsigned char *output, long out_len,
 			      long *posp,
-			      void (*error)(char *x)
-	)
+			      void (*error)(char *x))
 {
 	return unlzma(buf, in_len - 4, fill, flush, output, posp, error);
 }
diff -puN lib/decompress_unlzo.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2 lib/decompress_unlzo.c
--- a/lib/decompress_unlzo.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2
+++ a/lib/decompress_unlzo.c
@@ -289,15 +289,6 @@ exit:
 }
 
 #ifdef PREBOOT
-STATIC int INIT decompress(unsigned char *buf, long len,
-			   long (*fill)(void*, unsigned long),
-			   long (*flush)(void*, unsigned long),
-			   unsigned char *out_buf,
-			   long *pos,
-			   void (*error)(char *x))
-{
-	return unlzo(buf, len, fill, flush, out_buf, pos, error);
-}
 STATIC int INIT __decompress(unsigned char *buf, long len,
 			   long (*fill)(void*, unsigned long),
 			   long (*flush)(void*, unsigned long),
diff -puN lib/decompress_unxz.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2 lib/decompress_unxz.c
--- a/lib/decompress_unxz.c~lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2
+++ a/lib/decompress_unxz.c
@@ -395,15 +395,6 @@ error_alloc_state:
  * the kernel image.
  */
 #ifdef XZ_PREBOOT
-STATIC int INIT decompress(unsigned char *buf, long len,
-			   long (*fill)(void*, unsigned long),
-			   long (*flush)(void*, unsigned long),
-			   unsigned char *out_buf,
-			   long *pos,
-			   void (*error)(char *x))
-{
-	return unxz(buf, len, fill, flush, out_buf, pos, error);
-}
 STATIC int INIT __decompress(unsigned char *buf, long len,
 			   long (*fill)(void*, unsigned long),
 			   long (*flush)(void*, unsigned long),
_

Patches currently in -mm which might be from yinghai@kernel.org are

mm-add-utility-for-early-copy-from-unmapped-ram.patch
arm64-support-initrd-outside-kernel-linear-map.patch
x86-use-generic-early-mem-copy.patch
x86-use-generic-early-mem-copy-fix.patch
lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel.patch
lib-decompressors-use-real-out-buf-size-for-gunzip-with-kernel-v2.patch
linux-next.patch

