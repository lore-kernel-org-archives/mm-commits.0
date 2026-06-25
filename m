Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABFA2D8DB0
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 04:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782361776; cv=none; b=MPg26SbV9XTe4+mcgIBKU6utDjVZL79opXOO1opQxKtsb8+burZ1W3Al8awdv02nxFdlrP8EgtfFthjL2aUp7z0S+eq65ljN1xFaQ/sMDyTJS9Hx32sLj0pQX+ekZPGSb6CmnqooeS1uj3WRta/adDzL5PBp8B3VBzaH2VVlBMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782361776; c=relaxed/simple;
	bh=h5YUN/M2jZ2BfIX0AlqGHaGq/ANSuJdyjSvfhWGRwfQ=;
	h=Date:To:From:Subject:Message-Id; b=qDGd7XwOZ+mXpYcQ2S6U9EO6wua1UvP/w9nOr1m5SVcTY8vJme74KpMlI3SDATi8YpdmHZKmjF75dRvNFxlRS1sLFbmqIgs5jBFDwuo52jRpI+j+sa/MlYMTxWSLlnlLJQKIYvGrpozsoJHQvD9eXgVqXn+zCoNPm8OISRtYa5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J/qaN7eV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J/qaN7eV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDE31F00A3A;
	Thu, 25 Jun 2026 04:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782361774;
	bh=yLtrtKqXQlGjsReKTWZWZ9X00RWMR8fomx5HVObpmyo=;
	h=Date:To:From:Subject;
	b=J/qaN7eVlvZG070u/Zw6tQucIB2E9TM+8YH0TOXmqctALsWrI2JaZEIJnHsRV/yON
	 zpy4W1iCZ/+WoJsXNvDcvSug9HBSj0eTCChWKzwvgzvInzOwCwmtJ3gxyQJ2yHttod
	 iY85hLYEzezCfdM927VNX671H5utZp9lpeHSm34I=
Date: Wed, 24 Jun 2026 21:29:34 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,oleg@redhat.com,lance.yang@linux.dev,dave@stgolabs.net,catalin.marinas@arm.com,cai@lca.pw,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch added to mm-new branch
Message-Id: <20260625042934.7DDE31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kmemleak: stop the task stack scan early when interrupted
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/kmemleak: stop the task stack scan early when interrupted
Date: Mon, 15 Jun 2026 10:49:07 -0700

scan_block() already checks scan_should_stop() for every pointer and bails
out of the current block, but the task stack walk cannot tell and keeps
issuing a separate scan_should_stop() between every task.

Return that status from scan_block() and use it as the task stack loop
condition, so the walk stops as soon as a scan is interrupted.

Link: https://lore.kernel.org/20260615-kmemleak-stack-resched-v3-2-acecd7d7fd92@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Qian Cai <cai@lca.pw>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted
+++ a/mm/kmemleak.c
@@ -1524,22 +1524,25 @@ static int scan_should_stop(void)
 
 /*
  * Scan a memory block (exclusive range) for valid pointers and add those
- * found to the gray list.
+ * found to the gray list. Return non-zero if the scan was interrupted.
  */
-static void scan_block(void *_start, void *_end,
-		       struct kmemleak_object *scanned)
+static int scan_block(void *_start, void *_end,
+		      struct kmemleak_object *scanned)
 {
 	unsigned long *ptr;
 	unsigned long *start = PTR_ALIGN(_start, BYTES_PER_POINTER);
 	unsigned long *end = _end - (BYTES_PER_POINTER - 1);
 	unsigned long flags;
+	int stop = 0;
 
 	raw_spin_lock_irqsave(&kmemleak_lock, flags);
 	for (ptr = start; ptr < end; ptr++) {
 		unsigned long pointer;
 
-		if (scan_should_stop())
+		if (scan_should_stop()) {
+			stop = 1;
 			break;
+		}
 
 		kasan_disable_current();
 		pointer = *(unsigned long *)kasan_reset_tag((void *)ptr);
@@ -1549,6 +1552,8 @@ static void scan_block(void *_start, voi
 		pointer_update_refs(scanned, pointer, OBJECT_PERCPU);
 	}
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
+
+	return stop;
 }
 
 /*
@@ -1704,6 +1709,7 @@ static void kmemleak_scan_task_stacks(vo
 {
 	struct pid *pid;
 	int nr = 1;
+	int stop = 0;
 
 	do {
 		struct task_struct *p = NULL;
@@ -1722,13 +1728,13 @@ static void kmemleak_scan_task_stacks(vo
 			void *stack = try_get_task_stack(p);
 
 			if (stack) {
-				scan_block(stack, stack + THREAD_SIZE, NULL);
+				stop = scan_block(stack, stack + THREAD_SIZE, NULL);
 				put_task_stack(p);
 			}
 			put_task_struct(p);
 		}
 		cond_resched();
-	} while (pid && !scan_should_stop());
+	} while (pid && !stop);
 }
 
 /*
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-avoid-soft-lockup-when-scanning-task-stacks.patch
mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch
mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch

