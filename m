From: akpm@linux-foundation.org
Subject: - mmu-notifier-core-fix-2.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:18:19 -0700
Message-ID: <200807232330.m6NNUuYd017836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754625AbYGWXcT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:32:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, aliguori@us.ibm.com, andrea@qumranet.com, avi@qumranet.com, chrisw@redhat.com, cl@linux-foundation.org, dada1@cosmosbay.com, holt@sg


The patch titled
     mmu-notifier-core-fix-2
has been removed from the -mm tree.  Its filename was
     mmu-notifier-core-fix-2.patch

This patch was dropped because it was folded into mmu-notifier-core.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmu-notifier-core-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

mm/mmu_notifier.c: In function '__mmu_notifier_clear_flush_young':
mm/mmu_notifier.c:92: error: implicit declaration of function 'hlist_for_each_entry_rcu'
mm/mmu_notifier.c:92: error: 'hlist' undeclared (first use in this function)
mm/mmu_notifier.c:92: error: (Each undeclared identifier is reported only once
mm/mmu_notifier.c:92: error: for each function it appears in.)
mm/mmu_notifier.c:92: error: expected ';' before '{' token
mm/mmu_notifier.c: In function '__mmu_notifier_invalidate_page':
mm/mmu_notifier.c:108: error: 'hlist' undeclared (first use in this function)
mm/mmu_notifier.c:108: error: expected ';' before '{' token
mm/mmu_notifier.c: In function '__mmu_notifier_invalidate_range_start':
mm/mmu_notifier.c:122: error: 'hlist' undeclared (first use in this function)
mm/mmu_notifier.c:122: error: expected ';' before '{' token
mm/mmu_notifier.c: In function '__mmu_notifier_invalidate_range_end':
mm/mmu_notifier.c:136: error: 'hlist' undeclared (first use in this function)
mm/mmu_notifier.c:136: error: expected ';' before '{' token
mm/mmu_notifier.c: In function 'mmu_notifier_unregister':
mm/mmu_notifier.c:247: error: implicit declaration of function 'hlist_del_rcu'

Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>
Cc: Anthony Liguori <aliguori@us.ibm.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Izik Eidus <izike@qumranet.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Kanoj Sarcar <kanojsarcar@yahoo.com>
Cc: Marcelo Tosatti <marcelo@kvack.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/mmu_notifier.c~mmu-notifier-core-fix-2 mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mmu-notifier-core-fix-2
+++ a/mm/mmu_notifier.c
@@ -9,6 +9,7 @@
  *  the COPYING file in the top-level directory.
  */
 
+#include <linux/rculist.h>
 #include <linux/mmu_notifier.h>
 #include <linux/module.h>
 #include <linux/mm.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
kill-generic_file_direct_io.patch
use-generic_access_phys-for-dev-mem-mappings.patch
spufs-use-the-new-vm_ops-access.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch
page-flags-record-page-flag-overlays-explicitly.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups.patch
vma-page-offset-has-no-callees-drop-it.patch
sync_file_range_write-may-and-will-block-document-that.patch
vmallocinfo-add-numa-information.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
bootmem-add-debugging-framework.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
mmu-notifier-core-fix-2.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts-fix.patch
rtc-cmos-improve-hpet-irq-glue-build-fix.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant-sm501-align-panel-fb-to-page_size-fix.patch
lcd-add-platform_lcd-driver-fix.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
fbcon-remove-stray-semicolons-checkpatch-fixes.patch

