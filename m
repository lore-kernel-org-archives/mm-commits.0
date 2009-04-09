From: akpm@linux-foundation.org
Subject: + x86edac-fix-for-compiler-error-in-trapsc.patch added to -mm tree
Date: Wed, 08 Apr 2009 17:52:43 -0700
Message-ID: <200904090052.n390qhep028897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758001AbZDIAzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Apr 2009 20:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, mingo@elte.hu, norsk5@yahoo.com


The patch titled
     x86,edac: fix for compiler error in traps.c
has been added to the -mm tree.  Its filename is
     x86edac-fix-for-compiler-error-in-trapsc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
x86edac-fix-for-compiler-error-in-trapsc.patch
libfs-make-simple_read_from_buffer-conventional.patch

