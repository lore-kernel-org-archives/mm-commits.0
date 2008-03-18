From: akpm@linux-foundation.org
Subject: + arch-alpha-kernel-trapsc-use-time_-macros.patch added to -mm tree
Date: Mon, 17 Mar 2008 21:18:33 -0700
Message-ID: <200803180418.m2I4IX2W013741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580AbYCRETm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 00:19:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: caglar@pardus.org.tr, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     arch/alpha/kernel/traps.c: use time_* macros
has been added to the -mm tree.  Its filename is
     arch-alpha-kernel-trapsc-use-time_-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/alpha/kernel/traps.c: use time_* macros
From: S.Caglar Onur <caglar@pardus.org.tr>

The functions time_before, time_before_eq, time_after, and time_after_eq are
more robust for comparing jiffies against other values.

So implement usage of the time_after() macro, defined in linux/jiffies.h,
which deals with wrapping correctly

Signed-off-by: S.Caglar Onur <caglar@pardus.org.tr>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/traps.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/alpha/kernel/traps.c~arch-alpha-kernel-trapsc-use-time_-macros arch/alpha/kernel/traps.c
--- a/arch/alpha/kernel/traps.c~arch-alpha-kernel-trapsc-use-time_-macros
+++ a/arch/alpha/kernel/traps.c
@@ -8,6 +8,7 @@
  * This file initializes the trap entry points
  */
 
+#include <linux/jiffies.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
@@ -781,7 +782,7 @@ do_entUnaUser(void __user * va, unsigned
 	   with the unaliged access.  */
 
 	if (!test_thread_flag (TIF_UAC_NOPRINT)) {
-		if (cnt >= 5 && jiffies - last_time > 5*HZ) {
+		if (cnt >= 5 && time_after(jiffies, last_time + 5 * HZ)) {
 			cnt = 0;
 		}
 		if (++cnt < 5) {
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

arch-alpha-kernel-trapsc-use-time_-macros.patch
arch-ia64-kernel-use-time_-macros.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
arch-powerpc-platforms-iseries-pcic-use-time_-macros.patch
drivers-net-arcnet-arcnetc-use-time_-macros.patch
drivers-net-tokenring-3c359c-use-time_-macros.patch
drivers-net-wireless-atmelc-use-time_-macros.patch
fs-binfmt_aoutc-use-printk_ratelimit.patch
fix-indentation.patch

