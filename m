From: akpm@linux-foundation.org
Subject: + tty-i386-x86_64-arbitary-speed-support.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:44:44 -0800
Message-ID: <200703110944.l2B9iitv009076@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41640 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbXCKJoz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:44:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     tty: i386/x86_64 arbitary speed support
has been added to the -mm tree.  Its filename is
     tty-i386-x86_64-arbitary-speed-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: i386/x86_64 arbitary speed support
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/ioctls.h     |    4 ++++
 include/asm-i386/termbits.h   |   14 ++++++++++++++
 include/asm-i386/termios.h    |    6 ++++--
 include/asm-x86_64/termbits.h |    2 +-
 4 files changed, 23 insertions(+), 3 deletions(-)

diff -puN include/asm-i386/ioctls.h~tty-i386-x86_64-arbitary-speed-support include/asm-i386/ioctls.h
--- a/include/asm-i386/ioctls.h~tty-i386-x86_64-arbitary-speed-support
+++ a/include/asm-i386/ioctls.h
@@ -47,6 +47,10 @@
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
+#define TCGETS2		_IOR('T',0x2A, struct termios2)
+#define TCSETS2		_IOW('T',0x2B, struct termios2)
+#define TCSETSW2	_IOW('T',0x2C, struct termios2)
+#define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
diff -puN include/asm-i386/termbits.h~tty-i386-x86_64-arbitary-speed-support include/asm-i386/termbits.h
--- a/include/asm-i386/termbits.h~tty-i386-x86_64-arbitary-speed-support
+++ a/include/asm-i386/termbits.h
@@ -17,6 +17,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct termios2 {
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
 struct ktermios {
 	tcflag_t c_iflag;		/* input mode flags */
 	tcflag_t c_oflag;		/* output mode flags */
@@ -129,6 +140,7 @@ struct ktermios {
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
+#define   BOTHER  0010000
 #define    B57600 0010001
 #define   B115200 0010002
 #define   B230400 0010003
@@ -148,6 +160,8 @@ struct ktermios {
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
+#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0000001
 #define ICANON	0000002
diff -puN include/asm-i386/termios.h~tty-i386-x86_64-arbitary-speed-support include/asm-i386/termios.h
--- a/include/asm-i386/termios.h~tty-i386-x86_64-arbitary-speed-support
+++ a/include/asm-i386/termios.h
@@ -81,8 +81,10 @@ struct termio {
 	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
 })
 
-#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
-#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
+#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
+#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
+#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
 
 #endif	/* __KERNEL__ */
 
diff -puN include/asm-x86_64/termbits.h~tty-i386-x86_64-arbitary-speed-support include/asm-x86_64/termbits.h
--- a/include/asm-x86_64/termbits.h~tty-i386-x86_64-arbitary-speed-support
+++ a/include/asm-x86_64/termbits.h
@@ -160,7 +160,7 @@ struct ktermios {
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
-#define IBSHIFT	  8		/* Shift from CBAUD to CIBAUD */
+#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
 
 /* c_lflag bits */
 #define ISIG	0000001
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
ata_piix-remove-ugly-layering-violation.patch
pata_cmd640-multiple-updates.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
dilnetpc-fix-warning.patch
baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced.patch
resend-iphase-64bit-cleanup.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
z85230-fix-fifo-handling.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
