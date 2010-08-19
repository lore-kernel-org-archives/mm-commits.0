From: akpm@linux-foundation.org
Subject: + drivers-scsi-pm8001-pm8001_hwic-handle-allocation-failures.patch added to -mm tree
Date: Thu, 19 Aug 2010 16:25:50 -0700
Message-ID: <201008192325.o7JNPojL014600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab0HSXZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 19:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, James.Bottomley@HansenPartnership.com, jack_wang@usish.com


The patch titled
     drivers/scsi/pm8001/pm8001_hwi.c: handle allocation failures
has been added to the -mm tree.  Its filename is
     drivers-scsi-pm8001-pm8001_hwic-handle-allocation-failures.patch

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
Subject: drivers/scsi/pm8001/pm8001_hwi.c: handle allocation failures
From: Dan Carpenter <error27@gmail.com>

Return -ENOMEM if the allocations fail.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Jack Wang <jack_wang@usish.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/pm8001/pm8001_hwi.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/scsi/pm8001/pm8001_hwi.c~drivers-scsi-pm8001-pm8001_hwic-handle-allocation-failures drivers/scsi/pm8001/pm8001_hwi.c
--- a/drivers/scsi/pm8001/pm8001_hwi.c~drivers-scsi-pm8001-pm8001_hwic-handle-allocation-failures
+++ a/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4194,6 +4194,8 @@ static int pm8001_chip_get_nvmd_req(stru
 
 	nvmd_type = ioctl_payload->minor_function;
 	fw_control_context = kzalloc(sizeof(struct fw_control_ex), GFP_KERNEL);
+	if (!fw_control_context)
+		return -ENOMEM;
 	fw_control_context->usrAddr = (u8 *)&ioctl_payload->func_specific[0];
 	fw_control_context->len = ioctl_payload->length;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
@@ -4272,6 +4274,8 @@ static int pm8001_chip_set_nvmd_req(stru
 
 	nvmd_type = ioctl_payload->minor_function;
 	fw_control_context = kzalloc(sizeof(struct fw_control_ex), GFP_KERNEL);
+	if (!fw_control_context)
+		return -ENOMEM;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	memcpy(pm8001_ha->memoryMap.region[NVMD].virt_ptr,
 		ioctl_payload->func_specific,
@@ -4381,6 +4385,8 @@ pm8001_chip_fw_flash_update_req(struct p
 	struct pm8001_ioctl_payload *ioctl_payload = payload;
 
 	fw_control_context = kzalloc(sizeof(struct fw_control_ex), GFP_KERNEL);
+	if (!fw_control_context)
+		return -ENOMEM;
 	fw_control = (struct fw_control_info *)&ioctl_payload->func_specific[0];
 	if (fw_control->len != 0) {
 		if (pm8001_mem_alloc(pm8001_ha->pdev,
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
drivers-scsi-pm8001-pm8001_hwic-handle-allocation-failures.patch
ip2-remove-unneeded-null-check.patch
ip2-return-efault-on-copy_to_user-errors.patch

