From: akpm@linux-foundation.org
Subject: + cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix.patch added to -mm tree
Date: Fri, 21 Aug 2009 16:15:10 -0700
Message-ID: <200908212315.n7LNFARw006613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932533AbZHUXPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 19:15:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, a.p.zijlstra@chello.nl, bblum@google.com, ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com, mingo@elte.hu, oleg@redhat.com


The patch titled
     cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix
has been added to the -mm tree.  Its filename is
     cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix
From: Dave Young <hidave.darkstar@gmail.com>

kernel/sched.c:10452: error: expected ';', ',' or ')' before 'bool'
kernel/sched.c:10536: error: 'cpu_cgroup_attach' undeclared here (not in a function)

Cc: Ben Blum <bblum@google.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix kernel/sched.c
--- a/kernel/sched.c~cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix
+++ a/kernel/sched.c
@@ -10448,7 +10448,7 @@ cpu_cgroup_can_attach(struct cgroup_subs
 
 static void
 cpu_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-		  struct cgroup *old_cont, struct task_struct *tsk
+		  struct cgroup *old_cont, struct task_struct *tsk,
 		  bool threadgroup)
 {
 	sched_move_task(tsk);
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

linux-next.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix.patch
pc-fs-char_devc-remove-useless-loop-fix.patch

