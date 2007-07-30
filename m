From: akpm@linux-foundation.org
Subject: + add-a-missing-lib_y-to-arch-alpha-boot-makefile.patch added to -mm tree
Date: Mon, 30 Jul 2007 13:35:42 -0700
Message-ID: <200707302035.l6UKZgB3029276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39961 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968147AbXG3Ug3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 16:36:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mroos@linux.ee, ink@jurassic.park.msu.ru, jay.estabrook@hp.com, rth@twiddle.net, sam@ravnborg.org


The patch titled
     add a missing LIB_Y to arch/alpha/boot Makefile
has been added to the -mm tree.  Its filename is
     add-a-missing-lib_y-to-arch-alpha-boot-makefile.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add a missing LIB_Y to arch/alpha/boot Makefile
From: Meelis Roos <mroos@linux.ee>

Add $(LIBS_Y) to get lib/lib.a so srm_printk is present.

Signed-off-by: Meelis Roos <mroos@linux.ee>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jay Estabrook <jay.estabrook@hp.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/boot/Makefile |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/alpha/boot/Makefile~add-a-missing-lib_y-to-arch-alpha-boot-makefile arch/alpha/boot/Makefile
--- a/arch/alpha/boot/Makefile~add-a-missing-lib_y-to-arch-alpha-boot-makefile
+++ a/arch/alpha/boot/Makefile
@@ -104,7 +104,7 @@ OBJ_bootlx   := $(obj)/head.o $(obj)/mai
 OBJ_bootph   := $(obj)/head.o $(obj)/bootp.o
 OBJ_bootpzh  := $(obj)/head.o $(obj)/bootpz.o $(obj)/misc.o
 
-$(obj)/bootloader: $(obj)/bootloader.lds $(OBJ_bootlx) FORCE
+$(obj)/bootloader: $(obj)/bootloader.lds $(OBJ_bootlx) $(LIBS_Y) FORCE
 	$(call if_changed,ld)
 
 $(obj)/bootpheader: $(obj)/bootloader.lds $(OBJ_bootph) $(LIBS_Y) FORCE
_

Patches currently in -mm which might be from mroos@linux.ee are

alpha-fix-mkbb-compilation-warnings.patch
alpha-fix-objstripc-compilation-warnings.patch
alpha-fix-boot-mainc-warning.patch
lib-move-kasprintf-to-a-separate-file.patch
add-a-missing-lib_y-to-arch-alpha-boot-makefile.patch
acpi-cure-run-together-printk-lines.patch
fix-integer-overflow-warning-in-i2o_block.patch
