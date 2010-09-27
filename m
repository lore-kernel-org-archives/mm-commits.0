From: akpm@linux-foundation.org
Subject: + lib-list_sort-do-not-pass-bad-pointers-to-cmp-callback.patch added to -mm tree
Date: Mon, 27 Sep 2010 12:05:14 -0700
Message-ID: <201009271905.o8RJ5Edl010702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757120Ab0I0TFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 15:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: don.mullis@gmail.com, Artem.Bityutskiy@nokia.com, stable@kernel.org


The patch titled
     lib/list_sort: do not pass bad pointers to cmp callback
has been added to the -mm tree.  Its filename is
     lib-list_sort-do-not-pass-bad-pointers-to-cmp-callback.patch

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
Subject: lib/list_sort: do not pass bad pointers to cmp callback
From: Don Mullis <don.mullis@gmail.com>

If the original list is a POT in length, the first callback from line 73
will pass a==b both pointing to the original list_head.  This is dangerous
because the 'list_sort()' user can use 'container_of()' and accesses the
"containing" object, which does not necessary exist for the list head.  So
the user can access RAM which does not belong to him.  If this is a write
access, we can end up with memory corruption.  This patch fixes the issue.

Signed-off-by: Don Mullis <don.mullis@gmail.com>
Tested-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/list_sort.c~lib-list_sort-do-not-pass-bad-pointers-to-cmp-callback lib/list_sort.c
--- a/lib/list_sort.c~lib-list_sort-do-not-pass-bad-pointers-to-cmp-callback
+++ a/lib/list_sort.c
@@ -70,7 +70,7 @@ static void merge_and_restore_back_links
 		 * element comparison is needed, so the client's cmp()
 		 * routine can invoke cond_resched() periodically.
 		 */
-		(*cmp)(priv, tail, tail);
+		(*cmp)(priv, tail->next, tail->next);
 
 		tail->next->prev = tail;
 		tail = tail->next;
_

Patches currently in -mm which might be from don.mullis@gmail.com are

linux-next.patch
lib-list_sort-do-not-pass-bad-pointers-to-cmp-callback.patch
lib-kconfigdebug-add-list_sort-debugging-switch.patch
lib-list_sort-test-use-more-reasonable-printk-levels.patch
lib-list_sort-test-use-generic-random32.patch
lib-list_sort-test-improve-errors-handling.patch
lib-list_sort-test-unify-test-messages.patch
lib-list_sort-test-check-element-addresses.patch

