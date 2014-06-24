From: akpm@linux-foundation.org
Subject: [merged]
 ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch removed
 from -mm tree
Date: Tue, 24 Jun 2014 12:02:45 -0700
Message-ID: <53a9cb55.R0NdsU41WpDuxL1I%akpm__33410.0890126594$1403636578$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbaFXTCq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:02:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, stable@vger.kernel.org, tony.luck@intel.com, wwoods@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: arch/ia64/include/uapi/asm/fcntl.h needs personality.h
has been removed from the -mm tree.  Its filename was
     ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
fs-isofs-logging-clean-up-fix.patch
panic-add-taint_softlockup-fix.patch
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

