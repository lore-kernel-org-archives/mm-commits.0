From: akpm@linux-foundation.org
Subject: - blackfin-enable-arbitary-speed-serial-setting.patch removed from -mm tree
Date: Fri, 12 Oct 2007 15:25:36 -0700
Message-ID: <200710122225.l9CMPaXU006564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57778 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933005AbXJLWZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Oct 2007 18:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, aubrey.li@analog.com, bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     blackfin: enable arbitary speed serial setting
has been removed from the -mm tree.  Its filename was
     blackfin-enable-arbitary-speed-serial-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: blackfin: enable arbitary speed serial setting
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Add the needed definitions to activate arbitary speed support on the
blackfin platform.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Bryan Wu <bryan.wu@analog.com>
Acked-by: Aubrey Li <aubrey.li@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-blackfin/ioctls.h   |    4 ++++
 include/asm-blackfin/termbits.h |    5 ++++-
 include/asm-blackfin/termios.h  |    6 ++++--
 3 files changed, 12 insertions(+), 3 deletions(-)

diff -puN include/asm-blackfin/ioctls.h~blackfin-enable-arbitary-speed-serial-setting include/asm-blackfin/ioctls.h
--- a/include/asm-blackfin/ioctls.h~blackfin-enable-arbitary-speed-serial-setting
+++ a/include/asm-blackfin/ioctls.h
@@ -47,6 +47,10 @@
 #define TIOCSBRK	0x5427	/* BSD compatibility */
 #define TIOCCBRK	0x5428	/* BSD compatibility */
 #define TIOCGSID	0x5429	/* Return the session ID of FD */
+#define TCGETS2		_IOR('T',0x2A, struct termios2)
+#define TCSETS2		_IOW('T',0x2B, struct termios2)
+#define TCSETSW2	_IOW('T',0x2C, struct termios2)
+#define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int)	/* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)	/* Lock/unlock Pty */
 
diff -puN include/asm-blackfin/termbits.h~blackfin-enable-arbitary-speed-serial-setting include/asm-blackfin/termbits.h
--- a/include/asm-blackfin/termbits.h~blackfin-enable-arbitary-speed-serial-setting
+++ a/include/asm-blackfin/termbits.h
@@ -140,6 +140,7 @@ struct ktermios {
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
+#define	   BOTHER 0010000
 #define    B57600 0010001
 #define   B115200 0010002
 #define   B230400 0010003
@@ -155,10 +156,12 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
-#define CIBAUD	  002003600000	/* input baud rate (not used) */
+#define CIBAUD	  002003600000	/* input baud rate */
 #define CMSPAR	  010000000000	/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000	/* flow control */
 
+#define	IBSHIFT	16		/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0000001
 #define ICANON	0000002
diff -puN include/asm-blackfin/termios.h~blackfin-enable-arbitary-speed-serial-setting include/asm-blackfin/termios.h
--- a/include/asm-blackfin/termios.h~blackfin-enable-arbitary-speed-serial-setting
+++ a/include/asm-blackfin/termios.h
@@ -98,8 +98,10 @@ struct termio {
 	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
 })
 
-#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
-#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
+#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
+#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
+#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
 
 #endif				/* __KERNEL__ */
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
wake-up-from-a-serial-port.patch
git-scsi-misc.patch
initio-fix-conflict-when-loading-driver.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
tty-bring-the-old-cris-driver-back-somewhere-into-the.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-missing-word-in-documentation.patch
ide-cd-is-unmaintained.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
fs-correct-sus-compliance-for-open-of-large-file-without.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
usb_serial-stop-passing-null-to-functions-that-expect-data.patch
ark3116-update-termios-handling.patch
usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
ch341-fix-termios-handling.patch
digi_acceleport-fix-termios-and-also-readability-a-bit.patch
empeg-clean-up-and-handle-speeds.patch
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
