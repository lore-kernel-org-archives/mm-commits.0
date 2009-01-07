From: akpm@linux-foundation.org
Subject: - parport-ieee1284-use-del_timer_sync-in-parport_wait_event.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:21:11 -0800
Message-ID: <200901072221.n07MLB7O020336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758495AbZAGWWL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:22:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     parport: ieee1284: use del_timer_sync() in parport_wait_event()
has been removed from the -mm tree.  Its filename was
     parport-ieee1284-use-del_timer_sync-in-parport_wait_event.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport: ieee1284: use del_timer_sync() in parport_wait_event()
From: Michael Buesch <mb@bu3sch.de>

Use del_timer_sync() instead of del_timer() to make sure the timer won't
be running when we return from parport_wait_event(), because this would
crash due to destruction of timer_list.

This is untested and just based on a code review.  Just think about the
following sequence of events:

- add_timer()

- down_interruptible() is interrupted by a signal.

- we enter the timer callback handler on another CPU.

- del_timer(), but the timer callback is still running.

- eturn from parport_wait_even, which destroys the automatic variable
  "timer" while the callback is running on another CPU.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/ieee1284.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/parport/ieee1284.c~parport-ieee1284-use-del_timer_sync-in-parport_wait_event drivers/parport/ieee1284.c
--- a/drivers/parport/ieee1284.c~parport-ieee1284-use-del_timer_sync-in-parport_wait_event
+++ a/drivers/parport/ieee1284.c
@@ -84,7 +84,7 @@ int parport_wait_event (struct parport *
 
 	add_timer (&timer);
 	ret = down_interruptible (&port->physport->ieee1284.irq);
-	if (!del_timer (&timer) && !ret)
+	if (!del_timer_sync(&timer) && !ret)
 		/* Timed out. */
 		ret = 1;
 
_

Patches currently in -mm which might be from mb@bu3sch.de are

origin.patch

