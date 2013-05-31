From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-sysc-remove-unnecessary-parameter-of-set_one_prio-fix.patch removed
 from -mm tree
Date: Fri, 31 May 2013 16:08:11 -0700
Message-ID: <51a92d5b.+C/L7CDzhTB95j3o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424Ab3EaXIM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 19:08:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lig.fnst@cn.fujitsu.com, akpm@linux-foundation.org

Subject: [folded-merged] kernel-sysc-remove-unnecessary-parameter-of-set_one_prio-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,lig.fnst@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 16:08:11 -0700


The patch titled
     Subject: kernel-sysc-remove-unnecessary-parameter-of-set_one_prio-fix
has been removed from the -mm tree.  Its filename was
     kernel-sysc-remove-unnecessary-parameter-of-set_one_prio-fix.patch

This patch was dropped because it was folded into kernel-sysc-remove-unnecessary-parameter-of-set_one_prio.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-sysc-remove-unnecessary-parameter-of-set_one_prio-fix

clean up definitions, remove unneeded assignment

Cc: liguang <lig.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sys.c~kernel-sysc-remove-unnecessary-parameter-of-set_one_prio-fix kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-remove-unnecessary-parameter-of-set_one_prio-fix
+++ a/kernel/sys.c
@@ -153,7 +153,8 @@ static bool set_one_prio_perm(struct tas
  */
 static int set_one_prio(struct task_struct *p, int niceval)
 {
-	int no_nice, error = 0;
+	int no_nice;
+	int error = 0;
 
 	if (!set_one_prio_perm(p)) {
 		error = -EPERM;
@@ -186,7 +187,6 @@ SYSCALL_DEFINE3(setpriority, int, which,
 		goto out;
 
 	/* normalize: avoid signed division (rounding problems) */
-	error = -ESRCH;
 	if (niceval < -20)
 		niceval = -20;
 	if (niceval > 19)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
kernel-sysc-remove-unnecessary-parameter-of-set_one_prio.patch
rbtree-remove-unneeded-include-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch
dev-oldmem-remove-the-interface-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

