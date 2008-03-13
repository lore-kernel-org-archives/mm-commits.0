From: akpm@linux-foundation.org
Subject: - sysdev-detect-multiple-driver-registrations.patch removed from -mm tree
Date: Thu, 13 Mar 2008 11:59:35 -0700
Message-ID: <200803131859.m2DIxZxa027964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754228AbYCMTEA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:04:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@fluff.org, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     sysdev: detect multiple driver registrations
has been removed from the -mm tree.  Its filename was
     sysdev-detect-multiple-driver-registrations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysdev: detect multiple driver registrations
From: Ben Dooks <ben@fluff.org>

I've just found how easy it is to accidentally register a sysdev_driver for
two different classes.  When this happens, bad things happen as the
sysdev_driver structure keeps has the list entry for the driver
registration.

The following patch makes a WARN_ON() if this happens, although I think
BUG_ON or returning -EAGAIN could also be valid responses to this.

Signed-off-by: Ben Dooks <ben@fluff.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/sys.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/base/sys.c~sysdev-detect-multiple-driver-registrations drivers/base/sys.c
--- a/drivers/base/sys.c~sysdev-detect-multiple-driver-registrations
+++ a/drivers/base/sys.c
@@ -171,6 +171,11 @@ int sysdev_driver_register(struct sysdev
 	WARN_ON(drv->entry.next != drv->entry.prev);
 	WARN_ON(drv->entry.next != NULL);
 
+	/* Check whether this driver has already been added to a class. */
+
+	WARN_ON(drv->entry.next != drv->entry.prev);
+	WARN_ON(drv->entry.next != NULL);
+
 	mutex_lock(&sysdev_drivers_lock);
 	if (cls && kset_get(&cls->kset)) {
 		list_add_tail(&drv->entry, &cls->drivers);
_

Patches currently in -mm which might be from ben@fluff.org are


