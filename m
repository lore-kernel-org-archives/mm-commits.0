From: akpm@linux-foundation.org
Subject: + dcdbas-export-functionality-for-use-in-other-drivers.patch added to -mm tree
Date: Tue, 02 Dec 2008 11:52:15 -0800
Message-ID: <200812021952.mB2JqFgo015734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbYLBTxi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 14:53:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg59@srcf.ucam.org, Matt_Domsch@dell.com, greg@kroah.com, mjg@redhat.com


The patch titled
     dcdbas: export functionality for use in other drivers
has been added to the -mm tree.  Its filename is
     dcdbas-export-functionality-for-use-in-other-drivers.patch

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
Subject: dcdbas: export functionality for use in other drivers
From: Matthew Garrett <mjg59@srcf.ucam.org>

The dcdbas code allows calls to be made into the firmware on Dell systems.
 Exporting this to other drivers allows them to implement Dell-specific
functionality in a safe way.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dcdbas.c |    9 +++++----
 drivers/firmware/dcdbas.h |    2 ++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/firmware/dcdbas.c~dcdbas-export-functionality-for-use-in-other-drivers drivers/firmware/dcdbas.c
--- a/drivers/firmware/dcdbas.c~dcdbas-export-functionality-for-use-in-other-drivers
+++ a/drivers/firmware/dcdbas.c
@@ -255,11 +255,11 @@ static long generate_smi(void *_smi_cmd)
 }
 
 /**
- * smi_request: generate SMI request
+ * dcdbas_smi_request: generate SMI request
  *
  * Called with smi_data_lock.
  */
-static int smi_request(struct smi_cmd *smi_cmd)
+int dcdbas_smi_request(struct smi_cmd *smi_cmd)
 {
 	if (smi_cmd->magic != SMI_CMD_MAGIC) {
 		dev_info(&dcdbas_pdev->dev, "%s: invalid magic value\n",
@@ -301,14 +301,14 @@ static ssize_t smi_request_store(struct 
 	switch (val) {
 	case 2:
 		/* Raw SMI */
-		ret = smi_request(smi_cmd);
+		ret = dcdbas_smi_request(smi_cmd);
 		if (!ret)
 			ret = count;
 		break;
 	case 1:
 		/* Calling Interface SMI */
 		smi_cmd->ebx = (u32) virt_to_phys(smi_cmd->command_buffer);
-		ret = smi_request(smi_cmd);
+		ret = dcdbas_smi_request(smi_cmd);
 		if (!ret)
 			ret = count;
 		break;
@@ -325,6 +325,7 @@ out:
 	mutex_unlock(&smi_data_lock);
 	return ret;
 }
+EXPORT_SYMBOL(dcdbas_smi_request);
 
 /**
  * host_control_smi: generate host control SMI
diff -puN drivers/firmware/dcdbas.h~dcdbas-export-functionality-for-use-in-other-drivers drivers/firmware/dcdbas.h
--- a/drivers/firmware/dcdbas.h~dcdbas-export-functionality-for-use-in-other-drivers
+++ a/drivers/firmware/dcdbas.h
@@ -101,5 +101,7 @@ struct apm_cmd {
 	} __attribute__ ((packed)) parameters;
 } __attribute__ ((packed));
 
+int dcdbas_smi_request(struct smi_cmd *smi_cmd);
+
 #endif /* _DCDBAS_H_ */
 
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

linux-next.patch
hp-wmi-handle-rfkill_register-failure.patch
dcdbas-export-functionality-for-use-in-other-drivers.patch
misc-add-dell-laptop-driver.patch
misc-add-dell-laptop-driver-fix.patch

