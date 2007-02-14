From: akpm@linux-foundation.org
Subject: + sata-use-null-for-ptrs.patch added to -mm tree
Date: Wed, 14 Feb 2007 14:43:02 -0800
Message-ID: <200702142243.l1EMh28X011629@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49725 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbXBNWnN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 17:43:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jeff@garzik.org


The patch titled
     SATA: use NULL for ptrs
has been added to the -mm tree.  Its filename is
     sata-use-null-for-ptrs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SATA: use NULL for ptrs
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse warnings in SATA:
drivers/ata/sata_sil.c:342:9: warning: Using plain integer as NULL pointer
drivers/ata/sata_mv.c:2056:55: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_mv.c  |    2 +-
 drivers/ata/sata_sil.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/ata/sata_mv.c~sata-use-null-for-ptrs drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~sata-use-null-for-ptrs
+++ a/drivers/ata/sata_mv.c
@@ -2052,7 +2052,7 @@ static void mv_port_init(struct ata_iopo
 	port->altstatus_addr = port->ctl_addr = shd_base + SHD_CTL_AST_OFS;
 
 	/* unused: */
-	port->cmd_addr = port->bmdma_addr = port->scr_addr = 0;
+	port->cmd_addr = port->bmdma_addr = port->scr_addr = NULL;
 
 	/* Clear any currently outstanding port interrupt conditions */
 	serr_ofs = mv_scr_offset(SCR_ERROR);
diff -puN drivers/ata/sata_sil.c~sata-use-null-for-ptrs drivers/ata/sata_sil.c
--- a/drivers/ata/sata_sil.c~sata-use-null-for-ptrs
+++ a/drivers/ata/sata_sil.c
@@ -339,7 +339,7 @@ static inline void __iomem *sil_scr_addr
 		break;
 	}
 
-	return 0;
+	return NULL;
 }
 
 static u32 sil_scr_read (struct ata_port *ap, unsigned int sc_reg)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
build-errors-uevent-with-config_sysfs=n.patch
acpi-use-null-for-ptrs.patch
git-drm.patch
sata-use-null-for-ptrs.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
parisc-fix-module_param-iommu-permission.patch
pci-sysfs-kobject-kernel-doc-fixes.patch
ueagle-atmc-needs-schedh.patch
kernel-doc-include-struct-short-description-in-title.patch
tty-use-null-for-ptrs.patch
irq-kernel-doc-fixes.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
cdrom-use-unsigned-bitfields.patch
