Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C523A42049D;
	Tue,  4 Aug 2026 04:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816291; cv=none; b=OneUZFaGxXTsmTBue7zGs4Dom3AXnv7AkC7x00hyyXJSGUXzdAXM6Hu2ovXgAtgVx2WVfLYuPHKPka0mgB+BUJSd//NgTxc8tWPvaO3nG75Xdf1uJfwsMLWEifM5CMJq5EofKl/APpyw1d2vXIxpjbC8PUsIo0RsvIvBYBYC2I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816291; c=relaxed/simple;
	bh=auu73RBtJn1Aem/39NKKwukCzmvXOWAfQg6Zr76vs48=;
	h=Date:To:From:Subject:Message-Id; b=LIUzgZw+gIQApdHmgoJnxAvW7AaN2Yw0VPvPcBdqBcdEI4Ud4o3k0r9HaOlGAtFJ+P7b3lvuad3TF+lzeoE/37hnUBJiYID92rNDH8KXmGQiNkrIkilYqomO7FtcQ+TzDqpzEXdEmCqHh+Cdz5xHSmEG8WrsbRBTF/egGYLcrJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EUcs2cBB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EUcs2cBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E5C1F000E9;
	Tue,  4 Aug 2026 04:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816289;
	bh=dMSKKD6MkC7/1jobU5asUduMHhw86E68/MyQytB8nVI=;
	h=Date:To:From:Subject;
	b=EUcs2cBBwJsO966Wf0BFFSB8zCA4TAtvhc0IGMiGi6OVrgRQmfv1mD5OpcEV96qz3
	 SCFHckQSD8byp5nFmi8y2F0sRqio2aYzUDbdXQbztYk6UHwEi2PzbJ3LSyzvQ2fv+W
	 EWqNeoX4bylNrJTzVkh0Er+lsivTsPUeI8lr7bjo=
Date: Mon, 03 Aug 2026 21:04:49 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rostedt@goodmis.org,peterz@infradead.org,oleg@redhat.com,nogikh@google.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,elver@google.com,ebiederm@xmission.com,brauner@kernel.org,adrianhuang0701@gmail.com,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] signal-avoid-shared-siginfo-namespace-rewrites.patch removed from -mm tree
Message-Id: <20260804040449.99E5C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: signal: avoid shared siginfo namespace rewrites
has been removed from the -mm tree.  Its filename was
     signal-avoid-shared-siginfo-namespace-rewrites.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bradley Morgan <include@grrlz.net>
Subject: signal: avoid shared siginfo namespace rewrites
Date: Mon, 22 Jun 2026 20:25:08 +0000

send_signal_locked() rewrites sender ids for the target namespace.  Group
sends reuse the same siginfo, so one recipient can affect the next.

Copy the siginfo before changing it.

Link: https://lore.kernel.org/86a8857d58d43ee26a8b365b837fd24830343494.1782159692.git.include@grrlz.net
Fixes: 7a0cf094944e ("signal: Correct namespace fixups of si_pid and si_uid")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Adrian Huang <adrianhuang0701@gmail.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/signal.c~signal-avoid-shared-siginfo-namespace-rewrites
+++ a/kernel/signal.c
@@ -1181,6 +1181,7 @@ static inline bool has_si_pid_and_uid(st
 int send_signal_locked(int sig, struct kernel_siginfo *info,
 		       struct task_struct *t, enum pid_type type)
 {
+	struct kernel_siginfo rewritten;
 	/* Should SIGKILL or SIGSTOP be received by a pid namespace init? */
 	bool force = false;
 
@@ -1194,6 +1195,9 @@ int send_signal_locked(int sig, struct k
 		/* SIGKILL and SIGSTOP is special or has ids */
 		struct user_namespace *t_user_ns;
 
+		rewritten = *info;
+		info = &rewritten;
+
 		rcu_read_lock();
 		t_user_ns = task_cred_xxx(t, user_ns);
 		if (current_user_ns() != t_user_ns) {
_

Patches currently in -mm which might be from include@grrlz.net are

taskstats-drop-the-dead-null-attribute-check-in-parse.patch
taskstats-fold-the-two-cpumask-handlers-into-one.patch

