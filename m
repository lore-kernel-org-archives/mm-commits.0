From: akpm@linux-foundation.org
Subject: - make-get_user_pages-interruptible-update.patch removed from -mm tree
Date: Tue, 02 Dec 2008 08:20:51 -0800
Message-ID: <200812021620.mB2GKp56027599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746AbYLBQVh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 11:21:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, hugh@veritas.com, matthew@wil.cx, menage@google.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     make-get_user_pages-interruptible-update
has been removed from the -mm tree.  Its filename was
     make-get_user_pages-interruptible-update.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make-get_user_pages-interruptible-update
From: Ying Han <yinghan@google.com>

Cc: Paul Menage <menage@google.com>
Signed-off-by: Ying Han <yinghan@google.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~make-get_user_pages-interruptible-update mm/memory.c
--- a/mm/memory.c~make-get_user_pages-interruptible-update
+++ a/mm/memory.c
@@ -1220,7 +1220,9 @@ int __get_user_pages(struct task_struct 
 
 			/*
 			 * If we have a pending SIGKILL, don't keep
-			 * allocating memory.
+			 * allocating memory. We check both current
+			 * and tsk to cover the cases where current
+			 * is allocating pages on behalf of tsk.
 			 */
 			if (unlikely(sigkill_pending(current) ||
 					sigkill_pending(tsk)))
_

Patches currently in -mm which might be from yinghan@google.com are

make-get_user_pages-interruptible-update.patch

