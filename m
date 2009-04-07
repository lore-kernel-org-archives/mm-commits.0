From: akpm@linux-foundation.org
Subject: [merged] esp-fix-section-mismatch-warning.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:04 -0700
Message-ID: <200904071906.n37J64ax010632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbZDGTIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:08:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, arobinso@nyx.net, mm-commits@vger.kernel.org


The patch titled
     esp: fix section mismatch warning
has been removed from the -mm tree.  Its filename was
     esp-fix-section-mismatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: esp: fix section mismatch warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Not critical.

WARNING: drivers/char/esp.o(.text+0x278): Section mismatch in reference from the function show_serial_version() to the variable .init.data:serial_version
The function show_serial_version() references
the variable __initdata serial_version.
This is often because show_serial_version lacks a __initdata
annotation or the annotation of serial_version is wrong.

WARNING: drivers/char/esp.o(.text+0x27d): Section mismatch in reference from the function show_serial_version() to the variable .init.data:serial_name
The function show_serial_version() references
the variable __initdata serial_name.
This is often because show_serial_version lacks a __initdata
annotation or the annotation of serial_name is wrong.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew J. Robinson <arobinso@nyx.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/esp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/esp.c~esp-fix-section-mismatch-warning drivers/char/esp.c
--- a/drivers/char/esp.c~esp-fix-section-mismatch-warning
+++ a/drivers/char/esp.c
@@ -2258,7 +2258,7 @@ static int esp_open(struct tty_struct *t
  * driver.
  */
 
-static void show_serial_version(void)
+static void __init show_serial_version(void)
 {
 	printk(KERN_INFO "%s version %s (DMA %u)\n",
 		serial_name, serial_version, dma);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sysctl-lockdep-support-for-sysctl-reference-counting-fix.patch
qla2x-fix-printk-format-warnings.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
reiser4-export-remove_from_page_cache-fix.patch

