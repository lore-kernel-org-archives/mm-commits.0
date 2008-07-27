From: akpm@linux-foundation.org
Subject: + mmu-notifiers-add-mm_take_all_locks-operation-fix.patch added to -mm tree
Date: Sun, 27 Jul 2008 02:38:29 -0700
Message-ID: <200807270938.m6R9cTjd012660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbYG0Jk0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 05:40:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, aliguori@us.ibm.com, andrea@qumranet.com, avi@qumranet.com, chrisw@redhat.com, cl@linux-foundation.org, dada1@cosmosbay.com, holt@sgi.com, hugh@veritas.com, izike@qumranet.com, kanojsarcar@yahoo.com, marcelo@kvack.org, npiggin@suse.de, paulmck@us.ibm.com, rdreier@cisco.com, riel@redhat.com, rusty@rustcorp.com.au, steiner@sgi.com, swise@opengridcomputing.com, torvalds@linux-foundation.org


The patch titled
     mmu-notifiers-add-mm_take_all_locks-operation-fix
has been added to the -mm tree.  Its filename is
     mmu-notifiers-add-mm_take_all_locks-operation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmu-notifiers-add-mm_take_all_locks-operation-fix
From: Andrew Morton <akpm@linux-foundation.org>

yes?

Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>
Cc: Anthony Liguori <aliguori@us.ibm.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Izik Eidus <izike@qumranet.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Kanoj Sarcar <kanojsarcar@yahoo.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marcelo Tosatti <marcelo@kvack.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mmu-notifiers-add-mm_take_all_locks-operation-fix mm/mmap.c
--- a/mm/mmap.c~mmu-notifiers-add-mm_take_all_locks-operation-fix
+++ a/mm/mmap.c
@@ -2340,7 +2340,7 @@ static void vm_lock_mapping(struct addre
  * against a concurrent mm_take_all_locks() by the mm_all_locks_mutex.
  *
  * mm_take_all_locks() and mm_drop_all_locks are expensive operations
- * that may have to take thousand of locks.
+ * that may have to take thousandw of locks.
  *
  * mm_take_all_locks() can fail if it's interrupted by signals.
  */
@@ -2349,7 +2349,7 @@ int mm_take_all_locks(struct mm_struct *
 	struct vm_area_struct *vma;
 	int ret = -EINTR;
 
-	BUG_ON(down_read_trylock(&mm->mmap_sem));
+	BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
 
 	mutex_lock(&mm_all_locks_mutex);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hugetlb-remove-unused-variable-warning.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
linux-next-fixups.patch
linux-next-rejects.patch
next-remove-localversion.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
pci-make-pci_register_driver-a-macro.patch
x86-pci-replace-dbg-with-pr_debug-fix.patch
x86-pci-replace-dbg-with-pr_debug-fix-2.patch
include-asm-generic-pgtable-nopmdh-macros-are-noxious-reason-435.patch
arch-x86-pci-i386c-fix-printk-warnings.patch
drm-fix-sparc64-build.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-jg-misc.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-ubi-git-rejects.patch
bridge-send-correct-mtu-value-in-pmtu-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
kernel-trace-tracec-remove-unused-variable.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
drivers-net-wireless-iwlwifi-iwl-ledc-printk-fix.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
ftrace-disable-function-tracing-bringing-up-new-cpu-fix.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifiers-add-mm_take_all_locks-operation-fix.patch
mmu-notifier-core.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
gru-driver-v3-hardware-data-structures-fix.patch
gru-driver-v3-hardware-data-structures-fix-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
define-page_file_cache-function-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-units-fix.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-page-statistics-units-fix.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
introduce-__get_user_pages-fix.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

