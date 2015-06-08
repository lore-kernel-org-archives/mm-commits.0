From: akpm@linux-foundation.org
Subject: +
 mm-kmemleak-do-not-acquire-scan_mutex-in-kmemleak_do_cleanup.patch added to -mm tree
Date: Mon, 08 Jun 2015 14:50:57 -0700
Message-ID: <55760e41.HhYL81ohmKlapJ39%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbbFHVu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2015 17:50:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: do not acquire scan_mutex in kmemleak_do_cleanup()
has been added to the -mm tree.  Its filename is
     mm-kmemleak-do-not-acquire-scan_mutex-in-kmemleak_do_cleanup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-do-not-acquire-scan_mutex-in-kmemleak_do_cleanup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-do-not-acquire-scan_mutex-in-kmemleak_do_cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch
mm-kmemleak-allow-safe-memory-scanning-during-kmemleak-disabling.patch
mm-kmemleak-fix-delete_object_-race-when-called-on-the-same-memory-block.patch
mm-kmemleak-do-not-acquire-scan_mutex-in-kmemleak_do_cleanup.patch
mm-kmemleak-avoid-deadlock-on-the-kmemleak-object-insertion-error-path.patch
linux-next.patch

