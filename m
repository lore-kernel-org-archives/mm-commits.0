From: akpm@linux-foundation.org
Subject: - clocksource-make-clocksource_mask-bullet-proof.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:40:54 -0800
Message-ID: <200712172340.lBHNes3a008329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55360 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937657AbXLQX5b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:57:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: Make CLOCKSOURCE_MASK bullet-proof
has been removed from the -mm tree.  Its filename was
     clocksource-make-clocksource_mask-bullet-proof.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clocksource: Make CLOCKSOURCE_MASK bullet-proof
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clocksource.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/clocksource.h~clocksource-make-clocksource_mask-bullet-proof include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-make-clocksource_mask-bullet-proof
+++ a/include/linux/clocksource.h
@@ -103,7 +103,7 @@ struct clocksource {
 #define CLOCK_SOURCE_VALID_FOR_HRES		0x20
 
 /* simplify initialization of mask field */
-#define CLOCKSOURCE_MASK(bits) (cycle_t)(bits<64 ? ((1ULL<<bits)-1) : -1)
+#define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
 
 /**
  * clocksource_khz2mult - calculates mult from khz and shift
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
git-mips.patch
git-watchdog.patch
git-x86.patch
