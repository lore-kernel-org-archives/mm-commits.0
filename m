From: akpm@linux-foundation.org
Subject: [patch 31/94] lib/test: delete five error messages for
 failed memory allocations
Date: Fri, 17 Nov 2017 15:28:00 -0800
Message-ID: <20171117232800.pdD5L3Q1R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55470 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966927AbdKQX2C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:28:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, elfring@users.sourceforge.net, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Markus Elfring <elfring@users.sourceforge.net>
Subject: lib/test: delete five error messages for failed memory allocations

Omit extra messages for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Link: http://lkml.kernel.org/r/410a4c5a-4ee0-6fcc-969c-103d8e496b78@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c     |    5 ++---
 lib/test_kmod.c      |    8 ++------
 lib/test_list_sort.c |    9 +++------
 3 files changed, 7 insertions(+), 15 deletions(-)

diff -puN lib/test_kasan.c~lib-test-delete-five-error-messages-for-a-failed-memory-allocation lib/test_kasan.c
--- a/lib/test_kasan.c~lib-test-delete-five-error-messages-for-a-failed-memory-allocation
+++ a/lib/test_kasan.c
@@ -353,10 +353,9 @@ static noinline void __init memcg_accoun
 	 */
 	for (i = 0; i < 5; i++) {
 		p = kmem_cache_alloc(cache, GFP_KERNEL);
-		if (!p) {
-			pr_err("Allocation failed\n");
+		if (!p)
 			goto free_cache;
-		}
+
 		kmem_cache_free(cache, p);
 		msleep(100);
 	}
diff -puN lib/test_kmod.c~lib-test-delete-five-error-messages-for-a-failed-memory-allocation lib/test_kmod.c
--- a/lib/test_kmod.c~lib-test-delete-five-error-messages-for-a-failed-memory-allocation
+++ a/lib/test_kmod.c
@@ -783,10 +783,8 @@ static int kmod_config_sync_info(struct
 	free_test_dev_info(test_dev);
 	test_dev->info = vzalloc(config->num_threads *
 				 sizeof(struct kmod_test_device_info));
-	if (!test_dev->info) {
-		dev_err(test_dev->dev, "Cannot alloc test_dev info\n");
+	if (!test_dev->info)
 		return -ENOMEM;
-	}
 
 	return 0;
 }
@@ -1089,10 +1087,8 @@ static struct kmod_test_device *alloc_te
 	struct miscdevice *misc_dev;
 
 	test_dev = vzalloc(sizeof(struct kmod_test_device));
-	if (!test_dev) {
-		pr_err("Cannot alloc test_dev\n");
+	if (!test_dev)
 		goto err_out;
-	}
 
 	mutex_init(&test_dev->config_mutex);
 	mutex_init(&test_dev->trigger_mutex);
diff -puN lib/test_list_sort.c~lib-test-delete-five-error-messages-for-a-failed-memory-allocation lib/test_list_sort.c
--- a/lib/test_list_sort.c~lib-test-delete-five-error-messages-for-a-failed-memory-allocation
+++ a/lib/test_list_sort.c
@@ -76,17 +76,14 @@ static int __init list_sort_test(void)
 	pr_debug("start testing list_sort()\n");
 
 	elts = kcalloc(TEST_LIST_LEN, sizeof(*elts), GFP_KERNEL);
-	if (!elts) {
-		pr_err("error: cannot allocate memory\n");
+	if (!elts)
 		return err;
-	}
 
 	for (i = 0; i < TEST_LIST_LEN; i++) {
 		el = kmalloc(sizeof(*el), GFP_KERNEL);
-		if (!el) {
-			pr_err("error: cannot allocate memory\n");
+		if (!el)
 			goto exit;
-		}
+
 		 /* force some equivalencies */
 		el->value = prandom_u32() % (TEST_LIST_LEN / 3);
 		el->serial = i;
_
