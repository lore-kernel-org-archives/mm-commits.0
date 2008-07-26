From: akpm@linux-foundation.org
Subject: - pm-selftest-rtc-paranoia.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:10 -0700
Message-ID: <200807262113.m6QLDA5p019576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757403AbYGZVNS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:13:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     pm selftest:  rtc paranoia
has been removed from the -mm tree.  Its filename was
     pm-selftest-rtc-paranoia.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

