From: akpm@linux-foundation.org
Subject: [folded-merged] swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch removed from -mm tree
Date: Tue, 18 Dec 2012 15:08:21 -0800
Message-ID: <20121218230822.3D7F282004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:35406 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab2LRXIX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 18:08:23 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so184877qaq.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 15:08:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, hughd@google.com, khlebnikov@openvz.org, minchan@kernel.org, riel@redhat.com, shli@fusionio.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
has been removed from the -mm tree.  Its filename was
     swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

This patch was dropped because it was folded into swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix

tweak code comment

Cc: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN mm/internal.h~swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix mm/internal.h
--- a/mm/internal.h~swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
+++ a/mm/internal.h
@@ -377,15 +377,12 @@ unsigned long reclaim_clean_pages_from_l
 #define ALLOC_CMA		0x80 /* allow allocations from CMA areas */
 
 /*
- * Unnecessary readahead harms performance. 1. for SSD, big size read is more
- * expensive than small size read, so extra unnecessary read only has overhead.
- * For harddisk, this overhead doesn't exist. 2. unnecessary readahead will
- * allocate extra memroy, which further tights memory pressure, so more
- * swapout/swapin.
- * These adds a simple swap random access detection. In swap page fault, if
- * page is found in swap cache, decrease an account of vma, otherwise we need
- * do sync swapin and the account is increased. Optionally swapin will do
- * readahead if the counter is below a threshold.
+ * Unnecessary readahead harms performance, especially for SSD devices, where
+ * large reads are significantly more expensive than small ones.
+ * These implements simple swap random access detection. In swap page fault: if
+ * the page is found in swapcache, decrease a counter in the vma, otherwise we
+ * need to perform sync swapin and the counter is increased.  Optionally swapin
+ * will perform readahead if the counter is below a threshold.
  */
 #ifdef CONFIG_SWAP
 #define SWAPRA_MISS_THRESHOLD  (100)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
memory-hotplug-document-and-enable-config_movable_node.patch
memcg-kmem-accounting-basic-infrastructure.patch
slub-slub-specific-propagation-changes.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
sgi-xp-handle-non-fatal-traps-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup.patch
mm.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

