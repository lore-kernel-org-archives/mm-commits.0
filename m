From: akpm@linux-foundation.org
Subject: [merged] m32r-consistently-use-suffix.patch removed from -mm tree
Date: Mon, 23 Jul 2012 14:30:58 -0700
Message-ID: <20120723213058.900C71E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:55585 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab2GWVa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 17:30:59 -0400
Received: by yenl3 with SMTP id l3so784054yen.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 14:30:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: consistently use "suffix-$(...)"
has been removed from the -mm tree.  Its filename was
     m32r-consistently-use-suffix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
mn10300-only-add-mmem-funcs-to-kbuild_cflags-if-gcc-supports-it.patch
frv-kill-used-but-uninitialized-variable.patch

