From: akpm@linux-foundation.org
Subject: + m32r-consistently-use-suffix.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:35:53 -0700
Message-ID: <20120713213554.9E10F5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:41006 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab2GMVf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:35:56 -0400
Received: by eaao13 with SMTP id o13so204837eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:35:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, takata@linux-m32r.org


The patch titled
     Subject: m32r: consistently use "suffix-$(...)"
has been added to the -mm tree.  Its filename is
     m32r-consistently-use-suffix.patch

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
Subject: m32r: consistently use "suffix-$(...)"

a556bec9955c ("m32r: fix arch/m32r/boot/compressed/Makefile") changed
"$(suffix_y)" to "$(suffix-y)", but didn't update any location where
"suffix_y" is set, causing:

make[5]: *** No rule to make target `arch/m32r/boot/compressed/vmlinux.bin.', needed by `arch/m32r/boot/compressed/piggy.o'.  Stop.
make[4]: *** [arch/m32r/boot/compressed/vmlinux] Error 2
make[3]: *** [zImage] Error 2

Correct the other locations to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/boot/compressed/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/m32r/boot/compressed/Makefile~m32r-consistently-use-suffix arch/m32r/boot/compressed/Makefile
--- a/arch/m32r/boot/compressed/Makefile~m32r-consistently-use-suffix
+++ a/arch/m32r/boot/compressed/Makefile
@@ -43,9 +43,9 @@ endif
 
 OBJCOPYFLAGS += -R .empty_zero_page
 
-suffix_$(CONFIG_KERNEL_GZIP)	= gz
-suffix_$(CONFIG_KERNEL_BZIP2)	= bz2
-suffix_$(CONFIG_KERNEL_LZMA)	= lzma
+suffix-$(CONFIG_KERNEL_GZIP)	= gz
+suffix-$(CONFIG_KERNEL_BZIP2)	= bz2
+suffix-$(CONFIG_KERNEL_LZMA)	= lzma
 
 $(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.$(suffix-y) FORCE
 	$(call if_changed,ld)
_
Subject: Subject: m32r: consistently use "suffix-$(...)"

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

