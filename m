From: akpm@linux-foundation.org
Subject: [merged]
 kcov-detect-double-association-with-a-single-task.patch removed from -mm
 tree
Date: Wed, 07 Feb 2018 11:58:57 -0800
Message-ID: <20180207195857.MUSdEuyyS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60134 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754710AbeBGT66 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:58:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, mm-commits@vger.kernel.org, sp3485@columbia.edu, syzkaller@googlegroups.com


The patch titled
     Subject: kcov: detect double association with a single task
has been removed from the -mm tree.  Its filename was
     kcov-detect-double-association-with-a-single-task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: kcov: detect double association with a single task

Currently KCOV_ENABLE does not check if the current task is already
associated with another kcov descriptor. As the result it is possible
to associate a single task with more than one kcov descriptor, which
later leads to a memory leak of the old descriptor. This relation is
really meant to be one-to-one (task has only one back link).

Extend validation to detect such misuse.

Link: http://lkml.kernel.org/r/20180122082520.15716-1-dvyukov@google.com
Fixes: 5c9a8750a640 ("kernel: add kcov code coverage")
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: Shankara Pailoor <sp3485@columbia.edu>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/kcov.c~kcov-detect-double-association-with-a-single-task kernel/kcov.c
--- a/kernel/kcov.c~kcov-detect-double-association-with-a-single-task
+++ a/kernel/kcov.c
@@ -358,7 +358,8 @@ static int kcov_ioctl_locked(struct kcov
 		 */
 		if (kcov->mode != KCOV_MODE_INIT || !kcov->area)
 			return -EINVAL;
-		if (kcov->t != NULL)
+		t = current;
+		if (kcov->t != NULL || t->kcov != NULL)
 			return -EBUSY;
 		if (arg == KCOV_TRACE_PC)
 			kcov->mode = KCOV_MODE_TRACE_PC;
@@ -370,7 +371,6 @@ static int kcov_ioctl_locked(struct kcov
 #endif
 		else
 			return -EINVAL;
-		t = current;
 		/* Cache in task struct for performance. */
 		t->kcov_size = kcov->size;
 		t->kcov_area = kcov->area;
_

Patches currently in -mm which might be from dvyukov@google.com are


