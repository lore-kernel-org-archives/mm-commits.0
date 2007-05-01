From: akpm@linux-foundation.org
Subject: + char-isicom-use-pr_debug.patch added to -mm tree
Date: Tue, 01 May 2007 15:36:37 -0700
Message-ID: <200705012236.l41MabZ4008295@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754682AbXEAWgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 18:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: isicom, use pr_debug
has been added to the -mm tree.  Its filename is
     char-isicom-use-pr_debug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: isicom, use pr_debug
From: Jiri Slaby <jirislaby@gmail.com>

isicom, use pr_debug

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-use-pr_debug drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-use-pr_debug
+++ a/drivers/char/isicom.c
@@ -137,11 +137,10 @@
 #define InterruptTheCard(base) outw(0, (base) + 0xc)
 #define ClearInterrupt(base) inw((base) + 0x0a)
 
+#define pr_dbg(str...) pr_debug("ISICOM: " str)
 #ifdef DEBUG
-#define pr_dbg(str...) printk(KERN_DEBUG "ISICOM: " str)
 #define isicom_paranoia_check(a, b, c) __isicom_paranoia_check((a), (b), (c))
 #else
-#define pr_dbg(str...) do { } while (0)
 #define isicom_paranoia_check(a, b, c) 0
 #endif
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

input-ff-add-ff_raw-effect.patch
input-phantom-add-a-new-driver.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
drivers-char-use-__set_current_state.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
char-cyclades-create-cy_init_ze.patch
char-cyclades-use-pci_iomap-unmap.patch
char-cyclades-init-ze-immediately.patch
char-cyclades-create-cy_pci_probe.patch
char-cyclades-move-card-entries-init-into-function.patch
char-cyclades-init-card-struct-immediately.patch
char-cyclades-remove-some-global-vars.patch
char-cyclades-cy_init-error-handling.patch
char-cyclades-tty_register_device-separately-for-each-device.patch
char-cyclades-clear-interrupts-before-releasing.patch
char-cyclades-allow-debug_shirq.patch
char-mxser-schedule-for-removal.patch
char-isicom-use-pr_debug.patch
serial-serial_core-use-pr_debug.patch
shrink_slab-handle-bad-shrinkers.patch
