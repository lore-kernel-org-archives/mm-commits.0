From: akpm@linux-foundation.org
Subject: + drivers-misc-replace-remaining-__function__-occurrences.patch added to -mm tree
Date: Wed, 05 Mar 2008 19:50:11 -0800
Message-ID: <200803060350.m263oBkZ007335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039AbYCFD6R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 22:58:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     drivers/misc: replace remaining __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     drivers-misc-replace-remaining-__function__-occurrences.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ibmasm/command.c   |    6 +++---
 drivers/misc/ibmasm/heartbeat.c |    6 +++---
 drivers/misc/ioc4.c             |   20 ++++++++++----------
 drivers/misc/sony-laptop.c      |    4 ++--
 4 files changed, 18 insertions(+), 18 deletions(-)

diff -puN drivers/misc/ibmasm/command.c~drivers-misc-replace-remaining-__function__-occurrences drivers/misc/ibmasm/command.c
--- a/drivers/misc/ibmasm/command.c~drivers-misc-replace-remaining-__function__-occurrences
+++ a/drivers/misc/ibmasm/command.c
@@ -96,7 +96,7 @@ static inline void do_exec_command(struc
 {
 	char tsbuf[32];
 
-	dbg("%s:%d at %s\n", __FUNCTION__, __LINE__, get_timestamp(tsbuf));
+	dbg("%s:%d at %s\n", __func__, __LINE__, get_timestamp(tsbuf));
 
 	if (ibmasm_send_i2o_message(sp)) {
 		sp->current_command->status = IBMASM_CMD_FAILED;
@@ -119,7 +119,7 @@ void ibmasm_exec_command(struct service_
 	unsigned long flags;
 	char tsbuf[32];
 
-	dbg("%s:%d at %s\n", __FUNCTION__, __LINE__, get_timestamp(tsbuf));
+	dbg("%s:%d at %s\n", __func__, __LINE__, get_timestamp(tsbuf));
 
 	spin_lock_irqsave(&sp->lock, flags);
 
@@ -139,7 +139,7 @@ static void exec_next_command(struct ser
 	unsigned long flags;
 	char tsbuf[32];
 
-	dbg("%s:%d at %s\n", __FUNCTION__, __LINE__, get_timestamp(tsbuf));
+	dbg("%s:%d at %s\n", __func__, __LINE__, get_timestamp(tsbuf));
 
 	spin_lock_irqsave(&sp->lock, flags);
 	sp->current_command = dequeue_command(sp);
diff -puN drivers/misc/ibmasm/heartbeat.c~drivers-misc-replace-remaining-__function__-occurrences drivers/misc/ibmasm/heartbeat.c
--- a/drivers/misc/ibmasm/heartbeat.c~drivers-misc-replace-remaining-__function__-occurrences
+++ a/drivers/misc/ibmasm/heartbeat.c
@@ -75,9 +75,9 @@ void ibmasm_heartbeat_exit(struct servic
 {
 	char tsbuf[32];
 
-	dbg("%s:%d at %s\n", __FUNCTION__, __LINE__, get_timestamp(tsbuf));
+	dbg("%s:%d at %s\n", __func__, __LINE__, get_timestamp(tsbuf));
 	ibmasm_wait_for_response(sp->heartbeat, IBMASM_CMD_TIMEOUT_NORMAL);
-	dbg("%s:%d at %s\n", __FUNCTION__, __LINE__, get_timestamp(tsbuf));
+	dbg("%s:%d at %s\n", __func__, __LINE__, get_timestamp(tsbuf));
 	suspend_heartbeats = 1;
 	command_put(sp->heartbeat);
 }
@@ -88,7 +88,7 @@ void ibmasm_receive_heartbeat(struct ser
 	struct dot_command_header *header = (struct dot_command_header *)cmd->buffer;
 	char tsbuf[32];
 
-	dbg("%s:%d at %s\n", __FUNCTION__, __LINE__, get_timestamp(tsbuf));
+	dbg("%s:%d at %s\n", __func__, __LINE__, get_timestamp(tsbuf));
 	if (suspend_heartbeats)
 		return;
 
diff -puN drivers/misc/ioc4.c~drivers-misc-replace-remaining-__function__-occurrences drivers/misc/ioc4.c
--- a/drivers/misc/ioc4.c~drivers-misc-replace-remaining-__function__-occurrences
+++ a/drivers/misc/ioc4.c
@@ -75,7 +75,7 @@ ioc4_register_submodule(struct ioc4_subm
 			printk(KERN_WARNING
 			       "%s: IOC4 submodule %s probe failed "
 			       "for pci_dev %s",
-			       __FUNCTION__, module_name(is->is_owner),
+			       __func__, module_name(is->is_owner),
 			       pci_name(idd->idd_pdev));
 		}
 	}
@@ -102,7 +102,7 @@ ioc4_unregister_submodule(struct ioc4_su
 			printk(KERN_WARNING
 			       "%s: IOC4 submodule %s remove failed "
 			       "for pci_dev %s.\n",
-			       __FUNCTION__, module_name(is->is_owner),
+			       __func__, module_name(is->is_owner),
 			       pci_name(idd->idd_pdev));
 		}
 	}
@@ -282,7 +282,7 @@ ioc4_probe(struct pci_dev *pdev, const s
 	if ((ret = pci_enable_device(pdev))) {
 		printk(KERN_WARNING
 		       "%s: Failed to enable IOC4 device for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(pdev));
+		       __func__, pci_name(pdev));
 		goto out;
 	}
 	pci_set_master(pdev);
@@ -292,7 +292,7 @@ ioc4_probe(struct pci_dev *pdev, const s
 	if (!idd) {
 		printk(KERN_WARNING
 		       "%s: Failed to allocate IOC4 data for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(pdev));
+		       __func__, pci_name(pdev));
 		ret = -ENODEV;
 		goto out_idd;
 	}
@@ -307,7 +307,7 @@ ioc4_probe(struct pci_dev *pdev, const s
 		printk(KERN_WARNING
 		       "%s: Unable to find IOC4 misc resource "
 		       "for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(idd->idd_pdev));
+		       __func__, pci_name(idd->idd_pdev));
 		ret = -ENODEV;
 		goto out_pci;
 	}
@@ -316,7 +316,7 @@ ioc4_probe(struct pci_dev *pdev, const s
 		printk(KERN_WARNING
 		       "%s: Unable to request IOC4 misc region "
 		       "for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(idd->idd_pdev));
+		       __func__, pci_name(idd->idd_pdev));
 		ret = -ENODEV;
 		goto out_pci;
 	}
@@ -326,7 +326,7 @@ ioc4_probe(struct pci_dev *pdev, const s
 		printk(KERN_WARNING
 		       "%s: Unable to remap IOC4 misc region "
 		       "for pci_dev %s.\n",
-		       __FUNCTION__, pci_name(idd->idd_pdev));
+		       __func__, pci_name(idd->idd_pdev));
 		ret = -ENODEV;
 		goto out_misc_region;
 	}
@@ -372,7 +372,7 @@ ioc4_probe(struct pci_dev *pdev, const s
 			printk(KERN_WARNING
 			       "%s: IOC4 submodule 0x%s probe failed "
 			       "for pci_dev %s.\n",
-			       __FUNCTION__, module_name(is->is_owner),
+			       __func__, module_name(is->is_owner),
 			       pci_name(idd->idd_pdev));
 		}
 	}
@@ -406,7 +406,7 @@ ioc4_remove(struct pci_dev *pdev)
 			printk(KERN_WARNING
 			       "%s: IOC4 submodule 0x%s remove failed "
 			       "for pci_dev %s.\n",
-			       __FUNCTION__, module_name(is->is_owner),
+			       __func__, module_name(is->is_owner),
 			       pci_name(idd->idd_pdev));
 		}
 	}
@@ -418,7 +418,7 @@ ioc4_remove(struct pci_dev *pdev)
 		printk(KERN_WARNING
 		       "%s: Unable to get IOC4 misc mapping for pci_dev %s. "
 		       "Device removal may be incomplete.\n",
-		       __FUNCTION__, pci_name(idd->idd_pdev));
+		       __func__, pci_name(idd->idd_pdev));
 	}
 	release_mem_region(idd->idd_bar0, sizeof(struct ioc4_misc_regs));
 
diff -puN drivers/misc/sony-laptop.c~drivers-misc-replace-remaining-__function__-occurrences drivers/misc/sony-laptop.c
--- a/drivers/misc/sony-laptop.c~drivers-misc-replace-remaining-__function__-occurrences
+++ a/drivers/misc/sony-laptop.c
@@ -961,7 +961,7 @@ static int sony_nc_resume(struct acpi_de
 		ret = acpi_callsetfunc(sony_nc_acpi_handle, *item->acpiset,
 				       item->value, NULL);
 		if (ret < 0) {
-			printk("%s: %d\n", __FUNCTION__, ret);
+			printk("%s: %d\n", __func__, ret);
 			break;
 		}
 	}
@@ -1453,7 +1453,7 @@ static struct sonypi_eventtypes type4_ev
 		udelay(1);						\
 	if (!n)								\
 		dprintk("command failed at %s : %s (line %d)\n",	\
-				__FILE__, __FUNCTION__, __LINE__);	\
+				__FILE__, __func__, __LINE__);	\
 }
 
 static u8 sony_pic_call1(u8 dev)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
cifs-replace-remaining-__function__-occurrences.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
drivers-base-replace-remaining-__function__-occurrences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
jfs-replace-__inline-with-inline.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
mips-replace-__inline-with-inline.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
net-replace-__inline-with-inline.patch
irda-replace-__inline-with-inline.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
sh-replace-remaining-__function__-occurences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-stc-make-class-attributes-static.patch
scsi-osstc-make-class-attributes-static.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
isdn-replace-__inline-with-inline.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
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
security-replace-remaining-__function__-occurences.patch
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch
acpi-replace-remaining-__function__-occurrences.patch
ata-replace-remaining-__function__-occurrences.patch
block-replace-remaining-__function__-occurrences.patch
iop-admac-replace-remaining-__function__-occurrences.patch
ieee1394-replace-remaining-__function__-occurrences.patch
firmware-replace-remaining-__function__-occurrences.patch
mtd-replace-remaining-__function__-occurrences.patch
md-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
ioc3c-replace-remaining-__function__-occurrences.patch
watchdog-replace-remaining-__function__-occurrences.patch
spi-replace-remaining-__function__-occurrences.patch
power-replace-remaining-__function__-occurrences.patch
drivers-replace-remaining-__function__-occurrences.patch

