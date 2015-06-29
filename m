From: akpm@linux-foundation.org
Subject: [merged]
 mm-kmemleak-do-not-acquire-scan_mutex-in-kmemleak_do_cleanup.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:39:20 -0700
Message-ID: <5591acf8.4sM3C4KyRC0QXogT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbbF2UjU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: do not acquire scan_mutex in kmemleak_do_cleanup()
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-do-not-acquire-scan_mutex-in-kmemleak_do_cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: kmemleak: do not acquire scan_mutex in kmemleak_do_cleanup()

The kmemleak_do_cleanup() work thread already waits for the kmemleak_scan
thread to finish via kthread_stop().  Waiting in kthread_stop() while
scan_mutex is held may lead to deadlock if kmemleak_scan_thread() also
waits to acquire for scan_mutex.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/kmemleak.c~mm-kmemleak-do-not-acquire-scan_mutex-in-kmemleak_do_cleanup mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleak-do-not-acquire-scan_mutex-in-kmemleak_do_cleanup
+++ a/mm/kmemleak.c
@@ -1762,7 +1762,6 @@ static void __kmemleak_do_cleanup(void)
  */
 static void kmemleak_do_cleanup(struct work_struct *work)
 {
-	mutex_lock(&scan_mutex);
 	stop_scan_thread();
 
 	/*
@@ -1777,7 +1776,6 @@ static void kmemleak_do_cleanup(struct w
 	else
 		pr_info("Kmemleak disabled without freeing internal data. "
 			"Reclaim the memory with \"echo clear > /sys/kernel/debug/kmemleak\"\n");
-	mutex_unlock(&scan_mutex);
 }
 
 static DECLARE_WORK(cleanup_work, kmemleak_do_cleanup);
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch

