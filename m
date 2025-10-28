Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38825227
	for <mm-commits@vger.kernel.org>; Tue, 28 Oct 2025 00:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761610008; cv=none; b=VeiTgQJ9M5fcNPJABGNyAfHNDn+2EPsZW7KQZIJjU9xsUNQfTVtFEDQ/JAQog6aP4Lxl8Nrm/xUQ4Lpzmy+dBDh8Q9/ys8U8Z4hXe62fsg2FSuyhBLkHKqpztcJNcr1JQ4U6BfTYWkInLkExsyLWm8plq0taBmhM6qtYkbNWsxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761610008; c=relaxed/simple;
	bh=n3srh3GebPAIxhHNDZ6f4BTAlpMGYjtDfboR4dfZj7o=;
	h=Date:To:From:Subject:Message-Id; b=jlSXA0EsiGqe4hWqj1t4RwuibtzRy5IYR7NCF72QMoVIDH1Tc+av5VDR0HXe3zxt2bWthXW5sOi0olQ3J6AcyVauVXv7PazqQ/7TgdYZIRD3Tg5HZXdeWsnUvjjA/a4Xopbz6XqkqZVSlQpREfKxzCc7NhH17htIsUFvm0xVy98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nTuTsNrq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nTuTsNrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3682DC4CEF1;
	Tue, 28 Oct 2025 00:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761610007;
	bh=n3srh3GebPAIxhHNDZ6f4BTAlpMGYjtDfboR4dfZj7o=;
	h=Date:To:From:Subject:From;
	b=nTuTsNrqLl3sGfRYml7gMLnDzwfwO/h6qntC6Huru1GXxQtWtF5dDeK/OoWgK4VSz
	 n0EaExjOU83S+RPNvebYuDFB9NE0z511Q9B3BFPVGKSuem1WPVZqUnN+TvtdiaStEn
	 7OAKeqNMf28/mkR/i8iyIypDB/H/j1h5/Vv4XCKA=
Date: Mon, 27 Oct 2025 17:06:46 -0700
To: mm-commits@vger.kernel.org,paulmck@kernel.org,mjguzik@gmail.com,legion@kernel.org,kees@kernel.org,dhowells@redhat.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + release_task-kill-unnecessary-rcu_read_lock-around-dec_rlimit_ucounts.patch added to mm-nonmm-unstable branch
Message-Id: <20251028000647.3682DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: release_task: kill unnecessary rcu_read_lock() around dec_rlimit_ucounts()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     release_task-kill-unnecessary-rcu_read_lock-around-dec_rlimit_ucounts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/release_task-kill-unnecessary-rcu_read_lock-around-dec_rlimit_ucounts.patch

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
Subject: release_task: kill unnecessary rcu_read_lock() around dec_rlimit_ucounts()
Date: Sun, 26 Oct 2025 15:31:40 +0100

rcu_read_lock() was added to shut RCU-lockdep up when this code used
__task_cred()->rcu_dereference(), but after the commit 21d1c5e386bc
("Reimplement RLIMIT_NPROC on top of ucounts") it is no longer needed:
task_ucounts()->task_cred_xxx() takes rcu_read_lock() itself.

NOTE: task_ucounts() returns the pointer to another rcu-protected data,
struct ucounts.  So it should either be used when task->real_cred and thus
task->real_cred->ucounts is stable (release_task, copy_process,
copy_creds), or it should be called under rcu_read_lock().  In both cases
it is pointless to take rcu_read_lock() to read the cred->ucounts pointer.

Link: https://lkml.kernel.org/r/20251026143140.GA22463@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Alexey Gladkov <legion@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/exit.c~release_task-kill-unnecessary-rcu_read_lock-around-dec_rlimit_ucounts
+++ a/kernel/exit.c
@@ -251,10 +251,8 @@ repeat:
 	memset(&post, 0, sizeof(post));
 
 	/* don't need to get the RCU readlock here - the process is dead and
-	 * can't be modifying its own credentials. But shut RCU-lockdep up */
-	rcu_read_lock();
+	 * can't be modifying its own credentials. */
 	dec_rlimit_ucounts(task_ucounts(p), UCOUNT_RLIMIT_NPROC, 1);
-	rcu_read_unlock();
 
 	pidfs_exit(p);
 	cgroup_release(p);
_

Patches currently in -mm which might be from oleg@redhat.com are

release_task-kill-unnecessary-rcu_read_lock-around-dec_rlimit_ucounts.patch

