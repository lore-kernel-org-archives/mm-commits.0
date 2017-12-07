From: akpm@linux-foundation.org
Subject: + mm-oom-cgroup-aware-oom-killer-fix.patch added to -mm tree
Date: Thu, 07 Dec 2017 15:23:44 -0800
Message-ID: <5a29cd80.EFCEKIWcnpYYrwY/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56034 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752142AbdLGXXq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2017 18:23:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, tj@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-cgroup-aware-oom-killer-fix
has been added to the -mm tree.  Its filename is
     mm-oom-cgroup-aware-oom-killer-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-cgroup-aware-oom-killer-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-cgroup-aware-oom-killer-fix.patch

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
Subject: mm-oom-cgroup-aware-oom-killer-fix

two tweaks ariseing from merge fixups, per Roman

Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-cgroup-aware-oom-killer-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-cgroup-aware-oom-killer-fix
+++ a/mm/oom_kill.c
@@ -1096,11 +1096,9 @@ bool out_of_memory(struct oom_control *o
 		return true;
 	}
 
-	if (mem_cgroup_select_oom_victim(oc)) {
-		if (oom_kill_memcg_victim(oc)) {
-			delay = true;
-			goto out;
-		}
+	if (mem_cgroup_select_oom_victim(oc) && oom_kill_memcg_victim(oc)) {
+		delay = true;
+		goto out;
 	}
 
 	select_bad_process(oc);
@@ -1109,7 +1107,7 @@ bool out_of_memory(struct oom_control *o
 		dump_header(oc, NULL);
 		panic("Out of memory and no killable processes...\n");
 	}
-	if (oc->chosen_task && oc->chosen_task != (void *)-1UL) {
+	if (oc->chosen_task && oc->chosen_task != INFLIGHT_VICTIM) {
 		oom_kill_process(oc, !is_memcg_oom(oc) ? "Out of memory" :
 				 "Memory cgroup out of memory");
 		delay = true;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient.patch
stringh-work-around-for-increased-stack-usage-fix.patch
mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

