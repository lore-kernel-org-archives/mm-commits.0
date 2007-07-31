From: akpm@linux-foundation.org
Subject: - add-a-missing-lib_y-to-arch-alpha-boot-makefile.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:56:17 -0700
Message-ID: <200707312356.l6VNuHpd029308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47391 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763546AbXHAARt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mroos@linux.ee, ink@jurassic.park.msu.ru, jay.estabrook@hp.com, rth@twiddle.net, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     add a missing LIB_Y to arch/alpha/boot Makefile
has been removed from the -mm tree.  Its filename was
     add-a-missing-lib_y-to-arch-alpha-boot-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+), 1 deletion(-)

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

origin.patch
acpi-cure-run-together-printk-lines.patch
fix-runtogether-printks-in-cmd64x-ide-driver.patch
