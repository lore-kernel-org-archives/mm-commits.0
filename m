From: akpm@linux-foundation.org
Subject: +
 partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch added to -mm tree
Date: Mon, 20 May 2013 16:45:19 -0700
Message-ID: <519ab58f.qZk/vg8VrYA4MhrH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab3ETXpU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 19:45:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, phdm@macqel.be, akpm@linux-foundation.org

Subject: + partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,phdm@macqel.be
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 16:45:19 -0700


The patch titled
     Subject: partitions-add-aix-lvm-partition-support-files-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch

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
Subject: partitions-add-aix-lvm-partition-support-files-checkpatch-fixes

WARNING: line over 80 characters
#119: FILE: block/partitions/aix.c:95:
+static size_t read_lba(struct parsed_partitions *state, u64 lba, u8 * buffer, size_t count)

ERROR: "foo * bar" should be "foo *bar"
#119: FILE: block/partitions/aix.c:95:
+static size_t read_lba(struct parsed_partitions *state, u64 lba, u8 * buffer, size_t count)

ERROR: code indent should use tabs where possible
#124: FILE: block/partitions/aix.c:100:
+                return 0;$

WARNING: please, no spaces at the start of a line
#124: FILE: block/partitions/aix.c:100:
+                return 0;$

WARNING: Avoid CamelCase: <Sector>
#128: FILE: block/partitions/aix.c:104:
+		Sector sect;

ERROR: spaces required around that '+=' (ctx:WxV)
#137: FILE: block/partitions/aix.c:113:
+		totalreadcount +=copied;
 		               ^

ERROR: do not use assignment in if condition
#235: FILE: block/partitions/aix.c:211:
+	if (vgda_sector && (d = read_part_sector(state, vgda_sector, &sect))) {

ERROR: do not use assignment in if condition
#244: FILE: block/partitions/aix.c:220:
+	if (numlvs && (d = read_part_sector(state, vgda_sector + 1, &sect))) {

WARNING: line over 80 characters
#252: FILE: block/partitions/aix.c:228:
+			for (i = 0; foundlvs < numlvs && i < state->limit; i += 1) {

WARNING: line over 80 characters
#294: FILE: block/partitions/aix.c:270:
+					(i + 1 - lp_ix) * pp_blocks_size + psn_part1,

WARNING: line over 80 characters
#295: FILE: block/partitions/aix.c:271:
+					lvip[lv_ix].pps_per_lv * pp_blocks_size);

WARNING: line over 80 characters
#296: FILE: block/partitions/aix.c:272:
+				snprintf(tmp, sizeof(tmp), " <%s>\n", n[lv_ix].name);

WARNING: printk() should include KERN_ facility level
#306: FILE: block/partitions/aix.c:282:
+				printk("partition %s (%u pp's found) is not contiguous\n",

WARNING: kfree(NULL) is safe this check is probably not required
#311: FILE: block/partitions/aix.c:287:
+	if (n)
+		kfree(n);

total: 5 errors, 9 warnings, 291 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/partitions-add-aix-lvm-partition-support-files.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/aix.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN block/partitions/aix.c~partitions-add-aix-lvm-partition-support-files-checkpatch-fixes block/partitions/aix.c
--- a/block/partitions/aix.c~partitions-add-aix-lvm-partition-support-files-checkpatch-fixes
+++ a/block/partitions/aix.c
@@ -92,12 +92,13 @@ static u64 last_lba(struct block_device
  * Description:  Reads @count bytes from @state->bdev into @buffer.
  * Returns number of bytes read on success, 0 on error.
  */
-static size_t read_lba(struct parsed_partitions *state, u64 lba, u8 * buffer, size_t count)
+static size_t read_lba(struct parsed_partitions *state, u64 lba, u8 *buffer,
+			size_t count)
 {
 	size_t totalreadcount = 0;
 
 	if (!buffer || lba + count / 512 > last_lba(state->bdev))
-                return 0;
+		return 0;
 
 	while (count) {
 		int copied = 512;
@@ -110,7 +111,7 @@ static size_t read_lba(struct parsed_par
 		memcpy(buffer, data, copied);
 		put_dev_sector(sect);
 		buffer += copied;
-		totalreadcount +=copied;
+		totalreadcount += copied;
 		count -= copied;
 	}
 	return totalreadcount;
@@ -267,9 +268,10 @@ int aix_partition(struct parsed_partitio
 				char tmp[70];
 
 				put_partition(state, lv_ix + 1,
-					(i + 1 - lp_ix) * pp_blocks_size + psn_part1,
-					lvip[lv_ix].pps_per_lv * pp_blocks_size);
-				snprintf(tmp, sizeof(tmp), " <%s>\n", n[lv_ix].name);
+				  (i + 1 - lp_ix) * pp_blocks_size + psn_part1,
+				  lvip[lv_ix].pps_per_lv * pp_blocks_size);
+				snprintf(tmp, sizeof(tmp), " <%s>\n",
+					 n[lv_ix].name);
 				strlcat(state->pp_buf, tmp, PAGE_SIZE);
 				lvip[lv_ix].lv_is_contiguous = 1;
 				ret = 1;
@@ -279,12 +281,12 @@ int aix_partition(struct parsed_partitio
 		}
 		for (i = 0; i < state->limit; i += 1)
 			if (lvip[i].pps_found && !lvip[i].lv_is_contiguous)
-				printk("partition %s (%u pp's found) is not contiguous\n",
+				pr_warn("partition %s (%u pp's found) is "
+					"not contiguous\n",
 					n[i].name, lvip[i].pps_found);
 		kfree(pvd);
 	}
-	if (n)
-		kfree(n);
+	kfree(n);
 	kfree(lvip);
 	return ret;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
revert-selftest-add-simple-test-for-soft-dirty-bit.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
generic-dynamic-per-cpu-refcounting.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-prep-work-for-batch-completion-fix-4.patch
block-prep-work-for-batch-completion-fix-101.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

