From: akpm@linux-foundation.org
Subject: + lots-of-architectures-enable-arbitary-speed-tty-support.patch added to -mm tree
Date: Wed, 23 May 2007 14:09:58 -0700
Message-ID: <200705232109.l4NL9wvn032093@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173AbXEWVMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 17:12:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, bryan.wu@analog.com, chris@zankel.net, dhowells@redhat.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com, hskinnemoen@atmel.com, kkojima@rr.iij4u.or.jp, kyle@mcmartin.ca, lethal@linux-sh.org, ralf@linux-mips.org, rc@rc0.org.uk, rmk@arm.linux.org.uk, schwidefsky@de.ibm.com, spyro@f2s.com, starvik@axis.com, takata@linux-m32r.org, tony.luck@intel.com, uclinux-v850@lsi.nec.co.jp, willy@debian.org, ysato@users.sourceforge.jp, zippel@linux-m68k.org


The patch titled
     lots-of-architectures: enable arbitary speed tty support
has been added to the -mm tree.  Its filename is
     lots-of-architectures-enable-arbitary-speed-tty-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lots-of-architectures: enable arbitary speed tty support
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Add the termios2 structure ready for enabling on most platforms.  One or
two like Sparc are plain weird so have been left alone.  Most can use the
same structure as ktermios for termios2 (ie the newer ioctl uses the
structure matching the current kernel structure)

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: Russell King <rmk@arm.linux.org.uk>
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

 include/asm-arm/termbits.h      |   11 +++++++++++
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
 16 files changed, 176 insertions(+), 1 deletion(-)

diff -puN include/asm-arm/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support include/asm-arm/termbits.h
--- a/include/asm-arm/termbits.h~lots-of-architectures-enable-arbitary-speed-tty-support
+++ a/include/asm-arm/termbits.h
@@ -15,6 +15,17 @@ struct termios {
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct termios_2 {
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
arm-enable-arbitary-speed-tty-ioctls-and-split.patch
arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
ia64-arbitary-speed-tty-ioctl-support.patch
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
h8300-enable-arbitary-speed-tty-port-setup.patch
m32r-enable-arbitary-speed-tty-rate-setting.patch
etrax-enable-arbitary-speed-setting-on-tty-ports.patch
v850-enable-arbitary-speed-tty-ioctls.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
mpu401-warning-fixes.patch
lots-of-architectures-enable-arbitary-speed-tty-support.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
