From: akpm@linux-foundation.org
Subject: + include-linux-sched-mmh-re-inline-mmdrop.patch added to -mm
 tree
Date: Thu, 01 Feb 2018 14:40:04 -0800
Message-ID: <5a739744.ZBZOE2jTV8CLrzOr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56172 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751567AbeBAWkG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 17:40:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mingo@kernel.org, oleg@redhat.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/sched/mm.h: re-inline mmdrop()
has been added to the -mm tree.  Its filename is
     include-linux-sched-mmh-re-inline-mmdrop.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-sched-mmh-re-inline-mmdrop.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-sched-mmh-re-inline-mmdrop.patch

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
Subject: include/linux/sched/mm.h: re-inline mmdrop()

As Peter points out, Doing a CALL+RET for just the decrement is a bit silly.

Fixes: d70f2a14b72a4bc ("include/linux/sched/mm.h: uninline mmdrop_async(), etc")
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    8 +++++++-
 kernel/fork.c            |   10 ++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/sched/mm.h~include-linux-sched-mmh-re-inline-mmdrop include/linux/sched/mm.h
--- a/include/linux/sched/mm.h~include-linux-sched-mmh-re-inline-mmdrop
+++ a/include/linux/sched/mm.h
@@ -35,7 +35,13 @@ static inline void mmgrab(struct mm_stru
 	atomic_inc(&mm->mm_count);
 }
 
-extern void mmdrop(struct mm_struct *mm);
+extern void __mmdrop(struct mm_struct *mm);
+
+static inline void mmdrop(struct mm_struct *mm)
+{
+	if (unlikely(atomic_dec_and_test(&mm->mm_count)))
+		__mmdrop(mm);
+}
 
 /**
  * mmget() - Pin the address space associated with a &struct mm_struct.
diff -puN kernel/fork.c~include-linux-sched-mmh-re-inline-mmdrop kernel/fork.c
--- a/kernel/fork.c~include-linux-sched-mmh-re-inline-mmdrop
+++ a/kernel/fork.c
@@ -591,7 +591,7 @@ static void check_mm(struct mm_struct *m
  * is dropped: either by a lazy thread or by
  * mmput. Free the page directory and the mm.
  */
-static void __mmdrop(struct mm_struct *mm)
+void __mmdrop(struct mm_struct *mm)
 {
 	BUG_ON(mm == &init_mm);
 	mm_free_pgd(mm);
@@ -602,13 +602,7 @@ static void __mmdrop(struct mm_struct *m
 	put_user_ns(mm->user_ns);
 	free_mm(mm);
 }
-
-void mmdrop(struct mm_struct *mm)
-{
-	if (unlikely(atomic_dec_and_test(&mm->mm_count)))
-		__mmdrop(mm);
-}
-EXPORT_SYMBOL_GPL(mmdrop);
+EXPORT_SYMBOL_GPL(__mmdrop);
 
 static void mmdrop_async_fn(struct work_struct *work)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-re-inline-mmdrop.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
fs-crypto-hooksc-fix-build-with-gcc-444.patch
maintainers-update-arm-oxnas-platform-support-patterns-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

