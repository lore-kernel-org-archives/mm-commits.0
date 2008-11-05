From: akpm@linux-foundation.org
Subject: + bdi-register-sysfs-bdi-device-only-once-per-queue.patch added to -mm tree
Date: Wed, 05 Nov 2008 12:10:44 -0800
Message-ID: <200811052010.mA5KAjV1030371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756575AbYKEUL1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2008 15:11:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, a.p.zijlstra@chello.nl, dwmw2@infradead.org, jacmet@sunsite.dk


The patch titled
     bdi: register sysfs bdi device only once per queue
has been added to the -mm tree.  Its filename is
     bdi-register-sysfs-bdi-device-only-once-per-queue.patch

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
Subject: bdi: register sysfs bdi device only once per queue
From: Kay Sievers <kay.sievers@vrfy.org>

Devices which share the same queue, like floppies and mtd devices, get
registered multiple times in the bdi interface, but bdi accounts only the
last registered device of the devices sharing one queue.

On remove, all earlier registered devices leak, stay around in sysfs, and
cause "duplicate filename" errors if the devices are re-created.

This prevents the creation of multiple bdi interfaces per queue, and the
bdi device will carry the dev_t name of the block device which is the
first one registered, of the pool of devices using the same queue.

Tested-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/backing-dev.c~bdi-register-sysfs-bdi-device-only-once-per-queue mm/backing-dev.c
--- a/mm/backing-dev.c~bdi-register-sysfs-bdi-device-only-once-per-queue
+++ a/mm/backing-dev.c
@@ -176,6 +176,9 @@ int bdi_register(struct backing_dev_info
 	int ret = 0;
 	struct device *dev;
 
+	if (bdi->dev)
+		goto exit;
+
 	va_start(args, fmt);
 	dev = device_create_vargs(bdi_class, parent, MKDEV(0, 0), bdi, fmt, args);
 	va_end(args);
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

origin.patch
bdi-register-sysfs-bdi-device-only-once-per-queue.patch
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
linux-next.patch
rtc-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch

