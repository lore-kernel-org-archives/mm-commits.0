From: akpm@linux-foundation.org
Subject: + usb-forbid-memory-allocation-with-i-o-during-bus-reset.patch added to -mm tree
Date: Thu, 17 Jan 2013 13:58:03 -0800
Message-ID: <20130117215803.93BF25A4218@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:60662 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3AQWGU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jan 2013 17:06:20 -0500
Received: by mail-ia0-f202.google.com with SMTP id p22so213189iad.3
        for <mm-commits@vger.kernel.org>; Thu, 17 Jan 2013 14:06:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ming.lei@canonical.com, axboe@kernel.dk, davem@davemloft.net, david.decotigny@google.com, eric.dumazet@gmail.com, greg@kroah.com, jiri.kosina@suse.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, minchan@kernel.org, mingo@elte.hu, mingo@redhat.com, oneukum@suse.de, peterz@infradead.org, rjw@sisk.pl, stern@rowland.harvard.edu, therbert@google.com


The patch titled
     Subject: usb: forbid memory allocation with I/O during bus reset
has been added to the -mm tree.  Its filename is
     usb-forbid-memory-allocation-with-i-o-during-bus-reset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ming Lei <ming.lei@canonical.com>
Subject: usb: forbid memory allocation with I/O during bus reset

If one storage interface or usb network interface(iSCSI case) exists in
current configuration, memory allocation with GFP_KERNEL during
usb_device_reset() might trigger I/O transfer on the storage interface
itself and cause deadlock because the 'us->dev_mutex' is held in
.pre_reset() and the storage interface can't do I/O transfer when the
reset is triggered by other interface, or the error handling can't be
completed if the reset is triggered by the storage itself (error handling
path).

Signed-off-by: Ming Lei <ming.lei@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Decotigny <david.decotigny@google.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Jiri Kosina <jiri.kosina@suse.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hub.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/usb/core/hub.c~usb-forbid-memory-allocation-with-i-o-during-bus-reset drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~usb-forbid-memory-allocation-with-i-o-during-bus-reset
+++ a/drivers/usb/core/hub.c
@@ -5144,6 +5144,7 @@ int usb_reset_device(struct usb_device *
 {
 	int ret;
 	int i;
+	unsigned int noio_flag;
 	struct usb_host_config *config = udev->actconfig;
 
 	if (udev->state == USB_STATE_NOTATTACHED ||
@@ -5153,6 +5154,17 @@ int usb_reset_device(struct usb_device *
 		return -EINVAL;
 	}
 
+	/*
+	 * Don't allocate memory with GFP_KERNEL in current
+	 * context to avoid possible deadlock if usb mass
+	 * storage interface or usbnet interface(iSCSI case)
+	 * is included in current configuration. The easist
+	 * approach is to do it for every device reset,
+	 * because the device 'memalloc_noio' flag may have
+	 * not been set before reseting the usb device.
+	 */
+	noio_flag = memalloc_noio_save();
+
 	/* Prevent autosuspend during the reset */
 	usb_autoresume_device(udev);
 
@@ -5197,6 +5209,7 @@ int usb_reset_device(struct usb_device *
 	}
 
 	usb_autosuspend_device(udev);
+	memalloc_noio_restore(noio_flag);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(usb_reset_device);
_

Patches currently in -mm which might be from ming.lei@canonical.com are

origin.patch
linux-next.patch
mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation.patch
pm-runtime-introduce-pm_runtime_set_memalloc_noio.patch
block-genhdc-apply-pm_runtime_set_memalloc_noio-on-block-devices.patch
net-core-apply-pm_runtime_set_memalloc_noio-on-network-devices.patch
pm-runtime-force-memory-allocation-with-no-i-o-during-runtime-pm-callbcack.patch
usb-forbid-memory-allocation-with-i-o-during-bus-reset.patch

