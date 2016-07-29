From: akpm@linux-foundation.org
Subject: [merged] kmemleak-dont-hang-if-user-disables-scanning-early.patch removed from -mm tree
Date: Fri, 29 Jul 2016 11:56:52 -0700
Message-ID: <579ba6f4.tQFnitLVGpgluyjz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbcG2S4x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:56:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@oracle.com, catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak: don't hang if user disables scanning early
has been removed from the -mm tree.  Its filename was
     kmemleak-dont-hang-if-user-disables-scanning-early.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from vegard.nossum@oracle.com are

kcov-allow-more-fine-grained-coverage-instrumentation.patch

