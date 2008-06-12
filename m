From: akpm@linux-foundation.org
Subject: + pm-boot-time-suspend-selftest-vs-linux-next.patch added to -mm tree
Date: Thu, 12 Jun 2008 16:36:14 -0700
Message-ID: <200806122336.m5CNaEOQ013607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218AbYFLXhB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 19:37:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthltc@us.ibm.com, dbrownell@users.sourceforge.net, greg@kroah.com, mingo@elte.hu, pavel@suse.cz, rjw@sisk.pl


The patch titled
     PM: for-mm: Fix compile failure in boot time suspend selftest
has been added to the -mm tree.  Its filename is
     pm-boot-time-suspend-selftest-vs-linux-next.patch

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
Subject: PM: for-mm: Fix compile failure in boot time suspend selftest
From: Matt Helsley <matthltc@us.ibm.com>

The following config revealed a compilation problem in the suspend
self test program included in 2.6.26-rc5-mm2:

kernel/power/main.c: In function 'test_suspend':
kernel/power/main.c:688: warning: passing argument 2 of 'class_find_device' from incompatible pointer type
kernel/power/main.c:688: error: too few arguments to function 'class_find_device'
make[2]: *** [kernel/power/main.o] Error 1

#
# Power management options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set

Fix the compilation error by using NULL to tell
class_find_device() that we're initiating an iteration rather than
resuming a previously-initiated one.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/power/main.c~pm-boot-time-suspend-selftest-vs-linux-next kernel/power/main.c
--- a/kernel/power/main.c~pm-boot-time-suspend-selftest-vs-linux-next
+++ a/kernel/power/main.c
@@ -685,7 +685,7 @@ static int __init test_suspend(void)
 	}
 
 	/* RTCs have initialized by now too ... can we use one? */
-	class_find_device(rtc_class, &pony, has_wakealarm);
+	class_find_device(rtc_class, NULL, &pony, has_wakealarm);
 	if (pony)
 		rtc = rtc_class_open(pony);
 	if (!rtc) {
_

Patches currently in -mm which might be from matthltc@us.ibm.com are

pm-boot-time-suspend-selftest-vs-linux-next.patch

