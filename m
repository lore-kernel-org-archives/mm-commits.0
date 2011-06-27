From: akpm@linux-foundation.org
Subject: + mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-fix.patch added to -mm tree
Date: Mon, 27 Jun 2011 12:53:56 -0700
Message-ID: <201106271953.p5RJrvkO022902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753978Ab1F0Tye (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jun 2011 15:54:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jack@suse.cz, jinshan.xiong@whamcloud.com, mszeredi@suse.de


The patch titled
     mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-fix
has been added to the -mm tree.  Its filename is
     mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-fix.patch

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
Subject: mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-fix
From: Andrew Morton <akpm@linux-foundation.org>

take tree_lock in irq-safe manner

Cc: Jan Kara <jack@suse.cz>
Cc: Jay <jinshan.xiong@whamcloud.com>
Cc: Miklos Szeredi <mszeredi@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/inode.c~mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-fix fs/inode.c
--- a/fs/inode.c~mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-fix
+++ a/fs/inode.c
@@ -428,9 +428,9 @@ void end_writeback(struct inode *inode)
 	 * process of removing the last page (in __delete_from_page_cache())
 	 * and we must not free mapping under it.
 	 */
-	spin_lock(&inode->i_data.tree_lock);
+	spin_lock_irq(&inode->i_data.tree_lock);
 	BUG_ON(inode->i_data.nrpages);
-	spin_unlock(&inode->i_data.tree_lock);
+	spin_unlock_irq(&inode->i_data.tree_lock);
 	BUG_ON(!list_empty(&inode->i_data.private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback-fix.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
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
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages.patch
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

