From: akpm@linux-foundation.org
Subject: + clockevent-export-register_device-and-delta2ns.patch added to -mm tree
Date: Mon, 04 May 2009 14:24:06 -0700
Message-ID: <200905042124.n44LO6gu001609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515AbZEDV2J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 17:28:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@igel.co.jp, johnstul@us.ibm.com, lethal@linux-sh.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     clockevent: export register_device and delta2ns
has been added to the -mm tree.  Its filename is
     clockevent-export-register_device-and-delta2ns.patch

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
Subject: clockevent: export register_device and delta2ns
From: Magnus Damm <damm@igel.co.jp>

Export the following symbols using EXPORT_SYMBOL_GPL:
 - clockevent_delta2ns
 - clockevents_register_device

This allows us to build SuperH clockevent and clocksource drivers as
modules, see drivers/clocksource/sh_*.c

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clockevents.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/time/clockevents.c~clockevent-export-register_device-and-delta2ns kernel/time/clockevents.c
--- a/kernel/time/clockevents.c~clockevent-export-register_device-and-delta2ns
+++ a/kernel/time/clockevents.c
@@ -54,6 +54,7 @@ unsigned long clockevent_delta2ns(unsign
 
 	return (unsigned long) clc;
 }
+EXPORT_SYMBOL_GPL(clockevent_delta2ns);
 
 /**
  * clockevents_set_mode - set the operating mode of a clock event device
@@ -187,6 +188,7 @@ void clockevents_register_device(struct 
 
 	spin_unlock(&clockevents_lock);
 }
+EXPORT_SYMBOL_GPL(clockevents_register_device);
 
 /*
  * Noop handler when we shut down an event device
_

Patches currently in -mm which might be from damm@igel.co.jp are

linux-next.patch
clockevent-export-register_device-and-delta2ns.patch

