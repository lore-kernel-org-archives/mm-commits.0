From: akpm@linux-foundation.org
Subject: +
 swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch added to -mm tree
Date: Thu, 30 May 2013 14:45:55 -0700
Message-ID: <51a7c893.lHiAvaJGH+Sp2UkX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757942Ab3E3Vp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 17:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, aquini@redhat.com, akpm@linux-foundation.org

Subject: + swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch added to -mm tree
To: akpm@linux-foundation.org,aquini@redhat.com,hughd@google.com
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 14:45:55 -0700


The patch titled
     Subject: swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix
has been added to the -mm tree.  Its filename is
     swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch

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
Subject: swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix

tweak comments

Cc: Hugh Dickins <hughd@google.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/swapfile.c~swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix mm/swapfile.c
--- a/mm/swapfile.c~swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix
+++ a/mm/swapfile.c
@@ -2140,17 +2140,17 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 		if ((swap_flags & SWAP_FLAG_DISCARD) && swap_discardable(p)) {
 			/*
-			 * When discard is enabled for swap, with no particular
-			 * policy flagged, we set all swap discard flags here
-			 * in order to sustain backward compatibility with
-			 * older swapon(8) releases.
+			 * When discard is enabled for swap with no particular
+			 * policy flagged, we set all swap discard flags here in
+			 * order to sustain backward compatibility with older
+			 * swapon(8) releases.
 			 */
 			p->flags |= (SWP_DISCARDABLE | SWP_AREA_DISCARD |
 				     SWP_PAGE_DISCARD);
 
 			/*
 			 * By flagging sys_swapon, a sysadmin can tell us to
-			 * either do sinle-time area discards only, or to just
+			 * either do single-time area discards only, or to just
 			 * perform discards for released swap page-clusters.
 			 * Now it's time to adjust the p->flags accordingly.
 			 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

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
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
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

