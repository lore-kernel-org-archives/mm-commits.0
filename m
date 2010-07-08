From: akpm@linux-foundation.org
Subject: + serial-mmio32-support-for-8250_earlyc-fix.patch added to -mm tree
Date: Thu, 08 Jul 2010 11:59:59 -0700
Message-ID: <201007081859.o68IxxnO021676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755532Ab0GHTAJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 15:00:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, _deepfire@feelingofgreen.ru, greg@kroah.com


The patch titled
     serial-mmio32-support-for-8250_earlyc-fix
has been added to the -mm tree.  Its filename is
     serial-mmio32-support-for-8250_earlyc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial-mmio32-support-for-8250_earlyc-fix
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in serial-mmio32-support-for-8250_earlyc.patch:

drivers/serial/8250_early.c:207: warning: format '%p' expects type 'void *', but argument 3 has type 'long long unsigned int'
drivers/serial/8250_early.c:210: warning: format '%p' expects type 'void *', but argument 2 has type 'long long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Samium Gromoff <_deepfire@feelingofgreen.ru>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_early.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/8250_early.c~serial-mmio32-support-for-8250_earlyc-fix drivers/serial/8250_early.c
--- a/drivers/serial/8250_early.c~serial-mmio32-support-for-8250_earlyc-fix
+++ a/drivers/serial/8250_early.c
@@ -202,12 +202,12 @@ static int __init parse_options(struct e
 	}
 
 	if (mmio || mmio32)
-		printk(KERN_INFO "Early serial console at MMIO%s 0x%p (options '%s')\n",
+		printk(KERN_INFO "Early serial console at MMIO%s 0x%llu (options '%s')\n",
 		       mmio32 ? "32" : "", (unsigned long long) port->mapbase,
 		       device->options);
 	else
 		printk(KERN_INFO "Early serial console at I/O port 0x%pr (options '%s')\n",
-		       (unsigned long long) port->iobase, device->options);
+		       (void *) port->iobase, device->options);
 
 	return 0;
 }
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
compal-laptop-uses-hwmon-interfaces-depends-on-hwmon.patch
dib3000mc-reduce-large-stack-usage-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
serial-mmio32-support-for-8250_earlyc-fix.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
virtio_9ph-include-linux-typesh.patch
submittingpatches-add-more-about-patch-descriptions.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch
fusion-fix-kernel-doc-warnings.patch
timerc-fix-kernel-doc-warning.patch
mtd-nand_base-fix-kernel-doc-warnings-typos.patch
docbook-need-xmldoclinks-for-all-doc-types.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

