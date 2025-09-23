Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDD8256C8B
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597090; cv=none; b=AYCzLTcx9tqbqkgpkMP20rHqfgDuG2/AqUUeEj+DX8OeGTIvigPsnahTbSTuNwMQuBJcO+etTVAJ8IcZICmnaSyjEkkaYMRLZ6WM4LsiMRbmi0qwhvK4UazocbVK+M4KmjejxTOa1X1Gt+mQ6rZ8RkY953lKB9+i8ZQzrlLDq0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597090; c=relaxed/simple;
	bh=PYnVYAtVf94iChPOf5Up0AbhvRfdt5mfgX+CnJ6yX0w=;
	h=Date:To:From:Subject:Message-Id; b=HzrVbqYwIH2m+r5B437VuPUuxBSdejHYkMDZN3RMOrJn0zrN5SQdIIH2nPKI9VmEDW8sOE5ZYUYW8eVsnP+I3Sv1n4zj+lxhf6ExVV9NcBCoCJRrxmr2kCNT1Od8fNwVgX+aL5xId6kQVaRehBW7Bk+YLdCc7XybPdFrZwMiC34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ft4RxEjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ft4RxEjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE805C113D0;
	Tue, 23 Sep 2025 03:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597089;
	bh=PYnVYAtVf94iChPOf5Up0AbhvRfdt5mfgX+CnJ6yX0w=;
	h=Date:To:From:Subject:From;
	b=ft4RxEjON6IyQxb32T16CvwFwtRiXExsoAmql7GPUYDGT7N+JmCc2uFwbDCXsTSz0
	 4mgCvmI861lDdetRLj7T3GVYNJVQauglx0qS49TZAfdC9HoUYrQ24IB4ueUaZ5RPSa
	 bFVI3pqrYwD5Olyjky8hWp3GavJ/qWVsfoUyNpFM=
Date: Mon, 22 Sep 2025 20:11:29 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,jirislaby@kernel.org,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fix-the-wrong-comment-on-task_lock-nesting-with-tasklist_lock.patch removed from -mm tree
Message-Id: <20250923031129.AE805C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sched/task.h: fix the wrong comment on task_lock() nesting with tasklist_lock
has been removed from the -mm tree.  Its filename was
     fix-the-wrong-comment-on-task_lock-nesting-with-tasklist_lock.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: sched/task.h: fix the wrong comment on task_lock() nesting with tasklist_lock
Date: Sun, 14 Sep 2025 13:09:08 +0200

The ancient comment above task_lock() states that it can be nested outside
of read_lock(&tasklist_lock), but this is no longer true:

  CPU_0			CPU_1			CPU_2

  task_lock()		read_lock(tasklist)
  						write_lock_irq(tasklist)
  read_lock(tasklist)	task_lock()

Unless CPU_0 calls read_lock() in IRQ context, queued_read_lock_slowpath()
won't get the lock immediately, it will spin waiting for the pending
writer on CPU_2, resulting in a deadlock.

Link: https://lkml.kernel.org/r/20250914110908.GA18769@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/task.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/sched/task.h~fix-the-wrong-comment-on-task_lock-nesting-with-tasklist_lock
+++ a/include/linux/sched/task.h
@@ -210,9 +210,8 @@ static inline struct vm_struct *task_sta
  * pins the final release of task.io_context.  Also protects ->cpuset and
  * ->cgroup.subsys[]. And ->vfork_done. And ->sysvshm.shm_clist.
  *
- * Nests both inside and outside of read_lock(&tasklist_lock).
- * It must not be nested with write_lock_irq(&tasklist_lock),
- * neither inside nor outside.
+ * Nests inside of read_lock(&tasklist_lock). It must not be nested with
+ * write_lock_irq(&tasklist_lock), neither inside nor outside.
  */
 static inline void task_lock(struct task_struct *p)
 {
_

Patches currently in -mm which might be from oleg@redhat.com are


