From: akpm@linux-foundation.org
Subject: + drivers-platform-x86-thinkpad_acpic-handle-hkey-event-0x6040.patch added to -mm tree
Date: Mon, 25 Feb 2013 16:53:01 -0800
Message-ID: <20130226005301.AAB0031C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:38153 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3BZAxD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 19:53:03 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so380737ggn.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 16:53:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richih.mailinglist@gmail.com, bp@alien8.de, hmh@hmh.eng.br, mjg@redhat.com


The patch titled
     Subject: drivers/platform/x86/thinkpad_acpi.c: handle HKEY event 0x6040
has been added to the -mm tree.  Its filename is
     drivers-platform-x86-thinkpad_acpic-handle-hkey-event-0x6040.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: drivers/platform/x86/thinkpad_acpi.c: handle HKEY event 0x6040

Handle HKEY event generated on AC power change.  The current message asks
users to submit data related to this event which leads to a lot of
confusion and noise on the mailing list.

The following is a list affected models and 'Message-Id' from
ibm-acpi-devel@lists.sourceforge.net of people who saw this event when
either plugging or unplugging the AC adapter or docking or undocking their
laptop.

X120e - CAAAujb5v9dHdbdxDVvhNJoG4UrZC1TgKqeB_zGpAy7q8kZHMEQ@mail.gmail.com
X121e - 20120817143459.GB3462@x1.osrc.amd.com
X220  - Confirmed by Richard Hartmann
X220i - 4F406274.7070807@gmail.com
X220t - 4F489F5B.9040705@cs.tu-berlin.de
X230  - CAKx4u7kqvVH0-gstomsiVYdGC0i6=bGxzaQ8sq9gbg76TGme3w@mail.gmail.com
T420  - 9c848ee30b006737d0534d906bab0cf6@niklaas-baudet.net
T420s - 20120608080824.GS25324@hexapodia.org
W520  - 20121008181050.GF2549@ericlaptop.home.christensenplace.us

Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/thinkpad_acpi.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/platform/x86/thinkpad_acpi.c~drivers-platform-x86-thinkpad_acpic-handle-hkey-event-0x6040 drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~drivers-platform-x86-thinkpad_acpic-handle-hkey-event-0x6040
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -209,9 +209,8 @@ enum tpacpi_hkey_event_t {
 	TP_HKEY_EV_ALARM_SENSOR_XHOT	= 0x6022, /* sensor critically hot */
 	TP_HKEY_EV_THM_TABLE_CHANGED	= 0x6030, /* thermal table changed */
 
-	TP_HKEY_EV_UNK_6040		= 0x6040, /* Related to AC change?
-						     some sort of APM hint,
-						     W520 */
+	/* AC-related events */
+	TP_HKEY_EV_AC_CHANGED		= 0x6040, /* AC status changed */
 
 	/* Misc */
 	TP_HKEY_EV_RFKILL_CHANGED	= 0x7000, /* rfkill switch changed */
@@ -3629,6 +3628,12 @@ static bool hotkey_notify_6xxx(const u32
 			 "a sensor reports something is extremely hot!\n");
 		/* recommended action: immediate sleep/hibernate */
 		break;
+	case TP_HKEY_EV_AC_CHANGED:
+		/* X120e, X121e, X220, X220i, X220t, X230, T420, T420s, W520:
+		 * AC status changed; can be triggered by plugging or
+		 * unplugging AC adapter, docking or undocking. */
+
+		/* fallthrough */
 
 	case TP_HKEY_EV_KEY_NUMLOCK:
 	case TP_HKEY_EV_KEY_FN:
_

Patches currently in -mm which might be from richih.mailinglist@gmail.com are

drivers-platform-x86-thinkpad_acpic-handle-hkey-event-0x6040.patch

