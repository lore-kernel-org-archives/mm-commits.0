From: akpm@linux-foundation.org
Subject: [merged] kernel-time-tick-broadcastc-tick_broadcast_device-can-become-static.patch removed from -mm tree
Date: Thu, 07 May 2009 12:16:34 -0700
Message-ID: <200905071916.n47JGYdR020390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762461AbZEGT3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:29:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitri.vorobiev@movial.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     kernel/time/tick-broadcast.c tick_broadcast_device can become static
has been removed from the -mm tree.  Its filename was
     kernel-time-tick-broadcastc-tick_broadcast_device-can-become-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/time/tick-broadcast.c tick_broadcast_device can become static
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>

The variable tick_broadcast_device is not used outside of the
file where it is defined, so let's make it static.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-broadcast.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/tick-broadcast.c~kernel-time-tick-broadcastc-tick_broadcast_device-can-become-static kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~kernel-time-tick-broadcastc-tick_broadcast_device-can-become-static
+++ a/kernel/time/tick-broadcast.c
@@ -27,7 +27,7 @@
  * timer stops in C3 state.
  */
 
-struct tick_device tick_broadcast_device;
+static struct tick_device tick_broadcast_device;
 /* FIXME: Use cpumask_var_t. */
 static DECLARE_BITMAP(tick_broadcast_mask, NR_CPUS);
 static DECLARE_BITMAP(tmpmask, NR_CPUS);
_

Patches currently in -mm which might be from dmitri.vorobiev@movial.com are

linux-next.patch

