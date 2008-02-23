From: akpm@linux-foundation.org
Subject: + driver-core-fix-error-handling-in-bus_add_driver.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:29:09 -0800
Message-ID: <200802230729.m1N7TwJq017919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314AbYBWHaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:30:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cornelia.huck@de.ibm.com, greg@kroah.com, kay.sievers@vrfy.org


The patch titled
     Driver core: fix error handling in bus_add_driver()
has been added to the -mm tree.  Its filename is
     driver-core-fix-error-handling-in-bus_add_driver.patch

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
Subject: Driver core: fix error handling in bus_add_driver()
From: Cornelia Huck <cornelia.huck@de.ibm.com>

- If the allocation of ->priv fails, the reference on the bus
  must be dropped.
- If adding the kobject fails, kobject_put must be called to
  clean things up.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/bus.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/base/bus.c~driver-core-fix-error-handling-in-bus_add_driver drivers/base/bus.c
--- a/drivers/base/bus.c~driver-core-fix-error-handling-in-bus_add_driver
+++ a/drivers/base/bus.c
@@ -658,9 +658,10 @@ int bus_add_driver(struct device_driver 
 	pr_debug("bus: '%s': add driver %s\n", bus->name, drv->name);
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
+	if (!priv) {
+		error = -ENOMEM;
+		goto out_put_bus;
+	}
 	klist_init(&priv->klist_devices, NULL, NULL);
 	priv->driver = drv;
 	drv->p = priv;
@@ -668,7 +669,7 @@ int bus_add_driver(struct device_driver 
 	error = kobject_init_and_add(&priv->kobj, &driver_ktype, NULL,
 				     "%s", drv->name);
 	if (error)
-		goto out_put_bus;
+		goto out_unregister;
 
 	if (drv->bus->p->drivers_autoprobe) {
 		error = driver_attach(drv);
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

driver-core-fix-error-handling-in-bus_add_driver.patch
git-s390.patch
