From: akpm@osdl.org
Subject: + x86_64-2048-byte-command-line.patch added to -mm tree
Date: Thu, 25 Jan 2007 19:26:52 -0800
Message-ID: <200701260326.l0Q3Qqc7006335@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43363 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030721AbXAZD05 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 22:26:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alon.barlev@gmail.com, ak@suse.de


The patch titled
     x86_64: 2048-byte command line
has been added to the -mm tree.  Its filename is
     x86_64-2048-byte-command-line.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: 2048-byte command line
From: Alon Bar-Lev <alon.barlev@gmail.com>

Current implementation allows the kernel to receive up to 255 characters from
the bootloader.  While the boot protocol allows greater buffers to be sent.

In current environment, the command-line is used in order to specify many
values, including suspend/resume, module arguments, splash, initramfs and
more.  

255 characters are not enough anymore. 

After edd issue was fixed, and dynammic kernel command-line patch was
accepted, we can extend the COMMAND_LINE_SIZE without runtime memory
requirements.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-x86_64/setup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-x86_64/setup.h~x86_64-2048-byte-command-line include/asm-x86_64/setup.h
--- a/include/asm-x86_64/setup.h~x86_64-2048-byte-command-line
+++ a/include/asm-x86_64/setup.h
@@ -1,6 +1,6 @@
 #ifndef _x8664_SETUP_H
 #define _x8664_SETUP_H
 
-#define COMMAND_LINE_SIZE	256
+#define COMMAND_LINE_SIZE	2048
 
 #endif
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-alpha.patch
dynamic-kernel-command-line-arm.patch
dynamic-kernel-command-line-arm26.patch
dynamic-kernel-command-line-avr32.patch
dynamic-kernel-command-line-cris.patch
dynamic-kernel-command-line-frv.patch
dynamic-kernel-command-line-h8300.patch
dynamic-kernel-command-line-i386.patch
dynamic-kernel-command-line-ia64.patch
dynamic-kernel-command-line-m32r.patch
dynamic-kernel-command-line-m68k.patch
dynamic-kernel-command-line-m68knommu.patch
dynamic-kernel-command-line-mips.patch
dynamic-kernel-command-line-parisc.patch
dynamic-kernel-command-line-powerpc.patch
dynamic-kernel-command-line-ppc.patch
dynamic-kernel-command-line-s390.patch
dynamic-kernel-command-line-sh.patch
dynamic-kernel-command-line-sh64.patch
dynamic-kernel-command-line-sparc.patch
dynamic-kernel-command-line-sparc64.patch
dynamic-kernel-command-line-um.patch
dynamic-kernel-command-line-v850.patch
dynamic-kernel-command-line-x86_64.patch
dynamic-kernel-command-line-xtensa.patch
i386-2048-byte-command-line.patch
x86_64-2048-byte-command-line.patch
ia64-2048-byte-command-line.patch
