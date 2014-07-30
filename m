From: akpm@linux-foundation.org
Subject: +
 mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
 added to -mm tree
Date: Wed, 30 Jul 2014 14:26:53 -0700
Message-ID: <53d9631d.rkAXLmcnenVMlszT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:52978 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaG3V0z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Jul 2014 17:26:55 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so245178yha.2
        for <mm-commits@vger.kernel.org>; Wed, 30 Jul 2014 14:26:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix
has been added to the -mm tree.  Its filename is
     mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch

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
Subject: mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix

fix non-numa build

mm/oom_kill.c: In function 'pagefault_out_of_memory':
mm/oom_kill.c:697: error: 'first_memory_node' undeclared (first use in this function)
mm/oom_kill.c:697: error: (Each undeclared identifier is reported only once
mm/oom_kill.c:697: error: for each function it appears in.)

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/nodemask.h~mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix include/linux/nodemask.h
--- a/include/linux/nodemask.h~mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix
+++ a/include/linux/nodemask.h
@@ -479,6 +479,7 @@ static inline int num_node_state(enum no
 	for ( (node) = 0; (node) == 0; (node) = 1)
 
 #define first_online_node	0
+#define first_memory_node	0
 #define next_online_node(nid)	(MAX_NUMNODES)
 #define nr_node_ids		1
 #define nr_online_nodes		1
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path-fix.patch
mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings-fix-checkpatch-fixes.patch
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
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
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
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

