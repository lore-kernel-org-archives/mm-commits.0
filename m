From: akpm@linux-foundation.org
Subject: + char-cyclades-unexport-struct-cyclades_card.patch added to -mm tree
Date: Thu, 03 May 2007 23:45:23 -0700
Message-ID: <200705040645.l446jNOX030865@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965698AbXEDGp1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:45:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, unexport struct cyclades_card
has been added to the -mm tree.  Its filename is
     char-cyclades-unexport-struct-cyclades_card.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, unexport struct cyclades_card
From: Jiri Slaby <jirislaby@gmail.com>

Do not export internal card data to userspace. cytune doesn't use this
anyway.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c  |    8 --------
 include/linux/cyclades.h |   15 ++-------------
 2 files changed, 2 insertions(+), 21 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-unexport-struct-cyclades_card drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-unexport-struct-cyclades_card
+++ a/drivers/char/cyclades.c
@@ -4049,14 +4049,6 @@ cy_ioctl(struct tty_struct *tty, struct 
 	case CYGETRTSDTR_INV:
 		ret_val = info->rtsdtr_inv;
 		break;
-	case CYGETCARDINFO:
-		if (copy_to_user(argp, &cy_card[info->card],
-				 sizeof(struct cyclades_card))) {
-			ret_val = -EFAULT;
-			break;
-		}
-		ret_val = 0;
-		break;
 	case CYGETCD1400VER:
 		ret_val = info->chip_rev;
 		break;
diff -puN include/linux/cyclades.h~char-cyclades-unexport-struct-cyclades_card include/linux/cyclades.h
--- a/include/linux/cyclades.h~char-cyclades-unexport-struct-cyclades_card
+++ a/include/linux/cyclades.h
@@ -110,7 +110,6 @@ struct cyclades_idle_stats {
 #define CYZSETPOLLCYCLE		0x43590e
 #define CYZGETPOLLCYCLE		0x43590f
 #define CYGETCD1400VER		0x435910
-#define CYGETCARDINFO		0x435911
 #define	CYSETWAIT		0x435912
 #define	CYGETWAIT		0x435913
 
@@ -506,8 +505,9 @@ struct ZFW_CTRL {
 /****************** ****************** *******************/
 #endif
 
+#ifdef __KERNEL__
+
 /* Per card data structure */
-struct resource;
 struct cyclades_card {
     unsigned long base_phys;
     unsigned long ctl_phys;
@@ -520,20 +520,9 @@ struct cyclades_card {
     int bus_index;	/* address shift - 0 for ISA, 1 for PCI */
     int	intr_enabled;	/* FW Interrupt flag - 0 disabled, 1 enabled */
     struct pci_dev *pdev;
-#ifdef __KERNEL__
     spinlock_t card_lock;
-#else
-    unsigned long filler;
-#endif
 };
 
-struct cyclades_chip {
-  int filler;
-};
-
-
-#ifdef __KERNEL__
-
 /***************************************
  * Memory access functions/macros      *
  * (required to support Alpha systems) *
_

Patches currently in -mm which might be from jirislaby@gmail.com are

serial-serial_core-use-pr_debug.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
drivers-char-use-__set_current_state.patch
misc-add-sensable-phantom-driver.patch
misc-add-sensable-phantom-driver-v3.patch
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
char-cyclades-use-is_cyc_z-macro.patch
char-cyclades-switch-to-pci-probing.patch
char-cyclades-depends-on-pci-or-isa.patch
char-cyclades-unexport-struct-cyclades_card.patch
char-cyclades-remove-useless-fileds-from-cyclades_card.patch
char-cyclades-irq-is-int.patch
char-cyclades-printk-cleanups.patch
char-cyclades-mark-cyy_init_card-as-__devinit-not-__init.patch
char-cyclades-simplify-variables-initialization.patch
char-cyclades-get-rid-of-phys-addresses.patch
char-cyclades-make-info-card-a-pointer.patch
char-cyclades-remove-sleep_on.patch
char-cyclades-fix-blockmove.patch
char-cyclades-timers-cleanup.patch
char-cyclades-remove-unused-timestamps.patch
char-cyclades-remove-locking-macros.patch
char-cyclades-conditions-cleanup.patch
char-cyclades-fix-tty-device-unregister.patch
char-cyclades-dynamic-ports.patch
char-cyclades-probe-cleanup.patch
char-cyclades-copyright-and-version-changes.patch
shrink_slab-handle-bad-shrinkers.patch
