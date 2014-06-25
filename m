From: akpm@linux-foundation.org
Subject: + lib-list_sortc-convert-to-pr_foo.patch added to -mm tree
Date: Wed, 25 Jun 2014 14:53:18 -0700
Message-ID: <53ab44ce.9+ORSiOBhJSCPc6r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbaFYVxT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 17:53:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, artem.bityutskiy@linux.intel.com, david@fromorbit.com, don.mullis@gmail.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/list_sort.c: convert to pr_foo
has been added to the -mm tree.  Its filename is
     lib-list_sortc-convert-to-pr_foo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-list_sortc-convert-to-pr_foo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-list_sortc-convert-to-pr_foo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/list_sort.c: convert to pr_foo

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Don Mullis <don.mullis@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |   50 ++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

diff -puN lib/list_sort.c~lib-list_sortc-convert-to-pr_foo lib/list_sort.c
--- a/lib/list_sort.c~lib-list_sortc-convert-to-pr_foo
+++ a/lib/list_sort.c
@@ -1,3 +1,6 @@
+
+#define pr_fmt(fmt) "list_sort_test: " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/list_sort.h>
@@ -125,9 +128,8 @@ void list_sort(void *priv, struct list_h
 		}
 		if (lev > max_lev) {
 			if (unlikely(lev >= ARRAY_SIZE(part)-1)) {
-				printk_once(KERN_DEBUG "list passed to"
-					" list_sort() too long for"
-					" efficiency\n");
+				pr_debug_once("list passed to list_sort() too "
+					      "long for efficiency\n");
 				lev--;
 			}
 			max_lev = lev;
@@ -170,27 +172,25 @@ static struct debug_el **elts __initdata
 static int __init check(struct debug_el *ela, struct debug_el *elb)
 {
 	if (ela->serial >= TEST_LIST_LEN) {
-		printk(KERN_ERR "list_sort_test: error: incorrect serial %d\n",
-				ela->serial);
+		pr_err("error: incorrect serial %d\n", ela->serial);
 		return -EINVAL;
 	}
 	if (elb->serial >= TEST_LIST_LEN) {
-		printk(KERN_ERR "list_sort_test: error: incorrect serial %d\n",
-				elb->serial);
+		pr_err("error: incorrect serial %d\n", elb->serial);
 		return -EINVAL;
 	}
 	if (elts[ela->serial] != ela || elts[elb->serial] != elb) {
-		printk(KERN_ERR "list_sort_test: error: phantom element\n");
+		pr_err("error: phantom element\n");
 		return -EINVAL;
 	}
 	if (ela->poison1 != TEST_POISON1 || ela->poison2 != TEST_POISON2) {
-		printk(KERN_ERR "list_sort_test: error: bad poison: %#x/%#x\n",
-				ela->poison1, ela->poison2);
+		pr_err("error: bad poison: %#x/%#x\n",
+			ela->poison1, ela->poison2);
 		return -EINVAL;
 	}
 	if (elb->poison1 != TEST_POISON1 || elb->poison2 != TEST_POISON2) {
-		printk(KERN_ERR "list_sort_test: error: bad poison: %#x/%#x\n",
-				elb->poison1, elb->poison2);
+		pr_err("error: bad poison: %#x/%#x\n",
+			elb->poison1, elb->poison2);
 		return -EINVAL;
 	}
 	return 0;
@@ -214,20 +214,18 @@ static int __init list_sort_test(void)
 	struct list_head *cur;
 	LIST_HEAD(head);
 
-	printk(KERN_DEBUG "list_sort_test: start testing list_sort()\n");
+	pr_debug("start testing list_sort()\n");
 
 	elts = kcalloc(TEST_LIST_LEN, sizeof(*elts), GFP_KERNEL);
 	if (!elts) {
-		printk(KERN_ERR "list_sort_test: error: cannot allocate "
-				"memory\n");
+		pr_err("error: cannot allocate memory\n");
 		return err;
 	}
 
 	for (i = 0; i < TEST_LIST_LEN; i++) {
 		el = kmalloc(sizeof(*el), GFP_KERNEL);
 		if (!el) {
-			printk(KERN_ERR "list_sort_test: error: cannot "
-					"allocate memory\n");
+			pr_err("error: cannot allocate memory\n");
 			goto exit;
 		}
 		 /* force some equivalencies */
@@ -247,42 +245,38 @@ static int __init list_sort_test(void)
 		int cmp_result;
 
 		if (cur->next->prev != cur) {
-			printk(KERN_ERR "list_sort_test: error: list is "
-					"corrupted\n");
+			pr_err("error: list is corrupted\n");
 			goto exit;
 		}
 
 		cmp_result = cmp(NULL, cur, cur->next);
 		if (cmp_result > 0) {
-			printk(KERN_ERR "list_sort_test: error: list is not "
-					"sorted\n");
+			pr_err("error: list is not sorted\n");
 			goto exit;
 		}
 
 		el = container_of(cur, struct debug_el, list);
 		el1 = container_of(cur->next, struct debug_el, list);
 		if (cmp_result == 0 && el->serial >= el1->serial) {
-			printk(KERN_ERR "list_sort_test: error: order of "
-					"equivalent elements not preserved\n");
+			pr_err("error: order of equivalent elements not "
+				"preserved\n");
 			goto exit;
 		}
 
 		if (check(el, el1)) {
-			printk(KERN_ERR "list_sort_test: error: element check "
-					"failed\n");
+			pr_err("error: element check failed\n");
 			goto exit;
 		}
 		count++;
 	}
 	if (head.prev != cur) {
-		printk(KERN_ERR "list_sort_test: error: list is corrupted\n");
+		pr_err("error: list is corrupted\n");
 		goto exit;
 	}
 
 
 	if (count != TEST_LIST_LEN) {
-		printk(KERN_ERR "list_sort_test: error: bad list length %d",
-				count);
+		pr_err("error: bad list length %d", count);
 		goto exit;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
fs-isofs-logging-clean-up-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

