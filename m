From: akpm@linux-foundation.org
Subject: +
 mmoom_reaper-dont-call-mmput_async-without-atomic_inc_not_zero.patch added
 to -mm tree
Date: Wed, 01 Jun 2016 15:53:50 -0700
Message-ID: <574f677e.7PDxb+8urEgfFzDl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbcFAWxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2016 18:53:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, arnd@arndb.de, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,oom_reaper: don't call mmput_async() without atomic_inc_not_zero()
has been added to the -mm tree.  Its filename is
     mmoom_reaper-dont-call-mmput_async-without-atomic_inc_not_zero.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmoom_reaper-dont-call-mmput_async-without-atomic_inc_not_zero.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmoom_reaper-dont-call-mmput_async-without-atomic_inc_not_zero.patch

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
Subject: mm,oom_reaper: don't call mmput_async() without atomic_inc_not_zero()

Commit e2fe14564d3316d1 ("oom_reaper: close race with exiting task")
reduced frequency of needlessly selecting next OOM victim, but was
calling mmput_async() when atomic_inc_not_zero() failed.

Link: http://lkml.kernel.org/r/1464423365-5555-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Michal Hocko <mhocko@suse.com>
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

mmoom_reaper-dont-call-mmput_async-without-atomic_inc_not_zero.patch

