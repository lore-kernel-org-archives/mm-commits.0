From: akpm@linux-foundation.org
Subject: + mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
 added to -mm tree
Date: Thu, 25 May 2017 16:40:07 -0700
Message-ID: <59276b57.l4JbTY3d7F/B/RL1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48458 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933514AbdEYXkI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 19:40:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, guroan@gmail.com, khlebnikov@yandex-team.ru, mhocko@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix
has been added to the -mm tree.  Its filename is
     mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch

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
Subject: mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix

"mm: per-cgroup memory reclaim stats" renamed mem_cgroup_count_vm_event()

Cc: David Rientjes <rientjes@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Guschin <guroan@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Roman Gushchin <guro@fb.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix
+++ a/mm/oom_kill.c
@@ -879,7 +879,7 @@ static void oom_kill_process(struct oom_
 
 	/* Raise event before sending signal: reaper must see this */
 	count_vm_event(OOM_KILL);
-	mem_cgroup_count_vm_event(mm, OOM_KILL);
+	count_memcg_event_mm(mm, OOM_KILL);
 
 	/*
 	 * We should send SIGKILL before setting TIF_MEMDIE in order to prevent
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes.patch
mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

