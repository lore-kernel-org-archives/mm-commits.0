From: akpm@linux-foundation.org
Subject: [merged] x86-uv-xpc-null-deref-when-mesq-becomes-empty.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:39:57 -0800
Message-ID: <200912162039.nBGKdvHI013571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965005AbZLPUkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, mingo@elte.hu, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     x86: uv: xpc NULL deref when mesq becomes empty
has been removed from the -mm tree.  Its filename was
     x86-uv-xpc-null-deref-when-mesq-becomes-empty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: uv: xpc NULL deref when mesq becomes empty
From: Robin Holt <holt@sgi.com>

Under heavy load conditions, our set of xpc messages may become exhausted.
 The code handles this correctly with the exception of the management code
which hits a NULL pointer dereference.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_uv.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc_uv.c~x86-uv-xpc-null-deref-when-mesq-becomes-empty drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~x86-uv-xpc-null-deref-when-mesq-becomes-empty
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -949,11 +949,13 @@ xpc_get_fifo_entry_uv(struct xpc_fifo_he
 		head->first = first->next;
 		if (head->first == NULL)
 			head->last = NULL;
+
+		head->n_entries--;
+		BUG_ON(head->n_entries < 0);
+
+		first->next = NULL;
 	}
-	head->n_entries--;
-	BUG_ON(head->n_entries < 0);
 	spin_unlock_irqrestore(&head->lock, irq_flags);
-	first->next = NULL;
 	return first;
 }
 
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch

