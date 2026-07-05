Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3761D7081F
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 00:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783213145; cv=none; b=DA+YAe+FctRyRM+iRA5ixfmgvwqtUQ/gqJ9y4hr3ncVLAjmhydQ/rnIzXSBzCIOVu4JraZ9V1LhtiWCXHJ9WgxiC6zO+w2VUQ/3ejhGo2fJZy+31L8+0XOq5+KwcQEnnAVkFzeAjDqCRc6CrEsw4WgFE8J8kr6bf/KfNXhz2c2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783213145; c=relaxed/simple;
	bh=1NoADP4MCOgV7ie41Nr5kPOUKrPcPWaOk1hD1RKTLj0=;
	h=Date:To:From:Subject:Message-Id; b=X78jEb4KdS5dCZmw2xBhof8OFl5+L8QJ9vDjOJ4uPnqsgjeDCJZSFF1eTUU152SLQLATIzkfDq9FLz5rnnHbNTJAsJy6eCU/cu80f6FEEesB3xR8OkZBYmaDSWDXGjyKNGH2C/tpneTGoRx731TbeHR/Hsfcq07zyO/VVkczNdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P5AyqpBA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P5AyqpBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCBC1F000E9;
	Sun,  5 Jul 2026 00:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783213143;
	bh=qrcNs6fJQmS9FnOxSPEGMnpbST6ayKVlK5L+5T2xUhI=;
	h=Date:To:From:Subject;
	b=P5AyqpBAPqkP5CcB73i7vcMFl1VFY4viRYcfS42VTiKWm5nfH851JSgKfXL5DMovq
	 qodlF35olfK2V05TP48L/m9uzVgoX7Ld8jG9y2DszJJbfGK388w2PPEU+DvLmhsiG+
	 Zfo5vG/QwzcQ5uhiER9N77s2NoNz0jQ0495yKtsI=
Date: Sat, 04 Jul 2026 17:59:03 -0700
To: mm-commits@vger.kernel.org,include@grrlz.net,ebiederm@xmission.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + signal-avoid-unconditional-siginfo-copy-in-send_signal_locked.patch added to mm-nonmm-unstable branch
Message-Id: <20260705005903.9CCBC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: signal: avoid unconditional siginfo copy in send_signal_locked()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     signal-avoid-unconditional-siginfo-copy-in-send_signal_locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/signal-avoid-unconditional-siginfo-copy-in-send_signal_locked.patch

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
From: Oleg Nesterov <oleg@redhat.com>
Subject: signal: avoid unconditional siginfo copy in send_signal_locked()
Date: Sat, 4 Jul 2026 16:34:42 +0200

send_signal_locked() unconditionally copies siginfo before the namespace
translation to avoid corrupting a shared siginfo.

Not that I think this can actually hurt performance-wise, just it doesn't
look clean to me; the copy is only needed in the unlikely case when the
translation will actually change something.

Defer it to the two cases where si_pid/si_uid are rewritten, and while at
it add #ifdef's just for completeness.

Link: https://lore.kernel.org/akkaAgNfUby5_3nM@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/kernel/signal.c~signal-avoid-unconditional-siginfo-copy-in-send_signal_locked
+++ a/kernel/signal.c
@@ -1181,7 +1181,7 @@ static inline bool has_si_pid_and_uid(st
 int send_signal_locked(int sig, struct kernel_siginfo *info,
 		       struct task_struct *t, enum pid_type type)
 {
-	struct kernel_siginfo rewritten;
+	struct kernel_siginfo __maybe_unused rewritten;
 	/* Should SIGKILL or SIGSTOP be received by a pid namespace init? */
 	bool force = false;
 
@@ -1193,27 +1193,34 @@ int send_signal_locked(int sig, struct k
 		force = true;
 	} else if (has_si_pid_and_uid(info)) {
 		/* SIGKILL and SIGSTOP is special or has ids */
+#ifdef CONFIG_USER_NS
 		struct user_namespace *t_user_ns;
-
-		rewritten = *info;
-		info = &rewritten;
+		kuid_t uid;
 
 		rcu_read_lock();
 		t_user_ns = task_cred_xxx(t, user_ns);
 		if (current_user_ns() != t_user_ns) {
-			kuid_t uid = make_kuid(current_user_ns(), info->si_uid);
-			info->si_uid = from_kuid_munged(t_user_ns, uid);
+			rewritten = *info;
+			info = &rewritten;
+			uid = make_kuid(current_user_ns(), info->si_uid);
+			rewritten.si_uid = from_kuid_munged(t_user_ns, uid);
 		}
 		rcu_read_unlock();
-
+#endif
 		/* A kernel generated signal? */
 		force = (info->si_code == SI_KERNEL);
 
+#ifdef CONFIG_PID_NS
 		/* From an ancestor pid namespace? */
 		if (!task_pid_nr_ns(current, task_active_pid_ns(t))) {
-			info->si_pid = 0;
+			if (info != &rewritten) {
+				rewritten = *info;
+				info = &rewritten;
+			}
+			rewritten.si_pid = 0;
 			force = true;
 		}
+#endif
 	}
 	return __send_signal_locked(sig, info, t, type, force);
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

signal-change-sys_kill-to-use-send_sig_noinfo.patch
signal-avoid-unconditional-siginfo-copy-in-send_signal_locked.patch

