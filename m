From: akpm@linux-foundation.org
Subject: + mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch added to -mm tree
Date: Thu, 06 Sep 2012 13:08:50 -0700
Message-ID: <20120906200851.13C55200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:49519 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759239Ab2IFUIz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2012 16:08:55 -0400
Received: by eaac1 with SMTP id c1so128762eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 06 Sep 2012 13:08:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, andrea@qumranet.com, avi@redhat.com, cl@linux-foundation.org, haggaie@mellanox.com, hughd@google.com, liranl@mellanox.com, ogerlitz@mellanox.com, raindel@mellanox.com, sagig@mellanox.com, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix
has been added to the -mm tree.  Its filename is
     mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch

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
Subject: mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix

possible speed tweak in hugetlb_cow(), cleanups

Cc: Andrea Arcangeli <andrea@qumranet.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Haggai Eran <haggaie@mellanox.com>
Cc: Liran Liss <liranl@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Shachar Raindel <raindel@mellanox.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 mm/memory.c  |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix
+++ a/mm/hugetlb.c
@@ -2616,7 +2616,7 @@ retry_avoidcopy:
 	__SetPageUptodate(new_page);
 
 	mmun_start = address & huge_page_mask(h);
-	mmun_end   = (address & huge_page_mask(h)) + huge_page_size(h);
+	mmun_end = mmun_start + huge_page_size(h);
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	/*
 	 * Retake the page_table_lock to check for racing updates
diff -puN mm/memory.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix mm/memory.c
--- a/mm/memory.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix
+++ a/mm/memory.c
@@ -1096,8 +1096,7 @@ int copy_page_range(struct mm_struct *ds
 	} while (dst_pgd++, src_pgd++, addr = next, addr != end);
 
 	if (is_cow_mapping(vma->vm_flags))
-		mmu_notifier_invalidate_range_end(src_mm, mmun_start,
-						  mmun_end);
+		mmu_notifier_invalidate_range_end(src_mm, mmun_start, mmun_end);
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
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-support-migrate_discard-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
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
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

