From: akpm@linux-foundation.org
Subject: + lib-list_sort-test-use-generic-random32.patch added to -mm tree
Date: Mon, 27 Sep 2010 12:05:20 -0700
Message-ID: <201009271905.o8RJ5KSI010713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757228Ab0I0TFY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 15:05:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Artem.Bityutskiy@nokia.com, don.mullis@gmail.com


The patch titled
     lib/list_sort: test: use generic random32
has been added to the -mm tree.  Its filename is
     lib-list_sort-test-use-generic-random32.patch

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
Subject: lib/list_sort: test: use generic random32
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Instead of using own pseudo-random generator, use generic linux
'random32()' function.  Presumably, this should improve test coverage.

At the same time, do the following changes:
  o Use shorter macro name for test list length
  o Do not use strange 'l_h' name for 'struct list_head' element,
    use 'list', because it is traditional name and thus, makes the
    code more obvious and readable.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Don Mullis <don.mullis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff -puN lib/list_sort.c~lib-list_sort-test-use-generic-random32 lib/list_sort.c
--- a/lib/list_sort.c~lib-list_sort-test-use-generic-random32
+++ a/lib/list_sort.c
@@ -142,42 +142,45 @@ void list_sort(void *priv, struct list_h
 EXPORT_SYMBOL(list_sort);
 
 #ifdef CONFIG_TEST_LIST_SORT
+
+#include <linux/random.h>
+
 struct debug_el {
-	struct list_head l_h;
+	struct list_head list;
 	int value;
 	unsigned serial;
 };
 
 static int cmp(void *priv, struct list_head *a, struct list_head *b)
 {
-	return container_of(a, struct debug_el, l_h)->value
-	     - container_of(b, struct debug_el, l_h)->value;
+	return container_of(a, struct debug_el, list)->value
+	     - container_of(b, struct debug_el, list)->value;
 }
 
 /*
  * The pattern of set bits in the list length determines which cases
  * are hit in list_sort().
  */
-#define LIST_SORT_TEST_LENGTH (512+128+2) /* not including head */
+#define TEST_LIST_LEN (512+128+2) /* not including head */
 
 static int __init list_sort_test(void)
 {
-	int i, r = 1, count;
+	int i, count;
 	struct list_head *head = kmalloc(sizeof(*head), GFP_KERNEL);
 	struct list_head *cur;
 
 	printk(KERN_DEBUG "testing list_sort()\n");
 
 	cur = head;
-	for (i = 0; i < LIST_SORT_TEST_LENGTH; i++) {
+	for (i = 0; i < TEST_LIST_LEN; i++) {
 		struct debug_el *el = kmalloc(sizeof(*el), GFP_KERNEL);
 		BUG_ON(!el);
 		 /* force some equivalencies */
-		el->value = (r = (r * 725861) % 6599) % (LIST_SORT_TEST_LENGTH/3);
+		el->value = random32() % (TEST_LIST_LEN/3);
 		el->serial = i;
 
-		el->l_h.prev = cur;
-		cur->next = &el->l_h;
+		el->list.prev = cur;
+		cur->next = &el->list;
 		cur = cur->next;
 	}
 	head->prev = cur;
@@ -186,7 +189,7 @@ static int __init list_sort_test(void)
 
 	count = 1;
 	for (cur = head->next; cur->next != head; cur = cur->next) {
-		struct debug_el *el = container_of(cur, struct debug_el, l_h);
+		struct debug_el *el = container_of(cur, struct debug_el, list);
 		int cmp_result = cmp(NULL, cur, cur->next);
 		if (cur->next->prev != cur) {
 			printk(KERN_ERR "list_sort() returned "
@@ -197,7 +200,7 @@ static int __init list_sort_test(void)
 			return 1;
 		} else if (cmp_result == 0 &&
 				el->serial >= container_of(cur->next,
-					struct debug_el, l_h)->serial) {
+					struct debug_el, list)->serial) {
 			printk(KERN_ERR "list_sort() failed to preserve order "
 					"of equivalent elements!\n");
 			return 1;
@@ -206,7 +209,7 @@ static int __init list_sort_test(void)
 		count++;
 	}
 	kfree(cur);
-	if (count != LIST_SORT_TEST_LENGTH) {
+	if (count != TEST_LIST_LEN) {
 		printk(KERN_ERR "list_sort() returned list of "
 				"different length!\n");
 		return 1;
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

