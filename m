From: akpm@linux-foundation.org
Subject: + rapidio-add-device-access-check-into-the-enumeration.patch added to -mm tree
Date: Tue, 14 Sep 2010 15:21:27 -0700
Message-ID: <201009142221.o8EMLRo0021816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755012Ab0INWWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 18:22:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: add device access check into the enumeration
has been added to the -mm tree.  Its filename is
     rapidio-add-device-access-check-into-the-enumeration.patch

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
Subject: rapidio: add device access check into the enumeration
From: Alexandre Bounine <alexandre.bounine@idt.com>

Add explicit device access check before performing device enumeration. 
This gives a chance to clear possible link error conditions by issuing
safe maintenance read request(s).

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    6 ++++++
 drivers/rapidio/rio.c      |    2 +-
 drivers/rapidio/rio.h      |    2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-add-device-access-check-into-the-enumeration drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-add-device-access-check-into-the-enumeration
+++ a/drivers/rapidio/rio-scan.c
@@ -762,6 +762,12 @@ static int __devinit rio_enum_peer(struc
 	u16 destid;
 	int tmp;
 
+	if (rio_mport_chk_dev_access(port,
+			RIO_ANY_DESTID(port->sys_size), hopcount)) {
+		pr_debug("RIO: device access check failed\n");
+		return -1;
+	}
+
 	if (rio_get_host_deviceid_lock(port, hopcount) == port->host_deviceid) {
 		pr_debug("RIO: PE already discovered by this host\n");
 		/*
diff -puN drivers/rapidio/rio.c~rapidio-add-device-access-check-into-the-enumeration drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-device-access-check-into-the-enumeration
+++ a/drivers/rapidio/rio.c
@@ -546,7 +546,7 @@ err_out:
  * @destid: Device destination ID in network
  * @hopcount: Number of hops into the network
  */
-static int
+int
 rio_mport_chk_dev_access(struct rio_mport *mport, u16 destid, u8 hopcount)
 {
 	int i = 0;
diff -puN drivers/rapidio/rio.h~rapidio-add-device-access-check-into-the-enumeration drivers/rapidio/rio.h
--- a/drivers/rapidio/rio.h~rapidio-add-device-access-check-into-the-enumeration
+++ a/drivers/rapidio/rio.h
@@ -24,6 +24,8 @@ extern u32 rio_mport_get_physefb(struct 
 				 u16 destid, u8 hopcount);
 extern u32 rio_mport_get_efb(struct rio_mport *port, int local, u16 destid,
 			     u8 hopcount, u32 from);
+extern int rio_mport_chk_dev_access(struct rio_mport *mport, u16 destid,
+				    u8 hopcount);
 extern int rio_create_sysfs_dev_files(struct rio_dev *rdev);
 extern int rio_enum_mport(struct rio_mport *mport);
 extern int rio_disc_mport(struct rio_mport *mport);
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

