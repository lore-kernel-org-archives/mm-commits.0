From: akpm@linux-foundation.org
Subject: [patch 01/41] mm,oom_reaper: don't call mmput_async() without
 atomic_inc_not_zero()
Date: Fri, 24 Jun 2016 14:48:35 -0700
Message-ID: <576daab3.ZiOdMEl4KD62H84k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbcFXVsg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:48:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, penguin-kernel@I-love.SAKURA.ne.jp, arnd@arndb.de, mhocko@suse.com

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
