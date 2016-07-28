From: akpm@linux-foundation.org
Subject: [patch 081/101] kmemleak: don't hang if user disables scanning
 early
Date: Thu, 28 Jul 2016 15:48:32 -0700
Message-ID: <579a8bc0.pxOpo7252FyjO5yd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbcG1Wsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:48:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vegard.nossum@oracle.com, catalin.marinas@arm.com

From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: kmemleak: don't hang if user disables scanning early

If the user tries to disable automatic scanning early in the boot
process using e.g.:

  echo scan=off > /sys/kernel/debug/kmemleak

then this command will hang until SECS_FIRST_SCAN (= 60) seconds have
elapsed, even though the system is fully initialised.

We can fix this using interruptible sleep and checking if we're
supposed to stop whenever we wake up (like the rest of the code does).

Link: http://lkml.kernel.org/r/1468835005-2873-1-git-send-email-vegard.nossum@oracle.com
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/kmemleak.c~kmemleak-dont-hang-if-user-disables-scanning-early mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-dont-hang-if-user-disables-scanning-early
+++ a/mm/kmemleak.c
@@ -1485,8 +1485,10 @@ static int kmemleak_scan_thread(void *ar
 	 * Wait before the first scan to allow the system to fully initialize.
 	 */
 	if (first_run) {
+		signed long timeout = msecs_to_jiffies(SECS_FIRST_SCAN * 1000);
 		first_run = 0;
-		ssleep(SECS_FIRST_SCAN);
+		while (timeout && !kthread_should_stop())
+			timeout = schedule_timeout_interruptible(timeout);
 	}
 
 	while (!kthread_should_stop()) {
_
