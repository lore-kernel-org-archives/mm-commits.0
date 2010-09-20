From: akpm@linux-foundation.org
Subject: + kernel-remove-pf_flusher.patch added to -mm tree
Date: Mon, 20 Sep 2010 12:14:53 -0700
Message-ID: <201009201914.o8KJEr4c008040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757135Ab0ITTP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Sep 2010 15:15:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, axboe@kernel.dk


The patch titled
     kernel: remove PF_FLUSHER
has been added to the -mm tree.  Its filename is
     kernel-remove-pf_flusher.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel: remove PF_FLUSHER
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

PF_FLUSHER is only ever set, not tested, remove it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c     |    2 +-
 include/linux/sched.h |    1 -
 mm/backing-dev.c      |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/fs-writeback.c~kernel-remove-pf_flusher fs/fs-writeback.c
--- a/fs/fs-writeback.c~kernel-remove-pf_flusher
+++ a/fs/fs-writeback.c
@@ -782,7 +782,7 @@ int bdi_writeback_thread(void *data)
 	struct backing_dev_info *bdi = wb->bdi;
 	long pages_written;
 
-	current->flags |= PF_FLUSHER | PF_SWAPWRITE;
+	current->flags |= PF_SWAPWRITE;
 	set_freezable();
 	wb->last_active = jiffies;
 
diff -puN include/linux/sched.h~kernel-remove-pf_flusher include/linux/sched.h
--- a/include/linux/sched.h~kernel-remove-pf_flusher
+++ a/include/linux/sched.h
@@ -1702,7 +1702,6 @@ extern void thread_group_times(struct ta
 #define PF_DUMPCORE	0x00000200	/* dumped core */
 #define PF_SIGNALED	0x00000400	/* killed by a signal */
 #define PF_MEMALLOC	0x00000800	/* Allocating memory */
-#define PF_FLUSHER	0x00001000	/* responsible for disk writeback */
 #define PF_USED_MATH	0x00002000	/* if unset the fpu must be initialized before use */
 #define PF_FREEZING	0x00004000	/* freeze in progress. do not account to load */
 #define PF_NOFREEZE	0x00008000	/* this thread should not be frozen */
diff -puN mm/backing-dev.c~kernel-remove-pf_flusher mm/backing-dev.c
--- a/mm/backing-dev.c~kernel-remove-pf_flusher
+++ a/mm/backing-dev.c
@@ -360,7 +360,7 @@ static int bdi_forker_thread(void *ptr)
 {
 	struct bdi_writeback *me = ptr;
 
-	current->flags |= PF_FLUSHER | PF_SWAPWRITE;
+	current->flags |= PF_SWAPWRITE;
 	set_freezable();
 
 	/*
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
kernel-remove-pf_flusher.patch
kernel-extract-thread-types-from-task_struct-flags.patch

