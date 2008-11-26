From: akpm@linux-foundation.org
Subject: + make-get_user_pages-interruptible-update.patch added to -mm tree
Date: Tue, 25 Nov 2008 16:16:17 -0800
Message-ID: <200811260016.mAQ0GHqi005132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753488AbYKZARA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 19:17:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, hugh@veritas.com, matthew@wil.cx, menage@google.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, rientjes@google.com


The patch titled
     make-get_user_pages-interruptible-update
has been added to the -mm tree.  Its filename is
     make-get_user_pages-interruptible-update.patch

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

make-get_user_pages-interruptible.patch
make-get_user_pages-interruptible-update.patch

