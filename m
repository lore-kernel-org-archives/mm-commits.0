From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-fix-race-between-proc_watchdog_thresh-and-watchdog_timer_fn.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:06:26 -0800
Message-ID: <563d0842.9D4BUhuCViMJt5EF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033447AbbKFUG0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: fix race between proc_watchdog_thresh() and watchdog_timer_fn()
has been removed from the -mm tree.  Its filename was
     watchdog-fix-race-between-proc_watchdog_thresh-and-watchdog_timer_fn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: kernel/watchdog.c: fix race between proc_watchdog_thresh() and watchdog_timer_fn()

Theoretically it is possible that the watchdog timer expires right at the
time when a user sets 'watchdog_thresh' to zero (note: this disables the
lockup detectors).  In this scenario, the is_softlockup() function - which
is called by the timer - could produce a false positive.

Fix this by checking the current value of 'watchdog_thresh'.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/watchdog.c~watchdog-fix-race-between-proc_watchdog_thresh-and-watchdog_timer_fn kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-fix-race-between-proc_watchdog_thresh-and-watchdog_timer_fn
+++ a/kernel/watchdog.c
@@ -289,7 +289,7 @@ static int is_softlockup(unsigned long t
 {
 	unsigned long now = get_timestamp();
 
-	if (watchdog_enabled & SOFT_WATCHDOG_ENABLED) {
+	if ((watchdog_enabled & SOFT_WATCHDOG_ENABLED) && watchdog_thresh){
 		/* Warn about unreasonable delays. */
 		if (time_after(now, touch_ts + get_softlockup_thresh()))
 			return now - touch_ts;
_

Patches currently in -mm which might be from uobergfe@redhat.com are


