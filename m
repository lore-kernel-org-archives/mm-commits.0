From: akpm@linux-foundation.org
Subject: - fix-no_sync_cmos_clock-logic-inversion-in-kernel-time-ntpc.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:22 -0700
Message-ID: <200709160926.l8G9QMLD009178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33431 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401AbXIPJjn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:39:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony@bakeyournoodle.com, johnstul@us.ibm.com, paubert@iram.es, paulus@samba.org, tglx@linutronix.de, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     Fix "no_sync_cmos_clock"  logic inversion in kernel/time/ntp.c
has been removed from the -mm tree.  Its filename was
     fix-no_sync_cmos_clock-logic-inversion-in-kernel-time-ntpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix "no_sync_cmos_clock"  logic inversion in kernel/time/ntp.c
From: Tony Breeds <tony@bakeyournoodle.com>

Seems to me that this timer will only get started on platforms that say
they don't want it?

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Gabriel Paubert <paubert@iram.es>
Cc: Zachary Amsden <zach@vmware.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/ntp.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/ntp.c~fix-no_sync_cmos_clock-logic-inversion-in-kernel-time-ntpc kernel/time/ntp.c
--- a/kernel/time/ntp.c~fix-no_sync_cmos_clock-logic-inversion-in-kernel-time-ntpc
+++ a/kernel/time/ntp.c
@@ -226,7 +226,7 @@ static void sync_cmos_clock(unsigned lon
 
 static void notify_cmos_timer(void)
 {
-	if (no_sync_cmos_clock)
+	if (!no_sync_cmos_clock)
 		mod_timer(&sync_cmos_timer, jiffies + 1);
 }
 
_

Patches currently in -mm which might be from tony@bakeyournoodle.com are

origin.patch
mkmakefile-include-arch-on-o=-builds.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
