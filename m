From: akpm@linux-foundation.org
Subject: - ia64-2048-byte-command-line.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:31 -0800
Message-ID: <200702122248.l1CMmVbm014025@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45533 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030355AbXBLWsd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: 2048-byte command line
has been removed from the -mm tree.  Its filename was
     ia64-2048-byte-command-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: 2048-byte command line
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
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/setup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-ia64/setup.h~ia64-2048-byte-command-line include/asm-ia64/setup.h
--- a/include/asm-ia64/setup.h~ia64-2048-byte-command-line
+++ a/include/asm-ia64/setup.h
@@ -1,6 +1,6 @@
 #ifndef __IA64_SETUP_H
 #define __IA64_SETUP_H
 
-#define COMMAND_LINE_SIZE	512
+#define COMMAND_LINE_SIZE	2048
 
 #endif
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
