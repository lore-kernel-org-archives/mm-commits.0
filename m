From: akpm@linux-foundation.org
Subject: + fix-no_sync_cmos_clock-logic-inversion-in-kernel-time-ntpc.patch added to -mm tree
Date: Tue, 11 Sep 2007 11:50:49 -0700
Message-ID: <200709111850.l8BIoo2W023774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37862 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760749AbXIKSwf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 14:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tony@bakeyournoodle.com, johnstul@us.ibm.com, paubert@iram.es, paulus@samba.org, tglx@linutronix.de, zach@vmware.com


The patch titled
     Fix "no_sync_cmos_clock"  logic inversion in kernel/time/ntp.c
has been added to the -mm tree.  Its filename is
     fix-no_sync_cmos_clock-logic-inversion-in-kernel-time-ntpc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix "no_sync_cmos_clock"  logic inversion in kernel/time/ntp.c
From: tony@bakeyournoodle.com (Tony Breeds)

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
 1 file changed, 1 insertion(+), 1 deletion(-)

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

fix-no_sync_cmos_clock-logic-inversion-in-kernel-time-ntpc.patch
mkmakefile-include-arch-on-o=-builds.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
