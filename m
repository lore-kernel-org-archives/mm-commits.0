From: akpm@linux-foundation.org
Subject: + pm-serio-speed-up-resume.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:40:57 -0700
Message-ID: <200807111846.m6BIkcUW031021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755611AbYGKSqz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:46:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, dtor@mail.ru, lenb@kernel.org, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     pm: serio: speed up resume
has been added to the -mm tree.  Its filename is
     pm-serio-speed-up-resume.patch

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
Subject: pm: serio: speed up resume
From: Shaohua Li <shaohua.li@intel.com>

Subject: serio: Speed-up resume
serio_resume will call into psmouse_extensions(). In my test, the
routine is very slow, it blocks resume about 1 sec. Below patch (move
resume to kseriod, just like boot time probe) cures the issue in my
test, and seems no side effect. I'm no familiar with serio driver, so
please check.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Len Brown <lenb@kernel.org>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Dmitry Torokhov <dtor@mail.ru>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/serio.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff -puN drivers/input/serio/serio.c~pm-serio-speed-up-resume drivers/input/serio/serio.c
--- a/drivers/input/serio/serio.c~pm-serio-speed-up-resume
+++ a/drivers/input/serio/serio.c
@@ -163,6 +163,7 @@ enum serio_event_type {
 	SERIO_RECONNECT_PORT,
 	SERIO_REGISTER_PORT,
 	SERIO_ATTACH_DRIVER,
+	SERIO_RESUME_PORT,
 };
 
 struct serio_event {
@@ -287,6 +288,13 @@ static struct serio_event *serio_get_eve
 	return event;
 }
 
+#ifdef CONFIG_PM
+static void serio_resume_port(struct device *dev);
+#else
+static inline void serio_resume_port(struct device *dev)
+{
+}
+#endif /* CONFIG_PM */
 static void serio_handle_event(void)
 {
 	struct serio_event *event;
@@ -319,6 +327,10 @@ static void serio_handle_event(void)
 				serio_attach_driver(event->object);
 				break;
 
+			case SERIO_RESUME_PORT:
+				serio_resume_port(event->object);
+				break;
+
 			default:
 				break;
 		}
@@ -925,21 +937,26 @@ static int serio_suspend(struct device *
 	return 0;
 }
 
-static int serio_resume(struct device *dev)
+static void serio_resume_port(struct device *dev)
 {
 	struct serio *serio = to_serio_port(dev);
 
-	if (dev->power.power_state.event != PM_EVENT_ON &&
-	    serio_reconnect_driver(serio)) {
-		/*
-		 * Driver re-probing can take a while, so better let kseriod
-		 * deal with it.
-		 */
-		serio_rescan(serio);
+	if (serio_reconnect_driver(serio)) {
+		serio_disconnect_port(serio);
+		serio_find_driver(serio);
 	}
 
 	dev->power.power_state = PMSG_ON;
+}
 
+static int serio_resume(struct device *dev)
+{
+	/*
+	 * Driver reconnect can take a while, so better let kseriod
+	 * deal with it.
+	 */
+	if (dev->power.power_state.event != PM_EVENT_ON)
+		serio_queue_event(dev, NULL, SERIO_RESUME_PORT);
 	return 0;
 }
 #endif /* CONFIG_PM */
_

Patches currently in -mm which might be from shaohua.li@intel.com are

linux-next.patch
pm-serio-speed-up-resume.patch
pm-acpi-hibernation-utilize-hardware-signature.patch

