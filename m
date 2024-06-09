Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4EC4D8B5
	for <mm-commits@vger.kernel.org>; Sun,  9 Jun 2024 20:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717966622; cv=none; b=W8jMZ5kD2d9uMRu8ZtlKNqFk7ij+JGCHDLsFhcgPSMH4sEweVhOduK8ZfssQdKZrYDO3+3o4cT5Z+OOBC9h+I1L89yDq3I0Xzv8ZUOIIBUfymmVdX5Aq8Q51aQqG1/MZsKH+aCwyvrUHrGhVDBpmOoO6m0fRdA90QT52we3FDYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717966622; c=relaxed/simple;
	bh=DDOtPDj61/fQ7IWpKo/tasdNjTPzIPtqrBg5y23buYQ=;
	h=Date:To:From:Subject:Message-Id; b=TQs5DcygStv9D+pgEqZvvWK3o5EZKdcDX/OdE69n5st6oHW+Pq98ARFg3cSaUUykTWHnlI5ZgwOaGSJP3ogY18LcPksz7kpgKKOuPHhNiM/RucOyArS8QdFS3RMjVlPB+2AK4EGqwnBWbVgwSM1aw+TKwPBTjIEtdpciOK6XXkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Un32TwtD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Un32TwtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68119C2BD10;
	Sun,  9 Jun 2024 20:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717966621;
	bh=DDOtPDj61/fQ7IWpKo/tasdNjTPzIPtqrBg5y23buYQ=;
	h=Date:To:From:Subject:From;
	b=Un32TwtDGKIkNeoTkcsPrBqXBHk0/+dLiScqa5GiA8Mx+dkgZBAStYU7nk7XSvVdH
	 80VHb0UNzMoeUOSe5HY1G9Udys7TKRJc8n+Z70yxorfjkuhHOvTZirPY4hP4N559Zt
	 tUkQCMil6L1YLJPoTWdsZnHGC0s3+pLBNRN7ZOj8=
Date: Sun, 09 Jun 2024 13:57:00 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,qiang.zhang1211@gmail.com,paulmck@kernel.org,neeraj.upadhyay@kernel.org,mjguzik@gmail.com,michael.christie@oracle.com,mathieu.desnoyers@efficios.com,josh@joshtriplett.org,joel@joelfernandes.org,jiangshanlai@gmail.com,j.granados@samsung.com,fuweid89@gmail.com,frederic@kernel.org,brauner@kernel.org,boqun.feng@gmail.com,axboe@kernel.dk,apais@linux.microsoft.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zap_pid_ns_processes-dont-send-sigkill-to-sub-threads.patch added to mm-nonmm-unstable branch
Message-Id: <20240609205701.68119C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zap_pid_ns_processes: don't send SIGKILL to sub-threads
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     zap_pid_ns_processes-dont-send-sigkill-to-sub-threads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zap_pid_ns_processes-dont-send-sigkill-to-sub-threads.patch

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
Subject: zap_pid_ns_processes: don't send SIGKILL to sub-threads
Date: Sat, 8 Jun 2024 17:48:35 +0200

The comment above the idr_for_each_entry_continue() loop tries to explain
why we have to signal each thread in the namespace, but it is outdated. 
This code no longer uses kill_proc_info(), we have a target task so we can
check thread_group_leader() and avoid the unnecessary group_send_sig_info.
Better yet, we can change pid_task() to use PIDTYPE_TGID rather than
_PID, this way it returns NULL if this pid is not a group-leader pid.

Also, change this code to check SIGNAL_GROUP_EXIT, the exiting process /
thread doesn't necessarily has a pending SIGKILL.  Either way these checks
are racy without siglock, so the patch uses data_race() to shut up KCSAN.

Link: https://lkml.kernel.org/r/20240608154835.GD7947@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Wei Fu <fuweid89@gmail.com>
Cc: Zqiang <qiang.zhang1211@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/kernel/pid_namespace.c~zap_pid_ns_processes-dont-send-sigkill-to-sub-threads
+++ a/kernel/pid_namespace.c
@@ -191,21 +191,14 @@ void zap_pid_ns_processes(struct pid_nam
 	 * The last thread in the cgroup-init thread group is terminating.
 	 * Find remaining pid_ts in the namespace, signal and wait for them
 	 * to exit.
-	 *
-	 * Note:  This signals each threads in the namespace - even those that
-	 * 	  belong to the same thread group, To avoid this, we would have
-	 * 	  to walk the entire tasklist looking a processes in this
-	 * 	  namespace, but that could be unnecessarily expensive if the
-	 * 	  pid namespace has just a few processes. Or we need to
-	 * 	  maintain a tasklist for each pid namespace.
-	 *
 	 */
 	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	nr = 2;
 	idr_for_each_entry_continue(&pid_ns->idr, pid, nr) {
-		task = pid_task(pid, PIDTYPE_PID);
-		if (task && !__fatal_signal_pending(task))
+		task = pid_task(pid, PIDTYPE_TGID);
+		/* reading signal->flags is racy without sighand->siglock */
+		if (task && !(data_race(task->signal->flags) & SIGNAL_GROUP_EXIT))
 			group_send_sig_info(SIGKILL, SEND_SIG_PRIV, task, PIDTYPE_MAX);
 	}
 	read_unlock(&tasklist_lock);
_

Patches currently in -mm which might be from oleg@redhat.com are

zap_pid_ns_processes-dont-send-sigkill-to-sub-threads.patch

