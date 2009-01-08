From: akpm@linux-foundation.org
Subject: - dcdbas-export-functionality-for-use-in-other-drivers.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:50:34 -0800
Message-ID: <200901082250.n08MoYiS029727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763385AbZAHW7q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:59:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, Matt_Domsch@dell.com, greg@kroah.com, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dcdbas: export functionality for use in other drivers
has been removed from the -mm tree.  Its filename was
     dcdbas-export-functionality-for-use-in-other-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -238,11 +238,11 @@ static ssize_t host_control_on_shutdown_
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
 	cpumask_t old_mask;
 	int ret = 0;
@@ -309,14 +309,14 @@ static ssize_t smi_request_store(struct 
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
@@ -333,6 +333,7 @@ out:
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

origin.patch
eeepc-laptop-enable-bluetooth-for-asus-eee-901.patch
misc-add-dell-wmi-driver-for-hotkey-control.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch
video-mbp_nvidia_bl-add-a-debug-switch.patch
hp-wmi-handle-rfkill_register-failure.patch

