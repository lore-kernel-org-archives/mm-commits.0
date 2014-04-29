From: akpm@linux-foundation.org
Subject: +
 mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom-fix.patch added
 to -mm tree
Date: Tue, 29 Apr 2014 15:54:18 -0700
Message-ID: <53602d9a.ueFsmn96thX2vyiq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaD2WyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Apr 2014 18:54:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, sandeen@redhat.com, riel@redhat.com, mpatlasov@parallels.com, mhocko@suse.cz, jweiner@redhat.com, fengguang.wu@intel.com, Kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org

Subject: + mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom-fix.patch added to -mm tree
To: akpm@linux-foundation.org,Kosaki.motohiro@jp.fujitsu.com,fengguang.wu@intel.com,jweiner@redhat.com,mhocko@suse.cz,mpatlasov@parallels.com,riel@redhat.com,sandeen@redhat.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 29 Apr 2014 15:54:18 -0700


The patch titled
     Subject: mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom-fix
has been added to the -mm tree.  Its filename is
     mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom-fix.patch

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
Subject: mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom-fix

comment the obvious

Cc: <stable@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: KOSAKI Motohiro <Kosaki.motohiro@jp.fujitsu.com>
Cc: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom-fix
+++ a/mm/page-writeback.c
@@ -603,7 +603,7 @@ static inline long long pos_ratio_polyno
 
 	divisor = limit - setpoint;
 	if (!divisor)
-		divisor = 1;
+		divisor = 1;	/* Avoid div-by-zero */
 
 	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
 		    divisor);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix-fix.patch
mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

