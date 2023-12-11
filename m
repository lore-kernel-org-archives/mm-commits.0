Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8063679D8
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qDecIYdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E966BC433C9;
	Mon, 11 Dec 2023 01:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257757;
	bh=UzPbRlUIdBYTuL2GrDhXeP3oK5gYYOvDX9bLkFFAvH0=;
	h=Date:To:From:Subject:From;
	b=qDecIYdQ9sfgLPVpExShDwSCv18M2fH12gt5K0TcLx740OOcPd9BOt/0vbDPRll0x
	 1kDGswMhdWh297i2VU9n1FC7jRymzVeosbQ4HEpl3+rP0a5V1aGScoWPOVO1sfdWkG
	 kvkp8edRG7Hva1FJhMzSUoOycWLiJRJJHCVOP2/g=
Date: Sun, 10 Dec 2023 17:22:36 -0800
To: mm-commits@vger.kernel.org,ebiederm@xmission.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] introduce-for_other_threadsp-t.patch removed from -mm tree
Message-Id: <20231211012236.E966BC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: introduce for_other_threads(p, t)
has been removed from the -mm tree.  Its filename was
     introduce-for_other_threadsp-t.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: introduce for_other_threads(p, t)
Date: Mon, 30 Oct 2023 16:57:10 +0100

Cosmetic, but imho it makes the usage look more clear and simple, the new
helper doesn't require to initialize "t".

After this change while_each_thread() has only 3 users, and it is only
used in the do/while loops.

Link: https://lkml.kernel.org/r/20231030155710.GA9095@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                    |    3 +--
 include/linux/sched/signal.h |    3 +++
 kernel/signal.c              |   11 ++++-------
 3 files changed, 8 insertions(+), 9 deletions(-)

--- a/fs/exec.c~introduce-for_other_threadsp-t
+++ a/fs/exec.c
@@ -1578,11 +1578,10 @@ static void check_unsafe_exec(struct lin
 	 * will be able to manipulate the current directory, etc.
 	 * It would be nice to force an unshare instead...
 	 */
-	t = p;
 	n_fs = 1;
 	spin_lock(&p->fs->lock);
 	rcu_read_lock();
-	while_each_thread(p, t) {
+	for_other_threads(p, t) {
 		if (t->fs == p->fs)
 			n_fs++;
 	}
--- a/include/linux/sched/signal.h~introduce-for_other_threadsp-t
+++ a/include/linux/sched/signal.h
@@ -646,6 +646,9 @@ extern bool current_is_single_threaded(v
 #define while_each_thread(g, t) \
 	while ((t = next_thread(t)) != g)
 
+#define for_other_threads(p, t)	\
+	for (t = p; (t = next_thread(t)) != p; )
+
 #define __for_each_thread(signal, t)	\
 	list_for_each_entry_rcu(t, &(signal)->thread_head, thread_node, \
 		lockdep_is_held(&tasklist_lock))
--- a/kernel/signal.c~introduce-for_other_threadsp-t
+++ a/kernel/signal.c
@@ -1376,12 +1376,12 @@ int force_sig_info(struct kernel_siginfo
  */
 int zap_other_threads(struct task_struct *p)
 {
-	struct task_struct *t = p;
+	struct task_struct *t;
 	int count = 0;
 
 	p->signal->group_stop_count = 0;
 
-	while_each_thread(p, t) {
+	for_other_threads(p, t) {
 		task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
 		/* Don't require de_thread to wait for the vhost_worker */
 		if ((t->flags & (PF_IO_WORKER | PF_USER_WORKER)) != PF_USER_WORKER)
@@ -2465,12 +2465,10 @@ static bool do_signal_stop(int signr)
 			sig->group_exit_code = signr;
 
 		sig->group_stop_count = 0;
-
 		if (task_set_jobctl_pending(current, signr | gstop))
 			sig->group_stop_count++;
 
-		t = current;
-		while_each_thread(current, t) {
+		for_other_threads(current, t) {
 			/*
 			 * Setting state to TASK_STOPPED for a group
 			 * stop is always done with the siglock held,
@@ -2966,8 +2964,7 @@ static void retarget_shared_pending(stru
 	if (sigisemptyset(&retarget))
 		return;
 
-	t = tsk;
-	while_each_thread(tsk, t) {
+	for_other_threads(tsk, t) {
 		if (t->flags & PF_EXITING)
 			continue;
 
_

Patches currently in -mm which might be from oleg@redhat.com are


