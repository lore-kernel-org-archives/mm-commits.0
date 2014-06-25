From: akpm@linux-foundation.org
Subject: + lib-list_sortc-limit-number-of-unused-cmp-callbacks.patch added to -mm tree
Date: Wed, 25 Jun 2014 14:44:27 -0700
Message-ID: <53ab42bb.9ljb3QDnx22zvmx9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbaFYVo2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 17:44:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, artem.bityutskiy@linux.intel.com, david@fromorbit.com, don.mullis@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: list_sort.c: Limit number of unused cmp callbacks
has been added to the -mm tree.  Its filename is
     lib-list_sortc-limit-number-of-unused-cmp-callbacks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-list_sortc-limit-number-of-unused-cmp-callbacks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-list_sortc-limit-number-of-unused-cmp-callbacks.patch

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
lib-list_sort_test-return-enomem-when-allocation-fails.patch
lib-list_sort_test-add-extra-corruption-check.patch
lib-list_sort_test-simplify-and-harden-cleanup.patch
lib-list_sortc-limit-number-of-unused-cmp-callbacks.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
linux-next.patch

