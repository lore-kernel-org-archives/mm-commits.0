From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
 added to -mm tree
Date: Thu, 23 Oct 2014 12:43:49 -0700
Message-ID: <54495a75.7xX+XBqHx7PDi6SZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaJWTns (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 15:43:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch

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
Subject: mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix

forgot to refresh...

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix
+++ a/mm/memcontrol.c
@@ -5406,7 +5406,7 @@ static void mem_cgroup_clear_mc(void)
 	mc.to = NULL;
 	spin_unlock(&mc.lock);
 
-	atomic_dec(&memcg->moving_account);
+	atomic_dec(&from->moving_account);
 }
 
 static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
@@ -5446,7 +5446,7 @@ static int mem_cgroup_can_attach(struct
 			 * its pages to another memcg.  Then wait for
 			 * already started RCU-only updates to finish.
 			 */
-			atomic_inc(&memcg->moving_account);
+			atomic_inc(&from->moving_account);
 			synchronize_rcu();
 
 			spin_lock(&mc.lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-fix.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

