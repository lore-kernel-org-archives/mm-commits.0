From: akpm@linux-foundation.org
Subject: + reiser4-use-wake_up_process-instead-of-wake_up-when-possible.patch added to -mm tree
Date: Tue, 12 Aug 2008 15:28:45 -0700
Message-ID: <200808122228.m7CMSjWR016793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876AbYHLW3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 18:29:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmh3093@gmail.com, edward.shishkin@gmail.com


The patch titled
     reiser4: use wake_up_process() instead of wake_up() when possible
has been added to the -mm tree.  Its filename is
     reiser4-use-wake_up_process-instead-of-wake_up-when-possible.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: use wake_up_process() instead of wake_up() when possible
From: Ryan Hope <rmh3093@gmail.com>

This was item #6 on the todo list for reiser4 inclusion in mainline:

Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/entd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/reiser4/entd.c~reiser4-use-wake_up_process-instead-of-wake_up-when-possible fs/reiser4/entd.c
--- a/fs/reiser4/entd.c~reiser4-use-wake_up_process-instead-of-wake_up-when-possible
+++ a/fs/reiser4/entd.c
@@ -218,7 +218,7 @@ void reiser4_leave_flush(struct super_bl
 #endif
 	spin_unlock(&ent->guard);
 	if (wake_up_ent)
-		wake_up(&ent->wait);
+		wake_up_process(ent->tsk);
 }
 
 #define ENTD_CAPTURE_APAGE_BURST SWAP_CLUSTER_MAX
@@ -304,7 +304,7 @@ int write_page_by_ent(struct page *page,
 	ent->nr_todo_reqs++;
 	list_add_tail(&rq.link, &ent->todo_list);
 	if (ent->nr_todo_reqs == 1)
-		wake_up(&ent->wait);
+		wake_up_process(ent->tsk);
 
 	spin_unlock(&ent->guard);
 
_

Patches currently in -mm which might be from rmh3093@gmail.com are

reiser4-compile-warning-cleanups.patch
reiser4-use-wake_up_process-instead-of-wake_up-when-possible.patch

