From: akpm@linux-foundation.org
Subject: + etrax-enable-arbitary-speed-setting-on-tty-ports.patch added to -mm tree
Date: Wed, 23 May 2007 11:42:35 -0700
Message-ID: <200705231842.l4NIgYE6029414@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755918AbXEWSmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 14:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, starvik@axis.com


The patch titled
     etrax: enable arbitary speed setting on tty ports
has been added to the -mm tree.  Its filename is
     etrax-enable-arbitary-speed-setting-on-tty-ports.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: etrax: enable arbitary speed setting on tty ports
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Add the needed constants and bits. The actual code is already in the tty
layer and turned on by the definitions

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/ioctls.h   |    4 ++++
 include/asm-cris/termbits.h |    1 +
 include/asm-cris/termios.h  |    6 ++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff -puN include/asm-cris/ioctls.h~etrax-enable-arbitary-speed-setting-on-tty-ports include/asm-cris/ioctls.h
--- a/include/asm-cris/ioctls.h~etrax-enable-arbitary-speed-setting-on-tty-ports
+++ a/include/asm-cris/ioctls.h
@@ -48,6 +48,10 @@
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
+#define TCGETS2		_IOR('T',0x2A, struct termios2)
+#define TCSETS2		_IOW('T',0x2B, struct termios2)
+#define TCSETSW2	_IOW('T',0x2C, struct termios2)
+#define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
diff -puN include/asm-cris/termbits.h~etrax-enable-arbitary-speed-setting-on-tty-ports include/asm-cris/termbits.h
--- a/include/asm-cris/termbits.h~etrax-enable-arbitary-speed-setting-on-tty-ports
+++ a/include/asm-cris/termbits.h
@@ -155,6 +155,7 @@ struct ktermios {
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
+#define  BOTHER  0010000
 #define  B57600  0010001
 #define  B115200 0010002
 #define  B230400 0010003
diff -puN include/asm-cris/termios.h~etrax-enable-arbitary-speed-setting-on-tty-ports include/asm-cris/termios.h
--- a/include/asm-cris/termios.h~etrax-enable-arbitary-speed-setting-on-tty-ports
+++ a/include/asm-cris/termios.h
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
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
arm-enable-arbitary-speed-tty-ioctls-and-split.patch
arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
libata-add-support-for-ata_16-on-atapi.patch
fix-build-failure-for-drivers-ata-pata_sccc.patch
hpt3x2n-correct-revision-boundary.patch
pata_sis-fix-and-clean-up-some-timing-setups.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
ide-add-seagate-stt20000a-to-dma-blacklist.patch
serial-use-resource_size_t-for-port-io-addresses.patch
add-pci_try_set_mwi.patch
fix-pci_find_present.patch
git-scsi-misc.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
ncr5380-warning-fixes.patch
watchdog-documentation.patch
add-pci_try_set_mwi-prism54pci.patch
fix-crash-with-irqpoll-due-to-the-irqf_irqpoll-flag.patch
blackfin-enable-arbitary-speed-serial-setting.patch
etrax-enable-arbitary-speed-setting-on-tty-ports.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
mpu401-warning-fixes.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
