From: akpm@linux-foundation.org
Subject: + fix-timer_stats-printout-of-events-sec.patch added to -mm tree
Date: Thu, 04 Oct 2007 12:21:23 -0700
Message-ID: <200710041921.l94JLNCF024893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33587 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756303AbXJDTVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 15:21:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, akpm@linux-foundation.org, mingo@elte.hu


The patch titled
     Fix timer_stats printout of events/sec
has been added to the -mm tree.  Its filename is
     fix-timer_stats-printout-of-events-sec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix timer_stats printout of events/sec
From: Anton Blanchard <anton@samba.org>

When using /proc/timer_stats on ppc64 I noticed the events/sec field wasnt
accurate.  Sometimes the integer part was incorrect due to rounding (we
werent taking the fractional seconds into consideration).

The fraction part is also wrong, we need to pad the printf statement and
take the bottom three digits of 1000 times the value.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

origin.patch
fix-timer_stats-printout-of-events-sec.patch
git-infiniband.patch
