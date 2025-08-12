Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6ECC2D97BD
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 01:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754962489; cv=none; b=LtdHPYd+3OGt1HVWNK4wrPQYmApN9rdH5seY56lsCOBpr+lTKxsUJ846WT6gvLPQ/sRCF0WlsLxsThCpXuCR1Eqgn+4gGNDvw1RN+NDESfD6iCDpsb+GzkPjEQVNG4UGjvMTwLq036lZlucM/aiEQhnrxZ6NHRXQjHNXTUB3W3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754962489; c=relaxed/simple;
	bh=I3HzeM2pneYkybXSO1/jl71zIz+aS1o3NzGmUfoJOKc=;
	h=Date:To:From:Subject:Message-Id; b=Vz5EmQfJp6dreoYiRCs2izHddcJe8PTnLpRmnLT/EHUZqQx/YxFkX9u3TiqkUpEIPao5IQvM8vcqwGyJH5XHP0lo6mRz48vE6cwrMG980XJ8jOglw+vsowhtwH0y7ZivigrHjaRd+yNtW7B2yNcCRaeGxyvB2ayb3ne3EEhkbY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lhfml8ZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lhfml8ZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475A8C4CEF6;
	Tue, 12 Aug 2025 01:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754962489;
	bh=I3HzeM2pneYkybXSO1/jl71zIz+aS1o3NzGmUfoJOKc=;
	h=Date:To:From:Subject:From;
	b=Lhfml8ZTPfcCYFNsLeKmkqh014Ooz9BDKYeoK15moJWq8lPMDzB3YiZElKt34Ll8R
	 p8FfdTxyfKN2gm5v88W5njnplakuf5dLt2hryHc9D/IwSnVKvOkpY4iuuLboPF0DUo
	 /HETuLf9hXdG8zfpUnNt+hk0rgVjQJIRCYYyWjVk=
Date: Mon, 11 Aug 2025 18:34:48 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,mjguzik@gmail.com,gaoxiang17@xiaomi.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + pid-change-bacct_add_tsk-to-use-task_ppid_nr_ns.patch added to mm-nonmm-unstable branch
Message-Id: <20250812013449.475A8C4CEF6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: pid: change bacct_add_tsk() to use task_ppid_nr_ns()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     pid-change-bacct_add_tsk-to-use-task_ppid_nr_ns.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pid-change-bacct_add_tsk-to-use-task_ppid_nr_ns.patch

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
Subject: pid: change bacct_add_tsk() to use task_ppid_nr_ns()
Date: Sun, 10 Aug 2025 19:36:15 +0200

To simplify the code.

Link: https://lkml.kernel.org/r/20250810173615.GA20000@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: gaoxiang17 <gaoxiang17@xiaomi.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/tsacct.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/tsacct.c~pid-change-bacct_add_tsk-to-use-task_ppid_nr_ns
+++ a/kernel/tsacct.c
@@ -57,12 +57,11 @@ void bacct_add_tsk(struct user_namespace
 	stats->ac_sched	 = tsk->policy;
 	stats->ac_pid	 = task_pid_nr_ns(tsk, pid_ns);
 	stats->ac_tgid   = task_tgid_nr_ns(tsk, pid_ns);
+	stats->ac_ppid	 = task_ppid_nr_ns(tsk, pid_ns);
 	rcu_read_lock();
 	tcred = __task_cred(tsk);
 	stats->ac_uid	 = from_kuid_munged(user_ns, tcred->uid);
 	stats->ac_gid	 = from_kgid_munged(user_ns, tcred->gid);
-	stats->ac_ppid	 = pid_alive(tsk) ?
-		task_tgid_nr_ns(rcu_dereference(tsk->real_parent), pid_ns) : 0;
 	rcu_read_unlock();
 
 	task_cputime(tsk, &utime, &stime);
_

Patches currently in -mm which might be from oleg@redhat.com are

pid-make-__task_pid_nr_nsns-=-null-safe-for-zombie-callers.patch
pid-introduce-task_ppid_vnr.patch
pid-change-bacct_add_tsk-to-use-task_ppid_nr_ns.patch
pid-change-task_state-to-use-task_ppid_nr_ns.patch

