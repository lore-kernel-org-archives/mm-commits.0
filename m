From: akpm@linux-foundation.org
Subject: [merged] drivers-lguest-page_tablesc-rename-do_set_pte.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 13:40:43 -0700
Message-ID: <53445ecb.leHYPW/h4l7UPgmv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaDHUko (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:40:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, kirill.shutemov@linux.intel.com, akpm@linux-foundation.org

Subject: [merged] drivers-lguest-page_tablesc-rename-do_set_pte.patch removed from -mm tree
To: akpm@linux-foundation.org,kirill.shutemov@linux.intel.com,rusty@rustcorp.com.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:40:43 -0700


The patch titled
     Subject: drivers/lguest/page_tables.c: rename do_set_pte()
has been removed from the -mm tree.  Its filename was
     drivers-lguest-page_tablesc-rename-do_set_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

