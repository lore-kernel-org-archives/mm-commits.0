From: akpm@linux-foundation.org
Subject: [merged]
 kmemleak-free-internal-objects-only-if-therere-no-leaks-to-be-reported.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:29:24 -0700
Message-ID: <533f0814.f0W14GkZ9YgNUpre%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaDDT3Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com, lizefan@huawei.com

Subject: [merged] kmemleak-free-internal-objects-only-if-therere-no-leaks-to-be-reported.patch removed from -mm tree
To: lizefan@huawei.com,catalin.marinas@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:24 -0700


The patch titled
     Subject: kmemleak: free internal objects only if there're no leaks to be reported
has been removed from the -mm tree.  Its filename was
     kmemleak-free-internal-objects-only-if-therere-no-leaks-to-be-reported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: kmemleak: free internal objects only if there're no leaks to be reported

Currently if you stop kmemleak thread before disabling kmemleak, kmemleak
objects will be freed and so you won't be able to check previously
reported leaks.

With this patch, kmemleak objects won't be freed if there're leaks that
can be reported.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN mm/kmemleak.c~kmemleak-free-internal-objects-only-if-therere-no-leaks-to-be-reported mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-free-internal-objects-only-if-therere-no-leaks-to-be-reported
+++ a/mm/kmemleak.c
@@ -218,7 +218,8 @@ static int kmemleak_stack_scan = 1;
 static DEFINE_MUTEX(scan_mutex);
 /* setting kmemleak=on, will set this var, skipping the disable */
 static int kmemleak_skip_disable;
-
+/* If there are leaks that can be reported */
+static bool kmemleak_found_leaks;
 
 /*
  * Early object allocation/freeing logging. Kmemleak is initialized after the
@@ -1382,9 +1383,12 @@ static void kmemleak_scan(void)
 	}
 	rcu_read_unlock();
 
-	if (new_leaks)
+	if (new_leaks) {
+		kmemleak_found_leaks = true;
+
 		pr_info("%d new suspected memory leaks (see "
 			"/sys/kernel/debug/kmemleak)\n", new_leaks);
+	}
 
 }
 
@@ -1592,6 +1596,8 @@ static void kmemleak_clear(void)
 		spin_unlock_irqrestore(&object->lock, flags);
 	}
 	rcu_read_unlock();
+
+	kmemleak_found_leaks = false;
 }
 
 /*
@@ -1685,12 +1691,11 @@ static const struct file_operations kmem
 static void kmemleak_do_cleanup(struct work_struct *work)
 {
 	struct kmemleak_object *object;
-	bool cleanup = scan_thread == NULL;
 
 	mutex_lock(&scan_mutex);
 	stop_scan_thread();
 
-	if (cleanup) {
+	if (!kmemleak_found_leaks) {
 		rcu_read_lock();
 		list_for_each_entry_rcu(object, &object_list, object_list)
 			delete_object_full(object->pointer);
_

Patches currently in -mm which might be from lizefan@huawei.com are

origin.patch
kmemcheck-move-hook-into-__alloc_pages_nodemask-for-the-page-allocator.patch
linux-next.patch

