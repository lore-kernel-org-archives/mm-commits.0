Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE5B372677
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028796; cv=none; b=g1ushPBIqU+a2+z3t+1WwoapB/lpDQbyKIVv5/kGLJmc9lHAoW8f8Ck1NOeUfkCtKjXun45I+i1RAV/XxCTew7PQ5bcEh/MW7b5KOnXxRsf61GcFdWdiKQ55TBUkanQUzlAl+QEw0WpfkXpghQ9BdtmQzhrnY0BFhIL7RT+m2Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028796; c=relaxed/simple;
	bh=oTnzRH5pnahZk94Me8EqeJwlzCyV8ncWyI8lF3uVujQ=;
	h=Date:To:From:Subject:Message-Id; b=RxCYxuS7cFh03gXrULGoCF/4B0dfqLdf+xb0ddob7+8RygCvWVwtc7SOh4PPl/RaJot/bM7TY9Yz2Z1l1u6nSEU4gG0ElVrI8X5tXII2erWJga8fq1a2OqDHayC1mSaabkVza5gJ1JSUsEoym6d2MUyAo8YZjd+gjAHV6HmqYlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NFKgECF8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NFKgECF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DC11F00893;
	Fri, 29 May 2026 04:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028795;
	bh=Q4xBt1UKS2swvPep0pF3yvKaOENj3k/iA5iTlRN3/ts=;
	h=Date:To:From:Subject;
	b=NFKgECF8PiBc7qoSIXPhZeCaLYXB2K1So9nPQmaO0F9jkJ66G+ql/1bk4jZ8JO26I
	 CRjwpAV21DaVLTWHeb+nd+rD97M5BygwzMbmtFXy56Xp7HFIxPWvd43gNd9nQF7Y9W
	 yi7VqPuhpqhEh/y7Vk3iRrjaKT0Ibfh+D7DfRiKA=
Date: Thu, 28 May 2026 21:26:34 -0700
To: mm-commits@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kcov-allow-simultaneous-kcov_enable-kcov_remote_enable.patch removed from -mm tree
Message-Id: <20260529042635.19DC11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov: allow simultaneous KCOV_ENABLE/KCOV_REMOTE_ENABLE
has been removed from the -mm tree.  Its filename was
     kcov-allow-simultaneous-kcov_enable-kcov_remote_enable.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[jannh@google.com: remove unused constant KCOV_MODE_REMOTE, per Dmitry]
  Link: https://lore.kernel.org/20260515-kcov-simultaneous-remote-v2-1-56fde1cfa509@google.com
[jannh@google.com: update documentation on remote coverage collection]
  Link: https://lore.kernel.org/20260519-kcov-docs-v1-1-5bb22f4cb20c@google.com
[jannh@google.com: move and reword sentence on simultaneous normal/remote collection
  Link: https://lore.kernel.org/20260520-kcov-docs-v2-1-819f78778763@google.com
Link: https://lore.kernel.org/20260505-kcov-simultaneous-remote-v1-1-a670ba7cefd2@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kcov.rst |    6 +
 include/linux/kcov.h             |    2 
 include/linux/sched.h            |    3 
 kernel/kcov.c                    |   94 ++++++++++++++++-------------
 4 files changed, 61 insertions(+), 44 deletions(-)

--- a/Documentation/dev-tools/kcov.rst~kcov-allow-simultaneous-kcov_enable-kcov_remote_enable
+++ a/Documentation/dev-tools/kcov.rst
@@ -237,6 +237,9 @@ Both ``kcov_remote_start`` and ``kcov_re
 collection sections. The way a handle is used depends on the context where the
 matching code section executes.
 
+A thread can use two separate KCOV instances to collect remote coverage and
+normal coverage at the same time.
+
 KCOV supports collecting remote coverage from the following contexts:
 
 1. Global kernel background tasks. These are the tasks that are spawned during
@@ -262,6 +265,9 @@ gets saved to the ``kcov_handle`` field
 needs to be passed to the newly spawned local tasks via custom kernel code
 modifications. Those tasks should in turn use the passed handle in their
 ``kcov_remote_start`` and ``kcov_remote_stop`` annotations.
+In the kernel, common handles are wrapped in a ``kcov_common_handle_id``, which
+consumes no space in builds without ``CONFIG_KCOV``; subsystems that integrate
+with this mechanism should not need to use any ``#ifdef CONFIG_KCOV`` or such.
 
 KCOV follows a predefined format for both global and common handles. Each
 handle is a ``u64`` integer. Currently, only the one top and the lower 4 bytes
--- a/include/linux/kcov.h~kcov-allow-simultaneous-kcov_enable-kcov_remote_enable
+++ a/include/linux/kcov.h
@@ -21,8 +21,6 @@ enum kcov_mode {
 	KCOV_MODE_TRACE_PC = 2,
 	/* Collecting comparison operands mode. */
 	KCOV_MODE_TRACE_CMP = 3,
-	/* The process owns a KCOV remote reference. */
-	KCOV_MODE_REMOTE = 4,
 };
 
 #define KCOV_IN_CTXSW	(1 << 30)
--- a/include/linux/sched.h~kcov-allow-simultaneous-kcov_enable-kcov_remote_enable
+++ a/include/linux/sched.h
@@ -1517,6 +1517,9 @@ struct task_struct {
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


