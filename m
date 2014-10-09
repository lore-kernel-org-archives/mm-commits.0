From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-introduce-a-general-rcu-get_user_pages_fast-fix.patch removed from -mm
 tree
Date: Thu, 09 Oct 2014 13:45:21 -0700
Message-ID: <5436f3e1.arHbODpRyUgKv0gO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaJIUpV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:45:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, steve.capper@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-a-general-rcu-get_user_pages_fast-fix
has been removed from the -mm tree.  Its filename was
     mm-introduce-a-general-rcu-get_user_pages_fast-fix.patch

This patch was dropped because it was folded into mm-introduce-a-general-rcu-get_user_pages_fast.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-introduce-a-general-rcu-get_user_pages_fast-fix

various comment fixes

Cc: Steve Capper <steve.capper@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/gup.c~mm-introduce-a-general-rcu-get_user_pages_fast-fix mm/gup.c
--- a/mm/gup.c~mm-introduce-a-general-rcu-get_user_pages_fast-fix
+++ a/mm/gup.c
@@ -677,7 +677,7 @@ struct page *get_dump_page(unsigned long
 }
 #endif /* CONFIG_ELF_CORE */
 
-/**
+/*
  * Generic RCU Fast GUP
  *
  * get_user_pages_fast attempts to pin user pages by walking the page
@@ -930,8 +930,8 @@ static int gup_pud_range(pgd_t *pgdp, un
 }
 
 /*
- * Like get_user_pages_fast() except its IRQ-safe in that it won't fall
- * back to the regular GUP. It will only return non-negative values.
+ * Like get_user_pages_fast() except it's IRQ-safe in that it won't fall back to
+ * the regular GUP. It will only return non-negative values.
  */
 int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			  struct page **pages)
@@ -952,8 +952,8 @@ int __get_user_pages_fast(unsigned long
 		return 0;
 
 	/*
-	 * Disable interrupts, we use the nested form as we can already
-	 * have interrupts disabled by get_futex_key.
+	 * Disable interrupts.  We use the nested form as we can already have
+	 * interrupts disabled by get_futex_key.
 	 *
 	 * With interrupts disabled, we block page table pages from being
 	 * freed from under us. See mmu_gather_tlb in asm-generic/tlb.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch
mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
memory-hotplug-add-sysfs-zones_online_to-attribute.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
include-linux-migrateh-remove-migratepage-define.patch
introduce-dump_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-introduce-vm_bug_on_mm.patch
mm-debugc-use-pr_emerg.patch
mm-ksm-use-pr_err-instead-of-printk.patch
mm-introduce-a-general-rcu-get_user_pages_fast.patch
arm64-mm-enable-rcu-fast_gup-checkpatch-fixes.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
acct-eliminate-compile-warning-fix.patch

