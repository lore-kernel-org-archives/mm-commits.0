From: akpm@linux-foundation.org
Subject: + rapidio-add-new-sysfs-attributes-v2.patch added to -mm tree
Date: Fri, 25 Feb 2011 16:13:34 -0800
Message-ID: <201102260013.p1Q0DYGY005836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431Ab1BZAOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Feb 2011 19:14:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio-add-new-sysfs-attributes-v2
has been added to the -mm tree.  Its filename is
     rapidio-add-new-sysfs-attributes-v2.patch

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
Subject: rapidio-add-new-sysfs-attributes-v2
From: Alexandre Bounine <alexandre.bounine@idt.com>

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-sysfs.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/rapidio/rio-sysfs.c~rapidio-add-new-sysfs-attributes-v2 drivers/rapidio/rio-sysfs.c
--- a/drivers/rapidio/rio-sysfs.c~rapidio-add-new-sysfs-attributes-v2
+++ a/drivers/rapidio/rio-sysfs.c
@@ -59,8 +59,8 @@ static ssize_t lprev_show(struct device 
 {
 	struct rio_dev *rdev = to_rio_dev(dev);
 
-	return sprintf(buf, "%02d %s\n", RIO_GET_PORT_NUM(rdev->swpinfo),
-		       (rdev->prev) ? rio_name(rdev->prev) : "host");
+	return sprintf(buf, "%s\n",
+			(rdev->prev) ? rio_name(rdev->prev) : "root");
 }
 
 static ssize_t lnext_show(struct device *dev,
@@ -73,8 +73,10 @@ static ssize_t lnext_show(struct device 
 	if (rdev->pef & RIO_PEF_SWITCH) {
 		for (i = 0; i < RIO_GET_TOTAL_PORTS(rdev->swpinfo); i++) {
 			if (rdev->rswitch->nextdev[i])
-				str += sprintf(str, "%02d %s\n", i,
+				str += sprintf(str, "%s\n",
 					rio_name(rdev->rswitch->nextdev[i]));
+			else
+				str += sprintf(str, "null\n");
 		}
 	}
 
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-fix-sysfs-config-attribute-to-access-16mb-of-maint-space.patch
rapidio-add-new-sysfs-attributes.patch
rapidio-add-new-sysfs-attributes-v2.patch
rapidio-add-rapidio-documentation.patch
rapidio-add-rapidio-documentation-v2.patch

