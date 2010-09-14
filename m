From: akpm@linux-foundation.org
Subject: + rapidio-fix-rapidio-sysfs-hierarchy.patch added to -mm tree
Date: Tue, 14 Sep 2010 15:21:13 -0700
Message-ID: <201009142221.o8EMLDKZ021787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755020Ab0INWVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 18:21:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: fix RapidIO sysfs hierarchy
has been added to the -mm tree.  Its filename is
     rapidio-fix-rapidio-sysfs-hierarchy.patch

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
Subject: rapidio: fix RapidIO sysfs hierarchy
From: Alexandre Bounine <alexandre.bounine@idt.com>

This set of RapidIO patches extends support for standard error recovery
mechanism and adds new IDT Gen2 sRIO switch devices - CPS-1848 and
CPS-1616.  Implementation of the standard error-stopped state recovery
mechanism (as defined by the RapidIO specification) is required for the
new switches.

Version 2 of this set of patches addresses received comments and fixes an
error notification setup issue found in the idt_gen2.c after the first
version was released.


This patch:

Make RapidIO devices appear in /sys/devices/rapidio directory instead of
top of /sys/devices directory.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-driver.c |    2 +-
 drivers/rapidio/rio-scan.c   |    1 +
 include/linux/rio.h          |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/rapidio/rio-driver.c~rapidio-fix-rapidio-sysfs-hierarchy drivers/rapidio/rio-driver.c
--- a/drivers/rapidio/rio-driver.c~rapidio-fix-rapidio-sysfs-hierarchy
+++ a/drivers/rapidio/rio-driver.c
@@ -192,7 +192,7 @@ static int rio_match_bus(struct device *
       out:return 0;
 }
 
-static struct device rio_bus = {
+struct device rio_bus = {
 	.init_name = "rapidio",
 };
 
diff -puN drivers/rapidio/rio-scan.c~rapidio-fix-rapidio-sysfs-hierarchy drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-fix-rapidio-sysfs-hierarchy
+++ a/drivers/rapidio/rio-scan.c
@@ -478,6 +478,7 @@ static struct rio_dev __devinit *rio_set
 	}
 
 	rdev->dev.bus = &rio_bus_type;
+	rdev->dev.parent = &rio_bus;
 
 	device_initialize(&rdev->dev);
 	rdev->dev.release = rio_release_dev;
diff -puN include/linux/rio.h~rapidio-fix-rapidio-sysfs-hierarchy include/linux/rio.h
--- a/include/linux/rio.h~rapidio-fix-rapidio-sysfs-hierarchy
+++ a/include/linux/rio.h
@@ -67,6 +67,7 @@
 #define RIO_PW_MSG_SIZE		64
 
 extern struct bus_type rio_bus_type;
+extern struct device rio_bus;
 extern struct list_head rio_devices;	/* list of all devices */
 
 struct rio_mport;
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-fix-rapidio-sysfs-hierarchy.patch
rapidio-powerpc-85xx-modify-rio-port-write-interrupt-handler.patch
rapidio-use-stored-ingress-port-number-instead-of-register-read.patch
rapidio-add-relation-links-between-rio-device-structures.patch
rapidio-add-default-handler-for-error-stopped-state.patch
rapidio-modify-sysfs-initialization-for-switches.patch
rapidio-add-handling-of-orphan-port-write-message.patch
rapidio-add-device-access-check-into-the-enumeration.patch
rapidio-add-support-for-idt-cps-gen2-switches.patch
rapidio-add-handling-of-redundant-routes.patch

