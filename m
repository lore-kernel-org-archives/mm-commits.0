From: akpm@linux-foundation.org
Subject: - ppa-coding-police-and-printk-levels.patch removed from -mm tree
Date: Mon, 16 Jul 2007 14:00:22 -0700
Message-ID: <200707162100.l6GL0M76002593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59567 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759258AbXGPVQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:16:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ppa: coding police and printk levels
has been removed from the -mm tree.  Its filename was
     ppa-coding-police-and-printk-levels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ppa: coding police and printk levels
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Add printk levels
Clean up some oddities of formatting
Fix goto labels

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ppa.c |   57 ++++++++++++++++++++-----------------------
 1 files changed, 27 insertions(+), 30 deletions(-)

diff -puN drivers/scsi/ppa.c~ppa-coding-police-and-printk-levels drivers/scsi/ppa.c
--- a/drivers/scsi/ppa.c~ppa-coding-police-and-printk-levels
+++ a/drivers/scsi/ppa.c
@@ -129,11 +129,11 @@ static inline int ppa_proc_write(ppa_str
 	if ((length > 10) && (strncmp(buffer, "recon_tmo=", 10) == 0)) {
 		x = simple_strtoul(buffer + 10, NULL, 0);
 		dev->recon_tmo = x;
-		printk("ppa: recon_tmo set to %ld\n", x);
+		printk(KERN_INFO "ppa: recon_tmo set to %ld\n", x);
 		return length;
 	}
-	printk("ppa /proc: invalid variable\n");
-	return (-EINVAL);
+	printk(KERN_WARNING "ppa /proc: invalid variable\n");
+	return -EINVAL;
 }
 
 static int ppa_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length, int inout)
@@ -216,7 +216,7 @@ static unsigned char ppa_wait(ppa_struct
 
 	/* Counter expired - Time out occurred */
 	ppa_fail(dev, DID_TIME_OUT);
-	printk("ppa timeout in ppa_wait\n");
+	printk(KERN_WARNING "ppa timeout in ppa_wait\n");
 	return 0;		/* command timed out */
 }
 
@@ -248,7 +248,7 @@ static inline void ecp_sync(ppa_struct *
 				return;
 			udelay(5);
 		}
-		printk("ppa: ECP sync failed as data still present in FIFO.\n");
+		printk(KERN_WARNING "ppa: ECP sync failed as data still present in FIFO.\n");
 	}
 }
 
@@ -328,7 +328,7 @@ static int ppa_out(ppa_struct *dev, char
 		break;
 
 	default:
-		printk("PPA: bug in ppa_out()\n");
+		printk(KERN_ERR "PPA: bug in ppa_out()\n");
 		r = 0;
 	}
 	return r;
@@ -381,7 +381,7 @@ static int ppa_in(ppa_struct *dev, char 
 		break;
 
 	default:
-		printk("PPA: bug in ppa_ins()\n");
+		printk(KERN_ERR "PPA: bug in ppa_ins()\n");
 		r = 0;
 		break;
 	}
@@ -633,7 +633,7 @@ static void ppa_interrupt(struct work_st
 	struct scsi_cmnd *cmd = dev->cur_cmd;
 
 	if (!cmd) {
-		printk("PPA: bug in ppa_interrupt\n");
+		printk(KERN_ERR "PPA: bug in ppa_interrupt\n");
 		return;
 	}
 	if (ppa_engine(dev, cmd)) {
@@ -646,31 +646,31 @@ static void ppa_interrupt(struct work_st
 	case DID_OK:
 		break;
 	case DID_NO_CONNECT:
-		printk("ppa: no device at SCSI ID %i\n", cmd->device->target);
+		printk(KERN_DEBUG "ppa: no device at SCSI ID %i\n", cmd->device->target);
 		break;
 	case DID_BUS_BUSY:
-		printk("ppa: BUS BUSY - EPP timeout detected\n");
+		printk(KERN_DEBUG "ppa: BUS BUSY - EPP timeout detected\n");
 		break;
 	case DID_TIME_OUT:
-		printk("ppa: unknown timeout\n");
+		printk(KERN_DEBUG "ppa: unknown timeout\n");
 		break;
 	case DID_ABORT:
-		printk("ppa: told to abort\n");
+		printk(KERN_DEBUG "ppa: told to abort\n");
 		break;
 	case DID_PARITY:
-		printk("ppa: parity error (???)\n");
+		printk(KERN_DEBUG "ppa: parity error (???)\n");
 		break;
 	case DID_ERROR:
-		printk("ppa: internal driver error\n");
+		printk(KERN_DEBUG "ppa: internal driver error\n");
 		break;
 	case DID_RESET:
-		printk("ppa: told to reset device\n");
+		printk(KERN_DEBUG "ppa: told to reset device\n");
 		break;
 	case DID_BAD_INTR:
-		printk("ppa: bad interrupt (???)\n");
+		printk(KERN_WARNING "ppa: bad interrupt (???)\n");
 		break;
 	default:
-		printk("ppa: bad return code (%02x)\n",
+		printk(KERN_WARNING "ppa: bad return code (%02x)\n",
 		       (cmd->result >> 16) & 0xff);
 	}
 #endif
@@ -724,8 +724,7 @@ static int ppa_engine(ppa_struct *dev, s
 
 			if (retv) {
 				if (time_after(jiffies, dev->jstart + (1 * HZ))) {
-					printk
-					    ("ppa: Parallel port cable is unplugged!!\n");
+					printk(KERN_ERR "ppa: Parallel port cable is unplugged.\n");
 					ppa_fail(dev, DID_BUS_BUSY);
 					return 0;
 				} else {
@@ -755,11 +754,9 @@ static int ppa_engine(ppa_struct *dev, s
 	case 4:		/* Phase 4 - Setup scatter/gather buffers */
 		if (cmd->use_sg) {
 			/* if many buffers are available, start filling the first */
-			cmd->SCp.buffer =
-			    (struct scatterlist *) cmd->request_buffer;
+			cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
 			cmd->SCp.this_residual = cmd->SCp.buffer->length;
-			cmd->SCp.ptr =
-			    page_address(cmd->SCp.buffer->page) +
+			cmd->SCp.ptr = page_address(cmd->SCp.buffer->page) +
 			    cmd->SCp.buffer->offset;
 		} else {
 			/* else fill the only available buffer */
@@ -800,7 +797,7 @@ static int ppa_engine(ppa_struct *dev, s
 		break;
 
 	default:
-		printk("ppa: Invalid scsi phase\n");
+		printk(KERN_ERR "ppa: Invalid scsi phase\n");
 	}
 	return 0;
 }
@@ -811,7 +808,7 @@ static int ppa_queuecommand(struct scsi_
 	ppa_struct *dev = ppa_dev(cmd->device->host);
 
 	if (dev->cur_cmd) {
-		printk("PPA: bug in ppa_queuecommand\n");
+		printk(KERN_ERR "PPA: bug in ppa_queuecommand\n");
 		return 0;
 	}
 	dev->failed = 0;
@@ -899,7 +896,7 @@ static int device_check(ppa_struct *dev)
 	/* This routine looks for a device and then attempts to use EPP
 	   to send a command. If all goes as planned then EPP is available. */
 
-	static char cmd[6] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
+	static u8 cmd[6] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 	int loop, old_mode, status, k, ppb = dev->base;
 	unsigned char l;
 
@@ -909,14 +906,14 @@ static int device_check(ppa_struct *dev)
 		if ((ppb & 0x0007) == 0x0000)
 			dev->mode = PPA_EPP_32;
 
-	      second_pass:
+second_pass:
 		ppa_connect(dev, CONNECT_EPP_MAYBE);
 		/* Select SCSI device */
 		if (!ppa_select(dev, loop)) {
 			ppa_disconnect(dev);
 			continue;
 		}
-		printk("ppa: Found device at ID %i, Attempting to use %s\n",
+		printk(KERN_INFO "ppa: Found device at ID %i, Attempting to use %s\n",
 		       loop, PPA_MODE_STRING[dev->mode]);
 
 		/* Send SCSI command */
@@ -965,7 +962,7 @@ static int device_check(ppa_struct *dev)
 			return -EIO;
 		}
 		ppa_disconnect(dev);
-		printk("ppa: Communication established with ID %i using %s\n",
+		printk(KERN_INFO "ppa: Communication established with ID %i using %s\n",
 		       loop, PPA_MODE_STRING[dev->mode]);
 		ppa_connect(dev, CONNECT_EPP_MAYBE);
 		ppa_reset_pulse(ppb);
@@ -1140,7 +1137,7 @@ static struct parport_driver ppa_driver 
 
 static int __init ppa_driver_init(void)
 {
-	printk("ppa: Version %s\n", PPA_VERSION);
+	printk(KERN_INFO "ppa: Version %s\n", PPA_VERSION);
 	return parport_register_driver(&ppa_driver);
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-powerpc.patch
git-ia64.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
ata-use-iomap_name.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
sb1250-duartc-sb1250-duart-serial-support.patch
mbcs-remove-lots-of-global-symbols.patch
i2o_cfg_passthru-cleanup.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
stallion-remove-unneeded-lock_kernel.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
drivers-edac-fix-edac_device-semaphore-to-mutex.patch
drivers-edac-fix-e752x-reversed-csrows.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-fix-leaf-sysfs-attribute.patch
drivers-edac-fix-edac_mc-init-apis.patch
drivers-edac-fix-edac_device-init-apis.patch
drivers-edac-fix-edac_mc-sysfs-completion-code.patch
drivers-edac-fix-edac_device-sysfs-completion-code.patch
