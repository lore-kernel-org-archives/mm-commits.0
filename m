From: akpm@linux-foundation.org
Subject: +
 mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
 added to -mm tree
Date: Thu, 17 Jul 2014 13:22:08 -0700
Message-ID: <53c83070.J4UF7w+LU8FnFUcT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:33829 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaGQUWJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 16:22:09 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so301841oah.0
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 13:22:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix
has been added to the -mm tree.  Its filename is
     mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch

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
Subject: mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix

clean up layout

Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/proc/vmcore.c~mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix
+++ a/fs/proc/vmcore.c
@@ -340,9 +340,9 @@ static inline char *alloc_elfnotes_buf(s
  *
  * Returns zero on success, -EAGAIN on failure.
  */
-static int remap_oldmem_pfn_checked(struct vm_area_struct *vma, unsigned long from,
-			     unsigned long pfn, unsigned long size,
-			     pgprot_t prot)
+static int remap_oldmem_pfn_checked(struct vm_area_struct *vma,
+				    unsigned long from, unsigned long pfn,
+				    unsigned long size, pgprot_t prot)
 {
 	size_t map_size;
 	unsigned long pos_start, pos_end, pos;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
revert-fs-seq_file-fallback-to-vmalloc-allocation.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

