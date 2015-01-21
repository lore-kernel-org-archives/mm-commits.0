From: akpm@linux-foundation.org
Subject: + mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
 added to -mm tree
Date: Tue, 20 Jan 2015 16:48:41 -0800
Message-ID: <54bef769.qIbGSoB7eDClebkU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbbAUAsm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jan 2015 19:48:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-allocate-transparent-hugepages-on-local-node-fix
has been added to the -mm tree.  Its filename is
     mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch

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
Subject: mm-thp-allocate-transparent-hugepages-on-local-node-fix

fix comment, add CONFIG_TRANSPARENT_HUGEPAGE dependency

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-thp-allocate-transparent-hugepages-on-local-node-fix mm/mempolicy.c
--- a/mm/mempolicy.c~mm-thp-allocate-transparent-hugepages-on-local-node-fix
+++ a/mm/mempolicy.c
@@ -2030,6 +2030,7 @@ retry_cpuset:
 	return page;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /**
  * alloc_hugepage_vma: Allocate a hugepage for a VMA
  * @gfp:
@@ -2057,7 +2058,7 @@ retry_cpuset:
  * all allocations for pages that will be mapped into
  * user space. Returns NULL when no page can be allocated.
  *
- * Should be called with the mm_sem of the vma hold.
+ * Should be called with vma->vm_mm->mmap_sem held.
  *
  */
 struct page *alloc_hugepage_vma(gfp_t gfp, struct vm_area_struct *vma,
@@ -2099,6 +2100,7 @@ alloc_with_fallback:
 	 */
 	return alloc_pages_vma(gfp, order, vma, addr, node);
 }
+#endif
 
 /**
  * 	alloc_pages_current - Allocate pages.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-vmstatc-fix-cleanup-ifdefs-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

