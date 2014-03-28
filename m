From: akpm@linux-foundation.org
Subject: +
 kmemleak-free-internal-objects-only-if-therere-no-leaks-to-be-reported.patch added to -mm tree
Date: Fri, 28 Mar 2014 13:22:41 -0700
Message-ID: <5335da11.QPdStmi2Q3nevGua%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaC1UWm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Mar 2014 16:22:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com, lizefan@huawei.com

Subject: + kmemleak-free-internal-objects-only-if-therere-no-leaks-to-be-reported.patch added to -mm tree
To: lizefan@huawei.com,catalin.marinas@arm.com
From: akpm@linux-foundation.org
Date: Fri, 28 Mar 2014 13:22:41 -0700


The patch titled
     Subject: kmemleak: free internal objects only if there're no leaks to be reported
has been added to the -mm tree.  Its filename is
     kmemleak-free-internal-objects-only-if-therere-no-leaks-to-be-reported.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmemleak-free-internal-objects-only-if-therere-no-leaks-to-be-reported.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmemleak-free-internal-objects-only-if-therere-no-leaks-to-be-reported.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kmemleak-free-internal-objects-only-if-therere-no-leaks-to-be-reported.patch
kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled.patch
kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled-v4.patch
kmemleak-remove-redundant-code.patch
kmemleak-change-some-global-variables-to-int.patch
kmemleak-change-some-global-variables-to-int-v4.patch
kmemcheck-move-hook-into-__alloc_pages_nodemask-for-the-page-allocator.patch
linux-next.patch

