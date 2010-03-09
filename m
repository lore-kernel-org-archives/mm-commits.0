From: akpm@linux-foundation.org
Subject: [merged] lib-revise-list_sort-header-comment.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:07:31 -0800
Message-ID: <201003091907.o29J7Vrg031341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756069Ab0CITWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: don.mullis@gmail.com, airlied@redhat.com, andi@firstfloor.org, david@fromorbit.com, dedekind@infradead.org, mm-commits@vger.kernel.org


The patch titled
     lib: revise list_sort() header comment
has been removed from the -mm tree.  Its filename was
     lib-revise-list_sort-header-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: revise list_sort() header comment
From: Don Mullis <don.mullis@gmail.com>

Clarify and correct header comment of list_sort().

Signed-off-by: Don Mullis <don.mullis@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN lib/list_sort.c~lib-revise-list_sort-header-comment lib/list_sort.c
--- a/lib/list_sort.c~lib-revise-list_sort-header-comment
+++ a/lib/list_sort.c
@@ -81,17 +81,18 @@ static void merge_and_restore_back_links
 }
 
 /**
- * list_sort - sort a list.
- * @priv: private data, passed to @cmp
+ * list_sort - sort a list
+ * @priv: private data, opaque to list_sort(), passed to @cmp
  * @head: the list to sort
  * @cmp: the elements comparison function
  *
- * This function implements "merge sort" which has O(nlog(n)) complexity.
- * The list is sorted in ascending order.
+ * This function implements "merge sort", which has O(nlog(n))
+ * complexity.
  *
- * The comparison function @cmp is supposed to return a negative value if @a is
- * less than @b, and a positive value if @a is greater than @b. If @a and @b
- * are equivalent, then it does not matter what this function returns.
+ * The comparison function @cmp must return a negative value if @a
+ * should sort before @b, and a positive value if @a should sort after
+ * @b. If @a and @b are equivalent, and their original relative
+ * ordering is to be preserved, @cmp must return 0.
  */
 void list_sort(void *priv, struct list_head *head,
 		int (*cmp)(void *priv, struct list_head *a,
_

Patches currently in -mm which might be from don.mullis@gmail.com are


