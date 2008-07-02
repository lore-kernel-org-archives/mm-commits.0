From: akpm@linux-foundation.org
Subject: + parport-fix-platform-driver-hotplug-coldplug.patch added to -mm tree
Date: Wed, 02 Jul 2008 01:51:27 -0700
Message-ID: <200807020851.m628pRDo008155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314AbYGBIwJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 04:52:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, greg@kroah.com, rjw@sisk.pl, stable@kernel.org


The patch titled
     parport: fix platform driver hotplug/coldplug
has been added to the -mm tree.  Its filename is
     parport-fix-platform-driver-hotplug-coldplug.patch

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
Subject: parport: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
with "platform:"), the platform modalias is prefixed with "platform:". 
Add MODULE_ALIAS() to the hotpluggable parport platform drivers, to
re-enable auto loading.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: <stable@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_ax88796.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/parport/parport_ax88796.c~parport-fix-platform-driver-hotplug-coldplug drivers/parport/parport_ax88796.c
--- a/drivers/parport/parport_ax88796.c~parport-fix-platform-driver-hotplug-coldplug
+++ a/drivers/parport/parport_ax88796.c
@@ -406,6 +406,8 @@ static int parport_ax88796_resume(struct
 #define parport_ax88796_resume  NULL
 #endif
 
+MODULE_ALIAS("platform:ax88796-pp");
+
 static struct platform_driver axdrv = {
 	.driver		= {
 		.name	= "ax88796-pp",
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

drivers-power-fix-platform-driver-hotplug-coldplug.patch
mfd-fix-platform-driver-hotplug-coldplug.patch
linux-next.patch
gpio-sysfs-interface-updated.patch
gpio-sysfs-interface-updated-update.patch
firmware-use-memory_read_from_buffer.patch
parport-fix-platform-driver-hotplug-coldplug.patch

