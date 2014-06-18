From: akpm@linux-foundation.org
Subject: + ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch added to -mm tree
Date: Wed, 18 Jun 2014 16:21:32 -0700
Message-ID: <53a21efc.+gcqV2f8fQh+Ea92%akpm__26577.5853804827$1403133702$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaFRXVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 19:21:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wwoods@redhat.com, tony.luck@intel.com, stable@vger.kernel.org, fengguang.wu@intel.com, akpm@linux-foundation.org


The patch titled
     Subject: ia64: arch/ia64/include/uapi/asm/fcntl.h needs personality.h
has been added to the -mm tree.  Its filename is
     ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch

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
Subject: ia64: arch/ia64/include/uapi/asm/fcntl.h needs personality.h

fs/notify/fanotify/fanotify_user.c: In function 'SYSC_fanotify_init':
fs/notify/fanotify/fanotify_user.c:726: error: implicit declaration of function 'personality'
fs/notify/fanotify/fanotify_user.c:726: error: 'PER_LINUX32' undeclared (first use in this function)
fs/notify/fanotify/fanotify_user.c:726: error: (Each undeclared identifier is reported only once
fs/notify/fanotify/fanotify_user.c:726: error: for each function it appears in.)

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Will Woods <wwoods@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>	[3.15.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/uapi/asm/fcntl.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/ia64/include/uapi/asm/fcntl.h~ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh arch/ia64/include/uapi/asm/fcntl.h
--- a/arch/ia64/include/uapi/asm/fcntl.h~ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh
+++ a/arch/ia64/include/uapi/asm/fcntl.h
@@ -8,6 +8,7 @@
 #define force_o_largefile()	\
 		(personality(current->personality) != PER_LINUX32)
 
+#include <linux/personality.h>
 #include <asm-generic/fcntl.h>
 
 #endif /* _ASM_IA64_FCNTL_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry-checkpatch-fixes.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep-checkpatch-fixes.patch
shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
fs-isofs-logging-clean-up-fix.patch
initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

