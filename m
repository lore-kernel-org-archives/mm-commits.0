From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 08 Jul 2016 14:33:33 -0700
Message-ID: <57801c2d.vhPr2bHIOdOh0njc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbcGHVde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 17:33:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/fault.c |    6 ------
 kernel/sched/fair.c   |    4 ----
 2 files changed, 10 deletions(-)

diff -puN arch/arm64/mm/fault.c~linux-next-git-rejects arch/arm64/mm/fault.c
--- a/arch/arm64/mm/fault.c~linux-next-git-rejects
+++ a/arch/arm64/mm/fault.c
@@ -282,14 +282,8 @@ static int __kprobes do_page_fault(unsig
 		mm_flags |= FAULT_FLAG_WRITE;
 	}
 
-<<<<<<< HEAD
-	if (permission_fault(esr) && (addr < USER_DS)) {
-		/* regs->orig_addr_limit may be 0 if we entered from EL0 */
-		if (regs->orig_addr_limit == KERNEL_DS)
-=======
 	if (is_permission_fault(esr) && (addr < USER_DS)) {
 		if (get_fs() == KERNEL_DS)
->>>>>>> linux-next/akpm-base
 			die("Accessing user space memory with fs=KERNEL_DS", regs, esr);
 
 		if (!search_exception_tables(regs->pc))
diff -puN kernel/sched/fair.c~linux-next-git-rejects kernel/sched/fair.c
--- a/kernel/sched/fair.c~linux-next-git-rejects
+++ a/kernel/sched/fair.c
@@ -765,11 +765,7 @@ void post_init_entity_util_avg(struct sc
 		update_tg_load_avg(cfs_rq, false);
 }
 
-<<<<<<< HEAD
-#else
-=======
 #else /* !CONFIG_SMP */
->>>>>>> linux-next/akpm-base
 void init_entity_runnable_average(struct sched_entity *se)
 {
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-improve-recovery-performance-v2-fix.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
mm-zsmalloc-add-per-class-compact-trace-event-checkpatch-fixes.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

