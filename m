From: akpm@linux-foundation.org
Subject: - char-cyclades-unexport-struct-cyclades_card.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:28 -0700
Message-ID: <200705090257.l492vSYg010194@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032754AbXEIC5b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, unexport struct cyclades_card
has been removed from the -mm tree.  Its filename was
     char-cyclades-unexport-struct-cyclades_card.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
