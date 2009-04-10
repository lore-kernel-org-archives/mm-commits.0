From: akpm@linux-foundation.org
Subject: + timers-allow-deferrable-timers-for-intervals-tv2-tv5-to-be-deferred.patch added to -mm tree
Date: Fri, 10 Apr 2009 16:03:33 -0700
Message-ID: <200904102303.n3AN3XsG006170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751758AbZDJXGu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 19:06:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jon-hunter@ti.com, mingo@elte.hu, tglx@linutronix.de, venkatesh.pallipadi@intel.com


The patch titled
     timers: allow deferrable timers for intervals tv2-tv5 to be deferred
has been added to the -mm tree.  Its filename is
     timers-allow-deferrable-timers-for-intervals-tv2-tv5-to-be-deferred.patch

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
Subject: timers: allow deferrable timers for intervals tv2-tv5 to be deferred
From: Jon Hunter <jon-hunter@ti.com>

In the current kernel implementation only kernel timers for time interval
tv1 are being deferred.  This patch allows any timer that is configured as
deferrable to be defer regardless of time interval.

This patch was previously discussed in
http://marc.info/?l=linux-kernel&m=123196343531966&w=2 and was acked by
Venki Pallipadi, the author of the original deferrable timer patch.

Signed-off-by: Jon Hunter <jon-hunter@ti.com>
Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/timer.c~timers-allow-deferrable-timers-for-intervals-tv2-tv5-to-be-deferred kernel/timer.c
--- a/kernel/timer.c~timers-allow-deferrable-timers-for-intervals-tv2-tv5-to-be-deferred
+++ a/kernel/timer.c
@@ -1015,6 +1015,9 @@ cascade:
 		index = slot = timer_jiffies & TVN_MASK;
 		do {
 			list_for_each_entry(nte, varp->vec + slot, entry) {
+				if (tbase_get_deferrable(nte->base))
+					continue;
+
 				found = 1;
 				if (time_before(nte->expires, expires))
 					expires = nte->expires;
_

Patches currently in -mm which might be from jon-hunter@ti.com are

timers-allow-deferrable-timers-for-intervals-tv2-tv5-to-be-deferred.patch

