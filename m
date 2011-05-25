From: akpm@linux-foundation.org
Subject: [merged] fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch removed from -mm tree
Date: Wed, 25 May 2011 13:32:32 -0700
Message-ID: <201105252030.p4PKUtGT015008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932313Ab1EYUb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:31:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jiaweiwei.xiyou@gmail.com, petr@vandrovec.name, mm-commits@vger.kernel.org


The patch titled
     fs/ncpfs/inode.c: suppress used-uninitialised warning
has been removed from the -mm tree.  Its filename was
     fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ncpfs/inode.c: suppress used-uninitialised warning
From: Andrew Morton <akpm@linux-foundation.org>

fs/ncpfs/inode.c: In function 'ncp_fill_super':
fs/ncpfs/inode.c:451: warning: 'data.mounted_vol[1u]' may be used uninitialized in this function
fs/ncpfs/inode.c:451: warning: 'data.mounted_vol[2u]' may be used uninitialized in this function
fs/ncpfs/inode.c:451: warning: 'data.mounted_vol[3u]' may be used uninitialized in this function
...

It's notabug, but we can easily fix it with a memset().

Reported-by: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/ncpfs/inode.c~fs-ncpfs-inodec-suppress-used-uninitialised-warning fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~fs-ncpfs-inodec-suppress-used-uninitialised-warning
+++ a/fs/ncpfs/inode.c
@@ -461,7 +461,7 @@ static int ncp_fill_super(struct super_b
 #endif
 	struct ncp_entry_info finfo;
 
-	data.wdog_pid = NULL;
+	memset(&data, 0, sizeof(data));
 	server = kzalloc(sizeof(struct ncp_server), GFP_KERNEL);
 	if (!server)
 		return -ENOMEM;
@@ -496,7 +496,6 @@ static int ncp_fill_super(struct super_b
 				struct ncp_mount_data_v4* md = (struct ncp_mount_data_v4*)raw_data;
 
 				data.flags = md->flags;
-				data.int_flags = 0;
 				data.mounted_uid = md->mounted_uid;
 				data.wdog_pid = find_get_pid(md->wdog_pid);
 				data.ncp_fd = md->ncp_fd;
@@ -507,7 +506,6 @@ static int ncp_fill_super(struct super_b
 				data.file_mode = md->file_mode;
 				data.dir_mode = md->dir_mode;
 				data.info_fd = -1;
-				data.mounted_vol[0] = 0;
 			}
 			break;
 		default:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
backlight-add-backlight-type-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-m68k-merge-mmu-and-non-mmu-bitopsh.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
mtd-convert-to-seq_file-interface.patch
rfcomm-corec-avoid-dangling-pointer-check-session-exists-checkpatch-fixes.patch
drivers-bcma-host_pcic-needs-slabh.patch
slab-use-numa_no_node.patch
mm.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix-checkpatch-fixes.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
add-the-pagefault-count-into-memcg-stats.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

