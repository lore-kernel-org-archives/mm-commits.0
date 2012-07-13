From: akpm@linux-foundation.org
Subject: + m32r-make-memset-global-for-config_kernel_bzip2=y.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:36:00 -0700
Message-ID: <20120713213601.9DC105C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:51140 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab2GMVgD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:36:03 -0400
Received: by wibhr14 with SMTP id hr14so55698wib.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:36:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, takata@linux-m32r.org


The patch titled
     Subject: m32r: make memset() global for CONFIG_KERNEL_BZIP2=y
has been added to the -mm tree.  Its filename is
     m32r-make-memset-global-for-config_kernel_bzip2=y.patch

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
Subject: Subject: m32r: make memset() global for CONFIG_KERNEL_BZIP2=y

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

