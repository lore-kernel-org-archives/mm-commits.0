From: akpm@linux-foundation.org
Subject: [merged] clockevent-export-register_device-and-delta2ns.patch removed from -mm tree
Date: Thu, 07 May 2009 12:16:40 -0700
Message-ID: <200905071916.n47JGeqE020555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754660AbZEGTVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:21:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@igel.co.jp, johnstul@us.ibm.com, lethal@linux-sh.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clockevent: export register_device and delta2ns
has been removed from the -mm tree.  Its filename was
     clockevent-export-register_device-and-delta2ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

