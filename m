From: akpm@linux-foundation.org
Subject: + mmoom-remove-oom_lock-serialization-from-the-oom-reaper.patch
 added to -mm tree
Date: Mon, 27 Nov 2017 16:06:36 -0800
Message-ID: <5a1ca88c.Llnopit430jo9Zdy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48900 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752406AbdK1AGi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2017 19:06:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, aarcange@redhat.com, hannes@cmpxchg.org, mhocko@suse.com, mjaggi@caviumnetworks.com, oleg@redhat.com, rientjes@google.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,oom: remove oom_lock serialization from the OOM reaper
has been added to the -mm tree.  Its filename is
     mmoom-remove-oom_lock-serialization-from-the-oom-reaper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmoom-remove-oom_lock-serialization-from-the-oom-reaper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmoom-remove-oom_lock-serialization-from-the-oom-reaper.patch

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
Subject: mm,oom: remove oom_lock serialization from the OOM reaper

Since "mm,oom: Move last second allocation to inside the OOM killer."
changed to do last second allocation attempt after confirming that there
is no OOM victim's mm without MMF_OOM_SKIP set, we no longer need to block
the OOM reaper using oom_lock.  This patch should allow start reclaiming
earlier than now.

Link: http://lkml.kernel.org/r/1511607169-5084-3-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Manish Jaggi <mjaggi@caviumnetworks.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN mm/oom_kill.c~mmoom-remove-oom_lock-serialization-from-the-oom-reaper mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom-remove-oom_lock-serialization-from-the-oom-reaper
+++ a/mm/oom_kill.c
@@ -491,22 +491,6 @@ static bool __oom_reap_task_mm(struct ta
 	struct vm_area_struct *vma;
 	bool ret = true;
 
-	/*
-	 * We have to make sure to not race with the victim exit path
-	 * and cause premature new oom victim selection:
-	 * __oom_reap_task_mm		exit_mm
-	 *   mmget_not_zero
-	 *				  mmput
-	 *				    atomic_dec_and_test
-	 *				  exit_oom_victim
-	 *				[...]
-	 *				out_of_memory
-	 *				  select_bad_process
-	 *				    # no TIF_MEMDIE task selects new victim
-	 *  unmap_page_range # frees some memory
-	 */
-	mutex_lock(&oom_lock);
