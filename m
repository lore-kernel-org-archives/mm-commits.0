From: akpm@linux-foundation.org
Subject: [withdrawn] x86edac-fix-for-compiler-error-in-trapsc.patch removed from -mm tree
Date: Thu, 09 Apr 2009 09:56:27 -0700
Message-ID: <200904091656.n39GuRtC016204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935909AbZDIQ7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 12:59:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mingo@elte.hu, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     x86,edac: fix for compiler error in traps.c
has been removed from the -mm tree.  Its filename was
     x86edac-fix-for-compiler-error-in-trapsc.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86,edac: fix for compiler error in traps.c
From: Steven Rostedt <rostedt@goodmis.org>

Impact: compile fix

 I got this compile failure on both tip/tracing/core as well as on
 v2.6.30-rc1.

   LD      .tmp_vmlinux1
 arch/x86/kernel/built-in.o: In function `do_nmi':
 (.text+0x3c18): undefined reference to `edac_handler_set'
 arch/x86/kernel/built-in.o: In function `do_nmi':
 (.text+0x3c48): undefined reference to `edac_atomic_assert_error'
 make: *** [.tmp_vmlinux1] Error 1
 [root@bxrhel51 linux-trace.git]# grep edac_handler_set
 [root@bxrhel51 linux-trace.git]# Grep edac_handler_set '*.[ch]'
 find .  -name "*.[ch]" ! -type d  | xargs grep  "edac_handler_set"
 ./arch/x86/kernel/traps.c:	if (edac_handler_set()) {
 ./include/linux/edac.h:extern int edac_handler_set(void);
 ./drivers/edac/edac_stub.c:int edac_handler_set(void)
 ./drivers/edac/edac_stub.c:EXPORT_SYMBOL_GPL(edac_handler_set);

This patch seems to fix it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/Makefile~x86edac-fix-for-compiler-error-in-trapsc drivers/edac/Makefile
--- a/drivers/edac/Makefile~x86edac-fix-for-compiler-error-in-trapsc
+++ a/drivers/edac/Makefile
@@ -7,7 +7,7 @@
 #
 
 
-obj-$(CONFIG_EDAC)			:= edac_stub.o
+obj-$(CONFIG_EDAC)			+= edac_stub.o
 obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_core.o
 
 edac_core-objs	:= edac_mc.o edac_device.o edac_mc_sysfs.o edac_pci_sysfs.o
_

Patches currently in -mm which might be from rostedt@goodmis.org are

x86edac-fix-for-compiler-error-in-trapsc.patch
libfs-make-simple_read_from_buffer-conventional.patch

