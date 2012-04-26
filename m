From: akpm@linux-foundation.org
Subject: + mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch added to -mm tree
Date: Thu, 26 Apr 2012 16:11:04 -0700
Message-ID: <20120426231105.19880A035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:48551 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2DZXLH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Apr 2012 19:11:07 -0400
Received: by wgbdt11 with SMTP id dt11so5095wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Apr 2012 16:11:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujtisu.com, kosaki.motohiro@jp.fujitsu.com, minchan@kernel.org, riel@redhat.com, yinghan@google.com


The patch titled
     Subject: mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix
has been added to the -mm tree.  Its filename is
     mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch

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
Subject: mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix

s/mlock_vma_newpage/mlock_vma_newpage/, per Minchan.

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    4 ++--
 mm/vmscan.c   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/internal.h~mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix mm/internal.h
--- a/mm/internal.h~mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix
+++ a/mm/internal.h
@@ -164,7 +164,7 @@ static inline void munlock_vma_pages_all
  * to determine if it's being mapped into a LOCKED vma.
  * If so, mark page as mlocked.
  */
-static inline int mlock_vma_newpage(struct vm_area_struct *vma,
+static inline int mlocked_vma_newpage(struct vm_area_struct *vma,
 				    struct page *page)
 {
 	VM_BUG_ON(PageLRU(page));
@@ -223,7 +223,7 @@ extern unsigned long vma_address(struct 
 				 struct vm_area_struct *vma);
 #endif
 #else /* !CONFIG_MMU */
-static inline int mlock_vma_newpage(struct vm_area_struct *v, struct page *p)
+static inline int mlocked_vma_newpage(struct vm_area_struct *v, struct page *p)
 {
 	return 0;
 }
diff -puN mm/vmscan.c~mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix
+++ a/mm/vmscan.c
@@ -3321,7 +3321,7 @@ int page_evictable(struct page *page, st
 	if (mapping_unevictable(page_mapping(page)))
 		return 0;
 
-	if (PageMlocked(page) || (vma && mlock_vma_newpage(vma, page)))
+	if (PageMlocked(page) || (vma && mlocked_vma_newpage(vma, page)))
 		return 0;
 
 	return 1;
_
Subject: Subject: mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
sound-usb-endpointc-suppress-warning.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

