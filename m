From: akpm@linux-foundation.org
Subject: + w35und-unregister-device-from-the-ieee80211-stack-upon-disconnect.patch added to -mm tree
Date: Mon, 20 Apr 2009 14:09:23 -0700
Message-ID: <200904202109.n3KL9Nwt024734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbZDTVMZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Apr 2009 17:12:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, luoyi.ly@gmail.com, pavel@ucw.cz, sandro.bonazzola@gmail.com


The patch titled
     w35und: unregister device from the ieee80211 stack upon ->disconnect()
has been added to the -mm tree.  Its filename is
     w35und-unregister-device-from-the-ieee80211-stack-upon-disconnect.patch

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
Subject: w35und: unregister device from the ieee80211 stack upon ->disconnect()
From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: fix module removal

This patch fixes an oops when the w35und module is removed from the
kernel and added back.

Reported-by: luoyi <luoyi.ly@gmail.com>
Tested-by: Sandro Bonazzola <sandro.bonazzola@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/winbond/wbusb.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/staging/winbond/wbusb.c~w35und-unregister-device-from-the-ieee80211-stack-upon-disconnect drivers/staging/winbond/wbusb.c
--- a/drivers/staging/winbond/wbusb.c~w35und-unregister-device-from-the-ieee80211-stack-upon-disconnect
+++ a/drivers/staging/winbond/wbusb.c
@@ -368,7 +368,7 @@ static int wb35_probe(struct usb_interfa
 	if (err)
 		goto error_free_hw;
 
-	usb_set_intfdata(intf, priv);
+	usb_set_intfdata(intf, dev);
 
 	return 0;
 
@@ -397,10 +397,15 @@ static void wb35_hw_halt(struct wbsoft_p
 
 static void wb35_disconnect(struct usb_interface *intf)
 {
-	struct wbsoft_priv *priv = usb_get_intfdata(intf);
+	struct ieee80211_hw *hw = usb_get_intfdata(intf);
+	struct wbsoft_priv *priv = hw->priv;
 
 	wb35_hw_halt(priv);
 
+	ieee80211_stop_queues(hw);
+	ieee80211_unregister_hw(hw);
+	ieee80211_free_hw(hw);
+
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
 }
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
maintainers-update-kmemtrace-pattern-after-file-rename.patch
repeatable-slab-corruption-with-ltp-msgctl08.patch
linux-next.patch
w35und-remove-unused-code-from-wbsoft_configure_filter.patch
w35und-unregister-device-from-the-ieee80211-stack-upon-disconnect.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
slab-leaks3-default-y.patch

