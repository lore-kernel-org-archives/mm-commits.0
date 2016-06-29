From: akpm@linux-foundation.org
Subject: [merged]
 mmoom_reaper-dont-call-mmput_async-without-atomic_inc_not_zero.patch
 removed from -mm tree
Date: Tue, 28 Jun 2016 19:01:36 -0700
Message-ID: <57732c00.fixd6NXEw9SN9wr9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbcF2CBh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:01:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, arnd@arndb.de, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,oom_reaper: don't call mmput_async() without atomic_inc_not_zero()
has been removed from the -mm tree.  Its filename was
     mmoom_reaper-dont-call-mmput_async-without-atomic_inc_not_zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm,oom_reaper: don't call mmput_async() without atomic_inc_not_zero()

Commit e2fe14564d3316d1 ("oom_reaper: close race with exiting task")
reduced frequency of needlessly selecting next OOM victim, but was
calling mmput_async() when atomic_inc_not_zero() failed.

Link: http://lkml.kernel.org/r/1464423365-5555-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/oom_kill.c~mmoom_reaper-dont-call-mmput_async-without-atomic_inc_not_zero mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom_reaper-dont-call-mmput_async-without-atomic_inc_not_zero
+++ a/mm/oom_kill.c
@@ -478,6 +478,7 @@ static bool __oom_reap_task(struct task_
 	mm = p->mm;
 	if (!atomic_inc_not_zero(&mm->mm_users)) {
 		task_unlock(p);
+		mm = NULL;
 		goto unlock_oom;
 	}
 
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

mmoom-remove-unused-argument-from-oom_scan_process_thread.patch

