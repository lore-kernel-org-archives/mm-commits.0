From: akpm@linux-foundation.org
Subject: [merged] lib-list_sort_test-simplify-and-harden-cleanup.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:07:57 -0700
Message-ID: <53e3dc9d.eT32tP3HeOQhIZcm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:33167 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaHGUH6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:58 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so1177952pde.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, artem.bityutskiy@linux.intel.com, david@fromorbit.com, don.mullis@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: list_sort_test(): simplify and harden cleanup
has been removed from the -mm tree.  Its filename was
     lib-list_sort_test-simplify-and-harden-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

