Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B633F2D780D
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 01:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754962491; cv=none; b=flBoPaKAbXJ5WgO05GS9it3GeRC4/E412VMFgQKjn66ZjWywdHbTHUenm44gpwQ2h9HlQ2wHdFI4J4QQr55TyBfGId8ibEJWAXgD62gix8tANOFM5Kj0EbWwx6W7IzItkBB5H81FxqRhaC241yTsSI9dB+c6uvWU348eH7DzisU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754962491; c=relaxed/simple;
	bh=hJOc0EoIo9mdJwXJenk0c2gAXwXmH7Ag1LHnZARDdDs=;
	h=Date:To:From:Subject:Message-Id; b=GNjfgrvj0xjiJ0E5SsLjxBSUbTnQiWC4hBUAQM8v26ezOXjxEqlAX+OrJxcU30X+B3E0s/52bhWvHgY3h+JMmKfXIqDWsAuUFILuF2ZeyYfO/12B/51RYPGqyAqfciHB2iSGFFYwYdWaDNa1TE26uNUDkV51SziWCdk/ekHlv/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vTBn+DQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vTBn+DQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369B4C4CEED;
	Tue, 12 Aug 2025 01:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754962491;
	bh=hJOc0EoIo9mdJwXJenk0c2gAXwXmH7Ag1LHnZARDdDs=;
	h=Date:To:From:Subject:From;
	b=vTBn+DQjwFpsAIRMhNpnE1EJvRmRZBgzH2n2nG7P9FdIEw7T35gl+q0XSArt9hYSc
	 AJ74m0OpoDxpsuTvHgQXMczk086B5sYIaExfyIBSYGVPkf3R4FLmRiEAOeZFp3KpAZ
	 KirQ1G1Nr2zlnS7A9hxVyMuKlxpItNU+oDWk5MG0=
Date: Mon, 11 Aug 2025 18:34:50 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,mjguzik@gmail.com,gaoxiang17@xiaomi.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + pid-change-task_state-to-use-task_ppid_nr_ns.patch added to mm-nonmm-unstable branch
Message-Id: <20250812013451.369B4C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: pid: change task_state() to use task_ppid_nr_ns()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     pid-change-task_state-to-use-task_ppid_nr_ns.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pid-change-task_state-to-use-task_ppid_nr_ns.patch

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
Subject: pid: change task_state() to use task_ppid_nr_ns()
Date: Sun, 10 Aug 2025 19:36:20 +0200

To simplify the code.

Note that only tpid and max_fds really need rcu_read_lock(), we could move
task_ppid_nr_ns/task_tgid_nr_ns/task_numa_group_id/get_task_cred outside
of rcu read section.

Link: https://lkml.kernel.org/r/20250810173620.GA20007@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: gaoxiang17 <gaoxiang17@xiaomi.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/proc/array.c~pid-change-task_state-to-use-task_ppid_nr_ns
+++ a/fs/proc/array.c
@@ -157,13 +157,11 @@ static inline void task_state(struct seq
 	unsigned int max_fds = 0;
 
 	rcu_read_lock();
-	ppid = pid_alive(p) ?
-		task_tgid_nr_ns(rcu_dereference(p->real_parent), ns) : 0;
-
 	tracer = ptrace_parent(p);
 	if (tracer)
 		tpid = task_pid_nr_ns(tracer, ns);
 
+	ppid = task_ppid_nr_ns(p, ns);
 	tgid = task_tgid_nr_ns(p, ns);
 	ngid = task_numa_group_id(p);
 	cred = get_task_cred(p);
_

Patches currently in -mm which might be from oleg@redhat.com are

pid-make-__task_pid_nr_nsns-=-null-safe-for-zombie-callers.patch
pid-introduce-task_ppid_vnr.patch
pid-change-bacct_add_tsk-to-use-task_ppid_nr_ns.patch
pid-change-task_state-to-use-task_ppid_nr_ns.patch

