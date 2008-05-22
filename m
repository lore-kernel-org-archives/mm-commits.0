From: akpm@linux-foundation.org
Subject: + dac960-push-down-bkl.patch added to -mm tree
Date: Thu, 22 May 2008 16:16:11 -0700
Message-ID: <200805222316.m4MNGB9k026589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757560AbYEVXR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:17:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jens.axboe@oracle.com, ricknu-0@student.ltu.se


The patch titled
     DAC960: push down BKL
has been added to the -mm tree.  Its filename is
     dac960-push-down-bkl.patch

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
Subject: DAC960: push down BKL
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/DAC960.c |  157 +++++++++++++++++++++++++--------------
 1 file changed, 101 insertions(+), 56 deletions(-)

diff -puN drivers/block/DAC960.c~dac960-push-down-bkl drivers/block/DAC960.c
--- a/drivers/block/DAC960.c~dac960-push-down-bkl
+++ a/drivers/block/DAC960.c
@@ -6628,15 +6628,18 @@ static void DAC960_DestroyProcEntries(DA
  * DAC960_gam_ioctl is the ioctl function for performing RAID operations.
 */
 
-static int DAC960_gam_ioctl(struct inode *inode, struct file *file,
-			    unsigned int Request, unsigned long Argument)
+static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
+						unsigned long Argument)
 {
-  int ErrorCode = 0;
+  long ErrorCode = 0;
   if (!capable(CAP_SYS_ADMIN)) return -EACCES;
+
+  lock_kernel();
   switch (Request)
     {
     case DAC960_IOCTL_GET_CONTROLLER_COUNT:
-      return DAC960_ControllerCount;
+      ErrorCode = DAC960_ControllerCount;
+      break;
     case DAC960_IOCTL_GET_CONTROLLER_INFO:
       {
 	DAC960_ControllerInfo_T __user *UserSpaceControllerInfo =
@@ -6644,15 +6647,20 @@ static int DAC960_gam_ioctl(struct inode
 	DAC960_ControllerInfo_T ControllerInfo;
 	DAC960_Controller_T *Controller;
 	int ControllerNumber;
-	if (UserSpaceControllerInfo == NULL) return -EINVAL;
-	ErrorCode = get_user(ControllerNumber,
+	if (UserSpaceControllerInfo == NULL)
+		ErrorCode = -EINVAL;
+	else ErrorCode = get_user(ControllerNumber,
 			     &UserSpaceControllerInfo->ControllerNumber);
-	if (ErrorCode != 0) return ErrorCode;
+	if (ErrorCode != 0)
+		break;;
+	ErrorCode = -ENXIO;
 	if (ControllerNumber < 0 ||
-	    ControllerNumber > DAC960_ControllerCount - 1)
-	  return -ENXIO;
+	    ControllerNumber > DAC960_ControllerCount - 1) {
+	  break;
+	}
 	Controller = DAC960_Controllers[ControllerNumber];
-	if (Controller == NULL) return -ENXIO;
+	if (Controller == NULL)
+		break;;
 	memset(&ControllerInfo, 0, sizeof(DAC960_ControllerInfo_T));
 	ControllerInfo.ControllerNumber = ControllerNumber;
 	ControllerInfo.FirmwareType = Controller->FirmwareType;
@@ -6665,8 +6673,9 @@ static int DAC960_gam_ioctl(struct inode
 	ControllerInfo.PCI_Address = Controller->PCI_Address;
 	strcpy(ControllerInfo.ModelName, Controller->ModelName);
 	strcpy(ControllerInfo.FirmwareVersion, Controller->FirmwareVersion);
-	return (copy_to_user(UserSpaceControllerInfo, &ControllerInfo,
+	ErrorCode = (copy_to_user(UserSpaceControllerInfo, &ControllerInfo,
 			     sizeof(DAC960_ControllerInfo_T)) ? -EFAULT : 0);
+	break;
       }
     case DAC960_IOCTL_V1_EXECUTE_COMMAND:
       {
@@ -6684,30 +6693,39 @@ static int DAC960_gam_ioctl(struct inode
 	int ControllerNumber, DataTransferLength;
 	unsigned char *DataTransferBuffer = NULL;
 	dma_addr_t DataTransferBufferDMA;
-	if (UserSpaceUserCommand == NULL) return -EINVAL;
+	if (UserSpaceUserCommand == NULL) {
+		ErrorCode = -EINVAL;
+		break;
+	}
 	if (copy_from_user(&UserCommand, UserSpaceUserCommand,
 				   sizeof(DAC960_V1_UserCommand_T))) {
 		ErrorCode = -EFAULT;
-		goto Failure1a;
+		break;
 	}
 	ControllerNumber = UserCommand.ControllerNumber;
+    	ErrorCode = -ENXIO;
 	if (ControllerNumber < 0 ||
 	    ControllerNumber > DAC960_ControllerCount - 1)
-	  return -ENXIO;
+	    	break;
 	Controller = DAC960_Controllers[ControllerNumber];
-	if (Controller == NULL) return -ENXIO;
-	if (Controller->FirmwareType != DAC960_V1_Controller) return -EINVAL;
+	if (Controller == NULL)
+		break;
+	ErrorCode = -EINVAL;
+	if (Controller->FirmwareType != DAC960_V1_Controller)
+		break;
 	CommandOpcode = UserCommand.CommandMailbox.Common.CommandOpcode;
 	DataTransferLength = UserCommand.DataTransferLength;
-	if (CommandOpcode & 0x80) return -EINVAL;
+	if (CommandOpcode & 0x80)
+		break;
 	if (CommandOpcode == DAC960_V1_DCDB)
 	  {
 	    if (copy_from_user(&DCDB, UserCommand.DCDB,
 			       sizeof(DAC960_V1_DCDB_T))) {
 		ErrorCode = -EFAULT;
-		goto Failure1a;
+		break;
 	    }
-	    if (DCDB.Channel >= DAC960_V1_MaxChannels) return -EINVAL;
+	    if (DCDB.Channel >= DAC960_V1_MaxChannels)
+	    		break;
 	    if (!((DataTransferLength == 0 &&
 		   DCDB.Direction
 		   == DAC960_V1_DCDB_NoDataTransfer) ||
@@ -6717,38 +6735,37 @@ static int DAC960_gam_ioctl(struct inode
 		  (DataTransferLength < 0 &&
 		   DCDB.Direction
 		   == DAC960_V1_DCDB_DataTransferSystemToDevice)))
-	      return -EINVAL;
+		   	break;
 	    if (((DCDB.TransferLengthHigh4 << 16) | DCDB.TransferLength)
 		!= abs(DataTransferLength))
-	      return -EINVAL;
+			break;
 	    DCDB_IOBUF = pci_alloc_consistent(Controller->PCIDevice,
 			sizeof(DAC960_V1_DCDB_T), &DCDB_IOBUFDMA);
-	    if (DCDB_IOBUF == NULL)
-			return -ENOMEM;
+	    if (DCDB_IOBUF == NULL) {
+	    		ErrorCode = -ENOMEM;
+			break;
+		}
 	  }
+	ErrorCode = -ENOMEM;
 	if (DataTransferLength > 0)
 	  {
 	    DataTransferBuffer = pci_alloc_consistent(Controller->PCIDevice,
 				DataTransferLength, &DataTransferBufferDMA);
-	    if (DataTransferBuffer == NULL) {
-		ErrorCode = -ENOMEM;
-		goto Failure1;
-	    }
+	    if (DataTransferBuffer == NULL)
+	    	break;
 	    memset(DataTransferBuffer, 0, DataTransferLength);
 	  }
 	else if (DataTransferLength < 0)
 	  {
 	    DataTransferBuffer = pci_alloc_consistent(Controller->PCIDevice,
 				-DataTransferLength, &DataTransferBufferDMA);
-	    if (DataTransferBuffer == NULL) {
-		ErrorCode = -ENOMEM;
-		goto Failure1;
-	    }
+	    if (DataTransferBuffer == NULL)
+	    	break;
 	    if (copy_from_user(DataTransferBuffer,
 			       UserCommand.DataTransferBuffer,
 			       -DataTransferLength)) {
 		ErrorCode = -EFAULT;
-		goto Failure1;
+		break;
 	    }
 	  }
 	if (CommandOpcode == DAC960_V1_DCDB)
@@ -6825,8 +6842,7 @@ static int DAC960_gam_ioctl(struct inode
 	if (DCDB_IOBUF != NULL)
 	  pci_free_consistent(Controller->PCIDevice, sizeof(DAC960_V1_DCDB_T),
 			DCDB_IOBUF, DCDB_IOBUFDMA);
-      Failure1a:
-	return ErrorCode;
+      	break;
       }
     case DAC960_IOCTL_V2_EXECUTE_COMMAND:
       {
@@ -6844,32 +6860,43 @@ static int DAC960_gam_ioctl(struct inode
 	dma_addr_t DataTransferBufferDMA;
 	unsigned char *RequestSenseBuffer = NULL;
 	dma_addr_t RequestSenseBufferDMA;
-	if (UserSpaceUserCommand == NULL) return -EINVAL;
+
+	ErrorCode = -EINVAL;
+	if (UserSpaceUserCommand == NULL)
+		break;
 	if (copy_from_user(&UserCommand, UserSpaceUserCommand,
 			   sizeof(DAC960_V2_UserCommand_T))) {
 		ErrorCode = -EFAULT;
-		goto Failure2a;
+		break;
 	}
+	ErrorCode = -ENXIO;
 	ControllerNumber = UserCommand.ControllerNumber;
 	if (ControllerNumber < 0 ||
 	    ControllerNumber > DAC960_ControllerCount - 1)
-	  return -ENXIO;
+	    	break;
 	Controller = DAC960_Controllers[ControllerNumber];
-	if (Controller == NULL) return -ENXIO;
-	if (Controller->FirmwareType != DAC960_V2_Controller) return -EINVAL;
+	if (Controller == NULL)
+		break;
+	if (Controller->FirmwareType != DAC960_V2_Controller){
+		ErrorCode = -EINVAL;
+		break;
+	}
 	DataTransferLength = UserCommand.DataTransferLength;
+    	ErrorCode = -ENOMEM;
 	if (DataTransferLength > 0)
 	  {
 	    DataTransferBuffer = pci_alloc_consistent(Controller->PCIDevice,
 				DataTransferLength, &DataTransferBufferDMA);
-	    if (DataTransferBuffer == NULL) return -ENOMEM;
+	    if (DataTransferBuffer == NULL)
+	    	break;
 	    memset(DataTransferBuffer, 0, DataTransferLength);
 	  }
 	else if (DataTransferLength < 0)
 	  {
 	    DataTransferBuffer = pci_alloc_consistent(Controller->PCIDevice,
 				-DataTransferLength, &DataTransferBufferDMA);
-	    if (DataTransferBuffer == NULL) return -ENOMEM;
+	    if (DataTransferBuffer == NULL)
+	    	break;
 	    if (copy_from_user(DataTransferBuffer,
 			       UserCommand.DataTransferBuffer,
 			       -DataTransferLength)) {
@@ -6979,8 +7006,7 @@ static int DAC960_gam_ioctl(struct inode
 	if (RequestSenseBuffer != NULL)
 	  pci_free_consistent(Controller->PCIDevice, RequestSenseLength,
 		RequestSenseBuffer, RequestSenseBufferDMA);
-      Failure2a:
-	return ErrorCode;
+        break;
       }
     case DAC960_IOCTL_V2_GET_HEALTH_STATUS:
       {
@@ -6990,21 +7016,33 @@ static int DAC960_gam_ioctl(struct inode
 	DAC960_V2_HealthStatusBuffer_T HealthStatusBuffer;
 	DAC960_Controller_T *Controller;
 	int ControllerNumber;
-	if (UserSpaceGetHealthStatus == NULL) return -EINVAL;
+	if (UserSpaceGetHealthStatus == NULL) {
+		ErrorCode = -EINVAL;
+		break;
+	}
 	if (copy_from_user(&GetHealthStatus, UserSpaceGetHealthStatus,
-			   sizeof(DAC960_V2_GetHealthStatus_T)))
-		return -EFAULT;
+			   sizeof(DAC960_V2_GetHealthStatus_T))) {
+		ErrorCode = -EFAULT;
+		break;
+	}
+	ErrorCode = -ENXIO;
 	ControllerNumber = GetHealthStatus.ControllerNumber;
 	if (ControllerNumber < 0 ||
 	    ControllerNumber > DAC960_ControllerCount - 1)
-	  return -ENXIO;
+		    break;
 	Controller = DAC960_Controllers[ControllerNumber];
-	if (Controller == NULL) return -ENXIO;
-	if (Controller->FirmwareType != DAC960_V2_Controller) return -EINVAL;
+	if (Controller == NULL)
+		break;
+	if (Controller->FirmwareType != DAC960_V2_Controller) {
+		ErrorCode = -EINVAL;
+		break;
+	}
 	if (copy_from_user(&HealthStatusBuffer,
 			   GetHealthStatus.HealthStatusBuffer,
-			   sizeof(DAC960_V2_HealthStatusBuffer_T)))
-		return -EFAULT;
+			   sizeof(DAC960_V2_HealthStatusBuffer_T))) {
+		ErrorCode = -EFAULT;
+		break;
+	}
 	while (Controller->V2.HealthStatusBuffer->StatusChangeCounter
 	       == HealthStatusBuffer.StatusChangeCounter &&
 	       Controller->V2.HealthStatusBuffer->NextEventSequenceNumber
@@ -7012,21 +7050,28 @@ static int DAC960_gam_ioctl(struct inode
 	  {
 	    interruptible_sleep_on_timeout(&Controller->HealthStatusWaitQueue,
 					   DAC960_MonitoringTimerInterval);
-	    if (signal_pending(current)) return -EINTR;
+	    if (signal_pending(current)) {
+	    	ErrorCode = -EINTR;
+	    	break;
+	    }
 	  }
 	if (copy_to_user(GetHealthStatus.HealthStatusBuffer,
 			 Controller->V2.HealthStatusBuffer,
 			 sizeof(DAC960_V2_HealthStatusBuffer_T)))
-		return -EFAULT;
-	return 0;
+		ErrorCode = -EFAULT;
+	else
+		ErrorCode =  0;
       }
+      default:
+	ErrorCode = -ENOTTY;
     }
-  return -EINVAL;
+  unlock_kernel();
+  return ErrorCode;
 }
 
 static const struct file_operations DAC960_gam_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= DAC960_gam_ioctl
+	.unlocked_ioctl	= DAC960_gam_ioctl
 };
 
 static struct miscdevice DAC960_gam_dev = {
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
serial-fix-enable_irq_wake-disable_irq_wake-imbalance-in-serial_corec.patch
linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl-fix.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations-cleanup.patch
paride-push-ioctl-down-into-driver.patch
pktcdvd-push-bkl-down-into-driver.patch
efirtc-push-down-the-bkl.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
mwave-ioctl-bkl-pushdown.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch
pcwd-a-couple-of-watchdogs-escaped-conversion.patch
dac960-push-down-bkl.patch
cm4000_cs-switch-to-unlocked_ioctl.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
snapshot-push-bkl-down-into-ioctl-handlers.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch
dsp56k-bkl-pushdown.patch
lcd-push-the-bkl-down-into-the-driver-ioctl-handler.patch

