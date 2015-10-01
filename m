From: akpm@linux-foundation.org
Subject: +
 mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch added to -mm tree
Date: Thu, 01 Oct 2015 15:25:37 -0700
Message-ID: <560db2e1.rg2ux0E5diqu68tD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbbJAWZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2015 18:25:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kwalker@redhat.com, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, skozina@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix
has been added to the -mm tree.  Its filename is
     mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_kill-fix-the-wrong-task-mm-%3D%3D-mm-checks-in-oom_kill_process-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_kill-fix-the-wrong-task-mm-%3D%3D-mm-checks-in-oom_kill_process-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix

document process_shares_mm() a bit

Cc: David Rientjes <rientjes@google.com>
Cc: Kyle Walker <kwalker@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Stanislav Kozina <skozina@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/oom_kill.c~mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix
+++ a/mm/oom_kill.c
@@ -483,6 +483,12 @@ void oom_killer_enable(void)
 	oom_killer_disabled = false;
 }
 
+/*
+ * task->mm can be NULL if the task is the exited group leader.  So to
+ * determine whether the task is using a particular mm, we examine all the
+ * task's threads: if one of those is using this mm then this task was also
+ * using it.
+ */
 static bool process_shares_mm(struct task_struct *p, struct mm_struct *mm)
 {
 	struct task_struct *t;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
memcg-make-mem_cgroup_read_stat-unsigned-fix.patch
drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
linux-next-rejects.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

