From: akpm@linux-foundation.org
Subject: + proc-add-kpageidle-file-fix-6-fix.patch added to -mm tree
Date: Wed, 05 Aug 2015 16:14:23 -0700
Message-ID: <55c298cf.wYg5CjhOpUN7KFtE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbbHEXOY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2015 19:14:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreslc@google.com, mhocko@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-add-kpageidle-file-fix-6-fix
has been added to the -mm tree.  Its filename is
     proc-add-kpageidle-file-fix-6-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-add-kpageidle-file-fix-6-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-add-kpageidle-file-fix-6-fix.patch

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
Subject: proc-add-kpageidle-file-fix-6-fix

fix build

fs/proc/page.c: In function 'kpageidle_clear_pte_refs_one':
fs/proc/page.c:330: error: implicit declaration of function 'pmdp_clear_young_notify'
fs/proc/page.c:336: error: implicit declaration of function 'ptep_clear_young_notify'
fs/proc/page.c: In function 'kpageidle_read':
fs/proc/page.c:397: error: 'KPMBITS' undeclared (first use in this function)
fs/proc/page.c:397: error: (Each undeclared identifier is reported only once
fs/proc/page.c:397: error: for each function it appears in.)
fs/proc/page.c: In function 'kpageidle_write':
fs/proc/page.c:450: error: 'KPMBITS' undeclared (first use in this function)

Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/proc/page.c~proc-add-kpageidle-file-fix-6-fix fs/proc/page.c
--- a/fs/proc/page.c~proc-add-kpageidle-file-fix-6-fix
+++ a/fs/proc/page.c
@@ -10,6 +10,7 @@
 #include <linux/seq_file.h>
 #include <linux/hugetlb.h>
 #include <linux/memcontrol.h>
+#include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
 #include <linux/kernel-page-flags.h>
 #include <asm/uaccess.h>
@@ -17,6 +18,7 @@
 
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
+#define KPMBITS (KPMSIZE * BITS_PER_BYTE)
 
 /* /proc/kpagecount - an array exposing page counts
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
ocfs2-sysfile-interfaces-for-online-file-check-fix.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code-checkpatch-fixes.patch
mm-mlock-add-new-mlock-system-call-checkpatch-fixes.patch
mm-introduce-vm_lockonfault-checkpatch-fixes.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
pagemap-update-documentation-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-srcu-ify-shrinkers-fix-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
proc-add-kpageidle-file-fix-6-fix.patch
proc-export-idle-flag-via-kpageflags-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zswap-dynamic-pool-creation-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

