From: akpm@linux-foundation.org
Subject: + mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch added to -mm tree
Date: Thu, 09 Aug 2007 12:59:34 -0700
Message-ID: <200708091959.l79JxYWi016789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55873 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752560AbXHIT7z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 15:59:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     mxser: Remove use of dead TTY_FLIPBUF_SIZE definition
has been added to the -mm tree.  Its filename is
     mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mxser: Remove use of dead TTY_FLIPBUF_SIZE definition
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

We simply define it to the same value.  Nowdays the TTY flip value is
irrelevant but the value it used is as good as any so why risk breaking it

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.h |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/mxser.h~mxser-remove-use-of-dead-tty_flipbuf_size-definition drivers/char/mxser.h
--- a/drivers/char/mxser.h~mxser-remove-use-of-dead-tty_flipbuf_size-definition
+++ a/drivers/char/mxser.h
@@ -30,8 +30,7 @@
 
 #define TTY_THRESHOLD_THROTTLE  128
 
-#define LO_WATER	 	(TTY_FLIPBUF_SIZE)
-#define HI_WATER		(TTY_FLIPBUF_SIZE*2*3/4)
+#define HI_WATER		768
 
 // added by James. 03-11-2004.
 #define MOXA_SDS_GETICOUNTER  	(MOXA + 68)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

fix-serial-buffer-memory-leak.patch
fix-serial-buffer-memory-leak-fix.patch
nozomi-shoot-defunct-label.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
libata-acpi-checks-for-80wire-cable-headers.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
libata-correct-iordy-handling.patch
st340823a-hpa-and-libata.patch
pata_cmd64x-set-up-mwdma-modes-properly.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ata_piix-disallow-udma-133-on-ich5-ich7.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
dtc-clean-up-indent-damage-and-add-printk-levels.patch
kl5kusb105-switch-to-new-speed-api.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
pci-align-bar-settings-for-legacy-mode-ide-fix.patch
belkin_sa-avoid-divide-by-zero-error.patch
blackfin-enable-arbitary-speed-serial-setting.patch
char-cyclades-remove-bottom-half-processing.patch
