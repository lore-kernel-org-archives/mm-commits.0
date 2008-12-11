From: akpm@linux-foundation.org
Subject: + ioc4-automatically-load-sgiioc4-subordinate-module.patch added to -mm tree
Date: Thu, 11 Dec 2008 14:54:06 -0800
Message-ID: <200812112254.mBBMs6Mo023112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758083AbYLKWyl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 17:54:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bcasavan@sgi.com, bzolnier@gmail.com, mdr@sgi.com


The patch titled
     ioc4: automatically load sgiioc4 subordinate module
has been added to the -mm tree.  Its filename is
     ioc4-automatically-load-sgiioc4-subordinate-module.patch

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
Subject: ioc4: automatically load sgiioc4 subordinate module
From: Brent Casavant <bcasavan@sgi.com>

Modify ioc4 to always load the sgiioc4 IDE module if the board carrying
the IOC4 hardware actually implements the IDE interface (not all boards
bring this functionality off the IOC4 chip).  A drive hosted on the IDE
interface may contain the root filesystem, and sgiioc4 doesn't load
automatically as ioc4 owns the PCI device ID, not sgiioc4.

Signed-off-by: Michael Reed <mdr@sgi.com>
Signed-off-by: Brent Casavant <bcasavan@sgi.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ioc4.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff -puN drivers/misc/ioc4.c~ioc4-automatically-load-sgiioc4-subordinate-module drivers/misc/ioc4.c
--- a/drivers/misc/ioc4.c~ioc4-automatically-load-sgiioc4-subordinate-module
+++ a/drivers/misc/ioc4.c
@@ -269,6 +269,16 @@ ioc4_variant(struct ioc4_driver_data *id
 	return IOC4_VARIANT_PCI_RT;
 }
 
+static void
+ioc4_load_modules(struct work_struct *work)
+{
+	/* arg just has to be freed */
+
+	request_module("sgiioc4");
+
+	kfree(work);
+}
+
 /* Adds a new instance of an IOC4 card */
 static int
 ioc4_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
@@ -378,6 +388,32 @@ ioc4_probe(struct pci_dev *pdev, const s
 	}
 	mutex_unlock(&ioc4_mutex);
 
+	/* Request sgiioc4 IDE driver on boards that bring that functionality
+	 * off of IOC4.  The root filesystem may be hosted on a drive connected
+	 * to IOC4, so we need to make sure the sgiioc4 driver is loaded as it
+	 * won't be picked up by modprobes due to the ioc4 module owning the
+	 * PCI device.
+	 */
+	if (idd->idd_variant != IOC4_VARIANT_PCI_RT) {
+		struct work_struct *work;
+		work = kzalloc(sizeof(struct work_struct), GFP_KERNEL);
+		if (!work) {
+			printk(KERN_WARNING
+			       "%s: IOC4 unable to allocate memory for "
+			       "load of sub-modules.\n",
+			       __FUNCTION__);
+		}
+		else {
+			/* Request the module from a work procedure as the
+			 * modprobe goes out to a userland helper and that
+			 * will hang if done directly from ioc4_probe().
+			 */
+			printk(KERN_INFO "IOC4 loading sgiioc4 submodule\n");
+			INIT_WORK(work, ioc4_load_modules);
+			schedule_work(work);
+		}
+	}
+
 	return 0;
 
 out_misc_region:
@@ -462,6 +498,8 @@ ioc4_init(void)
 static void __devexit
 ioc4_exit(void)
 {
+	/* Ensure ioc4_load_modules() has completed before exiting */
+	flush_scheduled_work();
 	pci_unregister_driver(&ioc4_driver);
 }
 
_

Patches currently in -mm which might be from bcasavan@sgi.com are

ioc4-automatically-load-sgiioc4-subordinate-module.patch

