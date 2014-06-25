From: akpm@linux-foundation.org
Subject: + lib-list_sort_test-simplify-and-harden-cleanup.patch added to
 -mm tree
Date: Wed, 25 Jun 2014 14:44:08 -0700
Message-ID: <53ab42a8.GmFBE7x7hAnHhHus%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbaFYVoJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 17:44:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, artem.bityutskiy@linux.intel.com, david@fromorbit.com, don.mullis@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: list_sort_test(): simplify and harden cleanup
has been added to the -mm tree.  Its filename is
     lib-list_sort_test-simplify-and-harden-cleanup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-list_sort_test-simplify-and-harden-cleanup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-list_sort_test-simplify-and-harden-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: list_sort_test(): simplify and harden cleanup

There is no reason to maintain the list structure while freeing the debug
elements.  Aside from the redundant pointer manipulations, it is also
inefficient from a locality-of-reference viewpoint, since they are visited
in a random order (wrt.  the order they were allocated).  Furthermore, if
we jumped to exit: after detecting list corruption, it is actually
dangerous.

So just free the elements in the order they were allocated, using the
backing array elts.  Allocate that using kcalloc(), so that if allocation
of one of the debug element fails, we just end up calling kfree(NULL) for
the trailing elements.

Minor details: Use sizeof(*elts) instead of sizeof(void *), and return err
immediately when allocation of elts fails, to avoid introducing another
label just before the final return statement.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Don Mullis <don.mullis@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN lib/list_sort.c~lib-list_sort_test-simplify-and-harden-cleanup lib/list_sort.c
--- a/lib/list_sort.c~lib-list_sort_test-simplify-and-harden-cleanup
+++ a/lib/list_sort.c
@@ -209,16 +209,16 @@ static int __init list_sort_test(void)
 {
 	int i, count = 1, err = -ENOMEM;
 	struct debug_el *el;
-	struct list_head *cur, *tmp;
+	struct list_head *cur;
 	LIST_HEAD(head);
 
 	printk(KERN_DEBUG "list_sort_test: start testing list_sort()\n");
 
-	elts = kmalloc(sizeof(void *) * TEST_LIST_LEN, GFP_KERNEL);
+	elts = kcalloc(TEST_LIST_LEN, sizeof(*elts), GFP_KERNEL);
 	if (!elts) {
 		printk(KERN_ERR "list_sort_test: error: cannot allocate "
 				"memory\n");
-		goto exit;
+		return err;
 	}
 
 	for (i = 0; i < TEST_LIST_LEN; i++) {
@@ -286,11 +286,9 @@ static int __init list_sort_test(void)
 
 	err = 0;
 exit:
+	for (i = 0; i < TEST_LIST_LEN; i++)
+		kfree(elts[i]);
 	kfree(elts);
-	list_for_each_safe(cur, tmp, &head) {
-		list_del(cur);
-		kfree(container_of(cur, struct debug_el, list));
-	}
 	return err;
 }
 module_init(list_sort_test);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-list_sort_test-return-enomem-when-allocation-fails.patch
lib-list_sort_test-add-extra-corruption-check.patch
lib-list_sort_test-simplify-and-harden-cleanup.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
linux-next.patch
lib-list_sortc-limit-number-of-unused-cmp-callbacks.patch

