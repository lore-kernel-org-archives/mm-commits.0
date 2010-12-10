From: akpm@linux-foundation.org
Subject: + rapidio-add-definitions-of-component-tag-fields.patch added to -mm tree
Date: Fri, 10 Dec 2010 15:24:24 -0800
Message-ID: <201012102324.oBANOPeI009030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755395Ab0LJXY6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Dec 2010 18:24:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: add definitions of Component Tag fields
has been added to the -mm tree.  Its filename is
     rapidio-add-definitions-of-component-tag-fields.patch

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
Subject: rapidio: add definitions of Component Tag fields
From: Alexandre Bounine <alexandre.bounine@idt.com>

Add definition of the unique device identifier field in the component tag.
 RIO_CTAG_UDEVID does not take all 32 bits of the component tag value to
allow future extensions to the component tag use.

Selected size of the RIO_CTAG_UDEVID field (17 bits) is sufficient to
accommodate maximum number of endpoints in large RIO network (16-bit id)
plus switches.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |    2 +-
 include/linux/rio.h   |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/rapidio/rio.c~rapidio-add-definitions-of-component-tag-fields drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-definitions-of-component-tag-fields
+++ a/drivers/rapidio/rio.c
@@ -710,7 +710,7 @@ int rio_inb_pwrite_handler(union rio_pw_
 	u32 err_status, em_perrdet, em_ltlerrdet;
 	int rc, portnum;
 
-	rdev = rio_get_comptag(pw_msg->em.comptag, NULL);
+	rdev = rio_get_comptag((pw_msg->em.comptag & RIO_CTAG_UDEVID), NULL);
 	if (rdev == NULL) {
 		/* Device removed or enumeration error */
 		pr_debug("RIO: %s No matching device for CTag 0x%08x\n",
diff -puN include/linux/rio.h~rapidio-add-definitions-of-component-tag-fields include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-definitions-of-component-tag-fields
+++ a/include/linux/rio.h
@@ -66,6 +66,16 @@
 
 #define RIO_PW_MSG_SIZE		64
 
+/*
+ * A component tag value (stored in the component tag CSR) is used as device's
+ * unique identifier assigned during enumeration. Besides being used for
+ * identifying switches (which do not have device ID register), it also is used
+ * by error management notification and therefore has to be assigned
+ * to endpoints as well.
+ */
+#define RIO_CTAG_RESRVD	0xfffe0000 /* Reserved */
+#define RIO_CTAG_UDEVID	0x0001ffff /* Unique device identifier */
+
 extern struct bus_type rio_bus_type;
 extern struct device rio_bus;
 extern struct list_head rio_devices;	/* list of all devices */
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-use-common-destid-storage-for-endpoints-and-switches.patch
rapidio-integrate-rio_switch-into-rio_dev.patch
rapidio-add-definitions-of-component-tag-fields.patch
rapidio-add-device-object-linking-into-discovery.patch
rapidio-use-component-tag-for-unified-switch-identification.patch
rapidio-add-new-sysfs-attributes.patch
rapidio-add-new-idt-srio-switches.patch

