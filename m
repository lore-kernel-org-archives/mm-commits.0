From: akpm@linux-foundation.org
Subject: + fs-inodec-optimize-expensive-assertion-in-end_writeback.patch added to -mm tree
Date: Wed, 29 Jun 2011 14:40:44 -0700
Message-ID: <201106292140.p5TLeiIB013651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753951Ab1F2VlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 17:41:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jack@suse.cz


The patch titled
     fs/inode.c: optimize expensive assertion in end_writeback()
has been added to the -mm tree.  Its filename is
     fs-inodec-optimize-expensive-assertion-in-end_writeback.patch

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
Subject: fs/inode.c: optimize expensive assertion in end_writeback()
From: Andrew Morton <akpm@linux-foundation.org>

Taking spin_lock_irq() just to run BUG_ON() is a pretty sad use of CPU
cycles.  Speed this up by only taking the lock if it looks like the
BUG_ON() will be triggering.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN fs/inode.c~fs-inodec-optimize-expensive-assertion-in-end_writeback fs/inode.c
--- a/fs/inode.c~fs-inodec-optimize-expensive-assertion-in-end_writeback
+++ a/fs/inode.c
@@ -422,14 +422,18 @@ EXPORT_SYMBOL(remove_inode_hash);
 void end_writeback(struct inode *inode)
 {
 	might_sleep();
-	/*
-	 * We have to cycle tree_lock here because reclaim can be still in the
-	 * process of removing the last page (in __delete_from_page_cache())
-	 * and we must not free mapping under it.
-	 */
-	spin_lock_irq(&inode->i_data.tree_lock);
-	BUG_ON(inode->i_data.nrpages);
-	spin_unlock_irq(&inode->i_data.tree_lock);
+
+	if (unlikely(inode->i_data.nrpages)) {
+		/*
+		 * We have to cycle tree_lock here because reclaim can be still
+		 * in the process of removing the last page (in
+		 * __delete_from_page_cache()) and we must not free mapping
+		 * under it.
+		 */
+		spin_lock_irq(&inode->i_data.tree_lock);
+		BUG_ON(inode->i_data.nrpages);
+		spin_unlock_irq(&inode->i_data.tree_lock);
+	}
 	BUG_ON(!list_empty(&inode->i_data.private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memcg-fix-reclaimable-lru-check-in-memcg-checkpatch-fixes.patch
memcg-fix-reclaimable-lru-check-in-memcg-fix.patch
memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event-fix.patch
mm-preallocate-page-before-lock_page-at-filemap-cow-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-gma500-psb_intel_displayc-fix-build.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
mm-memoryc-remove-zap_block_size.patch
fs-inodec-optimize-expensive-assertion-in-end_writeback.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

