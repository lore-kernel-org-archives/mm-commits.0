From: akpm@linux-foundation.org
Subject: + ipc-do-not-goto-to-the-next-line.patch added to -mm tree
Date: Tue, 18 Nov 2008 21:06:13 -0800
Message-ID: <200811190506.mAJ56DOt004290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbYKSFGq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 00:06:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, wangcong@zeuux.org


The patch titled
     ipc: do not goto to the next line
has been added to the -mm tree.  Its filename is
     ipc-do-not-goto-to-the-next-line.patch

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

backlight-value-of-ili9320_rgb_if2-register-should-not-be-hardcoded.patch
ipc-do-not-goto-to-the-next-line.patch

