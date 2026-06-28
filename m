Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19EA262D0B;
	Sun, 28 Jun 2026 19:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782673929; cv=none; b=hnSZtu/UKFml36eUu2sV82Fsq6XrMJTNzAxR7D1K0hWIiMiWmBiYODKNyAHkMeLfAUYUK/jACa9xcYiupqHyy38rjeRUU7Tjfxn+r86Vdtj3fj+1K7cxgSqqUJmmiF8IFAPxRiVvjG+omhS7fkn4Xtfrg+mOLXHzRfYrFtvzE1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782673929; c=relaxed/simple;
	bh=3L12A3lGnS6WG0q7TXqD3Hfilz27LeKchoCOUjTVtaA=;
	h=Date:To:From:Subject:Message-Id; b=TukzyaOsWdS/FNkBDO0J6ADqRE8vIXqJQtsaXsyIAJUKIJD+/f9VTC4gdGA5k7j+LeViLZRs7whDqM6f/R11c25dduxnhFqD5J+OnbsI4pFcco1OUzJwgL7lW7TS0USK9DDIv5hw6GhAYL6darwWXj8QHHbjiVNTihfIOK0jJuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fTx8f/7S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fTx8f/7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFCB1F000E9;
	Sun, 28 Jun 2026 19:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782673927;
	bh=NI2dmLjhi0P+bHrbVKSvxGp3PTHKHDRuyitdYyjnWcs=;
	h=Date:To:From:Subject;
	b=fTx8f/7Souh24wdVKn0pbWpFRf+OBKlrhKw/Io5cvw4h9zp+6kuu8ZSVhMV44B4uA
	 1Y+4xHrtkZx69yYVkkX68wTKI6AxD6gFB904A+SoYSLKl8s5NSGVvXC7vl7B5cQyUB
	 awJlJ4ugqdw2jTjCkhJ/LP3n1l6muhSGJxtzx4PE=
Date: Sun, 28 Jun 2026 12:12:07 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rostedt@goodmis.org,peterz@infradead.org,oleg@redhat.com,nogikh@google.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,elver@google.com,ebiederm@xmission.com,brauner@kernel.org,adrianhuang0701@gmail.com,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + signal-avoid-shared-siginfo-namespace-rewrites.patch added to mm-nonmm-unstable branch
Message-Id: <20260628191207.6CFCB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: signal: avoid shared siginfo namespace rewrites
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     signal-avoid-shared-siginfo-namespace-rewrites.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/signal-avoid-shared-siginfo-namespace-rewrites.patch

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

lib-string-fix-memchr_inv-for-large-ranges.patch
signal-avoid-shared-siginfo-namespace-rewrites.patch

