From: akpm@linux-foundation.org
Subject: + tty-add-the-new-ioctls-and-definitionto-the-mips.patch added to -mm tree
Date: Thu, 07 Jun 2007 22:39:23 -0700
Message-ID: <200706080539.l585dNFL020195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38151 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754528AbXFHFkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 01:40:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, ralf@linux-mips.org


The patch titled
     tty: add the new ioctls and definitionto the MIPS architecture
has been added to the -mm tree.  Its filename is
     tty-add-the-new-ioctls-and-definitionto-the-mips.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

lots-of-architectures-enable-arbitary-speed-tty-support.patch
ia64-arbitary-speed-tty-ioctl-support.patch
git-libata-all.patch
pata-add-the-mcp73-77-support-to-pata-driver.patch
libata-correct-abuse-of-language.patch
libata-core-sff-fix-multiple-assumptions-about-dma.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
add-pci_try_set_mwi-prism54pci.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
h8300-enable-arbitary-speed-tty-port-setup.patch
arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
m32r-enable-arbitary-speed-tty-rate-setting.patch
etrax-enable-arbitary-speed-setting-on-tty-ports.patch
v850-enable-arbitary-speed-tty-ioctls.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
mpu401-warning-fixes.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
intel-rng-undo-mess-made-by-an-80-column-extremist.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
