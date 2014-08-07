From: akpm@linux-foundation.org
Subject: [merged]
 lib-list_sortc-limit-number-of-unused-cmp-callbacks.patch removed from -mm
 tree
Date: Thu, 07 Aug 2014 13:07:59 -0700
Message-ID: <53e3dc9f.mqdMVZgtJHohlJh9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:48002 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbaHGUIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:00 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so837808oig.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, artem.bityutskiy@linux.intel.com, david@fromorbit.com, don.mullis@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: list_sort.c: Limit number of unused cmp callbacks
has been removed from the -mm tree.  Its filename was
     lib-list_sortc-limit-number-of-unused-cmp-callbacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: list_sort.c: Limit number of unused cmp callbacks

The helper merge_and_restore_back_links() makes sure to call the caller's
cmp function during the final ->prev pointer fixup, so that the cmp
function may call cond_resched().  However, if the cmp function does not
call cond_resched() at all, this is entirely redundant.  If it does, doing
at least two function calls for every two pointer assignments is a bit
excessive.  This patch limits the calls to once for every 256 iterations.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Don Mullis <don.mullis@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN lib/list_sort.c~lib-list_sortc-limit-number-of-unused-cmp-callbacks lib/list_sort.c
--- a/lib/list_sort.c~lib-list_sortc-limit-number-of-unused-cmp-callbacks
+++ a/lib/list_sort.c
@@ -47,6 +47,7 @@ static void merge_and_restore_back_links
 				struct list_head *a, struct list_head *b)
 {
 	struct list_head *tail = head;
+	u8 count = 0;
 
 	while (a && b) {
 		/* if equal, take 'a' -- important for sort stability */
@@ -70,7 +71,8 @@ static void merge_and_restore_back_links
 		 * element comparison is needed, so the client's cmp()
 		 * routine can invoke cond_resched() periodically.
 		 */
-		(*cmp)(priv, tail->next, tail->next);
+		if (unlikely(!(++count)))
+			(*cmp)(priv, tail->next, tail->next);
 
 		tail->next->prev = tail;
 		tail = tail->next;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

