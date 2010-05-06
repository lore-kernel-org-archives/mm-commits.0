From: akpm@linux-foundation.org
Subject: + scsi-fix-pmcraid-build-errors.patch added to -mm tree
Date: Thu, 06 May 2010 15:14:29 -0700
Message-ID: <201005062214.o46MET9k018091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290Ab0EFWOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 18:14:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, anil_ravindranath@pmc-sierra.com


The patch titled
     scsi: fix pmcraid build errors
has been added to the -mm tree.  Its filename is
     scsi-fix-pmcraid-build-errors.patch

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
Subject: scsi: fix pmcraid build errors
From: Randy Dunlap <randy.dunlap@oracle.com>

pmcraid should depend on NET since it uses netlink interfaces.
This fixes multiple build errors when CONFIG_NET is not enabled:

ERROR: "genl_register_family" [drivers/scsi/pmcraid.ko] undefined!
ERROR: "genl_unregister_family" [drivers/scsi/pmcraid.ko] undefined!
ERROR: "nla_put" [drivers/scsi/pmcraid.ko] undefined!
ERROR: "init_net" [drivers/scsi/pmcraid.ko] undefined!
ERROR: "__alloc_skb" [drivers/scsi/pmcraid.ko] undefined!
ERROR: "netlink_broadcast" [drivers/scsi/pmcraid.ko] undefined!
ERROR: "kfree_skb" [drivers/scsi/pmcraid.ko] undefined!
ERROR: "skb_put" [drivers/scsi/pmcraid.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/Kconfig~scsi-fix-pmcraid-build-errors drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~scsi-fix-pmcraid-build-errors
+++ a/drivers/scsi/Kconfig
@@ -1849,7 +1849,7 @@ config ZFCP
 
 config SCSI_PMCRAID
 	tristate "PMC SIERRA Linux MaxRAID adapter support"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && NET
 	---help---
 	  This driver supports the PMC SIERRA MaxRAID adapters.
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
virtio_9ph-include-linux-typesh.patch
dib3000mc-reduce-large-stack-usage-fix.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
documentation-submittingdrivers-resources.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

