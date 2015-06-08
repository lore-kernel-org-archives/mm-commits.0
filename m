From: akpm@linux-foundation.org
Subject: +
 mm-kmemleak-allow-safe-memory-scanning-during-kmemleak-disabling.patch
 added to -mm tree
Date: Mon, 08 Jun 2015 14:50:53 -0700
Message-ID: <55760e3d.UA6rm+lUaVQelJx6%akpm__6756.15312434292$1433800284$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbbFHVuy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2015 17:50:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, stable@vger.kernel.org, vigneshr@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: allow safe memory scanning during kmemleak disabling
has been added to the -mm tree.  Its filename is
     mm-kmemleak-allow-safe-memory-scanning-during-kmemleak-disabling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-allow-safe-memory-scanning-during-kmemleak-disabling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-allow-safe-memory-scanning-during-kmemleak-disabling.patch

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
Subject: mm: kmemleak: allow safe memory scanning during kmemleak disabling

The kmemleak scanning thread can run for minutes.  Callbacks like
kmemleak_free() are allowed during this time, the race being taken care of
by the object->lock spinlock.  Such lock also prevents a memory block from
being freed or unmapped while it is being scanned by blocking the
kmemleak_free() -> ...  -> __delete_object() function until the lock is
released in scan_object().

When a kmemleak error occurs (e.g.  it fails to allocate its metadata),
kmemleak_enabled is set and __delete_object() is no longer called on freed
objects.  If kmemleak_scan is running at the same time, kmemleak_free() no
longer waits for the object scanning to complete, allowing the
corresponding memory block to be freed or unmapped (in the case of
vfree()).  This leads to kmemleak_scan potentially triggering a page
fault.

This patch separates the kmemleak_free() enabling/disabling from the
overall kmemleak_enabled nob so that we can defer the disabling of the
object freeing tracking until the scanning thread completed.  The
kmemleak_free_part() is deliberately ignored by this patch since this is
only called during boot before the scanning thread started.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Vignesh Radhakrishnan <vigneshr@codeaurora.org>
Tested-by: Vignesh Radhakrishnan <vigneshr@codeaurora.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN mm/kmemleak.c~mm-kmemleak-allow-safe-memory-scanning-during-kmemleak-disabling mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleak-allow-safe-memory-scanning-during-kmemleak-disabling
+++ a/mm/kmemleak.c
@@ -195,6 +195,8 @@ static struct kmem_cache *scan_area_cach
 
 /* set if tracing memory operations is enabled */
 static int kmemleak_enabled;
+/* same as above but only for the kmemleak_free() callback */
+static int kmemleak_free_enabled;
 /* set in the late_initcall if there were no errors */
 static int kmemleak_initialized;
 /* enables or disables early logging of the memory operations */
@@ -942,7 +944,7 @@ void __ref kmemleak_free(const void *ptr
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
-	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+	if (kmemleak_free_enabled && ptr && !IS_ERR(ptr))
 		delete_object_full((unsigned long)ptr);
 	else if (kmemleak_early_log)
 		log_early(KMEMLEAK_FREE, ptr, 0, 0);
@@ -982,7 +984,7 @@ void __ref kmemleak_free_percpu(const vo
 
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
-	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
+	if (kmemleak_free_enabled && ptr && !IS_ERR(ptr))
 		for_each_possible_cpu(cpu)
 			delete_object_full((unsigned long)per_cpu_ptr(ptr,
 								      cpu));
@@ -1750,6 +1752,13 @@ static void kmemleak_do_cleanup(struct w
 	mutex_lock(&scan_mutex);
 	stop_scan_thread();
 
+	/*
+	 * Once the scan thread has stopped, it is safe to no longer track
+	 * object freeing. Ordering of the scan thread stopping and the memory
+	 * accesses below is guaranteed by the kthread_stop() function.
+	 */
+	kmemleak_free_enabled = 0;
+
 	if (!kmemleak_found_leaks)
 		__kmemleak_do_cleanup();
 	else
@@ -1776,6 +1785,8 @@ static void kmemleak_disable(void)
 	/* check whether it is too early for a kernel thread */
 	if (kmemleak_initialized)
 		schedule_work(&cleanup_work);
+	else
+		kmemleak_free_enabled = 0;
 
 	pr_info("Kernel memory leak detector disabled\n");
 }
@@ -1840,8 +1851,10 @@ void __init kmemleak_init(void)
 	if (kmemleak_error) {
 		local_irq_restore(flags);
 		return;
-	} else
+	} else {
 		kmemleak_enabled = 1;
+		kmemleak_free_enabled = 1;
+	}
 	local_irq_restore(flags);
 
 	/*
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch
mm-kmemleak-allow-safe-memory-scanning-during-kmemleak-disabling.patch
mm-kmemleak-fix-delete_object_-race-when-called-on-the-same-memory-block.patch
mm-kmemleak-do-not-acquire-scan_mutex-in-kmemleak_do_cleanup.patch
mm-kmemleak-avoid-deadlock-on-the-kmemleak-object-insertion-error-path.patch
linux-next.patch

