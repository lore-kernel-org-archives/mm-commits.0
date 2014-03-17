From: akpm@linux-foundation.org
Subject: + befs-logging-clean-up-fix.patch added to -mm tree
Date: Mon, 17 Mar 2014 12:30:17 -0700
Message-ID: <53274d49.I5/7H4OdcXl2SFK/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaCQTaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Mar 2014 15:30:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, fengguang.wu@gmail.com, fabf@skynet.be, akpm@linux-foundation.org

Subject: + befs-logging-clean-up-fix.patch added to -mm tree
To: akpm@linux-foundation.org,fabf@skynet.be,fengguang.wu@gmail.com,joe@perches.com
From: akpm@linux-foundation.org
Date: Mon, 17 Mar 2014 12:30:17 -0700


The patch titled
     Subject: befs-logging-clean-up-fix
has been added to the -mm tree.  Its filename is
     befs-logging-clean-up-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/befs-logging-clean-up-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/befs-logging-clean-up-fix.patch

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
Subject: befs-logging-clean-up-fix

fix printk warnings, reported by Fengguang

Cc: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Cc: Fengguang Wu <fengguang.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/btree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/befs/btree.c~befs-logging-clean-up-fix fs/befs/btree.c
--- a/fs/befs/btree.c~befs-logging-clean-up-fix
+++ a/fs/befs/btree.c
@@ -263,7 +263,7 @@ befs_btree_find(struct super_block *sb,
 	this_node = kmalloc(sizeof (befs_btree_node),
 						GFP_NOFS);
 	if (!this_node) {
-		befs_error(sb, "befs_btree_find() failed to allocate %u "
+		befs_error(sb, "befs_btree_find() failed to allocate %zu "
 			   "bytes of memory", sizeof (befs_btree_node));
 		goto error;
 	}
@@ -437,7 +437,7 @@ befs_btree_read(struct super_block *sb,
 	}
 
 	if ((this_node = kmalloc(sizeof (befs_btree_node), GFP_NOFS)) == NULL) {
-		befs_error(sb, "befs_btree_read() failed to allocate %u "
+		befs_error(sb, "befs_btree_read() failed to allocate %zu "
 			   "bytes of memory", sizeof (befs_btree_node));
 		goto error;
 	}
@@ -498,7 +498,7 @@ befs_btree_read(struct super_block *sb,
 		   (int)keylen);
 
 	if (bufsize < keylen + 1) {
-		befs_error(sb, "%s keybuf too small (%u) "
+		befs_error(sb, "%s keybuf too small (%zu) "
 			   "for key of size %d", __func__, bufsize, keylen);
 		brelse(this_node->bh);
 		goto error_alloc;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-3.patch
mm-per-thread-vma-caching-fix-5.patch
mm-per-thread-vma-caching-fix-6-checkpatch-fixes.patch
mm-per-thread-vma-caching-fix-6-fix.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-vmalloc-avoid-soft-lockup-warnings-when-vunmaping-large-ranges-fix.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-propagate-error-to-user-fix.patch
zram-support-req_discard-v4-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
befs-logging-clean-up-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

