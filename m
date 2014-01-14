From: akpm@linux-foundation.org
Subject: + fs-execc-call-arch_pick_mmap_layout-only-once.patch added to
 -mm tree
Date: Tue, 14 Jan 2014 15:00:39 -0800
Message-ID: <52d5c197.RK9FwWqp8Pd69UIp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaANXAk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jan 2014 18:00:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pat-lkml@erley.org, richard@nod.at

Subject: + fs-execc-call-arch_pick_mmap_layout-only-once.patch added to -mm tree
To: richard@nod.at,pat-lkml@erley.org
From: akpm@linux-foundation.org
Date: Tue, 14 Jan 2014 15:00:39 -0800


The patch titled
     Subject: fs/exec.c: call arch_pick_mmap_layout() only once
has been added to the -mm tree.  Its filename is
     fs-execc-call-arch_pick_mmap_layout-only-once.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-execc-call-arch_pick_mmap_layout-only-once.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-execc-call-arch_pick_mmap_layout-only-once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: fs/exec.c: call arch_pick_mmap_layout() only once

Currently both setup_new_exec() and flush_old_exec() issue a call to
arch_pick_mmap_layout().  As setup_new_exec() and flush_old_exec() are
always called pairwise arch_pick_mmap_layout() is called twice.

This patch removes one call from setup_new_exec() to have it only called
once.

Signed-off-by: Richard Weinberger <richard@nod.at>
Tested-by: Pat Erley <pat-lkml@erley.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/exec.c~fs-execc-call-arch_pick_mmap_layout-only-once fs/exec.c
--- a/fs/exec.c~fs-execc-call-arch_pick_mmap_layout-only-once
+++ a/fs/exec.c
@@ -842,7 +842,6 @@ static int exec_mmap(struct mm_struct *m
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
 	task_unlock(tsk);
-	arch_pick_mmap_layout(mm);
 	if (old_mm) {
 		up_read(&old_mm->mmap_sem);
 		BUG_ON(active_mm != old_mm);
_

Patches currently in -mm which might be from richard@nod.at are

add-generic-fixmaph.patch
um-use-generic-fixmaph.patch
fs-execc-call-arch_pick_mmap_layout-only-once.patch
linux-next.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

