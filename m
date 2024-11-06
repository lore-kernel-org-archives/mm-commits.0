Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D83E18858C
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855609; cv=none; b=Qf/1L/YMnhEiwuXRlVLxDCpfCCQcW+vjQCZZkiEPAOMDIvkMAkQgnWFbTZ3EeCxsI+MGIJkUcEfrOWFYbZ9Ay+el3BonWHPrvjrlD6KysSSoV3SM+/6pehXJxackTjpgZ1dT/L25Yvt0NZf8Nb4YjkKaJlZ7Pu3cStn0W0oarOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855609; c=relaxed/simple;
	bh=8oGr3Zf0UOeQTWeUIm6AChLX0XIns2fe3S7nyl2lvaQ=;
	h=Date:To:From:Subject:Message-Id; b=n5Jt+NxQG4YKY4lRG+iX8ZL+zbR6lJpS2aqnC4S0i3+prkvaN2MaY2DLLD9NqydZ5staDfN8ffleyRbnF3DHNTC2WuTROEjtMbzoLHqca4SKHlYxhfRb8oGm2ND2/AhFuxJ4np4HJlPRr1xDui0GksdrJGv8WTi37U2GTltcPuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cu3AbdUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cu3AbdUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1027C4CECF;
	Wed,  6 Nov 2024 01:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855609;
	bh=8oGr3Zf0UOeQTWeUIm6AChLX0XIns2fe3S7nyl2lvaQ=;
	h=Date:To:From:Subject:From;
	b=Cu3AbdUvX63Muy+7bzZuTXOVaMSg+g2hZ3HrissnekN2Aa9LkkYlP6Q5qtjQ4K8pA
	 Zk8xTcP6xm0/zlshTnNUnA9SMqURZ6rpdu2D1W6Lm8CZSMx45FIOrghNJevmXBXgtf
	 Lf/EXmUjOzF7VAX2Bz7jPlZeGF11W2y7VGVW/pts=
Date: Tue, 05 Nov 2024 17:13:28 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,tzimmermann@suse.de,torvalds@linux-foundation.org,stephen.smalley.work@gmail.com,serge@hallyn.com,rostedt@goodmis.org,qmo@kernel.org,penguin-kernel@I-love.SAKURA.ne.jp,paul@paul-moore.com,omosnace@redhat.com,mripard@kernel.org,matus.jokay@stuba.sk,maarten.lankhorst@linux.intel.com,keescook@chromium.org,justinstitt@google.com,jmorris@namei.org,jack@suse.cz,horms@kernel.org,eparis@redhat.com,ebiederm@xmission.com,daniel.vetter@ffwll.ch,catalin.marinas@arm.com,brauner@kernel.org,andy.shevchenko@gmail.com,alx@kernel.org,alexei.starovoitov@gmail.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] get-rid-of-__get_task_comm.patch removed from -mm tree
Message-Id: <20241106011328.F1027C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: get rid of __get_task_comm()
has been removed from the -mm tree.  Its filename was
     get-rid-of-__get_task_comm.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: get rid of __get_task_comm()
Date: Mon, 7 Oct 2024 22:49:05 +0800

Patch series "Improve the copy of task comm", v8.

Using {memcpy,strncpy,strcpy,kstrdup} to copy the task comm relies on the
length of task comm.  Changes in the task comm could result in a
destination string that is overflow.  Therefore, we should explicitly
ensure the destination string is always NUL-terminated, regardless of the
task comm.  This approach will facilitate future extensions to the task
comm.

As suggested by Linus [0], we can identify all relevant code with the
following git grep command:

  git grep 'memcpy.*->comm\>'
  git grep 'kstrdup.*->comm\>'
  git grep 'strncpy.*->comm\>'
  git grep 'strcpy.*->comm\>'

PATCH #2~#4:   memcpy
PATCH #5~#6:   kstrdup
PATCH #7:      strcpy

Please note that strncpy() is not included in this series as it is being
tracked by another effort. [1]


This patch (of 7):

We want to eliminate the use of __get_task_comm() for the following
reasons:

- The task_lock() is unnecessary
  Quoted from Linus [0]:
  : Since user space can randomly change their names anyway, using locking
  : was always wrong for readers (for writers it probably does make sense
  : to have some lock - although practically speaking nobody cares there
  : either, but at least for a writer some kind of race could have
  : long-term mixed results

Link: https://lkml.kernel.org/r/20241007144911.27693-1-laoar.shao@gmail.com
Link: https://lkml.kernel.org/r/20241007144911.27693-2-laoar.shao@gmail.com
Link: https://lore.kernel.org/all/CAHk-=wivfrF0_zvf+oj6==Sh=-npJooP8chLPEfaFV0oNYTTBA@mail.gmail.com [0]
Link: https://lore.kernel.org/all/CAHk-=whWtUC-AjmGJveAETKOMeMFSTwKwu99v7+b6AyHMmaDFA@mail.gmail.com/
Link: https://lore.kernel.org/all/CAHk-=wjAmmHUg6vho1KjzQi2=psR30+CogFd4aXrThr2gsiS4g@mail.gmail.com/ [0]
Link: https://github.com/KSPP/linux/issues/90 [1]
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Matus Jokay <matus.jokay@stuba.sk>
Cc: Alejandro Colomar <alx@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Quentin Monnet <qmo@kernel.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c             |   10 ----------
 fs/proc/array.c       |    2 +-
 include/linux/sched.h |   28 ++++++++++++++++++++++------
 kernel/kthread.c      |    2 +-
 4 files changed, 24 insertions(+), 18 deletions(-)

--- a/fs/exec.c~get-rid-of-__get_task_comm
+++ a/fs/exec.c
@@ -1189,16 +1189,6 @@ static int unshare_sighand(struct task_s
 	return 0;
 }
 
-char *__get_task_comm(char *buf, size_t buf_size, struct task_struct *tsk)
-{
-	task_lock(tsk);
-	/* Always NUL terminated and zero-padded */
-	strscpy_pad(buf, tsk->comm, buf_size);
-	task_unlock(tsk);
-	return buf;
-}
-EXPORT_SYMBOL_GPL(__get_task_comm);
-
 /*
  * These functions flushes out all traces of the currently running executable
  * so that a new one can be started
--- a/fs/proc/array.c~get-rid-of-__get_task_comm
+++ a/fs/proc/array.c
@@ -109,7 +109,7 @@ void proc_task_name(struct seq_file *m,
 	else if (p->flags & PF_KTHREAD)
 		get_kthread_comm(tcomm, sizeof(tcomm), p);
 	else
-		__get_task_comm(tcomm, sizeof(tcomm), p);
+		get_task_comm(tcomm, p);
 
 	if (escape)
 		seq_escape_str(m, tcomm, ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
--- a/include/linux/sched.h~get-rid-of-__get_task_comm
+++ a/include/linux/sched.h
@@ -1121,9 +1121,12 @@ struct task_struct {
 	/*
 	 * executable name, excluding path.
 	 *
-	 * - normally initialized setup_new_exec()
-	 * - access it with [gs]et_task_comm()
-	 * - lock it with task_lock()
+	 * - normally initialized begin_new_exec()
+	 * - set it with set_task_comm()
+	 *   - strscpy_pad() to ensure it is always NUL-terminated and
+	 *     zero-padded
+	 *   - task_lock() to ensure the operation is atomic and the name is
+	 *     fully updated.
 	 */
 	char				comm[TASK_COMM_LEN];
 
@@ -1938,10 +1941,23 @@ static inline void set_task_comm(struct
 	__set_task_comm(tsk, from, false);
 }
 
-extern char *__get_task_comm(char *to, size_t len, struct task_struct *tsk);
+/*
+ * - Why not use task_lock()?
+ *   User space can randomly change their names anyway, so locking for readers
+ *   doesn't make sense. For writers, locking is probably necessary, as a race
+ *   condition could lead to long-term mixed results.
+ *   The strscpy_pad() in __set_task_comm() can ensure that the task comm is
+ *   always NUL-terminated and zero-padded. Therefore the race condition between
+ *   reader and writer is not an issue.
+ *
+ * - BUILD_BUG_ON() can help prevent the buf from being truncated.
+ *   Since the callers don't perform any return value checks, this safeguard is
+ *   necessary.
+ */
 #define get_task_comm(buf, tsk) ({			\
-	BUILD_BUG_ON(sizeof(buf) != TASK_COMM_LEN);	\
-	__get_task_comm(buf, sizeof(buf), tsk);		\
+	BUILD_BUG_ON(sizeof(buf) < TASK_COMM_LEN);	\
+	strscpy_pad(buf, (tsk)->comm);			\
+	buf;						\
 })
 
 #ifdef CONFIG_SMP
--- a/kernel/kthread.c~get-rid-of-__get_task_comm
+++ a/kernel/kthread.c
@@ -101,7 +101,7 @@ void get_kthread_comm(char *buf, size_t
 	struct kthread *kthread = to_kthread(tsk);
 
 	if (!kthread || !kthread->full_name) {
-		__get_task_comm(buf, buf_size, tsk);
+		strscpy(buf, tsk->comm, buf_size);
 		return;
 	}
 
_

Patches currently in -mm which might be from laoar.shao@gmail.com are


