Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFFA8248B
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 04:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757995677; cv=none; b=qg+yWpxNYZ9PeZplKb9esNfu+lKTGNhaoIfiwvedV56tg75Qy95v/l6ERGEZvf+h+Qy32bVfYgyQZlwpNeOcTvTUv6xihvCcK/1Gv6Zk95ejzw0I1Nfr41pijZ+J7sSdZO7mxPlBkzkC9wmSCOnBrNy6JWOVJDbl1wPsMLuJjMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757995677; c=relaxed/simple;
	bh=RKJUVCWvFwzjN/Q37Y733wtl79nGCMwDcafr97JrFio=;
	h=Date:To:From:Subject:Message-Id; b=JXEUVbvUxPq9mXfXpeKooYjVAP4Roo6neEGR90AoIHyvLctOaQCNokZB7o8M2bfaQ6+ibmryjjhf1Fgilsn+KuuyEh+otQtmZzTVQ3Nbw5K1mvdixxCHP3/YHQwqHMKKs+tlCL53YvDOO7muGId8b+YhK2pDqTZDnHBXtejIqgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c61rSPv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c61rSPv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EB7C4CEEB;
	Tue, 16 Sep 2025 04:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757995676;
	bh=RKJUVCWvFwzjN/Q37Y733wtl79nGCMwDcafr97JrFio=;
	h=Date:To:From:Subject:From;
	b=c61rSPv3ZXZcXDIcem0w2sUTWdirq+QDuvSY31bhfgUsi1UYf175pPKVJep28b5ap
	 XieBd08AfEnNUyolgr+ituI9wi54F4tiWUT/mv14RtoD9s68BSQKDIOkSQchBoL4d8
	 YOTM9HuBYY01Mg3x6LZfDcllf98foHvOB8nLuXrg=
Date: Mon, 15 Sep 2025 21:07:56 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,jirislaby@kernel.org,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-the-wrong-comment-on-task_lock-nesting-with-tasklist_lock.patch added to mm-nonmm-unstable branch
Message-Id: <20250916040756.C7EB7C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sched/task.h: fix the wrong comment on task_lock() nesting with tasklist_lock
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fix-the-wrong-comment-on-task_lock-nesting-with-tasklist_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-the-wrong-comment-on-task_lock-nesting-with-tasklist_lock.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

fix-the-wrong-comment-on-task_lock-nesting-with-tasklist_lock.patch
fix-the-racy-usage-of-task_locktsk-group_leader-in-sys_prlimit64-paths.patch

