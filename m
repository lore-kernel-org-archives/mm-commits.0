From: akpm@linux-foundation.org
Subject: + isapnp-removed-unused-isapnp_detected-and-isapnp_debug.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:39:16 -0700
Message-ID: <200708171839.l7HIdGnH023933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40973 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755635AbXHQSkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org, perex@suse.cz


The patch titled
     ISAPNP: removed unused isapnp_detected and ISAPNP_DEBUG
has been added to the -mm tree.  Its filename is
     isapnp-removed-unused-isapnp_detected-and-isapnp_debug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ISAPNP: removed unused isapnp_detected and ISAPNP_DEBUG
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

ISAPNP_DEBUG isn't used at all.  isapnp_detected is set but never read.
So remove them both.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/isapnp/core.c |    7 -------
 1 files changed, 7 deletions(-)

diff -puN drivers/pnp/isapnp/core.c~isapnp-removed-unused-isapnp_detected-and-isapnp_debug drivers/pnp/isapnp/core.c
--- a/drivers/pnp/isapnp/core.c~isapnp-removed-unused-isapnp_detected-and-isapnp_debug
+++ a/drivers/pnp/isapnp/core.c
@@ -47,9 +47,6 @@
 #if 0
 #define ISAPNP_REGION_OK
 #endif
-#if 0
-#define ISAPNP_DEBUG
-#endif
 
 int isapnp_disable;		/* Disable ISA PnP */
 static int isapnp_rdp;		/* Read Data Port */
@@ -93,7 +90,6 @@ MODULE_LICENSE("GPL");
 
 static unsigned char isapnp_checksum_value;
 static DEFINE_MUTEX(isapnp_cfg_mutex);
-static int isapnp_detected;
 static int isapnp_csn_count;
 
 /* some prototypes */
@@ -1067,7 +1063,6 @@ static int __init isapnp_init(void)
 	struct pnp_dev *dev;
 
 	if (isapnp_disable) {
-		isapnp_detected = 0;
 		printk(KERN_INFO "isapnp: ISA Plug & Play support disabled\n");
 		return 0;
 	}
@@ -1115,7 +1110,6 @@ static int __init isapnp_init(void)
 		}
 		isapnp_set_rdp();
 	}
-	isapnp_detected = 1;
 	if (isapnp_rdp < 0x203 || isapnp_rdp > 0x3ff) {
 		cards = isapnp_isolate();
 		if (cards < 0 || (isapnp_rdp < 0x203 || isapnp_rdp > 0x3ff)) {
@@ -1123,7 +1117,6 @@ static int __init isapnp_init(void)
 			release_region(_PIDXR, 1);
 #endif
 			release_region(_PNPWRP, 1);
-			isapnp_detected = 0;
 			printk(KERN_INFO
 			       "isapnp: No Plug & Play device found\n");
 			return 0;
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
move-free-pages-between-lists-on-steal.patch
convert-ill-defined-log2-to-ilog2.patch
tpm_tis-fix-interrupt-probing.patch
pnp-fix-up-after-lindent.patch
pnpacpi-simplify-irq_flags.patch
pnpacpi-remove-unnecessary-casts-of-void.patch
isapnp-removed-unused-isapnp_detected-and-isapnp_debug.patch
pnp-remove-module-infrastructure.patch
pnp-remove-null-pointer-checks.patch
