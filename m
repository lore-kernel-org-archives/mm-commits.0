From: akpm@linux-foundation.org
Subject: - fix-timer_stats-printout-of-events-sec.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:09:49 -0700
Message-ID: <200710102109.l9AL9nQS025808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52190 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757297AbXJJVKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:10:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Fix timer_stats printout of events/sec
has been removed from the -mm tree.  Its filename was
     fix-timer_stats-printout-of-events-sec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix timer_stats printout of events/sec
From: Anton Blanchard <anton@samba.org>

When using /proc/timer_stats on ppc64 I noticed the events/sec field wasnt
accurate.  Sometimes the integer part was incorrect due to rounding (we
werent taking the fractional seconds into consideration).

The fraction part is also wrong, we need to pad the printf statement and
take the bottom three digits of 1000 times the value.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_stats.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/time/timer_stats.c~fix-timer_stats-printout-of-events-sec kernel/time/timer_stats.c
--- a/kernel/time/timer_stats.c~fix-timer_stats-printout-of-events-sec
+++ a/kernel/time/timer_stats.c
@@ -327,8 +327,9 @@ static int tstats_show(struct seq_file *
 		ms = 1;
 
 	if (events && period.tv_sec)
-		seq_printf(m, "%ld total events, %ld.%ld events/sec\n", events,
-			   events / period.tv_sec, events * 1000 / ms);
+		seq_printf(m, "%ld total events, %ld.%03ld events/sec\n",
+			   events, events * 1000 / ms,
+			   (events * 1000000 / ms) % 1000);
 	else
 		seq_printf(m, "%ld total events\n", events);
 
_

Patches currently in -mm which might be from anton@samba.org are

git-infiniband.patch
