From: akpm@linux-foundation.org
Subject: - tty-add-the-new-ioctls-and-definitionto-the-mips.patch removed from -mm tree
Date: Tue, 11 Sep 2007 13:20:45 -0700
Message-ID: <200709112020.l8BKKjwA027731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35859 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967060AbXIKUVk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 16:21:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     tty: add the new ioctls and definitionto the MIPS architecture
has been removed from the -mm tree.  Its filename was
     tty-add-the-new-ioctls-and-definitionto-the-mips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty: add the new ioctls and definitionto the MIPS architecture
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Same as all the others, just put in the constants for the existing kernel
code and termios2 structure

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/ioctls.h   |    4 ++++
 include/asm-mips/termbits.h |    7 +++++--
 include/asm-mips/termios.h  |    6 ++++--
 3 files changed, 13 insertions(+), 4 deletions(-)

diff -puN include/asm-mips/ioctls.h~tty-add-the-new-ioctls-and-definitionto-the-mips include/asm-mips/ioctls.h
--- a/include/asm-mips/ioctls.h~tty-add-the-new-ioctls-and-definitionto-the-mips
+++ a/include/asm-mips/ioctls.h
@@ -77,6 +77,10 @@
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x7416  /* Return the session ID of FD */
+#define TCGETS2		_IOR('T',0x2A, struct termios2)
+#define TCSETS2		_IOW('T',0x2B, struct termios2)
+#define TCSETSW2	_IOW('T',0x2C, struct termios2)
+#define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
diff -puN include/asm-mips/termbits.h~tty-add-the-new-ioctls-and-definitionto-the-mips include/asm-mips/termbits.h
--- a/include/asm-mips/termbits.h~tty-add-the-new-ioctls-and-definitionto-the-mips
+++ a/include/asm-mips/termbits.h
@@ -164,6 +164,7 @@ struct ktermios {
 #define HUPCL	0002000		/* Hang up on last close.  */
 #define CLOCAL	0004000		/* Ignore modem status lines.  */
 #define CBAUDEX 0010000
+#define    BOTHER 0010000
 #define    B57600 0010001
 #define   B115200 0010002
 #define   B230400 0010003
@@ -179,9 +180,11 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
-#define CIBAUD	  002003600000	/* input baud rate (not used) */
+#define CIBAUD	  002003600000	/* input baud rate */
 #define CMSPAR    010000000000	/* mark or space (stick) parity */
-#define CRTSCTS	  020000000000		/* flow control */
+#define CRTSCTS	  020000000000	/* flow control */
+
+#define IBSHIFT	16		/* Shift from CBAUD to CIBAUD */
 
 /* c_lflag bits */
 #define ISIG	0000001		/* Enable signals.  */
diff -puN include/asm-mips/termios.h~tty-add-the-new-ioctls-and-definitionto-the-mips include/asm-mips/termios.h
--- a/include/asm-mips/termios.h~tty-add-the-new-ioctls-and-definitionto-the-mips
+++ a/include/asm-mips/termios.h
@@ -122,8 +122,10 @@ struct termio {
 	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
 })
 
-#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
-#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
+#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
+#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
+#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
 
 #endif /* defined(__KERNEL__) */
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

drivers-edac-fix-printk-level-down-to-debug-from-emerg.patch
drivers-edac-fix-e752x-correct-return-code.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
wake-up-from-a-serial-port.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
git-xtensa.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
