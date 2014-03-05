From: akpm@linux-foundation.org
Subject: + drivers-lguest-page_tablesc-rename-do_set_pte.patch added to
 -mm tree
Date: Wed, 05 Mar 2014 12:02:56 -0800
Message-ID: <531782f0.yfkayl5n6stViKXA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472AbaCEUC5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2014 15:02:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, kirill.shutemov@linux.intel.com, akpm@linux-foundation.org

Subject: + drivers-lguest-page_tablesc-rename-do_set_pte.patch added to -mm tree
To: akpm@linux-foundation.org,kirill.shutemov@linux.intel.com,rusty@rustcorp.com.au
From: akpm@linux-foundation.org
Date: Wed, 05 Mar 2014 12:02:56 -0800


The patch titled
     Subject: drivers/lguest/page_tables.c: rename do_set_pte()
has been added to the -mm tree.  Its filename is
     drivers-lguest-page_tablesc-rename-do_set_pte.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-lguest-page_tablesc-rename-do_set_pte.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-lguest-page_tablesc-rename-do_set_pte.patch

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
Subject: drivers/lguest/page_tables.c: rename do_set_pte()

"mm: introduce vm_ops->map_pages()" wants to export a do_set_pte() from core
kernel.  Rename lguest's do_set_pte() to something more lguest-specific.

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/page_tables.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/lguest/page_tables.c~drivers-lguest-page_tablesc-rename-do_set_pte drivers/lguest/page_tables.c
--- a/drivers/lguest/page_tables.c~drivers-lguest-page_tablesc-rename-do_set_pte
+++ a/drivers/lguest/page_tables.c
@@ -887,7 +887,7 @@ void guest_new_pagetable(struct lg_cpu *
  * _PAGE_ACCESSED then we can put a read-only PTE entry in immediately, and if
  * they set _PAGE_DIRTY then we can put a writable PTE entry in immediately.
  */
-static void do_set_pte(struct lg_cpu *cpu, int idx,
+static void __guest_set_pte(struct lg_cpu *cpu, int idx,
 		       unsigned long vaddr, pte_t gpte)
 {
 	/* Look up the matching shadow page directory entry. */
@@ -960,13 +960,13 @@ void guest_set_pte(struct lg_cpu *cpu,
 		unsigned int i;
 		for (i = 0; i < ARRAY_SIZE(cpu->lg->pgdirs); i++)
 			if (cpu->lg->pgdirs[i].pgdir)
-				do_set_pte(cpu, i, vaddr, gpte);
+				__guest_set_pte(cpu, i, vaddr, gpte);
 	} else {
 		/* Is this page table one we have a shadow for? */
 		int pgdir = find_pgdir(cpu->lg, gpgdir);
 		if (pgdir != ARRAY_SIZE(cpu->lg->pgdirs))
 			/* If so, do the update. */
-			do_set_pte(cpu, pgdir, vaddr, gpte);
+			__guest_set_pte(cpu, pgdir, vaddr, gpte);
 	}
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

