From: akpm@linux-foundation.org
Subject: [folded] arm-add-support-for-lzo-compressed-kernels-fix.patch removed from -mm tree
Date: Tue, 15 Dec 2009 15:54:52 -0800
Message-ID: <200912152354.nBFNsqMZ021851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755358AbZLPACb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 19:02:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: albin.tonnerre@free-electrons.com, hpa@zytor.com, mingo@elte.hu, ralf@linux-mips.org, rmk@arm.linux.org.uk, tbm@cyrius.com, tglx@linutronix.de, wuzhangjin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     arm-add-support-for-lzo-compressed-kernels-fix
has been removed from the -mm tree.  Its filename was
     arm-add-support-for-lzo-compressed-kernels-fix.patch

This patch was dropped because it was folded into arm-add-support-for-lzo-compressed-kernels.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm-add-support-for-lzo-compressed-kernels-fix
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>

Updated patch to fix the out-of-tree build issue, thanks to Martin Michlmayr
and Russell King

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Martin Michlmayr <tbm@cyrius.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/compressed/Makefile |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/arm/boot/compressed/Makefile~arm-add-support-for-lzo-compressed-kernels-fix arch/arm/boot/compressed/Makefile
--- a/arch/arm/boot/compressed/Makefile~arm-add-support-for-lzo-compressed-kernels-fix
+++ a/arch/arm/boot/compressed/Makefile
@@ -101,7 +101,10 @@ LDFLAGS_vmlinux += -X
 LDFLAGS_vmlinux += -T
 
 # For __aeabi_uidivmod
-lib1funcs = $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.o
+lib1funcs = $(obj)/lib1funcs.o
+
+$(obj)/lib1funcs.S: $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.S FORCE
+	$(call cmd,shipped)
 
 # Don't allow any static data in misc.o, which
 # would otherwise mess up our GOT table
_

Patches currently in -mm which might be from albin.tonnerre@free-electrons.com are

origin.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
lib-add-support-for-lzo-compressed-kernels.patch
arm-add-support-for-lzo-compressed-kernels.patch
arm-add-support-for-lzo-compressed-kernels-fix.patch
x86-add-support-for-lzo-compressed-kernels.patch
add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch

