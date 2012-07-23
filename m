From: akpm@linux-foundation.org
Subject: [merged] m32r-make-memset-global-for-config_kernel_bzip2=y.patch removed from -mm tree
Date: Mon, 23 Jul 2012 14:31:05 -0700
Message-ID: <20120723213106.0FBD9200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:53026 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab2GWVjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 17:39:23 -0400
Received: by wibhr14 with SMTP id hr14so178571wib.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 14:39:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: make memset() global for CONFIG_KERNEL_BZIP2=y
has been removed from the -mm tree.  Its filename was
     m32r-make-memset-global-for-config_kernel_bzip2=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: m32r: make memset() global for CONFIG_KERNEL_BZIP2=y

arch/m32r/boot/compressed/misc.c:31:14: error: static declaration of 'memset' follows non-static declaration
make[5]: *** [arch/m32r/boot/compressed/misc.o] Error 1
make[4]: *** [arch/m32r/boot/compressed/vmlinux] Error 2

Remove the static keyword to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/boot/compressed/misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/m32r/boot/compressed/misc.c~m32r-make-memset-global-for-config_kernel_bzip2=y arch/m32r/boot/compressed/misc.c
--- a/arch/m32r/boot/compressed/misc.c~m32r-make-memset-global-for-config_kernel_bzip2=y
+++ a/arch/m32r/boot/compressed/misc.c
@@ -28,7 +28,7 @@ static unsigned long free_mem_ptr;
 static unsigned long free_mem_end_ptr;
 
 #ifdef CONFIG_KERNEL_BZIP2
-static void *memset(void *s, int c, size_t n)
+void *memset(void *s, int c, size_t n)
 {
 	char *ss = s;
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
mn10300-only-add-mmem-funcs-to-kbuild_cflags-if-gcc-supports-it.patch
frv-kill-used-but-uninitialized-variable.patch

