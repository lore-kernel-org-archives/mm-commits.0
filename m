From: akpm@linux-foundation.org
Subject: + input-add-switch-for-dock-events.patch added to -mm tree
Date: Mon, 02 Jun 2008 16:21:33 -0700
Message-ID: <200806022321.m52NLXR6005047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754637AbYFBXWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2008 19:22:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg59@srcf.ucam.org, dtor@mail.ru, kristen.c.accardi@intel.com, lenb@kernel.org, mjg@redhat.com


The patch titled
     input: add switch for dock events
has been added to the -mm tree.  Its filename is
     input-add-switch-for-dock-events.patch

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
Subject: input: add switch for dock events
From: Matthew Garrett <mjg59@srcf.ucam.org>

Add a SW_DOCK switch to input.h.  ACPI docks currently send their docking
status as a uevent, but not all docks are ACPI or correspond to a device. 
In that case, it makes more sense to simply generate an input event on
docking or undocking.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/input.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/input.h~input-add-switch-for-dock-events include/linux/input.h
--- a/include/linux/input.h~input-add-switch-for-dock-events
+++ a/include/linux/input.h
@@ -640,6 +640,7 @@ struct input_absinfo {
 #define SW_RFKILL_ALL		0x03  /* rfkill master switch, type "any"
 					 set = radio enabled */
 #define SW_RADIO		SW_RFKILL_ALL	/* deprecated */
+#define SW_DOCK			0x04  /* set = plugged into dock */
 #define SW_MAX			0x0f
 #define SW_CNT			(SW_MAX+1)
 
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

origin.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
bay-exit-if-notify-handler-cannot-be-installed.patch
input-add-switch-for-dock-events.patch
acpi-send-switch-event-on-dock-events.patch
resend-misc-add-hp-wmi-laptop-extras-driver.patch

