Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5AB2CA8
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 01:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754962485; cv=none; b=mjPAri1LFT7WiKMAit8F2Fp5QJtvZdxcd0MR//vliSTARO0s1mgVh/oQi0a9goCqhFWL4V6m4m6DSvFFQd8gkPbLgy122hXpCNzb135zpB7YItmzFB2sN7X3L3zmZd0mA2sqNQtce+MOOtk85amGjwFfOXKSCHIpr9auZZlSv6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754962485; c=relaxed/simple;
	bh=7ZiymWfu2M0ZllWWl4HOm5zositVLsBtg56+40RHAV4=;
	h=Date:To:From:Subject:Message-Id; b=TfWgK1anh73bnXOoLRDzqK8FhS4S8O8pLNI3Ze2uk9/zW+9kPlIDLYRqw8EPlKRFDoIcy84wxlZ12fmuqGPy+BMtpPJdQNgSzkAKsWP3yBiYWhbGPPCD13YiKuLoMGKn2g5YvsMBNuXrdUaKGWkpL0qmqKKHGjSixJ2klatHy4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kJqVXwux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kJqVXwux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046F8C4CEED;
	Tue, 12 Aug 2025 01:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754962485;
	bh=7ZiymWfu2M0ZllWWl4HOm5zositVLsBtg56+40RHAV4=;
	h=Date:To:From:Subject:From;
	b=kJqVXwux+QueuEGjgKwNwiaDxXu/t3U+Rvdtbcloqi5ZXa8khHxNWqSOhLuPtecF9
	 F6OH7Aa0blditTbOTRl2AmQOLWs0EjJ2A+eLyJYTgYBftFyLBoPaQ0BbPUgjChdnOb
	 HztusW1y93kJklz3isf46fZPWEuDPsD9RoaiyG2o=
Date: Mon, 11 Aug 2025 18:34:44 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,mjguzik@gmail.com,gaoxiang17@xiaomi.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + pid-make-__task_pid_nr_nsns-=-null-safe-for-zombie-callers.patch added to mm-nonmm-unstable branch
Message-Id: <20250812013445.046F8C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: pid: make __task_pid_nr_ns(ns => NULL) safe for zombie callers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     pid-make-__task_pid_nr_nsns-=-null-safe-for-zombie-callers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pid-make-__task_pid_nr_nsns-=-null-safe-for-zombie-callers.patch

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
Subject: pid: make __task_pid_nr_ns(ns => NULL) safe for zombie callers
Date: Sun, 10 Aug 2025 19:36:04 +0200

task_pid_vnr(another_task) will crash if the caller was already reaped. 
The pid_alive(current) check can't really help, the parent/debugger can
call release_task() right after this check.

This also means that even task_ppid_nr_ns(current, NULL) is not safe,
pid_alive() only ensures that it is safe to dereference ->real_parent.

Change __task_pid_nr_ns() to ensure ns != NULL.

Link: https://lore.kernel.org/all/20250802022123.3536934-1-gxxa03070307@gmail.com/
Link: https://lkml.kernel.org/r/20250810173604.GA19991@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Originally-by: 高翔 <gaoxiang17@xiaomi.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/pid.c~pid-make-__task_pid_nr_nsns-=-null-safe-for-zombie-callers
+++ a/kernel/pid.c
@@ -514,7 +514,8 @@ pid_t __task_pid_nr_ns(struct task_struc
 	rcu_read_lock();
 	if (!ns)
 		ns = task_active_pid_ns(current);
-	nr = pid_nr_ns(rcu_dereference(*task_pid_ptr(task, type)), ns);
+	if (ns)
+		nr = pid_nr_ns(rcu_dereference(*task_pid_ptr(task, type)), ns);
 	rcu_read_unlock();
 
 	return nr;
_

Patches currently in -mm which might be from oleg@redhat.com are

pid-make-__task_pid_nr_nsns-=-null-safe-for-zombie-callers.patch
pid-introduce-task_ppid_vnr.patch
pid-change-bacct_add_tsk-to-use-task_ppid_nr_ns.patch
pid-change-task_state-to-use-task_ppid_nr_ns.patch

