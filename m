From: akpm@linux-foundation.org
Subject: + m32r-add-memcpy-for-config_kernel_gzip=y.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:35:57 -0700
Message-ID: <20120713213558.3136B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:36021 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab2GMVf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:35:59 -0400
Received: by qabg24 with SMTP id g24so101917qab.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:35:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, takata@linux-m32r.org


The patch titled
     Subject: m32r: add memcpy() for CONFIG_KERNEL_GZIP=y
has been added to the -mm tree.  Its filename is
     m32r-add-memcpy-for-config_kernel_gzip=y.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: m32r: add memcpy() for CONFIG_KERNEL_GZIP=y

  LD      arch/m32r/boot/compressed/vmlinux
arch/m32r/boot/compressed/misc.o: In function `zlib_updatewindow':
misc.c:(.text+0x190): undefined reference to `memcpy'
misc.c:(.text+0x190): relocation truncated to fit: R_M32R_26_PLTREL against undefined symbol `memcpy'
misc.c:(.text+0x1e0): undefined reference to `memcpy'
misc.c:(.text+0x1e0): relocation truncated to fit: R_M32R_26_PLTREL against undefined symbol `memcpy'
misc.c:(.text+0x218): undefined reference to `memcpy'
misc.c:(.text+0x218): relocation truncated to fit: R_M32R_26_PLTREL against undefined symbol `memcpy'
arch/m32r/boot/compressed/misc.o: In function `zlib_inflate':
misc.c:(.text+0x171c): undefined reference to `memcpy'
misc.c:(.text+0x171c): relocation truncated to fit: R_M32R_26_PLTREL against undefined symbol `memcpy'
make[5]: *** [arch/m32r/boot/compressed/vmlinux] Error 1

Add our own implementation of memcpy() to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/boot/compressed/misc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN arch/m32r/boot/compressed/misc.c~m32r-add-memcpy-for-config_kernel_gzip=y arch/m32r/boot/compressed/misc.c
--- a/arch/m32r/boot/compressed/misc.c~m32r-add-memcpy-for-config_kernel_gzip=y
+++ a/arch/m32r/boot/compressed/misc.c
@@ -39,6 +39,16 @@ static void *memset(void *s, int c, size
 #endif
 
 #ifdef CONFIG_KERNEL_GZIP
+void *memcpy(void *dest, const void *src, size_t n)
+{
+	char *d = dest;
+	const char *s = src;
+	while (n--)
+		*d++ = *s++;
+
+	return dest;
+}
+
 #define BOOT_HEAP_SIZE             0x10000
 #include "../../../../lib/decompress_inflate.c"
 #endif
_
Subject: Subject: m32r: add memcpy() for CONFIG_KERNEL_GZIP=y

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
mn10300-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout.patch
m32r-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch
m32r-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout.patch
m32r-fix-fix-breakage-from-m32r-use-generic-ptrace_resume-code-fallout.patch
m32r-consistently-use-suffix.patch
m32r-add-memcpy-for-config_kernel_gzip=y.patch
m32r-make-memset-global-for-config_kernel_bzip2=y.patch
mn10300-only-add-mmem-funcs-to-kbuild_cflags-if-gcc-supports-it.patch
frv-kill-used-but-uninitialized-variable.patch

