From: akpm@linux-foundation.org
Subject: - ipc-do-not-goto-to-the-next-line.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:36 -0800
Message-ID: <200901072220.n07MKaaS019825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932521AbZAGWdk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:33:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     ipc: do not goto to the next line
has been removed from the -mm tree.  Its filename was
     ipc-do-not-goto-to-the-next-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: do not goto to the next line
From: "Denis V. Lunev" <den@openvz.org>

Signed-off-by: Denis V. Lunev <den@openvz.org>
Reviewed-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN ipc/sem.c~ipc-do-not-goto-to-the-next-line ipc/sem.c
--- a/ipc/sem.c~ipc-do-not-goto-to-the-next-line
+++ a/ipc/sem.c
@@ -1216,7 +1216,6 @@ asmlinkage long sys_semtimedop(int semid
 	if (timeout && jiffies_left == 0)
 		error = -EAGAIN;
 	list_del(&queue.list);
-	goto out_unlock_free;
 
 out_unlock_free:
 	sem_unlock(sma);
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
linux-next.patch

