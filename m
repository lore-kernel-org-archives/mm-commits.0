From: akpm@linux-foundation.org
Subject: + kernel-time-tick-broadcastc-tick_broadcast_device-can-become-static.patch added to -mm tree
Date: Mon, 30 Mar 2009 16:04:18 -0700
Message-ID: <200903302304.n2UN4I2r016934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754089AbZC3XHF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 19:07:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitri.vorobiev@movial.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     kernel/time/tick-broadcast.c tick_broadcast_device can become static
has been added to the -mm tree.  Its filename is
     kernel-time-tick-broadcastc-tick_broadcast_device-can-become-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
kernel-time-tick-broadcastc-tick_broadcast_device-can-become-static.patch

