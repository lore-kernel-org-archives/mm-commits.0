From: akpm@linux-foundation.org
Subject: - reiser4-use-wake_up_process-instead-of-wake_up-when-possible.patch removed from -mm tree
Date: Tue, 30 Dec 2008 15:11:02 -0800
Message-ID: <200812302311.mBUNB22C019804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbYL3XLe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:11:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmh3093@gmail.com, edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: use wake_up_process() instead of wake_up() when possible
has been removed from the -mm tree.  Its filename was
     reiser4-use-wake_up_process-instead-of-wake_up-when-possible.patch

This patch was dropped because it was folded into reiser4.patch

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

reiser4.patch
reiser4-use-wake_up_process-instead-of-wake_up-when-possible.patch

