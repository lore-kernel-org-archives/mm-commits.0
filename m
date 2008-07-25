From: akpm@linux-foundation.org
Subject: + pm-selftest-rtc-paranoia.patch added to -mm tree
Date: Fri, 25 Jul 2008 14:50:49 -0700
Message-ID: <200807252150.m6PLonRP000463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934AbYGYVu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 17:50:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net


The patch titled
     pm selftest:  rtc paranoia
has been added to the -mm tree.  Its filename is
     pm-selftest-rtc-paranoia.patch

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
Subject: pm selftest:  rtc paranoia
From: David Brownell <dbrownell@users.sourceforge.net>

Cope with a quirk of some RTCs (notably ACPI ones) which aren't guaranteed
to implement oneshot behavior when they woke the system from sleeep:
forcibly disable the alarm, just in case.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/main.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN kernel/power/main.c~pm-selftest-rtc-paranoia kernel/power/main.c
--- a/kernel/power/main.c~pm-selftest-rtc-paranoia
+++ a/kernel/power/main.c
@@ -635,6 +635,13 @@ static void __init test_wakealarm(struct
 	}
 	if (status < 0)
 		printk(err_suspend, status);
+
+	/* Some platforms can't detect that the alarm triggered the
+	 * wakeup, or (accordingly) disable it after it afterwards.
+	 * It's supposed to give oneshot behavior; cope.
+	 */
+	alm.enabled = false;
+	rtc_set_alarm(rtc, &alm);
 }
 
 static int __init has_wakealarm(struct device *dev, void *name_ptr)
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
drivers-power-fix-platform-driver-hotplug-coldplug.patch
mfd-fix-platform-driver-hotplug-coldplug.patch
parport-fix-platform-driver-hotplug-coldplug.patch
gpio-sysfs-interface-updated.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch
gpio-max732x-driver.patch
pm-selftest-rtc-paranoia.patch
linux-next.patch

