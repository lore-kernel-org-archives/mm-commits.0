From: akpm@linux-foundation.org
Subject: - binfmt_elf_fdpic-update-for-cputime-changes.patch removed from -mm tree
Date: Wed, 22 Oct 2008 13:08:43 -0700
Message-ID: <200810222008.m9MK8hcA013818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073AbYJVUJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Oct 2008 16:09:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, adobriyan@gmail.com, fmayhar@google.com, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     binfmt_elf_fdpic: update for cputime changes
has been removed from the -mm tree.  Its filename was
     binfmt_elf_fdpic-update-for-cputime-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: binfmt_elf_fdpic: update for cputime changes
From: Paul Mundt <lethal@linux-sh.org>

Commit f06febc96ba8e0af80bcc3eaec0a109e88275fac "timers: fix itimer/many
thread hang" introduced a new task_cputime interface and subsequently
only converted binfmt_elf over to it. This results in the build for
binfmt_elf_fdpic blowing up given that p->signal->{u,s}time have
disappeared from underneath us.

Apply the same trivial fix from binfmt_elf to binfmt_elf_fdpic.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Frank Mayhar <fmayhar@google.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -puN fs/binfmt_elf_fdpic.c~binfmt_elf_fdpic-update-for-cputime-changes fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~binfmt_elf_fdpic-update-for-cputime-changes
+++ a/fs/binfmt_elf_fdpic.c
@@ -1390,20 +1390,15 @@ static void fill_prstatus(struct elf_prs
 	prstatus->pr_pgrp = task_pgrp_vnr(p);
 	prstatus->pr_sid = task_session_vnr(p);
 	if (thread_group_leader(p)) {
+		struct task_cputime cputime;
+
 		/*
-		 * This is the record for the group leader.  Add in the
-		 * cumulative times of previous dead threads.  This total
-		 * won't include the time of each live thread whose state
-		 * is included in the core dump.  The final total reported
-		 * to our parent process when it calls wait4 will include
-		 * those sums as well as the little bit more time it takes
-		 * this and each other thread to finish dying after the
-		 * core dump synchronization phase.
+		 * This is the record for the group leader.  It shows the
+		 * group-wide total, not its individual thread total.
 		 */
-		cputime_to_timeval(cputime_add(p->utime, p->signal->utime),
-				   &prstatus->pr_utime);
-		cputime_to_timeval(cputime_add(p->stime, p->signal->stime),
-				   &prstatus->pr_stime);
+		thread_group_cputime(p, &cputime);
+		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
+		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
 	} else {
 		cputime_to_timeval(p->utime, &prstatus->pr_utime);
 		cputime_to_timeval(p->stime, &prstatus->pr_stime);
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
mm-page_cgroup-needs-linux-vmalloch-for-vmalloc_node-vfree.patch
profiling-fix-up-config_proc_fs=n-build.patch
linux-next.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch

