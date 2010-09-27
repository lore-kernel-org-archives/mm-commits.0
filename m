From: akpm@linux-foundation.org
Subject: + lib-list_sort-test-use-more-reasonable-printk-levels.patch added to -mm tree
Date: Mon, 27 Sep 2010 12:05:18 -0700
Message-ID: <201009271905.o8RJ5IFY010710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757228Ab0I0TFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 15:05:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Artem.Bityutskiy@nokia.com, don.mullis@gmail.com


The patch titled
     lib/list_sort: test: use more reasonable printk levels
has been added to the -mm tree.  Its filename is
     lib-list_sort-test-use-more-reasonable-printk-levels.patch

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
Subject: lib/list_sort: test: use more reasonable printk levels
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

I do not see any reason to use KERN_WARN for normal messages and
KERN_EMERG for error messages in the lib_sort testing routine.  Let's use
more reasonable KERN_NORM and KERN_ERR levels.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Don Mullis <don.mullis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN lib/list_sort.c~lib-list_sort-test-use-more-reasonable-printk-levels lib/list_sort.c
--- a/lib/list_sort.c~lib-list_sort-test-use-more-reasonable-printk-levels
+++ a/lib/list_sort.c
@@ -166,7 +166,7 @@ static int __init list_sort_test(void)
 	struct list_head *head = kmalloc(sizeof(*head), GFP_KERNEL);
 	struct list_head *cur;
 
-	printk(KERN_WARNING "testing list_sort()\n");
+	printk(KERN_DEBUG "testing list_sort()\n");
 
 	cur = head;
 	for (i = 0; i < LIST_SORT_TEST_LENGTH; i++) {
@@ -189,17 +189,17 @@ static int __init list_sort_test(void)
 		struct debug_el *el = container_of(cur, struct debug_el, l_h);
 		int cmp_result = cmp(NULL, cur, cur->next);
 		if (cur->next->prev != cur) {
-			printk(KERN_EMERG "list_sort() returned "
-						"a corrupted list!\n");
+			printk(KERN_ERR "list_sort() returned "
+					"a corrupted list!\n");
 			return 1;
 		} else if (cmp_result > 0) {
-			printk(KERN_EMERG "list_sort() failed to sort!\n");
+			printk(KERN_ERR "list_sort() failed to sort!\n");
 			return 1;
 		} else if (cmp_result == 0 &&
 				el->serial >= container_of(cur->next,
 					struct debug_el, l_h)->serial) {
-			printk(KERN_EMERG "list_sort() failed to preserve order"
-						 " of equivalent elements!\n");
+			printk(KERN_ERR "list_sort() failed to preserve order "
+					"of equivalent elements!\n");
 			return 1;
 		}
 		kfree(cur->prev);
@@ -207,8 +207,8 @@ static int __init list_sort_test(void)
 	}
 	kfree(cur);
 	if (count != LIST_SORT_TEST_LENGTH) {
-		printk(KERN_EMERG "list_sort() returned list of"
-						"different length!\n");
+		printk(KERN_ERR "list_sort() returned list of "
+				"different length!\n");
 		return 1;
 	}
 	return 0;
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

