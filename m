From: akpm@linux-foundation.org
Subject: + devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch added to -mm tree
Date: Tue, 26 May 2009 14:16:34 -0700
Message-ID: <200905262116.n4QLGYFm011943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757034AbZEZVRe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 17:17:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, greg@kroah.com, kay.sievers@vrfy.org, tj@kernel.org


The patch titled
     devres: WARN() and return, don't crash on device_del() of uninitialized device
has been added to the -mm tree.  Its filename is
     devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch

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
Subject: devres: WARN() and return, don't crash on device_del() of uninitialized device
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

I just debugged an obscure crash caused by a device_del() of a all NULL'd
out struct device (in usb-serial) and found that a patch like this one would
have saved me time (in addition to improved chances of a bug report from
users hitting similar driver bugs).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/devres.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/base/devres.c~devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device drivers/base/devres.c
--- a/drivers/base/devres.c~devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device
+++ a/drivers/base/devres.c
@@ -428,6 +428,11 @@ int devres_release_all(struct device *de
 {
 	unsigned long flags;
 
+	/* Looks like an uninitialized device structure */
+	if (dev->devres_head.next == NULL) {
+		WARN(1);
+		return -ENODEV;
+	}
 	spin_lock_irqsave(&dev->devres_lock, flags);
 	return release_nodes(dev, dev->devres_head.next, &dev->devres_head,
 			     flags);
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

linux-next.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device-cleanup.patch
time-move-pit_tick_rate-to-linux-timexh.patch
spi_mpc83xx-handle-other-freescale-processors.patch
spi_mpc83xx-quieten-down-the-requested-speed-is-too-low-message.patch
spi_mpc83xx-add-small-delay-after-asserting-chip-select-line.patch
powerpc-86xx-add-mmc-spi-support-for-mpc8610hpcd-boards.patch
spi_mpc83xx-fix-checkpatch-issues.patch
spi_mpc83xx-split-mpc83xx_spi_work-into-two-routines.patch
spi_mpc83xx-remove-dead-code.patch
spi_mpc83xx-rename-spi_83xxc-to-spi_8xxxc.patch
spi_mpc8xxx-s-83xx-8xxx-g.patch
offb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch
mb862xxfb-restrict-compliation-of-platform-driver-to-ppc.patch
rapidio-add-common-mapping-apis-for-rapidio-memory-access.patch
powerpc-add-memory-map-support-to-freescale-rapidio-block.patch
rionet-add-memory-access-to-simulated-ethernet-over-rapidio.patch
rio-warn_unused_result-warnings-fix.patch
edac-add-cpc925-memory-controller-driver.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-cpc925-memory-controller-driver-mc-check-fixup.patch
edac-add-edac_device_alloc_index.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-cpc925-mc-platform-device-setup.patch
edac-cpc925-mc-platform-device-setup-v3.patch

