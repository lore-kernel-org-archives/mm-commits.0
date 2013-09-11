From: akpm@linux-foundation.org
Subject: + partitions-efi-some-style-cleanups-checkpatch-fixes.patch added to -mm tree
Date: Tue, 10 Sep 2013 17:21:40 -0700
Message-ID: <522fb794.ugqh0LPf+e3iNU4Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab3IKAVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 20:21:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, kzak@redhat.com, davidlohr@hp.com, akpm@linux-foundation.org

Subject: + partitions-efi-some-style-cleanups-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,kzak@redhat.com,matt.fleming@intel.com
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 17:21:40 -0700


The patch titled
     Subject: partitions-efi-some-style-cleanups-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     partitions-efi-some-style-cleanups-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/partitions-efi-some-style-cleanups-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/partitions-efi-some-style-cleanups-checkpatch-fixes.patch

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
Subject: partitions-efi-some-style-cleanups-checkpatch-fixes

Cc: Davidlohr Bueso <davidlohr@hp.com>

ERROR: code indent should use tabs where possible
#34: FILE: block/partitions/efi.c:295:
+                     (u8 *) pte, count) < count) {$

WARNING: please, no spaces at the start of a line
#34: FILE: block/partitions/efi.c:295:
+                     (u8 *) pte, count) < count) {$

WARNING: line over 80 characters
#44: FILE: block/partitions/efi.c:620:
+		good_agpt = is_gpt_valid(state, le64_to_cpu(pgpt->alternate_lba),

ERROR: code indent should use tabs where possible
#55: FILE: block/partitions/efi.c:638:
+                        printk(KERN_WARNING "Alternate GPT is invalid, using primary GPT.\n");$

WARNING: please, no spaces at the start of a line
#55: FILE: block/partitions/efi.c:638:
+                        printk(KERN_WARNING "Alternate GPT is invalid, using primary GPT.\n");$

WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
#55: FILE: block/partitions/efi.c:638:
+                        printk(KERN_WARNING "Alternate GPT is invalid, using primary GPT.\n");

ERROR: code indent should use tabs where possible
#65: FILE: block/partitions/efi.c:647:
+                printk(KERN_WARNING "Primary GPT is invalid, using alternate GPT.\n");$

WARNING: please, no spaces at the start of a line
#65: FILE: block/partitions/efi.c:647:
+                printk(KERN_WARNING "Primary GPT is invalid, using alternate GPT.\n");$

WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
#65: FILE: block/partitions/efi.c:647:
+                printk(KERN_WARNING "Primary GPT is invalid, using alternate GPT.\n");

WARNING: line over 80 characters
#75: FILE: block/partitions/efi.c:709:
+		if (!efi_guidcmp(ptes[i].partition_type_guid, PARTITION_LINUX_RAID_GUID))

total: 3 errors, 7 warnings, 55 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/partitions-efi-some-style-cleanups.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Karel Zak <kzak@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN block/partitions/efi.c~partitions-efi-some-style-cleanups-checkpatch-fixes block/partitions/efi.c
--- a/block/partitions/efi.c~partitions-efi-some-style-cleanups-checkpatch-fixes
+++ a/block/partitions/efi.c
@@ -292,7 +292,7 @@ static gpt_entry *alloc_read_gpt_entries
 		return NULL;
 
 	if (read_lba(state, le64_to_cpu(gpt->partition_entry_lba),
-                     (u8 *) pte, count) < count) {
+			(u8 *) pte, count) < count) {
 		kfree(pte);
                 pte=NULL;
 		return NULL;
@@ -617,7 +617,8 @@ static int find_valid_gpt(struct parsed_
 	good_pgpt = is_gpt_valid(state, GPT_PRIMARY_PARTITION_TABLE_LBA,
 				 &pgpt, &pptes);
         if (good_pgpt)
-		good_agpt = is_gpt_valid(state, le64_to_cpu(pgpt->alternate_lba),
+		good_agpt = is_gpt_valid(state,
+					 le64_to_cpu(pgpt->alternate_lba),
 					 &agpt, &aptes);
         if (!good_agpt && force_gpt)
                 good_agpt = is_gpt_valid(state, lastlba, &agpt, &aptes);
@@ -634,9 +635,8 @@ static int find_valid_gpt(struct parsed_
                 *ptes = pptes;
                 kfree(agpt);
                 kfree(aptes);
-                if (!good_agpt) {
+		if (!good_agpt)
                         printk(KERN_WARNING "Alternate GPT is invalid, using primary GPT.\n");
-                }
                 return 1;
         }
         else if (good_agpt) {
@@ -644,7 +644,7 @@ static int find_valid_gpt(struct parsed_
                 *ptes = aptes;
                 kfree(pgpt);
                 kfree(pptes);
-                printk(KERN_WARNING "Primary GPT is invalid, using alternate GPT.\n");
+		printk(KERN_WARNING "Primary GPT is invalid, using alternate GPT.\n");
                 return 1;
         }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch
block-support-embedded-device-command-line-partition.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
mm-track-vma-changes-with-vm_softdirty-bit-fix.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch
mm-page-writebackc-add-strictlimit-feature-fix.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch
vfs-allow-umount-to-handle-mountpoints-without-revalidating-them-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
partitions-efi-use-lba-aware-partition-records-checkpatch-fixes.patch
partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes.patch
partitions-efi-detect-hybrid-mbrs-checkpatch-fixes.patch
partitions-efi-some-style-cleanups-checkpatch-fixes.patch
block-partitions-efic-consistently-use-pr_foo.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
memcg-trivial-cleanups.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

