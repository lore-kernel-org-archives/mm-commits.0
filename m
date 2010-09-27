From: akpm@linux-foundation.org
Subject: + lib-list_sort-test-check-element-addresses.patch added to -mm tree
Date: Mon, 27 Sep 2010 12:05:26 -0700
Message-ID: <201009271905.o8RJ5QgZ010722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757228Ab0I0TFf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 15:05:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Artem.Bityutskiy@nokia.com, don.mullis@gmail.com


The patch titled
     lib/list_sort: test: check element addresses
has been added to the -mm tree.  Its filename is
     lib-list_sort-test-check-element-addresses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/list_sort: test: check element addresses
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Improve 'lib_sort()' test and check that:
 o 'cmp()' is called only for elements which were present in the original list,
   i.e., the 'a' and 'b' parameters are valid
 o the resulted (sorted) list consists onlly of the original elements
 o intdoruce "poison" fields to make sure data around 'struc list_head' field
   are not corrupted.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Don Mullis <don.mullis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |   75 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 67 insertions(+), 8 deletions(-)

diff -puN lib/list_sort.c~lib-list_sort-test-check-element-addresses lib/list_sort.c
--- a/lib/list_sort.c~lib-list_sort-test-check-element-addresses
+++ a/lib/list_sort.c
@@ -145,23 +145,65 @@ EXPORT_SYMBOL(list_sort);
 
 #include <linux/random.h>
 
+/*
+ * The pattern of set bits in the list length determines which cases
+ * are hit in list_sort().
+ */
+#define TEST_LIST_LEN (512+128+2) /* not including head */
+
+#define TEST_POISON1 0xDEADBEEF
+#define TEST_POISON2 0xA324354C
+
 struct debug_el {
+	unsigned int poison1;
 	struct list_head list;
+	unsigned int poison2;
 	int value;
 	unsigned serial;
 };
 
-static int cmp(void *priv, struct list_head *a, struct list_head *b)
+/* Array, containing pointers to all elements in the test list */
+static struct debug_el **elts __initdata;
+
+static int __init check(struct debug_el *ela, struct debug_el *elb)
 {
-	return container_of(a, struct debug_el, list)->value
-	     - container_of(b, struct debug_el, list)->value;
+	if (ela->serial >= TEST_LIST_LEN) {
+		printk(KERN_ERR "list_sort_test: error: incorrect serial %d\n",
+				ela->serial);
+		return -EINVAL;
+	}
+	if (elb->serial >= TEST_LIST_LEN) {
+		printk(KERN_ERR "list_sort_test: error: incorrect serial %d\n",
+				elb->serial);
+		return -EINVAL;
+	}
+	if (elts[ela->serial] != ela || elts[elb->serial] != elb) {
+		printk(KERN_ERR "list_sort_test: error: phantom element\n");
+		return -EINVAL;
+	}
+	if (ela->poison1 != TEST_POISON1 || ela->poison2 != TEST_POISON2) {
+		printk(KERN_ERR "list_sort_test: error: bad poison: %#x/%#x\n",
+				ela->poison1, ela->poison2);
+		return -EINVAL;
+	}
+	if (elb->poison1 != TEST_POISON1 || elb->poison2 != TEST_POISON2) {
+		printk(KERN_ERR "list_sort_test: error: bad poison: %#x/%#x\n",
+				elb->poison1, elb->poison2);
+		return -EINVAL;
+	}
+	return 0;
 }
 
-/*
- * The pattern of set bits in the list length determines which cases
- * are hit in list_sort().
- */
-#define TEST_LIST_LEN (512+128+2) /* not including head */
+static int __init cmp(void *priv, struct list_head *a, struct list_head *b)
+{
+	struct debug_el *ela, *elb;
+
+	ela = container_of(a, struct debug_el, list);
+	elb = container_of(b, struct debug_el, list);
+
+	check(ela, elb);
+	return ela->value - elb->value;
+}
 
 static int __init list_sort_test(void)
 {
@@ -172,6 +214,13 @@ static int __init list_sort_test(void)
 
 	printk(KERN_DEBUG "list_sort_test: start testing list_sort()\n");
 
+	elts = kmalloc(sizeof(void *) * TEST_LIST_LEN, GFP_KERNEL);
+	if (!elts) {
+		printk(KERN_ERR "list_sort_test: error: cannot allocate "
+				"memory\n");
+		goto exit;
+	}
+
 	for (i = 0; i < TEST_LIST_LEN; i++) {
 		el = kmalloc(sizeof(*el), GFP_KERNEL);
 		if (!el) {
@@ -182,6 +231,9 @@ static int __init list_sort_test(void)
 		 /* force some equivalencies */
 		el->value = random32() % (TEST_LIST_LEN/3);
 		el->serial = i;
+		el->poison1 = TEST_POISON1;
+		el->poison2 = TEST_POISON2;
+		elts[i] = el;
 		list_add_tail(&el->list, &head);
 	}
 
@@ -211,6 +263,12 @@ static int __init list_sort_test(void)
 					"equivalent elements not preserved\n");
 			goto exit;
 		}
+
+		if (check(el, el1)) {
+			printk(KERN_ERR "list_sort_test: error: element check "
+					"failed\n");
+			goto exit;
+		}
 		count++;
 	}
 
@@ -222,6 +280,7 @@ static int __init list_sort_test(void)
 
 	err = 0;
 exit:
+	kfree(elts);
 	list_for_each_safe(cur, tmp, &head) {
 		list_del(cur);
 		kfree(container_of(cur, struct debug_el, list));
_

Patches currently in -mm which might be from Artem.Bityutskiy@nokia.com are

linux-next.patch
jffs2-use-cond_resched-instead-of-yield.patch
lib-list_sort-do-not-pass-bad-pointers-to-cmp-callback.patch
lib-kconfigdebug-add-list_sort-debugging-switch.patch
lib-list_sort-test-use-more-reasonable-printk-levels.patch
lib-list_sort-test-use-generic-random32.patch
lib-list_sort-test-improve-errors-handling.patch
lib-list_sort-test-unify-test-messages.patch
lib-list_sort-test-check-element-addresses.patch

