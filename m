From: akpm@linux-foundation.org
Subject: [merged]
 lib-list_sort_test-return-enomem-when-allocation-fails.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:07:53 -0700
Message-ID: <53e3dc99.U/s/aLxV010nJ0Jh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f201.google.com ([209.85.160.201]:45993 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaHGUHy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:54 -0400
Received: by mail-yk0-f201.google.com with SMTP id 142so611428ykq.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, artem.bityutskiy@linux.intel.com, david@fromorbit.com, don.mullis@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: list_sort_test(): return -ENOMEM when allocation fails
has been removed from the -mm tree.  Its filename was
     lib-list_sort_test-return-enomem-when-allocation-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

