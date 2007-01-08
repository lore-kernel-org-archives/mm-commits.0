From: akpm@osdl.org
Subject: + dac960-kmalloc-kzalloc-casting-cleanups.patch added to -mm tree
Date: Mon, 08 Jan 2007 14:29:16 -0800
Message-ID: <200701082229.l08MTG2M020827@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49179 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030352AbXAHW3S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:29:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com


The patch titled
     DAC960: kmalloc->kzalloc/Casting cleanups
has been added to the -mm tree.  Its filename is
     dac960-kmalloc-kzalloc-casting-cleanups.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: DAC960: kmalloc->kzalloc/Casting cleanups
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

A patch to switch kmalloc->kzalloc and to clean unneeded kammloc,
pci_alloc_consistent casts

Signed-off-by: Ahmed Darwish <darwish.07@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/DAC960.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff -puN drivers/block/DAC960.c~dac960-kmalloc-kzalloc-casting-cleanups drivers/block/DAC960.c
--- a/drivers/block/DAC960.c~dac960-kmalloc-kzalloc-casting-cleanups
+++ a/drivers/block/DAC960.c
@@ -1373,8 +1373,7 @@ static boolean DAC960_V2_EnableMemoryMai
   Controller->BounceBufferLimit = DAC690_V2_PciDmaMask;
 
   /* This is a temporary dma mapping, used only in the scope of this function */
-  CommandMailbox =
-	  (DAC960_V2_CommandMailbox_T *)pci_alloc_consistent( PCI_Device,
+  CommandMailbox = pci_alloc_consistent(PCI_Device,
 		sizeof(DAC960_V2_CommandMailbox_T), &CommandMailboxDMA);
   if (CommandMailbox == NULL)
 	  return false;
@@ -1879,8 +1878,8 @@ static boolean DAC960_V2_ReadControllerC
       if (NewLogicalDeviceInfo->LogicalDeviceState !=
 	  DAC960_V2_LogicalDevice_Offline)
 	Controller->LogicalDriveInitiallyAccessible[LogicalDeviceNumber] = true;
-      LogicalDeviceInfo = (DAC960_V2_LogicalDeviceInfo_T *)
-	kmalloc(sizeof(DAC960_V2_LogicalDeviceInfo_T), GFP_ATOMIC);
+      LogicalDeviceInfo = kmalloc(sizeof(DAC960_V2_LogicalDeviceInfo_T),
+				   GFP_ATOMIC);
       if (LogicalDeviceInfo == NULL)
 	return DAC960_Failure(Controller, "LOGICAL DEVICE ALLOCATION");
       Controller->V2.LogicalDeviceInformation[LogicalDeviceNumber] =
@@ -2113,8 +2112,8 @@ static boolean DAC960_V2_ReadDeviceConfi
       if (!DAC960_V2_NewPhysicalDeviceInfo(Controller, Channel, TargetID, LogicalUnit))
 	  break;
 
-      PhysicalDeviceInfo = (DAC960_V2_PhysicalDeviceInfo_T *)
-		kmalloc(sizeof(DAC960_V2_PhysicalDeviceInfo_T), GFP_ATOMIC);
+      PhysicalDeviceInfo = kmalloc(sizeof(DAC960_V2_PhysicalDeviceInfo_T),
+				    GFP_ATOMIC);
       if (PhysicalDeviceInfo == NULL)
 		return DAC960_Failure(Controller, "PHYSICAL DEVICE ALLOCATION");
       Controller->V2.PhysicalDeviceInformation[PhysicalDeviceIndex] =
@@ -2122,8 +2121,8 @@ static boolean DAC960_V2_ReadDeviceConfi
       memcpy(PhysicalDeviceInfo, NewPhysicalDeviceInfo,
 		sizeof(DAC960_V2_PhysicalDeviceInfo_T));
 
-      InquiryUnitSerialNumber = (DAC960_SCSI_Inquiry_UnitSerialNumber_T *)
-	kmalloc(sizeof(DAC960_SCSI_Inquiry_UnitSerialNumber_T), GFP_ATOMIC);
+      InquiryUnitSerialNumber = kmalloc(
+	      sizeof(DAC960_SCSI_Inquiry_UnitSerialNumber_T), GFP_ATOMIC);
       if (InquiryUnitSerialNumber == NULL) {
 	kfree(PhysicalDeviceInfo);
 	return DAC960_Failure(Controller, "SERIAL NUMBER ALLOCATION");
@@ -4949,8 +4948,8 @@ static void DAC960_V2_ProcessCompletedCo
 	      PhysicalDevice.LogicalUnit = NewLogicalDeviceInfo->LogicalUnit;
 	      Controller->V2.LogicalDriveToVirtualDevice[LogicalDeviceNumber] =
 		PhysicalDevice;
-	      LogicalDeviceInfo = (DAC960_V2_LogicalDeviceInfo_T *)
-		kmalloc(sizeof(DAC960_V2_LogicalDeviceInfo_T), GFP_ATOMIC);
+	      LogicalDeviceInfo = kmalloc(sizeof(DAC960_V2_LogicalDeviceInfo_T),
+					  GFP_ATOMIC);
 	      Controller->V2.LogicalDeviceInformation[LogicalDeviceNumber] =
 		LogicalDeviceInfo;
 	      DAC960_Critical("Logical Drive %d (/dev/rd/c%dd%d) "
@@ -5709,14 +5708,14 @@ static boolean DAC960_CheckStatusBuffer(
       unsigned int NewStatusBufferLength = DAC960_InitialStatusBufferSize;
       while (NewStatusBufferLength < ByteCount)
 	NewStatusBufferLength *= 2;
-      Controller->CombinedStatusBuffer =
-	(unsigned char *) kmalloc(NewStatusBufferLength, GFP_ATOMIC);
+      Controller->CombinedStatusBuffer = kmalloc(NewStatusBufferLength,
+						  GFP_ATOMIC);
       if (Controller->CombinedStatusBuffer == NULL) return false;
       Controller->CombinedStatusBufferLength = NewStatusBufferLength;
       return true;
     }
-  NewStatusBuffer = (unsigned char *)
-    kmalloc(2 * Controller->CombinedStatusBufferLength, GFP_ATOMIC);
+  NewStatusBuffer = kmalloc(2 * Controller->CombinedStatusBufferLength,
+			     GFP_ATOMIC);
   if (NewStatusBuffer == NULL)
     {
       DAC960_Warning("Unable to expand Combined Status Buffer - Truncating\n",
_

Patches currently in -mm which might be from darwish.07@gmail.com are

git-cpufreq.patch
jsm_tty-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
cifs-remove-2-unneeded-kzalloc-casts.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
ucc-ether-driver-kmalloc-casting-cleanups.patch
