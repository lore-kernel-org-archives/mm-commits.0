From: akpm@linux-foundation.org
Subject: + mm-oom-fix-uninitialized-ret-in-task_will_free_mem.patch added
 to -mm tree
Date: Thu, 04 Aug 2016 14:46:58 -0700
Message-ID: <57a3b7d2.CWdJML75dpjki5gx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933827AbcHDVsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 17:48:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: fix uninitialized ret in task_will_free_mem()
has been added to the -mm tree.  Its filename is
     mm-oom-fix-uninitialized-ret-in-task_will_free_mem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-fix-uninitialized-ret-in-task_will_free_mem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-fix-uninitialized-ret-in-task_will_free_mem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mm, oom: fix uninitialized ret in task_will_free_mem()

    mm/oom_kill.c: In function `task_will_free_mem':
    mm/oom_kill.c:767: warning: `ret' may be used uninitialized in this function

If __task_will_free_mem() is never called inside the for_each_process()
loop, ret will not be initialized.

Fixes: 1af8bb43269563e4 ("mm, oom: fortify task_will_free_mem()")
Link: http://lkml.kernel.org/r/1470255599-24841-1-git-send-email-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mm-oom-fix-uninitialized-ret-in-task_will_free_mem mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-fix-uninitialized-ret-in-task_will_free_mem
+++ a/mm/oom_kill.c
@@ -764,7 +764,7 @@ bool task_will_free_mem(struct task_stru
 {
 	struct mm_struct *mm = task->mm;
 	struct task_struct *p;
-	bool ret;
+	bool ret = true;
 
 	/*
 	 * Skip tasks without mm because it might have passed its exit_mm and
_

Patches currently in -mm which might be from geert@linux-m68k.org are

slub-drop-bogus-inline-for-fixup_red_left.patch
mm-oom-fix-uninitialized-ret-in-task_will_free_mem.patch

