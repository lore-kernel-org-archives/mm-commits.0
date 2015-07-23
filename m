From: akpm@linux-foundation.org
Subject: +
 kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
 added to -mm tree
Date: Thu, 23 Jul 2015 11:18:11 -0700
Message-ID: <55b12fe3.zZobb59rNqQHJmFm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbbGWSSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jul 2015 14:18:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dyoung@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch

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
Subject: kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
#2072: FILE: kernel/kexec_core.c:41:
+#include <asm/uaccess.h>

WARNING: Use #include <linux/io.h> instead of <asm/io.h>
#2073: FILE: kernel/kexec_core.c:42:
+#include <asm/io.h>

ERROR: do not initialise globals to 0 or NULL
#2092: FILE: kernel/kexec_core.c:61:
+bool kexec_in_progress = false;

WARNING: Missing a blank line after declarations
#2221: FILE: kernel/kexec_core.c:190:
+			unsigned long pstart, pend;
+			pstart = image->segment[j].mem;

WARNING: Missing a blank line after declarations
#2319: FILE: kernel/kexec_core.c:288:
+		unsigned int count, i;
+		pages->mapping = NULL;

WARNING: else is not generally useful after a break or return
#2726: FILE: kernel/kexec_core.c:695:
+			break;
+		} else {

WARNING: Missing a blank line after declarations
#2915: FILE: kernel/kexec_core.c:884:
+	size_t size = 0;
+	mutex_lock(&kexec_mutex);

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#3263: FILE: kernel/kexec_core.c:1232:
+	BUG_ON(!crash_size || !crash_base);

total: 1 errors, 7 warnings, 2753 lines checked

./patches/kexec-split-kexec_load-syscall-from-kexec-core-code.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/kexec_core.c~kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes
+++ a/kernel/kexec_core.c
@@ -30,6 +30,8 @@
 #include <linux/freezer.h>
 #include <linux/pm.h>
 #include <linux/cpu.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 #include <linux/console.h>
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
@@ -38,8 +40,6 @@
 #include <linux/hugetlb.h>
 
 #include <asm/page.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
 #include <asm/sections.h>
 
 #include <crypto/hash.h>
@@ -187,6 +187,7 @@ int sanity_check_segment_list(struct kim
 		mend   = mstart + image->segment[i].memsz;
 		for (j = 0; j < i; j++) {
 			unsigned long pstart, pend;
+
 			pstart = image->segment[j].mem;
 			pend   = pstart + image->segment[j].memsz;
 			/* Do the segments overlap ? */
@@ -285,6 +286,7 @@ static struct page *kimage_alloc_pages(g
 	pages = alloc_pages(gfp_mask, order);
 	if (pages) {
 		unsigned int count, i;
+
 		pages->mapping = NULL;
 		set_page_private(pages, order);
 		count = 1 << order;
@@ -692,12 +694,9 @@ static struct page *kimage_alloc_page(st
 			addr = old_addr;
 			page = old_page;
 			break;
-		} else {
-			/* Place the page on the destination list I
-			 * will use it later.
-			 */
-			list_add(&page->lru, &image->dest_pages);
 		}
+		/* Place the page on the destination list, to be used later */
+		list_add(&page->lru, &image->dest_pages);
 	}
 
 	return page;
@@ -881,6 +880,7 @@ void crash_kexec(struct pt_regs *regs)
 size_t crash_get_memory_size(void)
 {
 	size_t size = 0;
+
 	mutex_lock(&kexec_mutex);
 	if (crashk_res.end != crashk_res.start)
 		size = resource_size(&crashk_res);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
ocfs2-sysfile-interfaces-for-online-file-check-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code-checkpatch-fixes.patch
mm-gup-add-mm_lock_present-checkpatch-fixes.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4-fix.patch
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
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

