From: akpm@linux-foundation.org
Subject: + kcov-detect-double-association-with-a-single-task.patch added
 to -mm tree
Date: Mon, 22 Jan 2018 14:37:44 -0800
Message-ID: <5a6667b8.zbfNueRFv3OEBHF7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48758 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbeAVWhp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Jan 2018 17:37:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, sp3485@columbia.edu, syzkaller@googlegroups.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: detect double association with a single task
has been added to the -mm tree.  Its filename is
     kcov-detect-double-association-with-a-single-task.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-detect-double-association-with-a-single-task.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-detect-double-association-with-a-single-task.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kasan-detect-invalid-frees-for-large-objects.patch
kasan-dont-use-__builtin_return_address1.patch
kasan-detect-invalid-frees-for-large-mempool-objects.patch
kasan-unify-code-between-kasan_slab_free-and-kasan_poison_kfree.patch
kasan-detect-invalid-frees.patch
kcov-detect-double-association-with-a-single-task.patch

