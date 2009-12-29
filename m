From: akpm@linux-foundation.org
Subject: [merged] fs-ext4-superc-fix-printk-warning.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:32:22 -0800
Message-ID: <200912292132.nBTLWMT8008624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752753AbZL2VcZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:32:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     fs/ext4/super.c: fix printk warning
has been removed from the -mm tree.  Its filename was
     fs-ext4-superc-fix-printk-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ext4/super.c: fix printk warning
From: Andrew Morton <akpm@linux-foundation.org>

sparc64 allmodconfig:

fs/ext4/super.c: In function `lifetime_write_kbytes_show':
fs/ext4/super.c:2174: warning: long long unsigned int format, long unsigned int arg (arg 4)
fs/ext4/super.c:2174: warning: long long unsigned int format, long unsigned int arg (arg 4)

Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext4/super.c~fs-ext4-superc-fix-printk-warning fs/ext4/super.c
--- a/fs/ext4/super.c~fs-ext4-superc-fix-printk-warning
+++ a/fs/ext4/super.c
@@ -2174,9 +2174,9 @@ static ssize_t lifetime_write_kbytes_sho
 	struct super_block *sb = sbi->s_buddy_cache->i_sb;
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n",
-			sbi->s_kbytes_written + 
+			(unsigned long long)(sbi->s_kbytes_written +
 			((part_stat_read(sb->s_bdev->bd_part, sectors[1]) -
-			  EXT4_SB(sb)->s_sectors_written_start) >> 1));
+			  EXT4_SB(sb)->s_sectors_written_start) >> 1)));
 }
 
 static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
linux-next.patch
linux-next-fixup.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
hid-logitech-g13-driver-002-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
net-sctp-socketc-squish-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
3x59x-fix-pci-resource-management.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

