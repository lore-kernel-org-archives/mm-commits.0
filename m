From: akpm@linux-foundation.org
Subject: + mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch added to -mm tree
Date: Tue, 04 Mar 2014 13:24:11 -0800
Message-ID: <5316447b.YhOHrByPndZxU5wg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbaCDVYM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 16:24:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gidisrael@gmail.com, akpm@linux-foundation.org

Subject: + mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch added to -mm tree
To: akpm@linux-foundation.org,gidisrael@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 13:24:11 -0800


The patch titled
     Subject: mm-use-macros-from-compilerh-instead-of-__attribute__-fix
has been added to the -mm tree.  Its filename is
     mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch

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
@@ -460,7 +460,7 @@ EXPORT_SYMBOL_GPL(vm_unmap_aliases);
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
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-per-thread-vma-caching-fix.patch
mm-per-thread-vma-caching-fix-fix.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
zram-use-zcomp-compressing-backends-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

