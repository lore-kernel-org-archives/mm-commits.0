Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8B714B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908611; cv=none; b=kcTVYl2S5h2WrllibJnSltnpPG3fSGuiCHwy+jsxI1qJXkOJxH1q05v0/KmI+FDfHpdGMTU00+70vrT8T1y+A2bHRQOdfphWPqFjLPWCijAxfNRnfLHKEZA39i4vOfUxKWDFxaflpqDnnorg84fQmpK6G8A6/nKa1UwNsTirx3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908611; c=relaxed/simple;
	bh=5vk9TDU1uo3uPqG50fGh/WbgBa9GhCHs2YopV5nnwBM=;
	h=Date:To:From:Subject:Message-Id; b=lgDazxAAwHlPBqmd6W51FHkS8leGh7OaewSM6/F2qkcDgEbXpONBoIx5+6jq+jT8ErzagvcOiYcMCgr7NFbCyKBFdyBxVt40AtaeSOF/vcWnWXNH1TOF85jsCK9dTCyMyeS0eVnjDu64CCZdqGCASiiu8h0aqIIytofQKQOvAmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NEyksb70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NEyksb70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A3CC19422;
	Wed, 12 Nov 2025 00:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908611;
	bh=5vk9TDU1uo3uPqG50fGh/WbgBa9GhCHs2YopV5nnwBM=;
	h=Date:To:From:Subject:From;
	b=NEyksb70CQfondVOUJ26YXD/PxFOGm0zsO5qHitudxOz1pUZQu/D9NRuKRqfdABZD
	 gok/1rJKXW8A/NRvY+VrurwQF7tFfptghnX379Xv3jVolkYlOqfziidHNbawOHxXME
	 b/qe4J51TiEIs1XkJrGzWC7Kftpjp1fPUcwwv39s=
Date: Tue, 11 Nov 2025 16:50:10 -0800
To: mm-commits@vger.kernel.org,paulmck@kernel.org,mjguzik@gmail.com,legion@kernel.org,kees@kernel.org,dhowells@redhat.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] release_task-kill-unnecessary-rcu_read_lock-around-dec_rlimit_ucounts.patch removed from -mm tree
Message-Id: <20251112005011.34A3CC19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: release_task: kill unnecessary rcu_read_lock() around dec_rlimit_ucounts()
has been removed from the -mm tree.  Its filename was
     release_task-kill-unnecessary-rcu_read_lock-around-dec_rlimit_ucounts.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


