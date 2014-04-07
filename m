From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch removed
 from -mm tree
Date: Mon, 07 Apr 2014 15:07:39 -0700
Message-ID: <534321ab.Z6kjDdG2TtEAMKm2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbaDGWHk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:07:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gidisrael@gmail.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,gidisrael@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:07:39 -0700


The patch titled
     Subject: mm-use-macros-from-compilerh-instead-of-__attribute__-fix
has been removed from the -mm tree.  Its filename was
     mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch

This patch was dropped because it was folded into mm-use-macros-from-compilerh-instead-of-__attribute__.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-use-macros-from-compilerh-instead-of-__attribute__-fix

while-we're-there consistency tweaks

Cc: Gideon Israel Dsouza <gidisrael@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 mm/nommu.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-use-macros-from-compilerh-instead-of-__attribute__-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-use-macros-from-compilerh-instead-of-__attribute__-fix
+++ a/mm/hugetlb.c
@@ -3522,7 +3522,7 @@ follow_huge_pud(struct mm_struct *mm, un
 #else /* !CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 
 /* Can be overriden by architectures */
-__weak struct page *
+struct page * __weak
 follow_huge_pud(struct mm_struct *mm, unsigned long address,
 	       pud_t *pud, int write)
 {
diff -puN mm/nommu.c~mm-use-macros-from-compilerh-instead-of-__attribute__-fix mm/nommu.c
--- a/mm/nommu.c~mm-use-macros-from-compilerh-instead-of-__attribute__-fix
+++ a/mm/nommu.c
@@ -461,7 +461,7 @@ EXPORT_SYMBOL_GPL(vm_unmap_aliases);
  * Implement a stub for vmalloc_sync_all() if the architecture chose not to
  * have one.
  */
-void  __weak vmalloc_sync_all(void)
+void __weak vmalloc_sync_all(void)
 {
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmnuma-reorganize-change_pmd_range.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-per-thread-vma-caching.patch
mm-use-macros-from-compilerh-instead-of-__attribute__.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix-2.patch
zram-propagate-error-to-user-fix.patch
zram-support-req_discard-v4-fix.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

