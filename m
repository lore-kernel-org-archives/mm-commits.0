From: akpm@linux-foundation.org
Subject: + block-partitions-efic-consistently-use-pr_foo.patch added to
 -mm tree
Date: Tue, 10 Sep 2013 17:21:42 -0700
Message-ID: <522fb796.HYckokZbpBYEFiZz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab3IKAVn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 20:21:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, kzak@redhat.com, davidlohr@hp.com, akpm@linux-foundation.org

Subject: + block-partitions-efic-consistently-use-pr_foo.patch added to -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,kzak@redhat.com,matt.fleming@intel.com
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 17:21:42 -0700


The patch titled
     Subject: block/partitions/efi.c: consistently use pr_foo()
has been added to the -mm tree.  Its filename is
     block-partitions-efic-consistently-use-pr_foo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-partitions-efic-consistently-use-pr_foo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-partitions-efic-consistently-use-pr_foo.patch

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
Subject: block/partitions/efi.c: consistently use pr_foo()

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Karel Zak <kzak@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |   45 ++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff -puN block/partitions/efi.c~block-partitions-efic-consistently-use-pr_foo block/partitions/efi.c
--- a/block/partitions/efi.c~block-partitions-efic-consistently-use-pr_foo
+++ a/block/partitions/efi.c
@@ -482,44 +482,42 @@ compare_gpts(gpt_header *pgpt, gpt_heade
 	if (!pgpt || !agpt)
 		return;
 	if (le64_to_cpu(pgpt->my_lba) != le64_to_cpu(agpt->alternate_lba)) {
-		printk(KERN_WARNING
-		       "GPT:Primary header LBA != Alt. header alternate_lba\n");
-		printk(KERN_WARNING "GPT:%lld != %lld\n",
+		pr_warn("GPT:Primary header LBA != Alt. header alternate_lba\n");
+		pr_warn("GPT:%lld != %lld\n",
 		       (unsigned long long)le64_to_cpu(pgpt->my_lba),
                        (unsigned long long)le64_to_cpu(agpt->alternate_lba));
 		error_found++;
 	}
 	if (le64_to_cpu(pgpt->alternate_lba) != le64_to_cpu(agpt->my_lba)) {
-		printk(KERN_WARNING
-		       "GPT:Primary header alternate_lba != Alt. header my_lba\n");
-		printk(KERN_WARNING "GPT:%lld != %lld\n",
+		pr_warn("GPT:Primary header alternate_lba != Alt. header my_lba\n");
+		pr_warn("GPT:%lld != %lld\n",
 		       (unsigned long long)le64_to_cpu(pgpt->alternate_lba),
                        (unsigned long long)le64_to_cpu(agpt->my_lba));
 		error_found++;
 	}
 	if (le64_to_cpu(pgpt->first_usable_lba) !=
             le64_to_cpu(agpt->first_usable_lba)) {
-		printk(KERN_WARNING "GPT:first_usable_lbas don't match.\n");
-		printk(KERN_WARNING "GPT:%lld != %lld\n",
+		pr_warn("GPT:first_usable_lbas don't match.\n");
+		pr_warn("GPT:%lld != %lld\n",
 		       (unsigned long long)le64_to_cpu(pgpt->first_usable_lba),
                        (unsigned long long)le64_to_cpu(agpt->first_usable_lba));
 		error_found++;
 	}
 	if (le64_to_cpu(pgpt->last_usable_lba) !=
             le64_to_cpu(agpt->last_usable_lba)) {
-		printk(KERN_WARNING "GPT:last_usable_lbas don't match.\n");
-		printk(KERN_WARNING "GPT:%lld != %lld\n",
+		pr_warn("GPT:last_usable_lbas don't match.\n");
+		pr_warn("GPT:%lld != %lld\n",
 		       (unsigned long long)le64_to_cpu(pgpt->last_usable_lba),
                        (unsigned long long)le64_to_cpu(agpt->last_usable_lba));
 		error_found++;
 	}
 	if (efi_guidcmp(pgpt->disk_guid, agpt->disk_guid)) {
-		printk(KERN_WARNING "GPT:disk_guids don't match.\n");
+		pr_warn("GPT:disk_guids don't match.\n");
 		error_found++;
 	}
 	if (le32_to_cpu(pgpt->num_partition_entries) !=
             le32_to_cpu(agpt->num_partition_entries)) {
-		printk(KERN_WARNING "GPT:num_partition_entries don't match: "
+		pr_warn("GPT:num_partition_entries don't match: "
 		       "0x%x != 0x%x\n",
 		       le32_to_cpu(pgpt->num_partition_entries),
 		       le32_to_cpu(agpt->num_partition_entries));
@@ -527,8 +525,7 @@ compare_gpts(gpt_header *pgpt, gpt_heade
 	}
 	if (le32_to_cpu(pgpt->sizeof_partition_entry) !=
             le32_to_cpu(agpt->sizeof_partition_entry)) {
-		printk(KERN_WARNING
-		       "GPT:sizeof_partition_entry values don't match: "
+		pr_warn("GPT:sizeof_partition_entry values don't match: "
 		       "0x%x != 0x%x\n",
                        le32_to_cpu(pgpt->sizeof_partition_entry),
 		       le32_to_cpu(agpt->sizeof_partition_entry));
@@ -536,34 +533,30 @@ compare_gpts(gpt_header *pgpt, gpt_heade
 	}
 	if (le32_to_cpu(pgpt->partition_entry_array_crc32) !=
             le32_to_cpu(agpt->partition_entry_array_crc32)) {
-		printk(KERN_WARNING
-		       "GPT:partition_entry_array_crc32 values don't match: "
+		pr_warn("GPT:partition_entry_array_crc32 values don't match: "
 		       "0x%x != 0x%x\n",
                        le32_to_cpu(pgpt->partition_entry_array_crc32),
 		       le32_to_cpu(agpt->partition_entry_array_crc32));
 		error_found++;
 	}
 	if (le64_to_cpu(pgpt->alternate_lba) != lastlba) {
-		printk(KERN_WARNING
-		       "GPT:Primary header thinks Alt. header is not at the end of the disk.\n");
-		printk(KERN_WARNING "GPT:%lld != %lld\n",
+		pr_warn("GPT:Primary header thinks Alt. header is not at the end of the disk.\n");
+		pr_warn("GPT:%lld != %lld\n",
 			(unsigned long long)le64_to_cpu(pgpt->alternate_lba),
 			(unsigned long long)lastlba);
 		error_found++;
 	}
 
 	if (le64_to_cpu(agpt->my_lba) != lastlba) {
-		printk(KERN_WARNING
-		       "GPT:Alternate GPT header not at the end of the disk.\n");
-		printk(KERN_WARNING "GPT:%lld != %lld\n",
+		pr_warn("GPT:Alternate GPT header not at the end of the disk.\n");
+		pr_warn("GPT:%lld != %lld\n",
 			(unsigned long long)le64_to_cpu(agpt->my_lba),
 			(unsigned long long)lastlba);
 		error_found++;
 	}
 
 	if (error_found)
-		printk(KERN_WARNING
-		       "GPT: Use GNU Parted to correct GPT errors.\n");
+		pr_warn("GPT: Use GNU Parted to correct GPT errors.\n");
 	return;
 }
 
@@ -636,7 +629,7 @@ static int find_valid_gpt(struct parsed_
                 kfree(agpt);
                 kfree(aptes);
 		if (!good_agpt)
-                        printk(KERN_WARNING "Alternate GPT is invalid, using primary GPT.\n");
+                        pr_warn("Alternate GPT is invalid, using primary GPT.\n");
                 return 1;
         }
         else if (good_agpt) {
@@ -644,7 +637,7 @@ static int find_valid_gpt(struct parsed_
                 *ptes = aptes;
                 kfree(pgpt);
                 kfree(pptes);
-		printk(KERN_WARNING "Primary GPT is invalid, using alternate GPT.\n");
+		pr_warn("Primary GPT is invalid, using alternate GPT.\n");
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

