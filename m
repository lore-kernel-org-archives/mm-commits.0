Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606198248B;
	Tue, 16 Sep 2025 04:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757995679; cv=none; b=MezFGuilOdEtGFCB/9d1X4GX0nrLEoFEUbwRPI3+yVEn9z0+bCGvbEv2qVLK2AG3QpCtcrFqxnIwBP8DgqaproAkZuJj0l4H3t2t4ZTA90UQLEezS1YC3iyA3ApXQfAE5qZ+080oIoWfoVtILf8fXnUYSwWgWiSItV4Gs7W+088=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757995679; c=relaxed/simple;
	bh=NYhWKQhQ/0Cc81fHZLR4FOZInE5vxOHt2PJwuSYvfls=;
	h=Date:To:From:Subject:Message-Id; b=LIUzEBpPzDDPjXEIflXYB9+8b1oNuAb3B+zERDoP3GwKW0oSEbvuqoDgFJwH0QdFCtAayfRJr81h7BJvddHdzwnzFwFSTOmjz09oWeCEoiNIHCsSbvQq3Rf+a+WyDZpaxM0XlN3MJJh7M+7OVuF9LOTbnVcoUXnIBNubq9u2DI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D/EaM1OC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D/EaM1OC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBD9C4CEEB;
	Tue, 16 Sep 2025 04:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757995678;
	bh=NYhWKQhQ/0Cc81fHZLR4FOZInE5vxOHt2PJwuSYvfls=;
	h=Date:To:From:Subject:From;
	b=D/EaM1OCT2cDg+QmvfUJd188EDx4kyQxDDvz92McaLPe1Oh3chi7iRtge/UlTozQr
	 nkirMXc6AcC0s2rlYygfMLzWQbjEj2kt//Xd7kpb7fhl7bsfTxzZR4ve5uybXKQxvK
	 gBxKbrtw2sB1QJgmKasRxqK4stbrLwcQWSwzZJ3Q=
Date: Mon, 15 Sep 2025 21:07:58 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mjguzik@gmail.com,jirislaby@kernel.org,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-the-racy-usage-of-task_locktsk-group_leader-in-sys_prlimit64-paths.patch added to mm-nonmm-unstable branch
Message-Id: <20250916040758.BBBD9C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/sys.c: fix the racy usage of task_lock(tsk->group_leader) in sys_prlimit64() paths
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fix-the-racy-usage-of-task_locktsk-group_leader-in-sys_prlimit64-paths.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-the-racy-usage-of-task_locktsk-group_leader-in-sys_prlimit64-paths.patch

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
Subject: kernel/sys.c: fix the racy usage of task_lock(tsk->group_leader) in sys_prlimit64() paths
Date: Mon, 15 Sep 2025 14:09:17 +0200

The usage of task_lock(tsk->group_leader) in sys_prlimit64()->do_prlimit()
path is very broken.

sys_prlimit64() does get_task_struct(tsk) but this only protects task_struct
itself. If tsk != current and tsk is not a leader, this process can exit/exec
and task_lock(tsk->group_leader) may use the already freed task_struct.

Another problem is that sys_prlimit64() can race with mt-exec which changes
->group_leader. In this case do_prlimit() may take the wrong lock, or (worse)
->group_leader may change between task_lock() and task_unlock().

Change sys_prlimit64() to take tasklist_lock when necessary. This is not
nice, but I don't see a better fix for -stable.

Link: https://lkml.kernel.org/r/20250915120917.GA27702@redhat.com
Fixes: 18c91bb2d872 ("prlimit: do not grab the tasklist_lock")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/kernel/sys.c~fix-the-racy-usage-of-task_locktsk-group_leader-in-sys_prlimit64-paths
+++ a/kernel/sys.c
@@ -1734,6 +1734,7 @@ SYSCALL_DEFINE4(prlimit64, pid_t, pid, u
 	struct rlimit old, new;
 	struct task_struct *tsk;
 	unsigned int checkflags = 0;
+	bool need_tasklist;
 	int ret;
 
 	if (old_rlim)
@@ -1760,8 +1761,25 @@ SYSCALL_DEFINE4(prlimit64, pid_t, pid, u
 	get_task_struct(tsk);
 	rcu_read_unlock();
 
-	ret = do_prlimit(tsk, resource, new_rlim ? &new : NULL,
-			old_rlim ? &old : NULL);
+	need_tasklist = !same_thread_group(tsk, current);
+	if (need_tasklist) {
+		/*
+		 * Ensure we can't race with group exit or de_thread(),
+		 * so tsk->group_leader can't be freed or changed until
+		 * read_unlock(tasklist_lock) below.
+		 */
+		read_lock(&tasklist_lock);
+		if (!pid_alive(tsk))
+			ret = -ESRCH;
+	}
+
+	if (!ret) {
+		ret = do_prlimit(tsk, resource, new_rlim ? &new : NULL,
+				old_rlim ? &old : NULL);
+	}
+
+	if (need_tasklist)
+		read_unlock(&tasklist_lock);
 
 	if (!ret && old_rlim) {
 		rlim_to_rlim64(&old, &old64);
_

Patches currently in -mm which might be from oleg@redhat.com are

fix-the-wrong-comment-on-task_lock-nesting-with-tasklist_lock.patch
fix-the-racy-usage-of-task_locktsk-group_leader-in-sys_prlimit64-paths.patch

