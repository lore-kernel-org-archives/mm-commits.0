From: akpm@linux-foundation.org
Subject: + dma-fix-platform-driver-hotplug-coldplug.patch added to -mm tree
Date: Wed, 02 Jul 2008 01:52:25 -0700
Message-ID: <200807020852.m628qPpL008206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300AbYGBIxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 04:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, dan.j.williams@intel.com, dbrownell@users.sourceforge.net, greg@kroah.com, rjw@sisk.pl, stable@kernel.org


The patch titled
     dma: fix platform driver hotplug/coldplug
has been added to the -mm tree.  Its filename is
     dma-fix-platform-driver-hotplug-coldplug.patch

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
Subject: dma: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
with "platform:"), the platform modalias is prefixed with "platform:". 
Add MODULE_ALIAS() to most of the hotpluggable platform drivers, to
re-enable auto loading.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: <stable@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/iop-adma.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/dma/iop-adma.c~dma-fix-platform-driver-hotplug-coldplug drivers/dma/iop-adma.c
--- a/drivers/dma/iop-adma.c~dma-fix-platform-driver-hotplug-coldplug
+++ a/drivers/dma/iop-adma.c
@@ -1387,6 +1387,8 @@ static void iop_chan_start_null_xor(stru
 	spin_unlock_bh(&iop_chan->lock);
 }
 
+MODULE_ALIAS("platform:iop-adma");
+
 static struct platform_driver iop_adma_driver = {
 	.probe		= iop_adma_probe,
 	.remove		= iop_adma_remove,
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

drivers-power-fix-platform-driver-hotplug-coldplug.patch
mfd-fix-platform-driver-hotplug-coldplug.patch
parport-fix-platform-driver-hotplug-coldplug.patch
linux-next.patch
gpio-sysfs-interface-updated.patch
gpio-sysfs-interface-updated-update.patch
firmware-use-memory_read_from_buffer.patch
dma-fix-platform-driver-hotplug-coldplug.patch

