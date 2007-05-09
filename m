From: akpm@linux-foundation.org
Subject: - tty-i386-x86_64-arbitary-speed-support.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:37 -0700
Message-ID: <200705090246.l492kb2Z008882@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934410AbXEICq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty: i386/x86_64 arbitary speed support
has been removed from the -mm tree.  Its filename was
     tty-i386-x86_64-arbitary-speed-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty: i386/x86_64 arbitary speed support
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Adds the needed TCGETS2/TCSETS2 ioctl calls, structures, defines and the like.
Tested against the test suite and passes.  Other platforms should need
roughly the same change.

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

origin.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
libata-add-support-for-ata_16-on-atapi.patch
fix-pata_qdic-probe-code.patch
pata_scc-fix-compilation.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
sl82c105-switch-to-ref-counting-api.patch
add-pci_try_set_mwi.patch
fix-pci_find_present.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
fix-old-scsi-adapter-crashes-with-cd-rom-take-2.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
upper-32-bits.patch
tty_set_ldisc-receive_room-fix.patch
tty-add-compat_ioctl.patch
tty-add-compat_ioctl-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
