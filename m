Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7456723F431;
	Tue, 23 Sep 2025 03:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597091; cv=none; b=D7NX+iy6hprqaIdlNc7r5LSGVhIQuy7+GnwRMUE8FBTs1+V1Boraf8vx5ewcaXWuMExFCBBycKt0gilUkwJMEieYmAvyTfBfHmYNC6jJD2k+IOWrYBTa27/8JxM3zI9O76yfclyYqzXt/OMh2aDv9V9cqK+JV2jI4KBi9ogFLUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597091; c=relaxed/simple;
	bh=vLgC7cotGmZQAHqKfrDNPWcIPYolEK7PTznTsaaZ1Pw=;
	h=Date:To:From:Subject:Message-Id; b=RaqN9Tl/IAmrgKtKxPi4+rWMsEPusa6e/yr+iYymfCqU4qSaU3vKnC66cnh3qAVQUFWgmeMl3TyTUK46+L0C0DNWUr7fIe8CDBFPwWah4BGX40K/lzlK8SFIKdx1+9IoQFoHFY7uvl2m6+ZwNFIwJo0EG7U4VIUWQRMKut5SA74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2oXhEHFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2oXhEHFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031C0C113D0;
	Tue, 23 Sep 2025 03:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597091;
	bh=vLgC7cotGmZQAHqKfrDNPWcIPYolEK7PTznTsaaZ1Pw=;
	h=Date:To:From:Subject:From;
	b=2oXhEHFGVJWX+QkzXB3f/Z27WfzBsVxrFWZmxJdqXNZ9f1+juAPwae6EYCXsrfySp
	 1t/tq0D8xikfWP+h0GAtZGaPjbA0dCcBBO4nHS3LPa/0B0tpmPbujJ/FBX/KPOcA4b
	 r0TxdITsE/ASj0Wdtggix7F+hrIL23er62WPxs70=
Date: Mon, 22 Sep 2025 20:11:30 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mjguzik@gmail.com,jirislaby@kernel.org,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fix-the-racy-usage-of-task_locktsk-group_leader-in-sys_prlimit64-paths.patch removed from -mm tree
Message-Id: <20250923031131.031C0C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/sys.c: fix the racy usage of task_lock(tsk->group_leader) in sys_prlimit64() paths
has been removed from the -mm tree.  Its filename was
     fix-the-racy-usage-of-task_locktsk-group_leader-in-sys_prlimit64-paths.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


