From: akpm@osdl.org
Subject: + xtensa-add-ktermios-and-minor-filename-fix.patch added to -mm tree
Date: Tue, 12 Dec 2006 12:50:28 -0800
Message-ID: <200612122050.kBCKoSL2015391@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40389 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932353AbWLLUuj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 15:50:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: czankel@tensilica.com, alan@lxorguk.ukuu.org.uk, chris@zankel.net


The patch titled
     Xtensa: Add ktermios and minor filename fix
has been added to the -mm tree.  Its filename is
     xtensa-add-ktermios-and-minor-filename-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Xtensa: Add ktermios and minor filename fix
From: Chris Zankel <czankel@tensilica.com>

The kernel termios (ktermios) changes were somehow missed for Xtensa.  This
patch adds the ktermios structure and also includes some minor file name
fix that was missed in the syscall patch.

Signed-off-by: Chris Zankel <chris@zankel.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/xtensa/kernel/Makefile   |    2 +-
 arch/xtensa/kernel/syscall.c  |    2 +-
 include/asm-xtensa/termbits.h |   11 +++++++++++
 include/asm-xtensa/uaccess.h  |    1 -
 4 files changed, 13 insertions(+), 3 deletions(-)

diff -puN arch/xtensa/kernel/Makefile~xtensa-add-ktermios-and-minor-filename-fix arch/xtensa/kernel/Makefile
--- a/arch/xtensa/kernel/Makefile~xtensa-add-ktermios-and-minor-filename-fix
+++ a/arch/xtensa/kernel/Makefile
@@ -6,7 +6,7 @@ extra-y := head.o vmlinux.lds
 
 
 obj-y := align.o entry.o irq.o coprocessor.o process.o ptrace.o semaphore.o  \
-	 setup.o signal.o syscalls.o time.o traps.o vectors.o platform.o  \
+	 setup.o signal.o syscall.o time.o traps.o vectors.o platform.o  \
 	 pci-dma.o
 
 ## windowspill.o
diff -puN arch/xtensa/kernel/syscall.c~xtensa-add-ktermios-and-minor-filename-fix arch/xtensa/kernel/syscall.c
--- a/arch/xtensa/kernel/syscall.c~xtensa-add-ktermios-and-minor-filename-fix
+++ a/arch/xtensa/kernel/syscall.c
@@ -16,7 +16,7 @@
  *
  */
 #include <asm/uaccess.h>
-#include <asm/syscalls.h>
+#include <asm/syscall.h>
 #include <asm/unistd.h>
 #include <linux/linkage.h>
 #include <linux/stringify.h>
diff -puN include/asm-xtensa/termbits.h~xtensa-add-ktermios-and-minor-filename-fix include/asm-xtensa/termbits.h
--- a/include/asm-xtensa/termbits.h~xtensa-add-ktermios-and-minor-filename-fix
+++ a/include/asm-xtensa/termbits.h
@@ -30,6 +30,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 
 #define VINTR 0
diff -puN include/asm-xtensa/uaccess.h~xtensa-add-ktermios-and-minor-filename-fix include/asm-xtensa/uaccess.h
--- a/include/asm-xtensa/uaccess.h~xtensa-add-ktermios-and-minor-filename-fix
+++ a/include/asm-xtensa/uaccess.h
@@ -23,7 +23,6 @@
 
 #ifdef __ASSEMBLY__
 
-#define _ASMLANGUAGE
 #include <asm/current.h>
 #include <asm/asm-offsets.h>
 #include <asm/processor.h>
_

Patches currently in -mm which might be from czankel@tensilica.com are

origin.patch
xtensa-add-ktermios-and-minor-filename-fix.patch

