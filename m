From: akpm@linux-foundation.org
Subject: - vsyscall-time-fix.patch removed from -mm tree
Date: Mon, 21 May 2007 13:09:49 -0700
Message-ID: <200705212009.l4LK9mBK018787@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44981 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765349AbXEUUMn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 16:12:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, sripathi@in.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     vsyscall time() fix
has been removed from the -mm tree.  Its filename was
     vsyscall-time-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vsyscall time() fix
From: john stultz <johnstul@us.ibm.com>

The vsyscall time() function basically returns the second portion of xtime
directly.  This however means that there is about a ticks worth of time each
second where time() will return a second value less then what gettimeofday()
does.

Additionally, this window where vtime() is behind vgettimeofday() grows when
dynticks is enabled.

Big thanks to Sripathi for noticing this issue and creating a test case to
work with!


This patch changes the vtime() implementation to call vgettimeofday(), much as
syscall time() implementation calls gettimeofday().

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Sripathi Kodi <sripathi@in.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/vsyscall.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/vsyscall.c~vsyscall-time-fix arch/x86_64/kernel/vsyscall.c
--- a/arch/x86_64/kernel/vsyscall.c~vsyscall-time-fix
+++ a/arch/x86_64/kernel/vsyscall.c
@@ -161,10 +161,13 @@ int __vsyscall(0) vgettimeofday(struct t
  * unlikely */
 time_t __vsyscall(1) vtime(time_t *t)
 {
+	struct timeval tv;
 	time_t result;
 	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
 		return time_syscall(t);
-	result = __vsyscall_gtod_data.wall_time_sec;
+
+	vgettimeofday(&tv, 0);
+	result = tv.tv_sec;
 	if (t)
 		*t = result;
 	return result;
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
i386-hpet-check-if-the-counter-works.patch
introduce-boot-based-time.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix-2.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix-3.patch
use-boot-based-time-for-uptime-in-proc.patch
