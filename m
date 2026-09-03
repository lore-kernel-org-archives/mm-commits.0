Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C48736896D;
	Thu,  3 Sep 2026 23:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788479736; cv=none; b=LiAnnJ4RXjA7+WrMZbr2AvsGHgx/mnrTt+uN0oCoIxs2bD1cBQWwzAul62qESuF0bNt4z8RZ+rQQWwQojVlyDyVpr0CjetDUUg606JcpcwMVvIKmyDwgxU3XL8v0iee31Jmhnv/OyTwkLUfFMn8vJx9rbVti0NsZgrbtsUTBkc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788479736; c=relaxed/simple;
	bh=EWIqrdXxmFzBpVvYQZAvyQrAaWzx2aA4+vuWt/WTOBU=;
	h=Date:To:From:Subject:Message-Id; b=hYb+xsylMo+vxIWV8396y2DZjGLD0YVqxZ6DvGlJINJpxJREJlxMPQaL5v3X66VzgaVBag6lu9eArqOuzsYcEYyobIrqtcrO2rYCvfbt12ge1fGRDetqVsc0+TCZ13IO5wdlbDlOpV1InLkX1TKKRMxVpJwRkRAYv+GkDyyDQ+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1qMeO2ys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1qMeO2ys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05831F000E9;
	Thu,  3 Sep 2026 23:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788479735;
	bh=gQ43+T65oPryyT5UvnBbA9jnzO/m3sStBQrel6+PjF4=;
	h=Date:To:From:Subject;
	b=1qMeO2yspt+nVRgZe2eHRGLLsuy2khh/XVbPpJbi21azHPAlqNVDe885w0XVUH0Si
	 LkAX7Tx1PO0x578wwFoU3neHK5KKouxUmNENdjJQB3M/ceTgggyItInnSRkj8R3bpu
	 ynjn5A/iVB0GHGBwU6Dj0JBX+sUVAh+fEoF5J5DM=
Date: Thu, 03 Sep 2026 16:55:34 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,richard120310@gmail.com,handyhandyman.adam@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-plist-fix-plist_requeue-corrupting-order-in-the-last-bucket.patch added to mm-nonmm-unstable branch
Message-Id: <20260903235534.F05831F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/plist: fix plist_requeue() corrupting order in the last bucket
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-plist-fix-plist_requeue-corrupting-order-in-the-last-bucket.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-plist-fix-plist_requeue-corrupting-order-in-the-last-bucket.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Adam Harshbarger <handyhandyman.adam@gmail.com>
Subject: lib/plist: fix plist_requeue() corrupting order in the last bucket
Date: Thu, 3 Sep 2026 17:24:56 -0500

plist_requeue() is meant to move a node to the end of its own priority
run.  When the node heads the *last* priority bucket it is instead placed
at the head of the whole list, leaving the plist unsorted:

  built:      A(prio 0) B(prio 1) C(prio 1)
  requeue(B): B(prio 1) A(prio 0) C(prio 1)
  expected:   A(prio 0) C(prio 1) B(prio 1)

prio_list is a *headless* circular ring of the nodes that lead each
priority bucket.  The shortcut added by commit 95d4b3450ebe ("lib/plist.c:
add shortcut for plist_requeue()") takes

	iter = list_entry(iter->prio_list.next, struct plist_node,
			  prio_list);
	node_next = &iter->node_list;

which from the last bucket wraps round to the *first* bucket, so node_next
ends up pointing at the head of the list rather than at its end.  The
plist_for_each_continue() loop immediately below it computes the correct
answer (&head->node_list) for that case.

With any bucket after it the shortcut is correct, which is why this went
unnoticed: the benchmark in that commit measured elapsed time and never
checked the resulting order.

Keep the shortcut -- it is a real win -- but exclude the case where iter's
bucket is the last one, which is exactly when its ring successor is the
first bucket again.

Reachable from mm/swapfile.c, which rotates swap_avail_heads[] with
plist_requeue().  It takes three or more swap devices: at least two
distinct priorities, so that a later bucket exists for the ring to wrap
round from, and two or more devices sharing the lowest priority, so that
plist_requeue() does not return early.  One device per priority returns
early at the node->prio != iter->prio test.  A single priority is also
safe, but for a different reason worth stating: with one bucket no node is
ever linked onto prio_list at all -- plist_add() skips it for the first
node and for every node whose predecessor shares its priority -- so
list_empty(&iter->prio_list) holds and the shortcut is never entered.

Tested by driving three implementations -- the pre-95d4b3450ebe code,
current mainline, and this patch -- through 1,084,492 identical random
add/del/requeue operations over 24 nodes and 1..5 distinct priorities,
comparing the resulting node_list node for node after every operation:

  variant             differs from pre-95d4b3450ebe  left list unsorted
  pre-95d4b3450ebe    -- (reference)                                  0
  mainline                                  289,297             276,660
  this patch                                      0                   0

Link: https://lore.kernel.org/20260903222456.1881786-1-handyhandyman.adam@gmail.com
Fixes: 95d4b3450ebe ("lib/plist.c: add shortcut for plist_requeue()")
Signed-off-by: Adam Harshbarger <handyhandyman.adam@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: I Hsin Cheng <richard120310@gmail.com>
Cc: <stable@vger.kernel.org> # v6.15+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/plist.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/lib/plist.c~lib-plist-fix-plist_requeue-corrupting-order-in-the-last-bucket
+++ a/lib/plist.c
@@ -174,8 +174,15 @@ void plist_requeue(struct plist_node *no
 	/*
 	 * After plist_del(), iter is the replacement of the node.  If the node
 	 * was on prio_list, take shortcut to find node_next instead of looping.
+	 *
+	 * prio_list is a headless ring, so from the LAST bucket ->next wraps
+	 * round to the first one; in that case node_next is the list head.
 	 */
 	if (!list_empty(&iter->prio_list)) {
+		struct plist_node *first = plist_first(head);
+
+		if (iter->prio_list.next == &first->prio_list)
+			goto queue;
 		iter = list_entry(iter->prio_list.next, struct plist_node,
 				  prio_list);
 		node_next = &iter->node_list;
_

Patches currently in -mm which might be from handyhandyman.adam@gmail.com are

lib-plist-fix-plist_requeue-corrupting-order-in-the-last-bucket.patch

