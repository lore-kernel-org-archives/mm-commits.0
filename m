From: akpm@linux-foundation.org
Subject: [merged] fs-fat-filec-fix-clearing-of-s_immutable.patch removed from -mm tree
Date: Tue, 07 Jun 2011 13:18:30 -0700
Message-ID: <201106072017.p57KHRVd024493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755425Ab1FGURf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 16:17:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dimondmm@yandex.ru, hch@lst.de, hirofumi@mail.parknet.co.jp, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fs/fat/file.c: fix clearing of S_IMMUTABLE
has been removed from the -mm tree.  Its filename was
     fs-fat-filec-fix-clearing-of-s_immutable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/fat/file.c: fix clearing of S_IMMUTABLE
From: Andrew Morton <akpm@linux-foundation.org>

Inode flags are corrupted when removing ATTR_SYS flag by
FAT_IOCTL_SET_ATTRIBUTES ioctl on fat file system mounted with
`sys_immutable' mount option.

Fix fat-fingered bitop from 21bea495943f9532 ("fat: split
fat_generic_ioctl").

Reported-by: Dmitry Dmitriev <dimondmm@yandex.ru>
Cc: Cristoph Hellwig <hch@lst.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fat/file.c~fs-fat-filec-fix-clearing-of-s_immutable fs/fat/file.c
--- a/fs/fat/file.c~fs-fat-filec-fix-clearing-of-s_immutable
+++ a/fs/fat/file.c
@@ -102,7 +102,7 @@ static int fat_ioctl_set_attributes(stru
 		if (attr & ATTR_SYS)
 			inode->i_flags |= S_IMMUTABLE;
 		else
-			inode->i_flags &= S_IMMUTABLE;
+			inode->i_flags &= ~S_IMMUTABLE;
 	}
 
 	fat_save_attrs(inode, attr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

backlight-add-backlight-type-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
writeback-sync-expired-inodes-first-in-background-writeback.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

