From: akpm@osdl.org
Subject: - ipmi-add-pigeonpoint-poweroff.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:17:44 -0800
Message-ID: <200612072317.kB7NHirn030957@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53894 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163880AbWLGXRu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:17:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minyard@acm.org, jbarnett@motorola.com, mm-commits@vger.kernel.org


The patch titled
     IPMI: add pigeonpoint poweroff
has been removed from the -mm tree.  Its filename was
     ipmi-add-pigeonpoint-poweroff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: add pigeonpoint poweroff
From: Corey Minyard <minyard@acm.org>

X86 boards generally use ACPI for the power management interactions with the
BMC.  However, non-x86 boards need some help.  This patch adds the help for
the Motorola PigeonPoint-based IPMCs.

Signed-off-by: Joseph Barnett <jbarnett@motorola.com>
Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/ipmi/ipmi_poweroff.c |   52 +++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_poweroff.c~ipmi-add-pigeonpoint-poweroff drivers/char/ipmi/ipmi_poweroff.c
--- a/drivers/char/ipmi/ipmi_poweroff.c~ipmi-add-pigeonpoint-poweroff
+++ a/drivers/char/ipmi/ipmi_poweroff.c
@@ -176,6 +176,42 @@ static int ipmi_request_in_rc_mode(ipmi_
 #define IPMI_ATCA_GET_ADDR_INFO_CMD	0x01
 #define IPMI_PICMG_ID			0
 
+#define IPMI_NETFN_OEM				0x2e
+#define IPMI_ATCA_PPS_GRACEFUL_RESTART		0x11
+#define IPMI_ATCA_PPS_IANA			"\x00\x40\x0A"
+#define IPMI_MOTOROLA_MANUFACTURER_ID		0x0000A1
+#define IPMI_MOTOROLA_PPS_IPMC_PRODUCT_ID	0x0051
+
+static void (*atca_oem_poweroff_hook)(ipmi_user_t user) = NULL;
+
+static void pps_poweroff_atca (ipmi_user_t user)
+{
+        struct ipmi_system_interface_addr smi_addr;
+        struct kernel_ipmi_msg            send_msg;
+        int                               rv;
+        /*
+         * Configure IPMI address for local access
+         */
+        smi_addr.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
+        smi_addr.channel = IPMI_BMC_CHANNEL;
+        smi_addr.lun = 0;
+
+        printk(KERN_INFO PFX "PPS powerdown hook used");
+
+        send_msg.netfn = IPMI_NETFN_OEM;
+        send_msg.cmd = IPMI_ATCA_PPS_GRACEFUL_RESTART;
+        send_msg.data = IPMI_ATCA_PPS_IANA;
+        send_msg.data_len = 3;
+        rv = ipmi_request_in_rc_mode(user,
+                                  (struct ipmi_addr *) &smi_addr,
+                                   &send_msg);
+        if (rv && rv != IPMI_UNKNOWN_ERR_COMPLETION_CODE) {
+                printk(KERN_ERR PFX "Unable to send ATCA ,"
+                       " IPMI error 0x%x\n", rv);
+        }
+	return;
+}
+
 static int ipmi_atca_detect (ipmi_user_t user)
 {
 	struct ipmi_system_interface_addr smi_addr;
@@ -201,6 +237,13 @@ static int ipmi_atca_detect (ipmi_user_t
 	rv = ipmi_request_wait_for_response(user,
 					    (struct ipmi_addr *) &smi_addr,
 					    &send_msg);
+
+        printk(KERN_INFO PFX "ATCA Detect mfg 0x%X prod 0x%X\n", mfg_id, prod_id);
+        if((mfg_id == IPMI_MOTOROLA_MANUFACTURER_ID)
+            && (prod_id == IPMI_MOTOROLA_PPS_IPMC_PRODUCT_ID)) {
+		printk(KERN_INFO PFX "Installing Pigeon Point Systems Poweroff Hook\n");
+		atca_oem_poweroff_hook = pps_poweroff_atca;
+	}
 	return !rv;
 }
 
@@ -234,12 +277,19 @@ static void ipmi_poweroff_atca (ipmi_use
 	rv = ipmi_request_in_rc_mode(user,
 				     (struct ipmi_addr *) &smi_addr,
 				     &send_msg);
-	if (rv) {
+        /** At this point, the system may be shutting down, and most
+         ** serial drivers (if used) will have interrupts turned off
+         ** it may be better to ignore IPMI_UNKNOWN_ERR_COMPLETION_CODE
+         ** return code
+         **/
+        if (rv && rv != IPMI_UNKNOWN_ERR_COMPLETION_CODE) {
 		printk(KERN_ERR PFX "Unable to send ATCA powerdown message,"
 		       " IPMI error 0x%x\n", rv);
 		goto out;
 	}
 
+	if(atca_oem_poweroff_hook)
+		return atca_oem_poweroff_hook(user);
  out:
 	return;
 }
_

Patches currently in -mm which might be from minyard@acm.org are

origin.patch

