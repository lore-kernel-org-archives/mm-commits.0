From: akpm@linux-foundation.org
Subject: + oom_reaper-avoid-pointless-atomic_inc_not_zero-usage.patch
 added to -mm tree
Date: Mon, 06 Jun 2016 14:16:15 -0700
Message-ID: <5755e81f.Iiu/RYbqC6vncsDn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbcFFVQQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2016 17:16:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, arnd@arndb.de, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom_reaper: avoid pointless atomic_inc_not_zero usage.
has been added to the -mm tree.  Its filename is
     oom_reaper-avoid-pointless-atomic_inc_not_zero-usage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom_reaper-avoid-pointless-atomic_inc_not_zero-usage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom_reaper-avoid-pointless-atomic_inc_not_zero-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: oom_reaper: avoid pointless atomic_inc_not_zero usage.

Since commit 36324a990cf578b5 ("oom: clear TIF_MEMDIE after oom_reaper
managed to unmap the address space") changed to use find_lock_task_mm()
for finding a mm_struct to reap, it is guaranteed that mm->mm_users > 0
because find_lock_task_mm() returns a task_struct with ->mm != NULL. 
Therefore, we can safely use atomic_inc().

Link: http://lkml.kernel.org/r/1465024759-8074-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN mm/oom_kill.c~oom_reaper-avoid-pointless-atomic_inc_not_zero-usage mm/oom_kill.c
--- a/mm/oom_kill.c~oom_reaper-avoid-pointless-atomic_inc_not_zero-usage
+++ a/mm/oom_kill.c
@@ -474,14 +474,8 @@ static bool __oom_reap_task(struct task_
 	p = find_lock_task_mm(tsk);
 	if (!p)
 		goto unlock_oom;
-
 	mm = p->mm;
-	if (!atomic_inc_not_zero(&mm->mm_users)) {
-		task_unlock(p);
-		mm = NULL;
-		goto unlock_oom;
-	}
