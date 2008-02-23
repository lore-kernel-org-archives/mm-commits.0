From: akpm@linux-foundation.org
Subject: + sysdev-detect-multiple-driver-registrations.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:29:11 -0800
Message-ID: <200802230730.m1N7U0AB017922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857AbYBWHam (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:30:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@fluff.org, greg@kroah.com, kay.sievers@vrfy.org


The patch titled
     sysdev: detect multiple driver registrations
has been added to the -mm tree.  Its filename is
     sysdev-detect-multiple-driver-registrations.patch

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
@@ -166,6 +166,11 @@ int sysdev_driver_register(struct sysdev
 {
 	int err = 0;
 
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

sysdev-detect-multiple-driver-registrations.patch
