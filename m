From: akpm@linux-foundation.org
Subject: [merged] mm-oom-fix-uninitialized-ret-in-task_will_free_mem.patch removed from -mm tree
Date: Mon, 15 Aug 2016 13:40:35 -0700
Message-ID: <57b228c3.67UmtfyxeL/Fbe9g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbcHOUkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Aug 2016 16:40:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: fix uninitialized ret in task_will_free_mem()
has been removed from the -mm tree.  Its filename was
     mm-oom-fix-uninitialized-ret-in-task_will_free_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Michal Hocko <mhocko@suse.com>
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


