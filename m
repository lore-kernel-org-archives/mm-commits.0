From: akpm@linux-foundation.org
Subject: + bug-introduce-build_bug_on_invalid-macro.patch added to -mm tree
Date: Mon, 30 Apr 2012 15:56:39 -0700
Message-ID: <20120430225640.38CA5A009E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:61043 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab2D3W4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 18:56:43 -0400
Received: by lbbgp10 with SMTP id gp10so116078lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 15:56:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, geert@linux-m68k.org, hpa@zytor.com, hughd@google.com, torvalds@linux-foundation.org, xiyou.wangcong@gmail.com


The patch titled
     Subject: bug: introduce BUILD_BUG_ON_INVALID() macro
has been added to the -mm tree.  Its filename is
     bug-introduce-build_bug_on_invalid-macro.patch

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
Subject: bug: introduce BUILD_BUG_ON_INVALID() macro

Sometimes we want to check some expressions correctness at compile time. 
"(void)(e);" or "if (e);" can be dangerous if the expression has
side-effects, and gcc sometimes generates a lot of code, even if the
expression has no effect.

This patch introduces macro BUILD_BUG_ON_INVALID() for such checks, it
forces a compilation error if expression is invalid without any extra
code.

[Cast to "long" required because sizeof does not work for bit-fields.]

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/bug.h~bug-introduce-build_bug_on_invalid-macro include/linux/bug.h
--- a/include/linux/bug.h~bug-introduce-build_bug_on_invalid-macro
+++ a/include/linux/bug.h
@@ -30,6 +30,13 @@ struct pt_regs;
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
 #define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
 
+/*
+ * BUILD_BUG_ON_INVALID() permits the compiler to check the validity of the
+ * expression but avoids the generation of any code, even if that expression
+ * has side-effects.
+ */
+#define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
+
 /**
  * BUILD_BUG_ON - break compile if a condition is true.
  * @condition: the condition which the compiler should know is false.
_
Subject: Subject: bug: introduce BUILD_BUG_ON_INVALID() macro

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
proc-pagemap-correctly-report-non-present-ptes-and-holes-between-vmas.patch
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
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

