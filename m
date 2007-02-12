From: akpm@linux-foundation.org
Subject: - isdn-rename-debug-option-config_serial_nopause_io.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:15 -0800
Message-ID: <200702122246.l1CMkFCD013790@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45219 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030329AbXBLWqT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:46:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     ISDN: Rename debug option CONFIG_SERIAL_NOPAUSE_IO
has been removed from the -mm tree.  Its filename was
     isdn-rename-debug-option-config_serial_nopause_io.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ISDN: Rename debug option CONFIG_SERIAL_NOPAUSE_IO
From: "Robert P. J. Day" <rpjday@mindspring.com>

Based on advice from K.  Keil, rename the special debug option
CONFIG_SERIAL_NOPAUSE_IO to ELSA_SERIAL_NOPAUSE_IO so it no longer resembles a
user-selectable kernel config option.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/elsa_ser.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/isdn/hisax/elsa_ser.c~isdn-rename-debug-option-config_serial_nopause_io drivers/isdn/hisax/elsa_ser.c
--- a/drivers/isdn/hisax/elsa_ser.c~isdn-rename-debug-option-config_serial_nopause_io
+++ a/drivers/isdn/hisax/elsa_ser.c
@@ -58,7 +58,7 @@ static inline unsigned int serial_in(str
 static inline unsigned int serial_inp(struct IsdnCardState *cs, int offset)
 {
 #ifdef SERIAL_DEBUG_REG
-#ifdef CONFIG_SERIAL_NOPAUSE_IO
+#ifdef ELSA_SERIAL_NOPAUSE_IO
 	u_int val = inb(cs->hw.elsa.base + 8 + offset);
 	debugl1(cs,"inp  %s %02x",ModemIn[offset], val);
 #else
@@ -67,7 +67,7 @@ static inline unsigned int serial_inp(st
 #endif
 	return(val);
 #else
-#ifdef CONFIG_SERIAL_NOPAUSE_IO
+#ifdef ELSA_SERIAL_NOPAUSE_IO
 	return inb(cs->hw.elsa.base + 8 + offset);
 #else
 	return inb_p(cs->hw.elsa.base + 8 + offset);
@@ -87,13 +87,13 @@ static inline void serial_outp(struct Is
 			       int value)
 {
 #ifdef SERIAL_DEBUG_REG
-#ifdef CONFIG_SERIAL_NOPAUSE_IO
+#ifdef ELSA_SERIAL_NOPAUSE_IO
 	debugl1(cs,"outp %s %02x",ModemOut[offset], value);
 #else
 	debugl1(cs,"outP %s %02x",ModemOut[offset], value);
 #endif
 #endif
-#ifdef CONFIG_SERIAL_NOPAUSE_IO
+#ifdef ELSA_SERIAL_NOPAUSE_IO
 	outb(value, cs->hw.elsa.base + 8 + offset);
 #else
     	outb_p(value, cs->hw.elsa.base + 8 + offset);
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
