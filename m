From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix-fix.patch removed from -mm tree
Date: Tue, 11 Sep 2012 15:59:23 -0700
Message-ID: <20120911225924.271A61E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:39812 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab2IKW70 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 18:59:26 -0400
Received: by qafl39 with SMTP id l39so132313qaf.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 15:59:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, andrea@qumranet.com, avi@redhat.com, cl@linux-foundation.org, haggaie@mellanox.com, hughd@google.com, liranl@mellanox.com, ogerlitz@mellanox.com, raindel@mellanox.com, sagig@mellanox.com, xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix-fix

small optimisation.  might fix bogus used-uninitialised warnings

Cc: Andrea Arcangeli <andrea@qumranet.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Haggai Eran <haggaie@mellanox.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liran Liss <liranl@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Shachar Raindel <raindel@mellanox.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix-fix mm/memory.c
--- a/mm/memory.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix-fix
+++ a/mm/memory.c
@@ -1041,6 +1041,7 @@ int copy_page_range(struct mm_struct *ds
 	unsigned long end = vma->vm_end;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
+	bool is_cow;
 	int ret;
 
 	/*
@@ -1074,7 +1075,8 @@ int copy_page_range(struct mm_struct *ds
 	 * parent mm. And a permission downgrade will only happen if
 	 * is_cow_mapping() returns true.
 	 */
-	if (is_cow_mapping(vma->vm_flags)) {
+	is_cow = is_cow_mapping(vma->vm_flags);
+	if (is_cow) {
 		mmun_start = addr;
 		mmun_end   = end;
 		mmu_notifier_invalidate_range_start(src_mm, mmun_start,
@@ -1095,7 +1097,7 @@ int copy_page_range(struct mm_struct *ds
 		}
 	} while (dst_pgd++, src_pgd++, addr = next, addr != end);
 
-	if (is_cow_mapping(vma->vm_flags))
+	if (is_cow)
 		mmu_notifier_invalidate_range_end(src_mm, mmun_start, mmun_end);
 	return ret;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

