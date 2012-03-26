From: akpm@linux-foundation.org
Subject: + procfs-fix-proc-statm.patch added to -mm tree
Date: Mon, 26 Mar 2012 15:40:28 -0700
Message-ID: <20120326224028.AA7AEA023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:41597 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2CZWka (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 18:40:30 -0400
Received: by vcbfk26 with SMTP id fk26so859958vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 15:40:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, drepper@gmail.com


The patch titled
     Subject: procfs: fix /proc/statm
has been added to the -mm tree.  Its filename is
     procfs-fix-proc-statm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: procfs: fix /proc/statm

bda7bad62bc4 ("procfs: speed up /proc/pid/stat, statm") broke /proc/statm
- 'text' is printed twice by mistake.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reported-by: Ulrich Drepper <drepper@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/array.c~procfs-fix-proc-statm fs/proc/array.c
--- a/fs/proc/array.c~procfs-fix-proc-statm
+++ a/fs/proc/array.c
@@ -550,7 +550,7 @@ int proc_pid_statm(struct seq_file *m, s
 	seq_put_decimal_ull(m, ' ', shared);
 	seq_put_decimal_ull(m, ' ', text);
 	seq_put_decimal_ull(m, ' ', 0);
-	seq_put_decimal_ull(m, ' ', text);
+	seq_put_decimal_ull(m, ' ', data);
 	seq_put_decimal_ull(m, ' ', 0);
 	seq_putc(m, '\n');
 
_
Subject: Subject: procfs: fix /proc/statm

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
procfs-fix-proc-statm.patch
mm-coredump-fail-allocations-when-coredumping-instead-of-oom-killing.patch
memcg-change-behavior-of-moving-charges-at-task-move.patch
memcg-change-behavior-of-moving-charges-at-task-move-fix.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

