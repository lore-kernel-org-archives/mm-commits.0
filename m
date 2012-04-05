From: akpm@linux-foundation.org
Subject: + list_debug-warn-for-adding-something-already-in-the-list.patch added to -mm tree
Date: Thu, 05 Apr 2012 16:57:02 -0700
Message-ID: <20120405235702.55F81A0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:49018 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2DEX5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Apr 2012 19:57:04 -0400
Received: by yhgm50 with SMTP id m50so232094yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 05 Apr 2012 16:57:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmetcalf@tilera.com, andi@firstfloor.org


The patch titled
     Subject: list_debug: WARN for adding something already in the list
has been added to the -mm tree.  Its filename is
     list_debug-warn-for-adding-something-already-in-the-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Metcalf <cmetcalf@tilera.com>
Subject: list_debug: WARN for adding something already in the list

We were bitten by this at one point and added an additional sanity test
for DEBUG_LIST.  You can't validly add a list_head to a list where either
prev or next is the same as the thing you're adding.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_debug.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN lib/list_debug.c~list_debug-warn-for-adding-something-already-in-the-list lib/list_debug.c
--- a/lib/list_debug.c~list_debug-warn-for-adding-something-already-in-the-list
+++ a/lib/list_debug.c
@@ -30,6 +30,9 @@ void __list_add(struct list_head *new,
 		"list_add corruption. prev->next should be "
 		"next (%p), but was %p. (prev=%p).\n",
 		next, prev->next, prev);
+	WARN(new == prev || new == next,
+	     "list_add double add: new=%p, prev=%p, next=%p.\n",
+	     new, prev, next);
 	next->prev = new;
 	new->next = next;
 	new->prev = prev;
_
Subject: Subject: list_debug: WARN for adding something already in the list

Patches currently in -mm which might be from cmetcalf@tilera.com are

origin.patch
linux-next.patch
list_debug-warn-for-adding-something-already-in-the-list.patch
c-r-ipc-message-queue-receive-cleanup.patch
c-r-ipc-message-queue-stealing-feature-introduced.patch

