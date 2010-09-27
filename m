From: akpm@linux-foundation.org
Subject: + lib-list_sort-test-unify-test-messages.patch added to -mm tree
Date: Mon, 27 Sep 2010 12:05:24 -0700
Message-ID: <201009271905.o8RJ5OiI010719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757228Ab0I0TF2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 15:05:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Artem.Bityutskiy@nokia.com, don.mullis@gmail.com


The patch titled
     lib/list_sort: test: unify test messages
has been added to the -mm tree.  Its filename is
     lib-list_sort-test-unify-test-messages.patch

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
Subject: lib/list_sort: test: unify test messages
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This patch unifies 'list_sort_test()' messages a bit and makes sure all of
them start with the "list_sort_test:" prefix to make it obvious for users
where the messages come from.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Don Mullis <don.mullis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN lib/list_sort.c~lib-list_sort-test-unify-test-messages lib/list_sort.c
--- a/lib/list_sort.c~lib-list_sort-test-unify-test-messages
+++ a/lib/list_sort.c
@@ -170,12 +170,12 @@ static int __init list_sort_test(void)
 	struct list_head *cur, *tmp;
 	LIST_HEAD(head);
 
-	printk(KERN_DEBUG "testing list_sort()\n");
+	printk(KERN_DEBUG "list_sort_test: start testing list_sort()\n");
 
 	for (i = 0; i < TEST_LIST_LEN; i++) {
 		el = kmalloc(sizeof(*el), GFP_KERNEL);
 		if (!el) {
-			printk(KERN_ERR "cancel list_sort() testing - cannot "
+			printk(KERN_ERR "list_sort_test: error: cannot "
 					"allocate memory\n");
 			goto exit;
 		}
@@ -192,30 +192,31 @@ static int __init list_sort_test(void)
 		int cmp_result;
 
 		if (cur->next->prev != cur) {
-			printk(KERN_ERR "list_sort() returned "
-					"a corrupted list!\n");
+			printk(KERN_ERR "list_sort_test: error: list is "
+					"corrupted\n");
 			goto exit;
 		}
 
 		cmp_result = cmp(NULL, cur, cur->next);
 		if (cmp_result > 0) {
-			printk(KERN_ERR "list_sort() failed to sort!\n");
+			printk(KERN_ERR "list_sort_test: error: list is not "
+					"sorted\n");
 			goto exit;
 		}
 
 		el = container_of(cur, struct debug_el, list);
 		el1 = container_of(cur->next, struct debug_el, list);
 		if (cmp_result == 0 && el->serial >= el1->serial) {
-			printk(KERN_ERR "list_sort() failed to preserve order "
-					"of equivalent elements!\n");
+			printk(KERN_ERR "list_sort_test: error: order of "
+					"equivalent elements not preserved\n");
 			goto exit;
 		}
 		count++;
 	}
 
 	if (count != TEST_LIST_LEN) {
-		printk(KERN_ERR "list_sort() returned list of "
-				"different length!\n");
+		printk(KERN_ERR "list_sort_test: error: bad list length %d",
+				count);
 		goto exit;
 	}
 
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

