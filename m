From: akpm@linux-foundation.org
Subject: + lib-list_sort_test-return-enomem-when-allocation-fails.patch
 added to -mm tree
Date: Wed, 25 Jun 2014 14:44:06 -0700
Message-ID: <53ab42a6.TQ6KB8/GPXwt5LQS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48142 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbaFYVoH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 17:44:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, artem.bityutskiy@linux.intel.com, david@fromorbit.com, don.mullis@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: list_sort_test(): return -ENOMEM when allocation fails
has been added to the -mm tree.  Its filename is
     lib-list_sort_test-return-enomem-when-allocation-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-list_sort_test-return-enomem-when-allocation-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-list_sort_test-return-enomem-when-allocation-fails.patch

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
Subject: lib: list_sort_test(): return -ENOMEM when allocation fails

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Don Mullis <don.mullis@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/list_sort.c~lib-list_sort_test-return-enomem-when-allocation-fails lib/list_sort.c
--- a/lib/list_sort.c~lib-list_sort_test-return-enomem-when-allocation-fails
+++ a/lib/list_sort.c
@@ -207,7 +207,7 @@ static int __init cmp(void *priv, struct
 
 static int __init list_sort_test(void)
 {
-	int i, count = 1, err = -EINVAL;
+	int i, count = 1, err = -ENOMEM;
 	struct debug_el *el;
 	struct list_head *cur, *tmp;
 	LIST_HEAD(head);
@@ -239,6 +239,7 @@ static int __init list_sort_test(void)
 
 	list_sort(NULL, &head, cmp);
 
+	err = -EINVAL;
 	for (cur = head.next; cur->next != &head; cur = cur->next) {
 		struct debug_el *el1;
 		int cmp_result;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-list_sort_test-return-enomem-when-allocation-fails.patch
lib-list_sort_test-add-extra-corruption-check.patch
lib-list_sort_test-simplify-and-harden-cleanup.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
linux-next.patch
lib-list_sortc-limit-number-of-unused-cmp-callbacks.patch

