From: akpm@linux-foundation.org
Subject: - m68k-enable-arbitary-speed-tty-support.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:12 -0700
Message-ID: <200708242056.l7OKuCNF014020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44953 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762906AbXHXVIx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: Enable arbitary speed tty support
has been removed from the -mm tree.  Its filename was
     m68k-enable-arbitary-speed-tty-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68k: Enable arbitary speed tty support
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Add the needed constants and defines to activate the existing code.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68k/ioctls.h   |    4 ++++
 include/asm-m68k/termbits.h |    5 ++++-
 include/asm-m68k/termios.h  |    6 ++++--
 3 files changed, 12 insertions(+), 3 deletions(-)

diff -puN include/asm-m68k/ioctls.h~m68k-enable-arbitary-speed-tty-support include/asm-m68k/ioctls.h
--- a/include/asm-m68k/ioctls.h~m68k-enable-arbitary-speed-tty-support
+++ a/include/asm-m68k/ioctls.h
@@ -46,6 +46,10 @@
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
+#define TCGETS2		_IOR('T',0x2A, struct termios2)
+#define TCSETS2		_IOW('T',0x2B, struct termios2)
+#define TCSETSW2	_IOW('T',0x2C, struct termios2)
+#define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
diff -puN include/asm-m68k/termbits.h~m68k-enable-arbitary-speed-tty-support include/asm-m68k/termbits.h
--- a/include/asm-m68k/termbits.h~m68k-enable-arbitary-speed-tty-support
+++ a/include/asm-m68k/termbits.h
@@ -141,6 +141,7 @@ struct ktermios {
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
+#define    BOTHER 0010000
 #define    B57600 0010001
 #define   B115200 0010002
 #define   B230400 0010003
@@ -156,10 +157,12 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
-#define CIBAUD	  002003600000	/* input baud rate (not used) */
+#define CIBAUD	  002003600000		/* input baud rate */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
+#define IBSHIFT	16			/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0000001
 #define ICANON	0000002
diff -puN include/asm-m68k/termios.h~m68k-enable-arbitary-speed-tty-support include/asm-m68k/termios.h
--- a/include/asm-m68k/termios.h~m68k-enable-arbitary-speed-tty-support
+++ a/include/asm-m68k/termios.h
@@ -82,8 +82,10 @@ struct termio {
 	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
 })
 
-#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
-#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
+#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
+#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
+#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
 
 #endif	/* __KERNEL__ */
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-switch-most-of-the-remaining-sff-drivers-to.patch
pata_marvell-add-more-identifiers.patch
libata-portmap-remove-unused-definitions.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-spot-bridge-chips.patch
libata-allow-for-original-ide-drives-that-dont-support-geometry-setting.patch
libata-strict-checking-for-identify-reporting.patch
libata-add-a-drivers-ide-style-dma-disable.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
git-scsi-misc.patch
fix-gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
kobil_sct-rework-driver.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
