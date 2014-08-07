From: akpm@linux-foundation.org
Subject: [merged] lib-list_sortc-convert-to-pr_foo.patch removed from -mm
 tree
Date: Thu, 07 Aug 2014 13:08:01 -0700
Message-ID: <53e3dca1.NDuSBldglloFAP3o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:36696 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaHGUIC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:02 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so839794oac.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, artem.bityutskiy@linux.intel.com, david@fromorbit.com, don.mullis@gmail.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/list_sort.c: convert to pr_foo
has been removed from the -mm tree.  Its filename was
     lib-list_sortc-convert-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/list_sort.c: convert to pr_foo

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Don Mullis <don.mullis@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |   49 +++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

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
@@ -125,9 +128,7 @@ void list_sort(void *priv, struct list_h
 		}
 		if (lev > max_lev) {
 			if (unlikely(lev >= ARRAY_SIZE(part)-1)) {
-				printk_once(KERN_DEBUG "list passed to"
-					" list_sort() too long for"
-					" efficiency\n");
+				printk_once(KERN_DEBUG "list too long for efficiency\n");
 				lev--;
 			}
 			max_lev = lev;
@@ -170,27 +171,25 @@ static struct debug_el **elts __initdata
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
@@ -214,20 +213,18 @@ static int __init list_sort_test(void)
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
@@ -247,42 +244,38 @@ static int __init list_sort_test(void)
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
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
rtc-add-pcf85063-support-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

