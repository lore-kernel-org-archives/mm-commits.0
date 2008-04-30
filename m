From: akpm@linux-foundation.org
Subject: - drivers-misc-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:26 -0700
Message-ID: <200804300540.m3U5eQdg028963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754785AbYD3Fk6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     drivers-misc-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
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

