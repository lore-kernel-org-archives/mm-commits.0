From: akpm@linux-foundation.org
Subject: - ioc3c-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Mon, 17 Mar 2008 14:01:00 -0700
Message-ID: <200803172101.m2HL1064030906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757199AbYCQVB0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:01:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     ioc3.c: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     ioc3c-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ioc3.c: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/sn/ioc3.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/sn/ioc3.c~ioc3c-replace-remaining-__function__-occurrences drivers/sn/ioc3.c
--- a/drivers/sn/ioc3.c~ioc3c-replace-remaining-__function__-occurrences
+++ a/drivers/sn/ioc3.c
@@ -561,7 +561,7 @@ void ioc3_unregister_submodule(struct io
 					printk(KERN_WARNING
 					       "%s: IOC3 submodule %s remove failed "
 					       "for pci_dev %s.\n",
-					       __FUNCTION__, module_name(is->owner),
+					       __func__, module_name(is->owner),
 					       pci_name(idd->pdev));
 			idd->active[is->id] = 0;
 			if(is->irq_mask)
@@ -611,7 +611,7 @@ static int ioc3_probe(struct pci_dev *pd
 	if ((ret = pci_enable_device(pdev))) {
 		printk(KERN_WARNING
 		       "%s: Failed to enable IOC3 device for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(pdev));
+		       __func__, pci_name(pdev));
 		goto out;
 	}
 	pci_set_master(pdev);
@@ -623,7 +623,7 @@ static int ioc3_probe(struct pci_dev *pd
                 if (ret < 0) {
                         printk(KERN_WARNING "%s: Unable to obtain 64 bit DMA "
                                "for consistent allocations\n",
-				__FUNCTION__);
+				__func__);
                 }
 	}
 #endif
@@ -633,7 +633,7 @@ static int ioc3_probe(struct pci_dev *pd
 	if (!idd) {
 		printk(KERN_WARNING
 		       "%s: Failed to allocate IOC3 data for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(pdev));
+		       __func__, pci_name(pdev));
 		ret = -ENODEV;
 		goto out_idd;
 	}
@@ -649,7 +649,7 @@ static int ioc3_probe(struct pci_dev *pd
 		printk(KERN_WARNING
 		       "%s: Unable to find IOC3 resource "
 		       "for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(pdev));
+		       __func__, pci_name(pdev));
 		ret = -ENODEV;
 		goto out_pci;
 	}
@@ -657,7 +657,7 @@ static int ioc3_probe(struct pci_dev *pd
 		printk(KERN_WARNING
 		       "%s: Unable to request IOC3 region "
 		       "for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(pdev));
+		       __func__, pci_name(pdev));
 		ret = -ENODEV;
 		goto out_pci;
 	}
@@ -666,7 +666,7 @@ static int ioc3_probe(struct pci_dev *pd
 		printk(KERN_WARNING
 		       "%s: Unable to remap IOC3 region "
 		       "for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(pdev));
+		       __func__, pci_name(pdev));
 		ret = -ENODEV;
 		goto out_misc_region;
 	}
@@ -709,7 +709,7 @@ static int ioc3_probe(struct pci_dev *pd
 		} else {
 			printk(KERN_WARNING
 			       "%s : request_irq fails for IRQ 0x%x\n ",
-			       __FUNCTION__, pdev->irq);
+			       __func__, pdev->irq);
 		}
 		if (!request_irq(pdev->irq+2, ioc3_intr_io, IRQF_SHARED,
 				 "ioc3-io", (void *)idd)) {
@@ -717,7 +717,7 @@ static int ioc3_probe(struct pci_dev *pd
 		} else {
 			printk(KERN_WARNING
 			       "%s : request_irq fails for IRQ 0x%x\n ",
-			       __FUNCTION__, pdev->irq+2);
+			       __func__, pdev->irq+2);
 		}
 	} else {
 		if (!request_irq(pdev->irq, ioc3_intr_io, IRQF_SHARED,
@@ -726,7 +726,7 @@ static int ioc3_probe(struct pci_dev *pd
 		} else {
 			printk(KERN_WARNING
 			       "%s : request_irq fails for IRQ 0x%x\n ",
-			       __FUNCTION__, pdev->irq);
+			       __func__, pdev->irq);
 		}
 	}
 
@@ -769,7 +769,7 @@ static void ioc3_remove(struct pci_dev *
 					printk(KERN_WARNING
 					       "%s: IOC3 submodule 0x%s remove failed "
 					       "for pci_dev %s.\n",
-					        __FUNCTION__,
+						__func__,
 						module_name(ioc3_submodules[id]->owner),
 					        pci_name(pdev));
 			idd->active[id] = 0;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa-tiwai.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
git-cifs.patch
cifs-remove-global_extern-macro.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
git-ieee1394.patch
git-infiniband.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
git-async-tx.patch
git-mips.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
git-net.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
power-replace-remaining-__function__-occurrences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
ext2-replace-remaining-__function__-occurrences.patch
jbd-sparse-warnings-in-revokec-journalc.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

