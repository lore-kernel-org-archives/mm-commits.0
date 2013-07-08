From: akpm@linux-foundation.org
Subject: [folded-merged]
 partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 15:32:21 -0700
Message-ID: <51db3df5.XNEhbteUdTIieRYV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab3GHWcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:32:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, phdm@macqel.be, akpm@linux-foundation.org

Subject: [folded-merged] partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,phdm@macqel.be,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:32:21 -0700


The patch titled
     Subject: partitions-add-aix-lvm-partition-support-files-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch

This patch was dropped because it was folded into partitions-add-aix-lvm-partition-support-files.patch

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
@@ -268,9 +269,10 @@ int aix_partition(struct parsed_partitio
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
@@ -280,12 +282,12 @@ int aix_partition(struct parsed_partitio
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
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
memcg-use-css_get-put-when-charging-uncharging-kmem.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch
partitions-add-aix-lvm-partition-support-files.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch

