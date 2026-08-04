Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C9A42049D
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816293; cv=none; b=Aonain7hLKCjDOxdAfgjuhtQBx+IDRfkRzXohsBxTcNPHVWVnZIv9A8EP0ORmYqr0ubygjAETwqLne0dlKBo83inuh2CD8xcRQB0GU1n2wJcHeTrWe9LsqufgC7KaOOVmZq+lthYIWKtQo6iI/+OWozUM+rp7NQagemxxHDTEck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816293; c=relaxed/simple;
	bh=QAa1lirZatadfAC/ZPtBmIuc5AnRoXm/8mFwGMclyZ4=;
	h=Date:To:From:Subject:Message-Id; b=ibGAhFrqUnrbO9qNguUQK0OUTYXMGTmdHJtX7UWOAmcDiNtQ0dWo/hqRrdMXJholSKv1Z8IywMObfLiUMzaQ4Q2xqw2Hd9p+Tj4PM8lc0QnPTVyTpApyt6GTYmDu1YiWrjPKkeNavbKovFYqDypNLFMHLKnHZBMlPbg8fVhadZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nI/A/FTN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nI/A/FTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191981F000E9;
	Tue,  4 Aug 2026 04:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816292;
	bh=AF3Ninnb4hBrnAZsoAV52y2J7ju+wbwHxGu33dhPtaY=;
	h=Date:To:From:Subject;
	b=nI/A/FTNZzXfNyFc5oK1BSDNhwvYt5/qkQUY7bGea3XcTxHw2XyEKNxSjCoquxxZF
	 /wms0lwkloc7Ma0Rlu3zCdjsoxbvhWaMo7lJXSZJapOxoY7S+k6AZNQ4AJxiIA8pHr
	 wAO/OFmVzi7bEY+1KX+PcGBhwdLny5ao1BZDpP2I=
Date: Mon, 03 Aug 2026 21:04:51 -0700
To: mm-commits@vger.kernel.org,include@grrlz.net,ebiederm@xmission.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] signal-avoid-unconditional-siginfo-copy-in-send_signal_locked.patch removed from -mm tree
Message-Id: <20260804040452.191981F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: signal: avoid unconditional siginfo copy in send_signal_locked()
has been removed from the -mm tree.  Its filename was
     signal-avoid-unconditional-siginfo-copy-in-send_signal_locked.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


