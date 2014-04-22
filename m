From: akpm@linux-foundation.org
Subject: + arc-call-find_vma-with-the-mmap_sem-held-fix.patch added to -mm tree
Date: Tue, 22 Apr 2014 11:14:21 -0700
Message-ID: <5356b17d.I8KKF0apV2V42ZD0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaDVSOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Apr 2014 14:14:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, davidlohr@hp.com, akpm@linux-foundation.org

Subject: + arc-call-find_vma-with-the-mmap_sem-held-fix.patch added to -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,vgupta@synopsys.com
From: akpm@linux-foundation.org
Date: Tue, 22 Apr 2014 11:14:21 -0700


The patch titled
     Subject: arc-call-find_vma-with-the-mmap_sem-held-fix
has been added to the -mm tree.  Its filename is
     arc-call-find_vma-with-the-mmap_sem-held-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arc-call-find_vma-with-the-mmap_sem-held-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arc-call-find_vma-with-the-mmap_sem-held-fix.patch

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
Subject: arc-call-find_vma-with-the-mmap_sem-held-fix

CSE current->active_mm, per Vineet

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/troubleshoot.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/arc/kernel/troubleshoot.c~arc-call-find_vma-with-the-mmap_sem-held-fix arch/arc/kernel/troubleshoot.c
--- a/arch/arc/kernel/troubleshoot.c~arc-call-find_vma-with-the-mmap_sem-held-fix
+++ a/arch/arc/kernel/troubleshoot.c
@@ -86,12 +86,13 @@ static void show_faulting_vma(unsigned l
 	unsigned long ino = 0;
 	dev_t dev = 0;
 	char *nm = buf;
+	struct mm_struct *active_mm = current->active_mm;
 
 	/* can't use print_vma_addr() yet as it doesn't check for
 	 * non-inclusive vma
 	 */
-	down_read(&current->active_mm->mmap_sem);
-	vma = find_vma(current->active_mm, address);
+	down_read(&active_mm->mmap_sem);
+	vma = find_vma(active_mm, address);
 
 	/* check against the find_vma( ) behaviour which returns the next VMA
 	 * if the container VMA is not found
@@ -113,7 +114,7 @@ static void show_faulting_vma(unsigned l
 	} else
 		pr_info("    @No matching VMA found\n");
 
-	up_read(&current->active_mm->mmap_sem);
+	up_read(&active_mm->mmap_sem);
 }
 
 static void show_ecr_verbose(struct pt_regs *regs)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-extract-code-to-fault-in-a-page-from-__get_user_pages-fix.patch
mm-gupc-tweaks.patch
mm-gupc-tweaks-fix.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

