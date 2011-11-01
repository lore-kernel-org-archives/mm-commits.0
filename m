From: akpm@linux-foundation.org
Subject: [merged] proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:07:15 -0700
Message-ID: <201111012107.pA1L7FJQ002680@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15154 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1KAVHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:07:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, cl@linux-foundation.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, rientjes@google.com, shemminger@vya


The patch titled
     Subject: /proc/self/numa_maps: restore "huge" tag for hugetlb vmas
has been removed from the -mm tree.  Its filename was
     proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: /proc/self/numa_maps: restore "huge" tag for hugetlb vmas

The display of the "huge" tag was accidentally removed in 29ea2f698 ("mm:
use walk_page_range() instead of custom page table walking code").

Reported-by: Stephen Hemminger <shemminger@vyatta.com>
Tested-by: Stephen Hemminger <shemminger@vyatta.com>
Reviewed-by: Stephen Wilson <wilsons@start.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: <stable@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/proc/task_mmu.c~proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas
+++ a/fs/proc/task_mmu.c
@@ -1039,6 +1039,9 @@ static int show_numa_map(struct seq_file
 		seq_printf(m, " stack");
 	}
 
+	if (is_vm_hugetlb_page(vma))
+		seq_printf(m, " huge");
+
 	walk_page_range(vma->vm_start, vma->vm_end, &walk);
 
 	if (!md->pages)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
readlinkat-ensure-we-return-enoent-for-the-empty-pathname-for-normal-lookups.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix.patch
drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
kexec-remove-kmsg_dump_kexec.patch
sysctl-add-support-for-poll-fix.patch
include-linux-dma-mappingh-add-dma_zalloc_coherent.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

