From: akpm@linux-foundation.org
Subject: - pm-boot-time-suspend-selftest-vs-linux-next.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:21:44 -0700
Message-ID: <200807232334.m6NNYLSF017906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755743AbYGWXfh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:35:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthltc@us.ibm.com, dbrownell@users.sourceforge.net, greg@kroah.com, mingo@elte.hu, pavel@suse.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     PM: for-mm: Fix compile failure in boot time suspend selftest
has been removed from the -mm tree.  Its filename was
     pm-boot-time-suspend-selftest-vs-linux-next.patch

This patch was dropped because it was folded into pm-boot-time-suspend-selftest.patch

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
@@ -687,7 +687,7 @@ static int __init test_suspend(void)
 	}
 
 	/* RTCs have initialized by now too ... can we use one? */
-	class_find_device(rtc_class, &pony, has_wakealarm);
+	class_find_device(rtc_class, NULL, &pony, has_wakealarm);
 	if (pony)
 		rtc = rtc_class_open(pony);
 	if (!rtc) {
_

Patches currently in -mm which might be from matthltc@us.ibm.com are

pm-boot-time-suspend-selftest.patch
pm-boot-time-suspend-selftest-vs-linux-next.patch

