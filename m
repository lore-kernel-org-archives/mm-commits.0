From: akpm@linux-foundation.org
Subject: + usbmon-fix-tiny-race-exposed-by-the-fastboot-patches.patch added to -mm tree
Date: Wed, 17 Sep 2008 12:53:55 -0700
Message-ID: <200809171953.m8HJrt4q027678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460AbYIQTyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 15:54:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, greg@kroah.com, zaitcev@redhat.com


The patch titled
     usbmon: fix tiny race exposed by the fastboot patches
has been added to the -mm tree.  Its filename is
     usbmon-fix-tiny-race-exposed-by-the-fastboot-patches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usbmon: fix tiny race exposed by the fastboot patches
From: Arjan van de Ven <arjan@linux.intel.com>

usbmon registers the notifier chain, takes the bus lock and then goes to
scan the existing devices for hooking up.

Unfortunately, if usb_mon gets initialized while USB bus discovery is
going on, it's possible that usbmon gets a notifier on one cpu (which runs
without USB locks), and the scan is going on and also finds the new bus,
resulting in a double sysfs registration, which then produces a WARNING.

Pete Zaitcev did the bug diagnostics on this one

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Pete Zaitcev <zaitcev@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/mon/mon_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/mon/mon_main.c~usbmon-fix-tiny-race-exposed-by-the-fastboot-patches drivers/usb/mon/mon_main.c
--- a/drivers/usb/mon/mon_main.c~usbmon-fix-tiny-race-exposed-by-the-fastboot-patches
+++ a/drivers/usb/mon/mon_main.c
@@ -361,12 +361,12 @@ static int __init mon_init(void)
 	}
 	// MOD_INC_USE_COUNT(which_module?);
 
-	usb_register_notify(&mon_nb);
 
 	mutex_lock(&usb_bus_list_lock);
 	list_for_each_entry (ubus, &usb_bus_list, bus_list) {
 		mon_bus_init(ubus);
 	}
+	usb_register_notify(&mon_nb);
 	mutex_unlock(&usb_bus_list_lock);
 	return 0;
 
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
usbmon-fix-tiny-race-exposed-by-the-fastboot-patches.patch

