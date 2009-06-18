From: akpm@linux-foundation.org
Subject: [merged] elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:52 -0700
Message-ID: <200906182246.n5IMkq6n005919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758409AbZFRW6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dhowells@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     elf_core_dump: use rcu_read_lock() to access ->real_parent
has been removed from the -mm tree.  Its filename was
     elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: elf_core_dump: use rcu_read_lock() to access ->real_parent
From: Oleg Nesterov <oleg@redhat.com>

In theory it is not safe to dereference ->parent/real_parent without
tasklist or rcu lock, we can race with re-parenting.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c       |    8 ++++++--
 fs/binfmt_elf_fdpic.c |    8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff -puN fs/binfmt_elf.c~elf_core_dump-use-rcu_read_lock-to-access-real_parent fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~elf_core_dump-use-rcu_read_lock-to-access-real_parent
+++ a/fs/binfmt_elf.c
@@ -1340,8 +1340,10 @@ static void fill_prstatus(struct elf_prs
 	prstatus->pr_info.si_signo = prstatus->pr_cursig = signr;
 	prstatus->pr_sigpend = p->pending.signal.sig[0];
 	prstatus->pr_sighold = p->blocked.sig[0];
+	rcu_read_lock();
+	prstatus->pr_ppid = task_pid_vnr(rcu_dereference(p->real_parent));
+	rcu_read_unlock();
 	prstatus->pr_pid = task_pid_vnr(p);
-	prstatus->pr_ppid = task_pid_vnr(p->real_parent);
 	prstatus->pr_pgrp = task_pgrp_vnr(p);
 	prstatus->pr_sid = task_session_vnr(p);
 	if (thread_group_leader(p)) {
@@ -1382,8 +1384,10 @@ static int fill_psinfo(struct elf_prpsin
 			psinfo->pr_psargs[i] = ' ';
 	psinfo->pr_psargs[len] = 0;
 
+	rcu_read_lock();
+	psinfo->pr_ppid = task_pid_vnr(rcu_dereference(p->real_parent));
+	rcu_read_unlock();
 	psinfo->pr_pid = task_pid_vnr(p);
-	psinfo->pr_ppid = task_pid_vnr(p->real_parent);
 	psinfo->pr_pgrp = task_pgrp_vnr(p);
 	psinfo->pr_sid = task_session_vnr(p);
 
diff -puN fs/binfmt_elf_fdpic.c~elf_core_dump-use-rcu_read_lock-to-access-real_parent fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~elf_core_dump-use-rcu_read_lock-to-access-real_parent
+++ a/fs/binfmt_elf_fdpic.c
@@ -1387,8 +1387,10 @@ static void fill_prstatus(struct elf_prs
 	prstatus->pr_info.si_signo = prstatus->pr_cursig = signr;
 	prstatus->pr_sigpend = p->pending.signal.sig[0];
 	prstatus->pr_sighold = p->blocked.sig[0];
+	rcu_read_lock();
+	prstatus->pr_ppid = task_pid_vnr(rcu_dereference(p->real_parent));
+	rcu_read_unlock();
 	prstatus->pr_pid = task_pid_vnr(p);
-	prstatus->pr_ppid = task_pid_vnr(p->real_parent);
 	prstatus->pr_pgrp = task_pgrp_vnr(p);
 	prstatus->pr_sid = task_session_vnr(p);
 	if (thread_group_leader(p)) {
@@ -1432,8 +1434,10 @@ static int fill_psinfo(struct elf_prpsin
 			psinfo->pr_psargs[i] = ' ';
 	psinfo->pr_psargs[len] = 0;
 
+	rcu_read_lock();
+	psinfo->pr_ppid = task_pid_vnr(rcu_dereference(p->real_parent));
+	rcu_read_unlock();
 	psinfo->pr_pid = task_pid_vnr(p);
-	psinfo->pr_ppid = task_pid_vnr(p->real_parent);
 	psinfo->pr_pgrp = task_pgrp_vnr(p);
 	psinfo->pr_sid = task_session_vnr(p);
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

