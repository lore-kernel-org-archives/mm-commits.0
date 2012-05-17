From: akpm@linux-foundation.org
Subject: + sched-set-taint_unsafe_smp-after-sleep-in-atomic-bug.patch added to -mm tree
Date: Thu, 17 May 2012 16:22:10 -0700
Message-ID: <20120517232210.A292EA02FF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:44942 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab2EQXWL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 May 2012 19:22:11 -0400
Received: by ggeh3 with SMTP id h3so311676gge.1
        for <mm-commits@vger.kernel.org>; Thu, 17 May 2012 16:22:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, a.p.zijlstra@chello.nl, mingo@elte.hu, rdunlap@xenotime.net


The patch titled
     From: Konstantin Khlebnikov <khlebnikov@openvz.org>
has been added to the -mm tree.  Its filename is
     sched-set-taint_unsafe_smp-after-sleep-in-atomic-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: sched: set TAINT_UNSAFE_SMP after sleep-in-atomic bug

Usually sleep-in-atomic bugs are followed by dozens other warnings.  This
patch should help to figure out original source of problem.  This taint
flag also turns off lockdep, because it can go mad after that.

Original TAINT_UNSAFE_SMP is used only on various ancient buggy K7
Athlons.  TAINT_UNSAFE_SMP is shown as 'S' in "Tainted" line, so let it be
acronym for SMP, Scheduler and Sleep-in-atomic.  Probably we should rename
it into TAINT_SHIT, but TAINT_CRAP is already there.  =)

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/oops-tracing.txt  |    2 +-
 Documentation/sysctl/kernel.txt |    1 +
 kernel/sched/core.c             |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff -puN Documentation/oops-tracing.txt~sched-set-taint_unsafe_smp-after-sleep-in-atomic-bug Documentation/oops-tracing.txt
--- a/Documentation/oops-tracing.txt~sched-set-taint_unsafe_smp-after-sleep-in-atomic-bug
+++ a/Documentation/oops-tracing.txt
@@ -237,7 +237,7 @@ characters, each representing a particul
   3: 'S' if the oops occurred on an SMP kernel running on hardware that
      hasn't been certified as safe to run multiprocessor.
      Currently this occurs only on various Athlons that are not
-     SMP capable.
+     SMP capable. Also cpu scheduler sets this after sleep-in-atomic bug.
 
   4: 'R' if a module was force unloaded by "rmmod -f", ' ' if all
      modules were unloaded normally.
diff -puN Documentation/sysctl/kernel.txt~sched-set-taint_unsafe_smp-after-sleep-in-atomic-bug Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~sched-set-taint_unsafe_smp-after-sleep-in-atomic-bug
+++ a/Documentation/sysctl/kernel.txt
@@ -590,6 +590,7 @@ can be ORed together:
    2 - A module was force loaded by insmod -f.
        Set by modutils >= 2.4.9 and module-init-tools.
    4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
+       Also cpu scheduler sets this after sleep-in-atomic bug.
    8 - A module was forcibly unloaded from the system by rmmod -f.
   16 - A hardware machine check error occurred on the system.
   32 - A bad page was discovered on the system.
diff -puN kernel/sched/core.c~sched-set-taint_unsafe_smp-after-sleep-in-atomic-bug kernel/sched/core.c
--- a/kernel/sched/core.c~sched-set-taint_unsafe_smp-after-sleep-in-atomic-bug
+++ a/kernel/sched/core.c
@@ -3133,6 +3133,7 @@ static noinline void __schedule_bug(stru
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
 	dump_stack();
+	add_taint(TAINT_UNSAFE_SMP);
 }
 
 /*
_
Subject: From: Konstantin Khlebnikov <khlebnikov@openvz.org>

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
fs-proc-fix-abba-deadlock-in-case-of-execution-attempt-of-map_files-entries.patch
mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
bug-introduce-build_bug_on_invalid-macro.patch
bug-completely-remove-code-generated-by-disabled-vm_bug_on.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
mm-vmscan-store-priority-in-struct-scan_control.patch
mm-add-link-from-struct-lruvec-to-struct-zone.patch
mm-vmscan-push-lruvec-pointer-into-isolate_lru_pages.patch
mm-vmscan-push-zone-pointer-into-shrink_page_list.patch
mm-vmscan-remove-update_isolated_counts.patch
mm-vmscan-push-lruvec-pointer-into-putback_inactive_pages.patch
mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size.patch
mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low.patch
mm-vmscan-push-lruvec-pointer-into-shrink_list.patch
mm-vmscan-push-lruvec-pointer-into-get_scan_count.patch
mm-vmscan-push-lruvec-pointer-into-should_continue_reclaim.patch
mm-vmscan-kill-struct-mem_cgroup_zone.patch
mm-memcg-get_lru_size-not-get_lruvec_size.patch
mm-trivial-cleanups-in-vmscanc.patch
mm-memcg-apply-add-del_page-to-lruvec.patch
sched-set-taint_unsafe_smp-after-sleep-in-atomic-bug.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

