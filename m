From: akpm@linux-foundation.org
Subject: +
 sched-inline-the-need_resched-test-into-the-caller-for-_cond_resched.patch
 added to -mm tree
Date: Tue, 20 Aug 2013 13:12:33 -0700
Message-ID: <5213cdb1.KsWX5wD8DIFtxYJW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3HTUMe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Aug 2013 16:12:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, a.p.zijlstra@chello.nl, ak@linux.intel.com

Subject: + sched-inline-the-need_resched-test-into-the-caller-for-_cond_resched.patch added to -mm tree
To: ak@linux.intel.com,a.p.zijlstra@chello.nl,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Tue, 20 Aug 2013 13:12:33 -0700


The patch titled
     Subject: sched: inline the need_resched test into the caller for _cond_resched
has been added to the -mm tree.  Its filename is
     sched-inline-the-need_resched-test-into-the-caller-for-_cond_resched.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sched-inline-the-need_resched-test-into-the-caller-for-_cond_resched.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sched-inline-the-need_resched-test-into-the-caller-for-_cond_resched.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sched: inline the need_resched test into the caller for _cond_resched

_cond_resched does at least two explicit calls just to decide to do
nothing: _cond_resched and should_resched().  Inline a need_resched() into
the caller to avoid these calls in the common case of no reschedule being
needed.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/sched.h~sched-inline-the-need_resched-test-into-the-caller-for-_cond_resched include/linux/sched.h
--- a/include/linux/sched.h~sched-inline-the-need_resched-test-into-the-caller-for-_cond_resched
+++ a/include/linux/sched.h
@@ -2442,7 +2442,7 @@ extern int __cond_resched_softirq(void);
 
 #ifdef CONFIG_PREEMPT_VOLUNTARY
 extern int _cond_resched(void);
-# define might_resched() _cond_resched()
+# define might_resched() (need_resched() ? _cond_resched() : 0)
 #else
 # define might_resched() do { } while (0)
 #endif
_

Patches currently in -mm which might be from ak@linux.intel.com are

thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch
mm-mempolicy-rename-check_range-to-queue_pages_range.patch
kernel-modsign_pubkeyc-fix-init-const-for-module-signing-code.patch
lto-watchdog-hpwdtc-make-assembler-label-global.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
x86-add-1-2-4-8-byte-optimization-to-64bit-__copy_fromto_user_inatomic.patch
x86-include-linux-schedh-in-asm-uaccessh.patch
tree-sweep-include-linux-schedh-for-might_sleep-users.patch
move-might_sleep-and-friends-from-kernelh-to-schedh.patch
sched-mark-should_resched-__always_inline.patch
sched-inline-the-need_resched-test-into-the-caller-for-_cond_resched.patch
linux-next.patch

