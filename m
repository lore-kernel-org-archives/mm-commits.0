From: akpm@linux-foundation.org
Subject: + intel_scu_ipc-remove-moorestown-support.patch added to -mm tree
Date: Mon, 06 Feb 2012 13:01:04 -0800
Message-ID: <20120206210104.EEEC4A016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:36779 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2BFVBI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 16:01:08 -0500
Received: by faaa19 with SMTP id a19so210542faa.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 13:01:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, hpa@zytor.com, mingo@elte.hu, mjg@redhat.com, tglx@linutronix.de


The patch titled
     Subject: intel_scu_ipc: remove Moorestown support
has been added to the -mm tree.  Its filename is
     intel_scu_ipc-remove-moorestown-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: intel_scu_ipc: remove Moorestown support

All the production devices use the PC compatible version of this device so
don't use the SCU interfaces or the SCU firmware interfaces.

Delete lots of code and conditional paths

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/intel_scu_ipc.c     |  210 ++-------------------
 drivers/platform/x86/intel_scu_ipcutil.c |   32 ---
 2 files changed, 31 insertions(+), 211 deletions(-)

diff -puN drivers/platform/x86/intel_scu_ipc.c~intel_scu_ipc-remove-moorestown-support drivers/platform/x86/intel_scu_ipc.c
--- a/drivers/platform/x86/intel_scu_ipc.c~intel_scu_ipc-remove-moorestown-support
+++ a/drivers/platform/x86/intel_scu_ipc.c
@@ -159,7 +159,7 @@ static inline int busy_loop(void) /* Wai
 /* Read/Write power control(PMIC in Langwell, MSIC in PenWell) registers */
 static int pwr_reg_rdwr(u16 *addr, u8 *data, u32 count, u32 op, u32 id)
 {
-	int i, nc, bytes, d;
+	int nc;
 	u32 offset = 0;
 	int err;
 	u8 cbuf[IPC_WWBUF_SIZE] = { };
@@ -174,55 +174,34 @@ static int pwr_reg_rdwr(u16 *addr, u8 *d
 		return -ENODEV;
 	}
 
-	if (platform != MRST_CPU_CHIP_PENWELL) {
-		bytes = 0;
-		d = 0;
-		for (i = 0; i < count; i++) {
-			cbuf[bytes++] = addr[i];
-			cbuf[bytes++] = addr[i] >> 8;
-			if (id != IPC_CMD_PCNTRL_R)
-				cbuf[bytes++] = data[d++];
-			if (id == IPC_CMD_PCNTRL_M)
-				cbuf[bytes++] = data[d++];
-		}
-		for (i = 0; i < bytes; i += 4)
-			ipc_data_writel(wbuf[i/4], i);
-		ipc_command(bytes << 16 |  id << 12 | 0 << 8 | op);
-	} else {
-		for (nc = 0; nc < count; nc++, offset += 2) {
-			cbuf[offset] = addr[nc];
-			cbuf[offset + 1] = addr[nc] >> 8;
-		}
-
-		if (id == IPC_CMD_PCNTRL_R) {
-			for (nc = 0, offset = 0; nc < count; nc++, offset += 4)
-				ipc_data_writel(wbuf[nc], offset);
-			ipc_command((count*2) << 16 |  id << 12 | 0 << 8 | op);
-		} else if (id == IPC_CMD_PCNTRL_W) {
-			for (nc = 0; nc < count; nc++, offset += 1)
-				cbuf[offset] = data[nc];
-			for (nc = 0, offset = 0; nc < count; nc++, offset += 4)
-				ipc_data_writel(wbuf[nc], offset);
-			ipc_command((count*3) << 16 |  id << 12 | 0 << 8 | op);
-		} else if (id == IPC_CMD_PCNTRL_M) {
-			cbuf[offset] = data[0];
-			cbuf[offset + 1] = data[1];
-			ipc_data_writel(wbuf[0], 0); /* Write wbuff */
-			ipc_command(4 << 16 |  id << 12 | 0 << 8 | op);
-		}
+	for (nc = 0; nc < count; nc++, offset += 2) {
+		cbuf[offset] = addr[nc];
+		cbuf[offset + 1] = addr[nc] >> 8;
+	}
+
+	if (id == IPC_CMD_PCNTRL_R) {
+		for (nc = 0, offset = 0; nc < count; nc++, offset += 4)
+			ipc_data_writel(wbuf[nc], offset);
+		ipc_command((count*2) << 16 |  id << 12 | 0 << 8 | op);
+	} else if (id == IPC_CMD_PCNTRL_W) {
+		for (nc = 0; nc < count; nc++, offset += 1)
+			cbuf[offset] = data[nc];
+		for (nc = 0, offset = 0; nc < count; nc++, offset += 4)
+			ipc_data_writel(wbuf[nc], offset);
+		ipc_command((count*3) << 16 |  id << 12 | 0 << 8 | op);
+	} else if (id == IPC_CMD_PCNTRL_M) {
+		cbuf[offset] = data[0];
+		cbuf[offset + 1] = data[1];
+		ipc_data_writel(wbuf[0], 0); /* Write wbuff */
+		ipc_command(4 << 16 |  id << 12 | 0 << 8 | op);
 	}
 
 	err = busy_loop();
 	if (id == IPC_CMD_PCNTRL_R) { /* Read rbuf */
 		/* Workaround: values are read as 0 without memcpy_fromio */
 		memcpy_fromio(cbuf, ipcdev.ipc_base + 0x90, 16);
-		if (platform != MRST_CPU_CHIP_PENWELL) {
-			for (nc = 0, offset = 2; nc < count; nc++, offset += 3)
-				data[nc] = ipc_data_readb(offset);
-		} else {
-			for (nc = 0; nc < count; nc++)
-				data[nc] = ipc_data_readb(nc);
-		}
+		for (nc = 0; nc < count; nc++)
+			data[nc] = ipc_data_readb(nc);
 	}
 	mutex_unlock(&ipclock);
 	return err;
@@ -503,148 +482,6 @@ int intel_scu_ipc_i2c_cntrl(u32 addr, u3
 }
 EXPORT_SYMBOL(intel_scu_ipc_i2c_cntrl);
 
-#define IPC_FW_LOAD_ADDR 0xFFFC0000 /* Storage location for FW image */
-#define IPC_FW_UPDATE_MBOX_ADDR 0xFFFFDFF4 /* Mailbox between ipc and scu */
-#define IPC_MAX_FW_SIZE 262144 /* 256K storage size for loading the FW image */
-#define IPC_FW_MIP_HEADER_SIZE 2048 /* Firmware MIP header size */
-/* IPC inform SCU to get ready for update process */
-#define IPC_CMD_FW_UPDATE_READY  0x10FE
-/* IPC inform SCU to go for update process */
-#define IPC_CMD_FW_UPDATE_GO     0x20FE
-/* Status code for fw update */
-#define IPC_FW_UPDATE_SUCCESS	0x444f4e45 /* Status code 'DONE' */
-#define IPC_FW_UPDATE_BADN	0x4241444E /* Status code 'BADN' */
-#define IPC_FW_TXHIGH		0x54784849 /* Status code 'IPC_FW_TXHIGH' */
-#define IPC_FW_TXLOW		0x54784c4f /* Status code 'IPC_FW_TXLOW' */
-
-struct fw_update_mailbox {
-	u32    status;
-	u32    scu_flag;
-	u32    driver_flag;
-};
-
-
-/**
- *	intel_scu_ipc_fw_update	-	 Firmware update utility
- *	@buffer: firmware buffer
- *	@length: size of firmware buffer
- *
- *	This function provides an interface to load the firmware into
- *	the SCU. Returns 0 on success or -1 on failure
- */
-int intel_scu_ipc_fw_update(u8 *buffer, u32 length)
-{
-	void __iomem *fw_update_base;
-	struct fw_update_mailbox __iomem *mailbox = NULL;
-	int retry_cnt = 0;
-	u32 status;
-
-	mutex_lock(&ipclock);
-	fw_update_base = ioremap_nocache(IPC_FW_LOAD_ADDR, (128*1024));
-	if (fw_update_base == NULL) {
-		mutex_unlock(&ipclock);
-		return -ENOMEM;
-	}
-	mailbox = ioremap_nocache(IPC_FW_UPDATE_MBOX_ADDR,
-					sizeof(struct fw_update_mailbox));
-	if (mailbox == NULL) {
-		iounmap(fw_update_base);
-		mutex_unlock(&ipclock);
-		return -ENOMEM;
-	}
-
-	ipc_command(IPC_CMD_FW_UPDATE_READY);
-
-	/* Intitialize mailbox */
-	writel(0, &mailbox->status);
-	writel(0, &mailbox->scu_flag);
-	writel(0, &mailbox->driver_flag);
-
-	/* Driver copies the 2KB MIP header to SRAM at 0xFFFC0000*/
-	memcpy_toio(fw_update_base, buffer, 0x800);
-
-	/* Driver sends "FW Update" IPC command (CMD_ID 0xFE; MSG_ID 0x02).
-	* Upon receiving this command, SCU will write the 2K MIP header
-	* from 0xFFFC0000 into NAND.
-	* SCU will write a status code into the Mailbox, and then set scu_flag.
-	*/
-
-	ipc_command(IPC_CMD_FW_UPDATE_GO);
-
-	/*Driver stalls until scu_flag is set */
-	while (readl(&mailbox->scu_flag) != 1) {
-		rmb();
-		mdelay(1);
-	}
-
-	/* Driver checks Mailbox status.
-	 * If the status is 'BADN', then abort (bad NAND).
-	 * If the status is 'IPC_FW_TXLOW', then continue.
-	 */
-	while (readl(&mailbox->status) != IPC_FW_TXLOW) {
-		rmb();
-		mdelay(10);
-	}
-	mdelay(10);
-
-update_retry:
-	if (retry_cnt > 5)
-		goto update_end;
-
-	if (readl(&mailbox->status) != IPC_FW_TXLOW)
-		goto update_end;
-	buffer = buffer + 0x800;
-	memcpy_toio(fw_update_base, buffer, 0x20000);
-	writel(1, &mailbox->driver_flag);
-	while (readl(&mailbox->scu_flag) == 1) {
-		rmb();
-		mdelay(1);
-	}
-
-	/* check for 'BADN' */
-	if (readl(&mailbox->status) == IPC_FW_UPDATE_BADN)
-		goto update_end;
-
-	while (readl(&mailbox->status) != IPC_FW_TXHIGH) {
-		rmb();
-		mdelay(10);
-	}
-	mdelay(10);
-
-	if (readl(&mailbox->status) != IPC_FW_TXHIGH)
-		goto update_end;
-
-	buffer = buffer + 0x20000;
-	memcpy_toio(fw_update_base, buffer, 0x20000);
-	writel(0, &mailbox->driver_flag);
-
-	while (mailbox->scu_flag == 0) {
-		rmb();
-		mdelay(1);
-	}
-
-	/* check for 'BADN' */
-	if (readl(&mailbox->status) == IPC_FW_UPDATE_BADN)
-		goto update_end;
-
-	if (readl(&mailbox->status) == IPC_FW_TXLOW) {
-		++retry_cnt;
-		goto update_retry;
-	}
-
-update_end:
-	status = readl(&mailbox->status);
-
-	iounmap(fw_update_base);
-	iounmap(mailbox);
-	mutex_unlock(&ipclock);
-
-	if (status == IPC_FW_UPDATE_SUCCESS)
-		return 0;
-	return -EIO;
-}
-EXPORT_SYMBOL(intel_scu_ipc_fw_update);
-
 /*
  * Interrupt handler gets called when ioc bit of IPC_COMMAND_REG set to 1
  * When ioc bit is set to 1, caller api must wait for interrupt handler called
@@ -727,7 +564,6 @@ static void ipc_remove(struct pci_dev *p
 }
 
 static DEFINE_PCI_DEVICE_TABLE(pci_ids) = {
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080e)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x082a)},
 	{ 0,}
 };
diff -puN drivers/platform/x86/intel_scu_ipcutil.c~intel_scu_ipc-remove-moorestown-support drivers/platform/x86/intel_scu_ipcutil.c
--- a/drivers/platform/x86/intel_scu_ipcutil.c~intel_scu_ipc-remove-moorestown-support
+++ a/drivers/platform/x86/intel_scu_ipcutil.c
@@ -26,13 +26,10 @@
 
 static int major;
 
-#define MAX_FW_SIZE 264192
-
 /* ioctl commnds */
 #define	INTE_SCU_IPC_REGISTER_READ	0
 #define INTE_SCU_IPC_REGISTER_WRITE	1
 #define INTE_SCU_IPC_REGISTER_UPDATE	2
-#define INTE_SCU_IPC_FW_UPDATE		0xA2
 
 struct scu_ipc_data {
 	u32     count;  /* No. of registers */
@@ -88,27 +85,14 @@ static long scu_ipc_ioctl(struct file *f
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
-	if (cmd == INTE_SCU_IPC_FW_UPDATE) {
-			u8 *fwbuf = kmalloc(MAX_FW_SIZE, GFP_KERNEL);
-			if (fwbuf == NULL)
-				return -ENOMEM;
-			if (copy_from_user(fwbuf, (u8 *)arg, MAX_FW_SIZE)) {
-				kfree(fwbuf);
-				return -EFAULT;
-			}
-			ret = intel_scu_ipc_fw_update(fwbuf, MAX_FW_SIZE);
-			kfree(fwbuf);
-			return ret;
-	} else {
-		if (copy_from_user(&data, argp, sizeof(struct scu_ipc_data)))
-			return -EFAULT;
-		ret = scu_reg_access(cmd, &data);
-		if (ret < 0)
-			return ret;
-		if (copy_to_user(argp, &data, sizeof(struct scu_ipc_data)))
-			return -EFAULT;
-		return 0;
-	}
+	if (copy_from_user(&data, argp, sizeof(struct scu_ipc_data)))
+		return -EFAULT;
+	ret = scu_reg_access(cmd, &data);
+	if (ret < 0)
+		return ret;
+	if (copy_to_user(argp, &data, sizeof(struct scu_ipc_data)))
+		return -EFAULT;
+	return 0;
 }
 
 static const struct file_operations scu_ipc_fops = {
_
Subject: Subject: intel_scu_ipc: remove Moorestown support

Patches currently in -mm which might be from alan@linux.intel.com are

linux-next.patch
platform-x86-kill-off-moorestown.patch
intel_scu_ipc-remove-moorestown-support.patch
platform-x86-intel_mid_thermal-add-msic_thermal-alias.patch
platform-x86-intel_mid_thermal-convert-to-use-intel-msic-api.patch
platform-x86-intel_mid_thermal-turn-off-thermistor-voltage-by-default.patch
intel_mid_powerbtn-use-msic-read-write-instead-of-ipc_scu.patch
intel_mid_powerbtn-mark-irq-as-irqf_no_suspend.patch

