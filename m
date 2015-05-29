From: akpm@linux-foundation.org
Subject: + frontswap-allow-multiple-backends-fix.patch added to -mm tree
Date: Fri, 29 May 2015 15:07:23 -0700
Message-ID: <5568e31b.dZ1o2YiJrO20y1cI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308AbbE2WHY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 May 2015 18:07:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, boris.ostrovsky@oracle.com, david.vrabel@citrix.com, ddstreet@ieee.org, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frontswap-allow-multiple-backends-fix
has been added to the -mm tree.  Its filename is
     frontswap-allow-multiple-backends-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/frontswap-allow-multiple-backends-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/frontswap-allow-multiple-backends-fix.patch

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
Subject: frontswap-allow-multiple-backends-fix

fix typo, simplify for loops

Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN mm/frontswap.c~frontswap-allow-multiple-backends-fix mm/frontswap.c
--- a/mm/frontswap.c~frontswap-allow-multiple-backends-fix
+++ a/mm/frontswap.c
@@ -97,7 +97,7 @@ static inline void inc_frontswap_invalid
  *
  * Obviously the opposite (unloading the backend) must be done after all
  * the frontswap_[store|load|invalidate_area|invalidate_page] start
- * ignorning or failing the requests.  However, there is currently no way
+ * ignoring or failing the requests.  However, there is currently no way
  * to unload a backend once it is registered.
  */
 
@@ -118,10 +118,11 @@ void frontswap_register_ops(struct front
 	}
 	spin_unlock(&swap_lock);
 
-	for (i = find_first_bit(a, MAX_SWAPFILES);
-	     i < MAX_SWAPFILES;
-	     i = find_next_bit(a, MAX_SWAPFILES, i + 1))
+	i = find_first_bit(a, MAX_SWAPFILES);
+	while (i < MAX_SWAPFILES) {
 		ops->init(i);
+		i = find_next_bit(a, MAX_SWAPFILES, i + 1);
+	}
 
 	do {
 		ops->next = frontswap_ops;
@@ -233,8 +234,12 @@ int __frontswap_store(struct page *page)
 	BUG_ON(!PageLocked(page));
 	BUG_ON(sis == NULL);
 	dup = __frontswap_test(sis, offset);
-	for (ops = frontswap_ops, ret = -1; ops && ret; ops = ops->next)
+	ret = -1;
+	for (ops = frontswap_ops; ops; ops = ops->next) {
 		ret = ops->store(type, offset, page);
+		if (!ret)
+			break;
+	}
 	if (ret == 0) {
 		set_bit(offset, sis->frontswap_map);
 		inc_frontswap_succ_stores();
@@ -279,8 +284,12 @@ int __frontswap_load(struct page *page)
 	BUG_ON(sis == NULL);
 	if (!__frontswap_test(sis, offset))
 		return -1;
-	for (ops = frontswap_ops, ret = -1; ops && ret; ops = ops->next)
+	ret = -1;
+	for (ops = frontswap_ops; ops; ops = ops->next) {
 		ret = ops->load(type, offset, page);
+		if (!ret)
+			break;
+	}
 	if (ret == 0) {
 		inc_frontswap_loads();
 		if (frontswap_tmem_exclusive_gets_enabled) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fs-binfmt_elfc-load_elf_binary-return-einval-on-zero-length-mappings.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
frontswap-allow-multiple-backends-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
prctl-more-prctlpr_set_mm_-checks-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
init-do_mounts-add-create_dev-failure-log-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-block-nvme-corec-fix-build-with-gcc-444.patch
arch-x86-kvm-mmuc-work-around-gcc-444-bug.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
drivers-gpu-drm-i915-i915_gem_gttc-hack-around-build-error-on-i386.patch
drivers-gpu-drm-i915-i915_gem_gttc-hack-around-build-error-on-i386.patch

