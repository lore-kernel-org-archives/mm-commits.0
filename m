Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15F8175558
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 19:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720208494; cv=none; b=I9siVRKZQY8oqauUwF+fuxhSJxoAa5/yKnnugfnW3rNtdhA4BwA3R/QxsCT1I9fcgBxYb6VHaHxSskIMxo8/NIH5bnTrXH123WolhE7xst0pQidBYnGixdrFjmtgC6Tnuxb+99M0rrngwR6E0PxIMgeFJcz0b8kgiwzFUmXxIPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720208494; c=relaxed/simple;
	bh=guY8JfJEqxCdHaazbYH2e3UnJKf3Qhj7IcqaLR1CDuk=;
	h=Date:To:From:Subject:Message-Id; b=fTiArhDVCSA5gwMnhlZ3725xfG5QTM5BdG8kKTtW0uPMkpoiKWqQ0AlgYDVxTXkVCcz3FiTBLyFBJ/x/Q9XJ/J80NgY2+EO/DRdNWpQTd5oJuNCVk5TdbYs8DFrztDpsXlh9WVbHjLakK+tpKzsS9SgZYCDZ8azSf8l3L+Y8eHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=opU8hqBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="opU8hqBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A3FC116B1;
	Fri,  5 Jul 2024 19:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720208494;
	bh=guY8JfJEqxCdHaazbYH2e3UnJKf3Qhj7IcqaLR1CDuk=;
	h=Date:To:From:Subject:From;
	b=opU8hqBZlW0tQyoxOZXXQuQEPL+tndvu2xMkTAdPcAdBr+LUttjcUiKtI2IpmDic0
	 /DyGeEifuThDBMO98cQfo+a5WNB+jpwkbmGsYrHAYIuudkQ4kOVHNQV3XVmTEsB4Ge
	 zXf69onImlS8owxRB/I0slzcMGQmOAmF9w0J0mjg=
Date: Fri, 05 Jul 2024 12:41:33 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,qiang.zhang1211@gmail.com,paulmck@kernel.org,neeraj.upadhyay@kernel.org,mjguzik@gmail.com,michael.christie@oracle.com,mathieu.desnoyers@efficios.com,josh@joshtriplett.org,joel@joelfernandes.org,jiangshanlai@gmail.com,j.granados@samsung.com,fuweid89@gmail.com,frederic@kernel.org,brauner@kernel.org,boqun.feng@gmail.com,axboe@kernel.dk,apais@linux.microsoft.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zap_pid_ns_processes-dont-send-sigkill-to-sub-threads.patch removed from -mm tree
Message-Id: <20240705194134.55A3FC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zap_pid_ns_processes: don't send SIGKILL to sub-threads
has been removed from the -mm tree.  Its filename was
     zap_pid_ns_processes-dont-send-sigkill-to-sub-threads.patch

This patch was dropped because an updated version will be merged

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


