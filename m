From: akpm@linux-foundation.org
Subject: [patch 076/114] kcov: detect double association with a
 single task
Date: Tue, 06 Feb 2018 15:40:28 -0800
Message-ID: <20180206234028.d4VX7RWd7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55460 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932106AbeBFXk3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:40:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dvyukov@google.com, mm-commits@vger.kernel.org, sp3485@columbia.edu, syzkaller@googlegroups.com, torvalds@linux-foundation.org

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
