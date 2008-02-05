From: akpm@linux-foundation.org
Subject: - sh-termios-ioctl-definitions.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:39:57 -0800
Message-ID: <200802052239.m15MdcbL013067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40988 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932298AbYBEWnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     sh: termios ioctl definitions
has been removed from the -mm tree.  Its filename was
     sh-termios-ioctl-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sh: termios ioctl definitions
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

These ports are holding up progress and now have been for months. Do the
job for them.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-sh/ioctls.h   |    4 ++++
 include/asm-sh/termbits.h |    5 ++++-
 include/asm-sh/termios.h  |    6 ++++--
 3 files changed, 12 insertions(+), 3 deletions(-)

diff -puN include/asm-sh/ioctls.h~sh-termios-ioctl-definitions include/asm-sh/ioctls.h
--- a/include/asm-sh/ioctls.h~sh-termios-ioctl-definitions
+++ a/include/asm-sh/ioctls.h
@@ -78,6 +78,10 @@
 #define TIOCSBRK	_IO('T', 39) /* 0x5427 */ /* BSD compatibility */
 #define TIOCCBRK	_IO('T', 40) /* 0x5428 */ /* BSD compatibility */
 #define TIOCGSID	_IOR('T', 41, pid_t) /* 0x5429 */ /* Return the session ID of FD */
+#define TCGETS2		_IOR('T', 42, struct termios2)
+#define TCSETS2		_IOW('T', 43, struct termios2)
+#define TCSETSW2	_IOW('T', 44, struct termios2)
+#define TCSETSF2	_IOW('T', 45, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
diff -puN include/asm-sh/termbits.h~sh-termios-ioctl-definitions include/asm-sh/termbits.h
--- a/include/asm-sh/termbits.h~sh-termios-ioctl-definitions
+++ a/include/asm-sh/termbits.h
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
+#define CIBAUD	  002003600000		/* input baud rate */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
+#define IBSHIFT	16		/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0000001
 #define ICANON	0000002
diff -puN include/asm-sh/termios.h~sh-termios-ioctl-definitions include/asm-sh/termios.h
--- a/include/asm-sh/termios.h~sh-termios-ioctl-definitions
+++ a/include/asm-sh/termios.h
@@ -80,8 +80,10 @@ struct termio {
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
git-acpi.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
geode-lists-are-subscriber-only.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
documentation-about-unaligned-memory-access.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline-update.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
char-mxser-ioctl-cleanup.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
moxa-first-pass-at-termios-reporting.patch
n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch.patch
rocket-first-pass-at-termios-reporting.patch
rocket-dont-let-random-users-reset-the-controller.patch
tty_audit-fix-checkpatch-complaint.patch
tty_io-drag-screaming-into-coding-style-compliance.patch
tty_ioctl-drag-screaming-into-compliance-with-the-coding.patch
8250_early-coding-style.patch
8250_gsc-coding-style.patch
8250_hp300-coding-style.patch
8250_hub6-codding-style.patch
8250_pci-coding-style.patch
serial8250-coding-style.patch
8250-enable-rate-reporting-via-termios.patch
serial_core-bring-mostly-into-line-with-coding-style.patch
smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
