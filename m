From: akpm@linux-foundation.org
Subject: + git-block-git-rejects.patch added to -mm tree
Date: Sat, 26 Jul 2008 14:05:53 -0700
Message-ID: <200807262105.m6QL5rjs019260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755202AbYGZVF4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:05:56 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m6QL5rWl001047
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2008 14:05:54 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-block-git-rejects
has been added to the -mm tree.  Its filename is
     git-block-git-rejects.patch

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
Subject: git-block-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |   33 ---------------------------------
 1 file changed, 33 deletions(-)

diff -puN fs/splice.c~git-block-git-rejects fs/splice.c
--- a/fs/splice.c~git-block-git-rejects
+++ a/fs/splice.c
@@ -1162,38 +1162,6 @@ static long do_splice(struct file *in, l
 }
 
 /*
-<<<<<<< HEAD:fs/splice.c
-=======
- * Do a copy-from-user while holding the mmap_semaphore for reading, in a
- * manner safe from deadlocking with simultaneous mmap() (grabbing mmap_sem
- * for writing) and page faulting on the user memory pointed to by src.
- * This assumes that we will very rarely hit the partial != 0 path, or this
- * will not be a win.
- */
-static int copy_from_user_mmap_sem(void *dst, const void __user *src, size_t n)
-{
-	int partial;
-
-	if (!access_ok(VERIFY_READ, src, n))
-		return -EFAULT;
-
-	pagefault_disable();
-	partial = __copy_from_user_inatomic(dst, src, n);
-	pagefault_enable();
-
-	/*
-	 * Didn't copy everything, drop the mmap_sem and do a faulting copy
-	 */
-	if (unlikely(partial)) {
-		up_read(&current->mm->mmap_sem);
-		partial = copy_from_user(dst, src, n);
-		down_read(&current->mm->mmap_sem);
-	}
-
-	return partial;
-}
-
-/*
  * Just copy the data to user space
  */
 static int pipe_to_user_copy(struct pipe_inode_info *pipe,
@@ -1413,7 +1381,6 @@ static long vmsplice_to_user(struct file
 }
 
 /*
->>>>>>> FETCH_HEAD:fs/splice.c
  * Map an iov into an array of pages and offset/length tupples. With the
  * partial_page structure, we can map several non-contiguous ranges into
  * our ones pages[] map instead of splitting that operation into pieces.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hugetlb-remove-unused-variable-warning-checkpatch-fixes.patch
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
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
git-block-git-rejects.patch
git-block-ia64-build-fix.patch
git-block-fix-s390-build.patch
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

