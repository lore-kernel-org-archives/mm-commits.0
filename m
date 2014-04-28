From: akpm@linux-foundation.org
Subject: + memcg-kill-start_kernel-mm_init_ownerinit_mm.patch added to -mm tree
Date: Mon, 28 Apr 2014 15:58:07 -0700
Message-ID: <535edcff.SkiGv/sUn1m/rw3/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbaD1W6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Apr 2014 18:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pchiang@nvidia.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, bsingharora@gmail.com, oleg@redhat.com

Subject: + memcg-kill-start_kernel-mm_init_ownerinit_mm.patch added to -mm tree
To: oleg@redhat.com,bsingharora@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,pchiang@nvidia.com
From: akpm@linux-foundation.org
Date: Mon, 28 Apr 2014 15:58:07 -0700


The patch titled
     Subject: memcg: kill start_kernel()->mm_init_owner(&init_mm)
has been added to the -mm tree.  Its filename is
     memcg-kill-start_kernel-mm_init_ownerinit_mm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-kill-start_kernel-mm_init_ownerinit_mm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-kill-start_kernel-mm_init_ownerinit_mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: memcg: kill start_kernel()->mm_init_owner(&init_mm)

Remove start_kernel()->mm_init_owner(&init_mm, &init_task).

This doesn't really hurt but unnecessary and misleading.  init_task is the
"swapper" thread == current, its ->mm is always NULL.  And init_mm can
only be used as ->active_mm, not as ->mm.

mm_init_owner() has a single caller with this patch, perhaps it should
die.  mm_init() can initialize ->owner under #ifdef.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Peter Chiang <pchiang@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN init/main.c~memcg-kill-start_kernel-mm_init_ownerinit_mm init/main.c
--- a/init/main.c~memcg-kill-start_kernel-mm_init_ownerinit_mm
+++ a/init/main.c
@@ -507,7 +507,6 @@ asmlinkage void __init start_kernel(void
 	page_address_init();
 	pr_notice("%s", linux_banner);
 	setup_arch(&command_line);
-	mm_init_owner(&init_mm, &init_task);
 	mm_init_cpumask(&init_mm);
 	setup_command_line(command_line);
 	setup_nr_cpu_ids();
_

Patches currently in -mm which might be from oleg@redhat.com are

nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
mmvmacache-optimize-overflow-system-wide-flushing.patch
memcg-kill-config_mm_owner.patch
memcg-mm_update_next_owner-should-skip-kthreads.patch
memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch
memcg-kill-start_kernel-mm_init_ownerinit_mm.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
kthreads-kill-clone_kernel-change-kernel_threadkernel_init-to-avoid-clone_sighand.patch
signals-kill-sigfindinword.patch
signals-s-siginitset-sigemptyset-in-do_sigtimedwait.patch
signals-kill-rm_from_queue-change-prepare_signal-to-use-for_each_thread.patch
signals-rename-rm_from_queue_full-to-flush_sigqueue_mask.patch
signals-cleanup-the-usage-of-t-current-in-do_sigaction.patch
signals-mv-disallow_signal-from-schedh-exitc-to-signal.patch
signals-jffs2-fix-the-wrong-usage-of-disallow_signal.patch
signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal.patch
signals-disallow_signal-should-flush-the-potentially-pending-signal.patch
signals-introduce-kernel_sigaction.patch
signals-change-wait_for_helper-to-use-kernel_sigaction.patch
linux-next.patch

