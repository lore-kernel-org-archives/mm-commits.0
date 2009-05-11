From: akpm@linux-foundation.org
Subject: + lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-checkpatch-fixes.patch added to -mm tree
Date: Mon, 11 May 2009 15:01:03 -0700
Message-ID: <200905112201.n4BM13lt023851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097AbZEKWDP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 18:03:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux-foundation.org, nickpiggin@yahoo.com.au, shijie8@gmail.com


The patch titled
     lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-checkpatch-fixes.patch

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
Subject: lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo * bar" should be "foo *bar"
#48: FILE: lib/radix-tree.c:358:
+static void * radix_tree_lookup_element(struct radix_tree_root *root,

ERROR: spaces prohibited around that ':' (ctx:WxW)
#67: FILE: lib/radix-tree.c:392:
+	return is_slot ? (void *)slot : node;
 	                              ^

ERROR: "(foo**)" should be "(foo **)"
#85: FILE: lib/radix-tree.c:410:
+	return (void**)radix_tree_lookup_element(root, index, 1);

total: 3 errors, 0 warnings, 98 lines checked

./patches/lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Huang Shijie <shijie8@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/radix-tree.c~lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-checkpatch-fixes lib/radix-tree.c
--- a/lib/radix-tree.c~lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-checkpatch-fixes
+++ a/lib/radix-tree.c
@@ -355,7 +355,7 @@ EXPORT_SYMBOL(radix_tree_insert);
  * is_slot == 1 : search for the slot.
  * is_slot == 0 : search for the node.
  */
-static void * radix_tree_lookup_element(struct radix_tree_root *root,
+static void *radix_tree_lookup_element(struct radix_tree_root *root,
 					unsigned long index, int is_slot)
 {
 	unsigned int height, shift;
@@ -407,7 +407,7 @@ static void * radix_tree_lookup_element(
  */
 void **radix_tree_lookup_slot(struct radix_tree_root *root, unsigned long index)
 {
-	return (void**)radix_tree_lookup_element(root, index, 1);
+	return (void **)radix_tree_lookup_element(root, index, 1);
 }
 EXPORT_SYMBOL(radix_tree_lookup_slot);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
alpha-unbreak-percpu-again.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
fs-sysfs-filec-use-create_singlethread_workqueue.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-madvisec-dont-open-code-is_vm_hugetlb_page.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-checkpatch-fixes.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
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

