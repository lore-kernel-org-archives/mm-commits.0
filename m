From: akpm@linux-foundation.org
Subject: + mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch added to -mm tree
Date: Tue, 29 Nov 2011 15:40:08 -0800
Message-ID: <201111300021.pAU0LMq7003599@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:45763 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757155Ab1K3AV1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2011 19:21:27 -0500
Received: by vcbfl11 with SMTP id fl11so525127vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2011 16:21:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, chris.mason@oracle.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, jweiner@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, riel@redhat.com, shaohua.li@intel.com


The patch titled
     Subject: mm-exclude-reserved-pages-from-dirtyable-memory-fix
has been added to the -mm tree.  Its filename is
     mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-exclude-reserved-pages-from-dirtyable-memory-fix

fix highmem build

Cc: Chris Mason <chris.mason@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/page-writeback.c~mm-exclude-reserved-pages-from-dirtyable-memory-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-exclude-reserved-pages-from-dirtyable-memory-fix
+++ a/mm/page-writeback.c
@@ -157,8 +157,7 @@ static unsigned long highmem_dirtyable_m
 			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
 		x += zone_page_state(z, NR_FREE_PAGES) +
-		     zone_reclaimable_pages(z) -
-		     zone->dirty_balance_reserve;
+		     zone_reclaimable_pages(z) - z->dirty_balance_reserve;
 	}
 	/*
 	 * Make sure that the number of highmem pages is never larger
_
Subject: Subject: mm-exclude-reserved-pages-from-dirtyable-memory-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
include-net-netprio_cgrouph-various-fixes.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

