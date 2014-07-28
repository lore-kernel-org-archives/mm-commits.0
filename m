From: akpm@linux-foundation.org
Subject: +
 mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path-fix.patch added to -mm tree
Date: Mon, 28 Jul 2014 14:23:47 -0700
Message-ID: <53d6bf63.cUEAkGTSVerfVvY3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:57946 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaG1VXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jul 2014 17:23:48 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1963715pab.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2014 14:23:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.ryabinin@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path-fix
has been added to the -mm tree.  Its filename is
     mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path-fix.patch

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
Subject: mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path-fix

tweak code layout

Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path-fix mm/memory.c
--- a/mm/memory.c~mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path-fix
+++ a/mm/memory.c
@@ -2770,7 +2770,6 @@ static inline unsigned long fault_around
 	return ~(fault_around_bytes - 1) & PAGE_MASK;
 }
 
-
 #ifdef CONFIG_DEBUG_FS
 static int fault_around_bytes_get(void *data, u64 *val)
 {
@@ -2780,7 +2779,8 @@ static int fault_around_bytes_get(void *
 
 /*
  * fault_around_pages() and fault_around_mask() expects fault_around_bytes
- * rounded down to nearest page order. It's what do_fault_around() expects to see.
+ * rounded down to nearest page order. It's what do_fault_around() expects to
+ * see.
  */
 static int fault_around_bytes_set(void *data, u64 val)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path-fix.patch
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
rtc-add-pcf85063-support-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

