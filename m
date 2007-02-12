From: akpm@linux-foundation.org
Subject: - i386-2048-byte-command-line.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:27 -0800
Message-ID: <200702122248.l1CMmRm3014015@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45529 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030348AbXBLWsc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: 2048-byte command line
has been removed from the -mm tree.  Its filename was
     i386-2048-byte-command-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: 2048-byte command line
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/setup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-i386/setup.h~i386-2048-byte-command-line include/asm-i386/setup.h
--- a/include/asm-i386/setup.h~i386-2048-byte-command-line
+++ a/include/asm-i386/setup.h
@@ -6,7 +6,7 @@
 #ifndef _i386_SETUP_H
 #define _i386_SETUP_H
 
-#define COMMAND_LINE_SIZE 256
+#define COMMAND_LINE_SIZE 2048
 
 #ifdef __KERNEL__
 #include <linux/pfn.h>
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
