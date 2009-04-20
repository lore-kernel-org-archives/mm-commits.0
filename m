From: akpm@linux-foundation.org
Subject: + ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch added to -mm tree
Date: Mon, 20 Apr 2009 16:34:30 -0700
Message-ID: <200904202334.n3KNYU7S003762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbZDTXsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Apr 2009 19:48:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, hugh@veritas.com, ieidus@redhat.com, nickpiggin@yahoo.com.au


The patch titled
     ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch

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
Subject: ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: Use #include <linux/types.h> instead of <asm/types.h>
#54: FILE: include/linux/ksm.h:11:
+#include <asm/types.h>

ERROR: code indent should use tabs where possible
#65: FILE: include/linux/ksm.h:22:
+        __u64 reserved_bits;$

WARNING: line over 80 characters
#305: FILE: mm/ksm.c:175:
+ * slots_lock protects against removing and adding memory regions while a scanner

WARNING: braces {} are not necessary for single statement blocks
#485: FILE: mm/ksm.c:355:
+		if (mm == rmap_item->mm && rmap_item->address == addr) {
+			return rmap_item;
+		}

ERROR: code indent should use tabs where possible
#522: FILE: mm/ksm.c:392:
+^I ^I^Iif (!rmap_item->next && !rmap_item->prev) {$

WARNING: braces {} are not necessary for any arm of this statement
#857: FILE: mm/ksm.c:727:
+		if (ret) {
[...]
+		} else {
[...]

total: 2 errors, 4 warnings, 1746 lines checked

./patches/ksm-add-ksm-kernel-shared-memory-driver.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |    2 +-
 mm/ksm.c            |   14 ++++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff -puN include/linux/ksm.h~ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes include/linux/ksm.h
--- a/include/linux/ksm.h~ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes
+++ a/include/linux/ksm.h
@@ -19,7 +19,7 @@ struct ksm_memory_region {
 	__u32 npages; /* number of pages to share */
 	__u32 pad;
 	__u64 addr; /* the begining of the virtual address */
-        __u64 reserved_bits;
+	__u64 reserved_bits;
 };
 
 #define KSMIO 0xAB
diff -puN mm/ksm.c~ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes mm/ksm.c
--- a/mm/ksm.c~ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes
+++ a/mm/ksm.c
@@ -172,8 +172,8 @@ struct rmap_item {
  */
 static LIST_HEAD(slots);
 /*
- * slots_lock protects against removing and adding memory regions while a scanner
- * is in the middle of scanning.
+ * slots_lock protects against removing and adding memory regions while a
+ * scanner is in the middle of scanning.
  */
 static DECLARE_RWSEM(slots_lock);
 
@@ -352,9 +352,8 @@ static struct rmap_item *get_rmap_item(s
 
 	bucket = &rmap_hash[addr % nrmaps_hash];
 	hlist_for_each_entry(rmap_item, node, bucket, link) {
-		if (mm == rmap_item->mm && rmap_item->address == addr) {
+		if (mm == rmap_item->mm && rmap_item->address == addr)
 			return rmap_item;
-		}
 	}
 	return NULL;
 }
@@ -389,7 +388,7 @@ static void remove_rmap_item_from_tree(s
 
 	if (tree_item) {
 		if (rmap_item->stable_tree) {
-	 		if (!rmap_item->next && !rmap_item->prev) {
+			if (!rmap_item->next && !rmap_item->prev) {
 				rb_erase(&tree_item->node, &root_stable_tree);
 				free_tree_item(tree_item);
 				nnodes_stable_tree--;
@@ -724,11 +723,10 @@ static int try_to_merge_two_pages_alloc(
 		 * just one pte pointing to it, in this case we break
 		 * it.
 		 */
-		if (ret) {
+		if (ret)
 			break_cow(mm1, addr1);
-		} else {
+		else
 			ksm_pages_shared += 2;
-		}
 	}
 
 	put_page(kpage);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix.patch
clocksource-pass-clocksource-to-read-callback.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

