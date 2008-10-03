From: akpm@linux-foundation.org
Subject: - usb-improve-ehci_watchdogs-side-effect-in-cpu-power-management.patch removed from -mm tree
Date: Fri, 03 Oct 2008 14:29:10 -0700
Message-ID: <200810032129.m93LTArg016669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753261AbYJCV3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 17:29:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yi.y.yang@intel.com, david-b@pacbell.net, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb: improve ehci_watchdog's side effect in CPU power management
has been removed from the -mm tree.  Its filename was
     usb-improve-ehci_watchdogs-side-effect-in-cpu-power-management.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: improve ehci_watchdog's side effect in CPU power management
From: Yi Yang <yi.y.yang@intel.com>

ehci_watchdog will wake up CPU very frequently so that CPU stays at C3
very short, average residence time is about 50 ms on Aspire One, but we
expect it should be about 1 second or more, so this kind of periodic timer
is very bad for power saving.

We can't remove this timer because of some bad USB controller chipset, but
at least we should reduce its side effect to as low as possible.

This patch can make CPU stay at C3 longer, average residence time is about
twice as long as original.

Signed-off-by: Yi Yang <yi.y.yang@intel.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ehci.h |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/usb/host/ehci.h~usb-improve-ehci_watchdogs-side-effect-in-cpu-power-management drivers/usb/host/ehci.h
--- a/drivers/usb/host/ehci.h~usb-improve-ehci_watchdogs-side-effect-in-cpu-power-management
+++ a/drivers/usb/host/ehci.h
@@ -181,14 +181,16 @@ timer_action (struct ehci_hcd *ehci, enu
 	 * the async ring; just the I/O watchdog.  Note that if a
 	 * SHRINK were pending, OFF would never be requested.
 	 */
-	if (timer_pending(&ehci->watchdog)
-			&& ((BIT(TIMER_ASYNC_SHRINK) | BIT(TIMER_ASYNC_OFF))
-				& ehci->actions))
-		return;
+	enum ehci_timer_action oldactions = ehci->actions;
 
 	if (!test_and_set_bit (action, &ehci->actions)) {
 		unsigned long t;
 
+		if (timer_pending(&ehci->watchdog)
+			&& ((BIT(TIMER_ASYNC_SHRINK) | BIT(TIMER_ASYNC_OFF))
+				& oldactions))
+			return;
+
 		switch (action) {
 		case TIMER_IO_WATCHDOG:
 			t = EHCI_IO_JIFFIES;
@@ -204,7 +206,7 @@ timer_action (struct ehci_hcd *ehci, enu
 			t = DIV_ROUND_UP(EHCI_SHRINK_FRAMES * HZ, 1000) + 1;
 			break;
 		}
-		mod_timer(&ehci->watchdog, t + jiffies);
+		mod_timer(&ehci->watchdog, round_jiffies(t + jiffies));
 	}
 }
 
_

Patches currently in -mm which might be from yi.y.yang@intel.com are

git-acpi.patch
lib-pull-base-guessing-logic-to-helper-function.patch
lib-trivial-whitespace-tidy.patch
lib-remove-defining-macros-for-strict_strto.patch

