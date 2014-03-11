From: akpm@linux-foundation.org
Subject: [merged]
 cris-convert-ffs-from-an-object-like-macro-to-a-function-like-macro.patch
 removed from -mm tree
Date: Tue, 11 Mar 2014 11:25:16 -0700
Message-ID: <531f550c.nNldFeo2QZAzTegc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44254 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaCKSZR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Mar 2014 14:25:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, starvik@axis.com, jesper.nilsson@axis.com, geert@linux-m68k.org

Subject: [merged] cris-convert-ffs-from-an-object-like-macro-to-a-function-like-macro.patch removed from -mm tree
To: geert@linux-m68k.org,jesper.nilsson@axis.com,starvik@axis.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Mar 2014 11:25:16 -0700


The patch titled
     Subject: cris: convert ffs from an object-like macro to a function-like macro
has been removed from the -mm tree.  Its filename was
     cris-convert-ffs-from-an-object-like-macro-to-a-function-like-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: cris: convert ffs from an object-like macro to a function-like macro

This avoids bad interactions with code using identifiers called "ffs":

drivers/usb/gadget/f_fs.c: In function 'ffsmod_init':
drivers/usb/gadget/f_fs.c:2693:494: error: 'ffsusb_func' undeclared (first use in this function)
drivers/usb/gadget/f_fs.c:2693:494: note: each undeclared identifier is reported only once for each function it appears in
drivers/usb/gadget/f_fs.c: In function 'ffsmod_exit':
drivers/usb/gadget/f_fs.c:2693:677: error: 'ffsusb_func' undeclared (first use in this function)
drivers/usb/gadget/f_fs.c: At top level:
drivers/usb/gadget/f_fs.c:2693:35: warning: 'kernel_ffsusb_func' defined but not used [-Wunused-variable]
drivers/usb/gadget/f_fs.c: In function 'ffsmod_init':
drivers/usb/gadget/f_fs.c:2693:15: warning: control reaches end of non-void function [-Wreturn-type]

See http://kisskb.ellerman.id.au/kisskb/buildresult/10715817/

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/bitops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/cris/include/asm/bitops.h~cris-convert-ffs-from-an-object-like-macro-to-a-function-like-macro arch/cris/include/asm/bitops.h
--- a/arch/cris/include/asm/bitops.h~cris-convert-ffs-from-an-object-like-macro-to-a-function-like-macro
+++ a/arch/cris/include/asm/bitops.h
@@ -144,7 +144,7 @@ static inline int test_and_change_bit(in
  * definition, which doesn't have the same semantics.  We don't want to
  * use -fno-builtin, so just hide the name ffs.
  */
-#define ffs kernel_ffs
+#define ffs(x) kernel_ffs(x)
 
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/__fls.h>
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
arch-sh-boards-board-sh7757lcrc-fixup-sdhi-register-size.patch
cris-cpuinfo_op-should-depend-on-config_proc_fs.patch
linux-next.patch

