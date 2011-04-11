From: akpm@linux-foundation.org
Subject: + fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch added to -mm tree
Date: Mon, 11 Apr 2011 16:18:42 -0700
Message-ID: <201104112318.p3BNIgwZ010130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424Ab1DKXSq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 19:18:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jiaweiwei.xiyou@gmail.com, petr@vandrovec.name


The patch titled
     fs/ncpfs/inode.c: suppress used-uninitialised warning
has been added to the -mm tree.  Its filename is
     fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch

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
+	memset(data, 0, sizeof(data));
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

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes.patch
mm-add-vm-counters-for-transparent-hugepages.patch
drivers-scsi-mpt2sas-mpt2sas_ctlc-fix-unbounded-copy_to_user.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
osst-wrong-index-used-in-inner-loop-checkpatch-fixes.patch
drbd-fix-warning.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-tty-vt-vt_ioctlc-repair-insane-expression.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

