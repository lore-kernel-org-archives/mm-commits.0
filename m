From: akpm@linux-foundation.org
Subject: - lots-of-architectures-enable-arbitary-speed-tty-support.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:32:08 -0700
Message-ID: <200707132232.l6DMW8fw024975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49667 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752296AbXGMWes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:34:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, bryan.wu@analog.com, chris@zankel.net, dhowells@redhat.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com, hskinnemoen@atmel.com, kkojima@rr.iij4u.or.jp, kyle@mcmartin.ca, lethal@linux-sh.org, ralf@linux-mips.org, rc@rc0.org.uk, schwidefsky@de.ibm.com, spyro@f2s.com, starvik@axis.com, takata@linux-m32r.org, tony.luck@intel.com, uclinux-v850@lsi.nec.co.jp, willy@debian.org, ysato@users.sourceforge.jp, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     lots-of-architectures: enable arbitary speed tty support
has been removed from the -mm tree.  Its filename was
     lots-of-architectures-enable-arbitary-speed-tty-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lots-of-architectures: enable arbitary speed tty support
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Add the termios2 structure ready for enabling on most platforms.  One or
two like Sparc are plain weird so have been left alone.  Most can use the
same structure as ktermios for termios2 (ie the newer ioctl uses the
structure matching the current kernel structure)

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: Ian Molton <spyro@f2s.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Mikael Starvik <starvik@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Kazumoto Kojima <kkojima@rr.iij4u.or.jp>
Cc: Richard Curnow <rc@rc0.org.uk>
Cc: Miles Bader <uclinux-v850@lsi.nec.co.jp>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm26/termbits.h    |   12 +++++++++++-
 include/asm-avr32/termbits.h    |   11 +++++++++++
 include/asm-blackfin/termbits.h |   11 +++++++++++
 include/asm-cris/termbits.h     |   11 +++++++++++
 include/asm-frv/termbits.h      |   11 +++++++++++
 include/asm-h8300/termbits.h    |   11 +++++++++++
 include/asm-ia64/termbits.h     |   11 +++++++++++
 include/asm-m32r/termbits.h     |   11 +++++++++++
 include/asm-m68k/termbits.h     |   11 +++++++++++
 include/asm-mips/termbits.h     |   11 +++++++++++
 include/asm-parisc/termbits.h   |   11 +++++++++++
 include/asm-s390/termbits.h     |   11 +++++++++++
 include/asm-sh/termbits.h       |   11 +++++++++++
 include/asm-v850/termbits.h     |   11 +++++++++++
 include/asm-xtensa/termbits.h   |   11 +++++++++++
 15 files changed, 165 insertions(+), 1 deletion(-)

diff -puN include/asm-arm26/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-arm26/termbits.h
--- a/include/asm-arm26/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-arm26/termbits.h
@@ -15,7 +15,7 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
-struct ktermios {
+struct termios2 {
 	tcflag_t c_iflag;		/* input mode flags */
 	tcflag_t c_oflag;		/* output mode flags */
 	tcflag_t c_cflag;		/* control mode flags */
@@ -26,6 +26,16 @@ struct ktermios {
 	speed_t c_ospeed;		/* output speed */
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
 
 /* c_cc characters */
 #define VINTR 0
diff -puN include/asm-avr32/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-avr32/termbits.h
--- a/include/asm-avr32/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-avr32/termbits.h
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
diff -puN include/asm-blackfin/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-blackfin/termbits.h
--- a/include/asm-blackfin/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-blackfin/termbits.h
@@ -17,6 +17,17 @@ struct termios {
 	cc_t c_cc[NCCS];	/* control characters */
 };
 
+struct termios2 {
+	tcflag_t c_iflag;               /* input mode flags */
+	tcflag_t c_oflag;               /* output mode flags */
+	tcflag_t c_cflag;               /* control mode flags */
+	tcflag_t c_lflag;               /* local mode flags */
+	cc_t c_line;                    /* line discipline */
+	cc_t c_cc[NCCS];                /* control characters */
+	speed_t c_ispeed;               /* input speed */
+	speed_t c_ospeed;               /* output speed */
+};
+
 struct ktermios {
 	tcflag_t c_iflag;               /* input mode flags */
 	tcflag_t c_oflag;               /* output mode flags */
diff -puN include/asm-cris/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-cris/termbits.h
--- a/include/asm-cris/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-cris/termbits.h
@@ -19,6 +19,17 @@ struct termios {
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
diff -puN include/asm-frv/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-frv/termbits.h
--- a/include/asm-frv/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-frv/termbits.h
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
diff -puN include/asm-h8300/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-h8300/termbits.h
--- a/include/asm-h8300/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-h8300/termbits.h
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
diff -puN include/asm-ia64/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-ia64/termbits.h
--- a/include/asm-ia64/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-ia64/termbits.h
@@ -26,6 +26,17 @@ struct termios {
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
diff -puN include/asm-m32r/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-m32r/termbits.h
--- a/include/asm-m32r/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-m32r/termbits.h
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
diff -puN include/asm-m68k/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-m68k/termbits.h
--- a/include/asm-m68k/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-m68k/termbits.h
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
diff -puN include/asm-mips/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-mips/termbits.h
--- a/include/asm-mips/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-mips/termbits.h
@@ -30,6 +30,17 @@ struct termios {
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
diff -puN include/asm-parisc/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-parisc/termbits.h
--- a/include/asm-parisc/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-parisc/termbits.h
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
diff -puN include/asm-s390/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-s390/termbits.h
--- a/include/asm-s390/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-s390/termbits.h
@@ -25,6 +25,17 @@ struct termios {
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
diff -puN include/asm-sh/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-sh/termbits.h
--- a/include/asm-sh/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-sh/termbits.h
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
diff -puN include/asm-v850/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-v850/termbits.h
--- a/include/asm-v850/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-v850/termbits.h
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
diff -puN include/asm-xtensa/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-xtensa/termbits.h
--- a/include/asm-xtensa/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-xtensa/termbits.h
@@ -30,6 +30,17 @@ struct termios {
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
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-powerpc.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
ata-use-iomap_name.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
git-scsi-misc.patch
ppa-coding-police-and-printk-levels.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
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
improve-behaviour-of-spurious-irq-detect.patch
audit-add-tty-input-auditing.patch
revert-vanishing-ioctl-handler-debugging.patch
amiserial-remove-incorrect-no-termios-change-check.patch
genericserial-remove-bogus-optimisation-check-and-dead-code-paths.patch
synclink-remove-bogus-no-change-termios-optimisation.patch
68360serial-remove-broken-optimisation.patch
serial-remove-termios-checks-from-various-old-char-serial.patch
ia64-arbitary-speed-tty-ioctl-support.patch
sb1250-duartc-sb1250-duart-serial-support.patch
i2o_cfg_passthru-cleanup.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
stallion-remove-unneeded-lock_kernel.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
drivers-edac-fix-edac_device-semaphore-to-mutex.patch
drivers-edac-fix-e752x-reversed-csrows.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-fix-leaf-sysfs-attribute.patch
drivers-edac-fix-edac_mc-init-apis.patch
drivers-edac-fix-edac_device-init-apis.patch
drivers-edac-fix-edac_mc-sysfs-completion-code.patch
drivers-edac-fix-edac_device-sysfs-completion-code.patch
