Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D332B23BD1B
	for <mm-commits@vger.kernel.org>; Sat,  9 May 2026 01:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778289738; cv=none; b=oCh/I3Q0LzLcAIiID6ob4j5l4k38Wj3jV8TkQxgeQJNj8KPuPnxxwOAw0oK823QF3BpFjuWLeatbG/PwpaPrxIlinmYUU6IbaXrv+4FMA5r6sB7Q/NQHUHqP8euQPe/HovzWRy2f+NyEO0mSuh87HNSV0izujva3bXw6qj0Ojqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778289738; c=relaxed/simple;
	bh=aDwOI2uCHUmp74RpST5lTfjcAf//ubYido/tRG8l3N4=;
	h=Date:To:From:Subject:Message-Id; b=H7QyBZismbUMKCrHreFz4bCvU8VzLD3AWNUR5xAvPo2unfjRimNFUI3+j39Vjyhi2pe/oqY2l3eu3vmCVKM3oB2HKUUFEJvrRsSX0si7k6FT1/2/38veEQ+88MJ/pmhr82vtsCDLeVzZ99g9bsfNF1rjWI9jMdN8cjCzaMFQOv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Xe7ctXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Xe7ctXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640C8C2BCB0;
	Sat,  9 May 2026 01:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778289738;
	bh=aDwOI2uCHUmp74RpST5lTfjcAf//ubYido/tRG8l3N4=;
	h=Date:To:From:Subject:From;
	b=1Xe7ctXVKB8SBbv4lqx1fyLjtTKtAiqH8BuVx3MYBHe/XHZTi/cFLJ2lNtUvWOPcS
	 cgZE72oAyE7D3HlvkIQtrqzJ6xAe4Ihdys+Ycg919lrQDdESetngDGHhaqDBw1S8ui
	 1IVLLmzY3Ys7IiQdnMWV2z1pKcsB/TtZq6AdFTck=
Date: Fri, 08 May 2026 18:22:17 -0700
To: mm-commits@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-allow-simultaneous-kcov_enable-kcov_remote_enable.patch added to mm-nonmm-unstable branch
Message-Id: <20260509012218.640C8C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcov: allow simultaneous KCOV_ENABLE/KCOV_REMOTE_ENABLE
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-allow-simultaneous-kcov_enable-kcov_remote_enable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-allow-simultaneous-kcov_enable-kcov_remote_enable.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Jann Horn <jannh@google.com>
Subject: kcov: allow simultaneous KCOV_ENABLE/KCOV_REMOTE_ENABLE
Date: Tue, 05 May 2026 11:00:46 +0200

Allow the same userspace thread to simultaneously collect normal coverage
in syscall context (KCOV_ENABLE) and remote coverage of asynchronous work
created by the thread (KCOV_REMOTE_ENABLE).  With this, remote KCOV
coverage becomes useful for generic fuzzing and not just fuzzing of
specific data injection interfaces.

This requires that the task_struct::kcov_* fields are separated into ones
that are used by the task that generates coverage, and ones that are used
by the task that requested remote coverage.  To split this up:

 - Split task_struct::kcov into kcov and kcov_remote. kcov_task_exit() now
   has to clean up both separately.
 - Only use task_struct::kcov_mode on the task that generates coverage.
 - Only reset task_struct::kcov_handle on the task that requested remote
   coverage.

After this change, fields used by the task that generates coverage are:

 - kcov_mode
 - kcov_size
 - kcov_area
 - kcov
 - kcov_sequence
 - kcov_softirq

Fields used by the task that requested remote coverage are:

 - kcov_remote
 - kcov_handle

Link: https://lore.kernel.org/20260505-kcov-simultaneous-remote-v1-1-a670ba7cefd2@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    3 +
 kernel/kcov.c         |   94 ++++++++++++++++++++++------------------
 2 files changed, 55 insertions(+), 42 deletions(-)

--- a/include/linux/sched.h~kcov-allow-simultaneous-kcov_enable-kcov_remote_enable
+++ a/include/linux/sched.h
@@ -1514,6 +1514,9 @@ struct task_struct {
 	/* KCOV descriptor wired with this task or NULL: */
 	struct kcov			*kcov;
 
+	/* KCOV descriptor for remote coverage collection from other tasks: */
+	struct kcov			*kcov_remote;
+
 	/* KCOV common handle for remote coverage collection: */
 	u64				kcov_handle;
 
--- a/kernel/kcov.c~kcov-allow-simultaneous-kcov_enable-kcov_remote_enable
+++ a/kernel/kcov.c
@@ -368,6 +368,7 @@ static void kcov_start(struct task_struc
 	WRITE_ONCE(t->kcov_mode, mode);
 }
 
+/* operates on coverage-generator-owned fields */
 static void kcov_stop(struct task_struct *t)
 {
 	WRITE_ONCE(t->kcov_mode, KCOV_MODE_DISABLED);
@@ -377,16 +378,17 @@ static void kcov_stop(struct task_struct
 	t->kcov_area = NULL;
 }
 
+/* operates on coverage-generator-owned fields */
 static void kcov_task_reset(struct task_struct *t)
 {
 	kcov_stop(t);
 	t->kcov_sequence = 0;
-	t->kcov_handle = 0;
 }
 
 void kcov_task_init(struct task_struct *t)
 {
 	kcov_task_reset(t);
+	t->kcov_remote = NULL;
 	t->kcov_handle = current->kcov_handle;
 }
 
@@ -423,11 +425,14 @@ static void kcov_remote_reset(struct kco
 static void kcov_disable(struct task_struct *t, struct kcov *kcov)
 	__must_hold(&kcov->lock)
 {
-	kcov_task_reset(t);
-	if (kcov->remote)
+	if (kcov->remote) {
+		t->kcov_handle = 0;
+		t->kcov_remote = NULL;
 		kcov_remote_reset(kcov);
-	else
+	} else {
+		kcov_task_reset(t);
 		kcov_reset(kcov);
+	}
 }
 
 static void kcov_get(struct kcov *kcov)
@@ -453,41 +458,47 @@ void kcov_task_exit(struct task_struct *
 	unsigned long flags;
 
 	kcov = t->kcov;
-	if (kcov == NULL)
-		return;
-
-	spin_lock_irqsave(&kcov->lock, flags);
-	kcov_debug("t = %px, kcov->t = %px\n", t, kcov->t);
-	/*
-	 * For KCOV_ENABLE devices we want to make sure that t->kcov->t == t,
-	 * which comes down to:
-	 *        WARN_ON(!kcov->remote && kcov->t != t);
-	 *
-	 * For KCOV_REMOTE_ENABLE devices, the exiting task is either:
-	 *
-	 * 1. A remote task between kcov_remote_start() and kcov_remote_stop().
-	 *    In this case we should print a warning right away, since a task
-	 *    shouldn't be exiting when it's in a kcov coverage collection
-	 *    section. Here t points to the task that is collecting remote
-	 *    coverage, and t->kcov->t points to the thread that created the
-	 *    kcov device. Which means that to detect this case we need to
-	 *    check that t != t->kcov->t, and this gives us the following:
-	 *        WARN_ON(kcov->remote && kcov->t != t);
-	 *
-	 * 2. The task that created kcov exiting without calling KCOV_DISABLE,
-	 *    and then again we make sure that t->kcov->t == t:
-	 *        WARN_ON(kcov->remote && kcov->t != t);
-	 *
-	 * By combining all three checks into one we get:
-	 */
-	if (WARN_ON(kcov->t != t)) {
+	if (kcov) {
+		spin_lock_irqsave(&kcov->lock, flags);
+		kcov_debug("t = %px, kcov->t = %px\n", t, kcov->t);
+		/*
+		 * This could be a remote task between kcov_remote_start() and
+		 * kcov_remote_stop().
+		 * In this case we should print a warning right away, since a
+		 * task shouldn't be exiting when it's in a kcov coverage
+		 * collection section.
+		 *
+		 * Otherwise, this should be a task that created a local
+		 * kcov instance and hasn't called KCOV_DISABLE.
+		 * Make sure that t->kcov->t is consistent.
+		 */
+		if (WARN_ON(kcov->remote) || WARN_ON(kcov->t != t)) {
+			spin_unlock_irqrestore(&kcov->lock, flags);
+			return;
+		}
+		/* Just to not leave dangling references behind. */
+		kcov_disable(t, kcov);
 		spin_unlock_irqrestore(&kcov->lock, flags);
-		return;
+		kcov_put(kcov);
+	}
+	kcov = t->kcov_remote;
+	if (kcov) {
+		spin_lock_irqsave(&kcov->lock, flags);
+		kcov_debug("t = %px, kcov->t = %px\n", t, kcov->t);
+		/*
+		 * This is a KCOV_REMOTE_ENABLE device, and the task is the
+		 * user task which has requested remote coverage collection.
+		 * Make sure that t->kcov->t is consistent.
+		 */
+		if (WARN_ON(!kcov->remote) || WARN_ON(kcov->t != t)) {
+			spin_unlock_irqrestore(&kcov->lock, flags);
+			return;
+		}
+		/* Just to not leave dangling references behind. */
+		kcov_disable(t, kcov);
+		spin_unlock_irqrestore(&kcov->lock, flags);
+		kcov_put(kcov);
 	}
-	/* Just to not leave dangling references behind. */
-	kcov_disable(t, kcov);
-	spin_unlock_irqrestore(&kcov->lock, flags);
-	kcov_put(kcov);
 }
 
 static int kcov_mmap(struct file *filep, struct vm_area_struct *vma)
@@ -629,9 +640,9 @@ static int kcov_ioctl_locked(struct kcov
 	case KCOV_DISABLE:
 		/* Disable coverage for the current task. */
 		unused = arg;
-		if (unused != 0 || current->kcov != kcov)
-			return -EINVAL;
 		t = current;
+		if (unused != 0 || (kcov != t->kcov && kcov != t->kcov_remote))
+			return -EINVAL;
 		if (WARN_ON(kcov->t != t))
 			return -EINVAL;
 		kcov_disable(t, kcov);
@@ -641,7 +652,7 @@ static int kcov_ioctl_locked(struct kcov
 		if (kcov->mode != KCOV_MODE_INIT || !kcov->area)
 			return -EINVAL;
 		t = current;
-		if (kcov->t != NULL || t->kcov != NULL)
+		if (kcov->t != NULL || t->kcov_remote != NULL)
 			return -EBUSY;
 		remote_arg = (struct kcov_remote_arg *)arg;
 		mode = kcov_get_mode(remote_arg->trace_mode);
@@ -651,8 +662,7 @@ static int kcov_ioctl_locked(struct kcov
 		    LONG_MAX / sizeof(unsigned long))
 			return -EINVAL;
 		kcov->mode = mode;
-		t->kcov = kcov;
-	        t->kcov_mode = KCOV_MODE_REMOTE;
+		t->kcov_remote = kcov;
 		kcov->t = t;
 		kcov->remote = true;
 		kcov->remote_size = remote_arg->area_size;
_

Patches currently in -mm which might be from jannh@google.com are

kcov-refactor-common-handle-id-into-kcov_common_handle_id.patch
kcov-allow-simultaneous-kcov_enable-kcov_remote_enable.patch

