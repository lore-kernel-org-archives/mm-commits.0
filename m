From: akpm@linux-foundation.org
Subject: [merged] list_debug-warn-for-adding-something-already-in-the-list.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:57 -0700
Message-ID: <20120531191957.5B5EEA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:45460 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103Ab2EaTT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:58 -0400
Received: by ggeh3 with SMTP id h3so136071gge.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@tilera.com, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     Subject: list_debug: WARN for adding something already in the list
has been removed from the -mm tree.  Its filename was
     list_debug-warn-for-adding-something-already-in-the-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -31,6 +31,9 @@ void __list_add(struct list_head *new,
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

Patches currently in -mm which might be from cmetcalf@tilera.com are

origin.patch
linux-next.patch

