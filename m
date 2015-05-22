From: akpm@linux-foundation.org
Subject: + scsi-resolve-sg-buffer-const-ness-issue-fix.patch added to -mm
 tree
Date: Fri, 22 May 2015 13:34:32 -0700
Message-ID: <555f92d8.g+p1/lMIBKOlBjDE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbbEVUed (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 May 2015 16:34:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, arnd@arndb.de, david.s.gordon@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi-resolve-sg-buffer-const-ness-issue-fix
has been added to the -mm tree.  Its filename is
     scsi-resolve-sg-buffer-const-ness-issue-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scsi-resolve-sg-buffer-const-ness-issue-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scsi-resolve-sg-buffer-const-ness-issue-fix.patch

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
Subject: scsi-resolve-sg-buffer-const-ness-issue-fix

fix very broken build

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Gordon <david.s.gordon@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |    3 +++
 lib/scatterlist.c           |    6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/scsi_debug.c~scsi-resolve-sg-buffer-const-ness-issue-fix drivers/scsi/scsi_debug.c
diff -puN lib/scatterlist.c~scsi-resolve-sg-buffer-const-ness-issue-fix lib/scatterlist.c
--- a/lib/scatterlist.c~scsi-resolve-sg-buffer-const-ness-issue-fix
+++ a/lib/scatterlist.c
@@ -618,9 +618,8 @@ EXPORT_SYMBOL(sg_miter_stop);
  * Returns the number of copied bytes.
  *
  **/
-static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
-			     void *buf, size_t buflen, off_t skip,
-			     bool to_buffer)
+size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
+		      size_t buflen, off_t skip, bool to_buffer)
 {
 	unsigned int offset = 0;
 	struct sg_mapping_iter miter;
@@ -657,6 +656,7 @@ static size_t sg_copy_buffer(struct scat
 	local_irq_restore(flags);
 	return offset;
 }
+EXPORT_SYMBOL(sg_copy_buffer);
 
 /**
  * sg_copy_from_buffer - Copy from a linear buffer to an SG list
diff -puN include/linux/scatterlist.h~scsi-resolve-sg-buffer-const-ness-issue-fix include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~scsi-resolve-sg-buffer-const-ness-issue-fix
+++ a/include/linux/scatterlist.h
@@ -239,6 +239,9 @@ int sg_alloc_table_from_pages(struct sg_
 	unsigned long offset, unsigned long size,
 	gfp_t gfp_mask);
 
+size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
+		      size_t buflen, off_t skip, bool to_buffer);
+
 size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 			   const void *buf, size_t buflen);
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

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
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-kvm-mmuc-work-around-gcc-444-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

