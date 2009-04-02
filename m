From: akpm@linux-foundation.org
Subject: [folded] ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch removed from -mm tree
Date: Thu, 02 Apr 2009 16:16:00 -0700
Message-ID: <200904022316.n32NG0Gq009706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761720AbZDBXSS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 19:18:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tytso@mit.edu, yjwei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix
has been removed from the -mm tree.  Its filename was
     ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch

This patch was dropped because it was folded into ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix
From: Andrew Morton <akpm@linux-foundation.org>

- fix up coding-style glitches while we're there (checkpatch!!)

- rename `size' to `blocksize'.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN fs/ext3/namei.c~ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix
+++ a/fs/ext3/namei.c
@@ -161,12 +161,12 @@ static struct dx_frame *dx_probe(struct 
 				 struct dx_frame *frame,
 				 int *err);
 static void dx_release (struct dx_frame *frames);
-static int dx_make_map (struct ext3_dir_entry_2 *de, unsigned size,
+static int dx_make_map(struct ext3_dir_entry_2 *de, unsigned blocksize,
 			struct dx_hash_info *hinfo, struct dx_map_entry map[]);
 static void dx_sort_map(struct dx_map_entry *map, unsigned count);
 static struct ext3_dir_entry_2 *dx_move_dirents (char *from, char *to,
 		struct dx_map_entry *offsets, int count);
-static struct ext3_dir_entry_2* dx_pack_dirents (char *base, unsigned size);
+static struct ext3_dir_entry_2 *dx_pack_dirents(char *base, unsigned blocksize);
 static void dx_insert_block (struct dx_frame *frame, u32 hash, u32 block);
 static int ext3_htree_next_block(struct inode *dir, __u32 hash,
 				 struct dx_frame *frame,
@@ -708,14 +708,14 @@ errout:
  * Create map of hash values, offsets, and sizes, stored at end of block.
  * Returns number of entries mapped.
  */
-static int dx_make_map (struct ext3_dir_entry_2 *de, unsigned size,
-			struct dx_hash_info *hinfo, struct dx_map_entry *map_tail)
+static int dx_make_map(struct ext3_dir_entry_2 *de, unsigned blocksize,
+		struct dx_hash_info *hinfo, struct dx_map_entry *map_tail)
 {
 	int count = 0;
 	char *base = (char *) de;
 	struct dx_hash_info h = *hinfo;
 
-	while ((char *) de < base + size)
+	while ((char *) de < base + blocksize)
 	{
 		if (de->name_len && de->inode) {
 			ext3fs_dirhash(de->name, de->name_len, &h);
@@ -1120,13 +1120,14 @@ dx_move_dirents(char *from, char *to, st
  * Compact each dir entry in the range to the minimal rec_len.
  * Returns pointer to last entry in range.
  */
-static struct ext3_dir_entry_2* dx_pack_dirents(char *base, unsigned size)
+static struct ext3_dir_entry_2 *dx_pack_dirents(char *base, unsigned blocksize)
 {
-	struct ext3_dir_entry_2 *next, *to, *prev, *de = (struct ext3_dir_entry_2 *) base;
+	struct ext3_dir_entry_2 *next, *to, *prev;
+	struct ext3_dir_entry_2 *de = (struct ext3_dir_entry_2 *)base;
 	unsigned rec_len = 0;
 
 	prev = to = de;
-	while ((char*)de < base + size) {
+	while ((char*)de < base + blocksize) {
 		next = ext3_next_entry(de);
 		if (de->inode && de->name_len) {
 			rec_len = EXT3_DIR_REC_LEN(de->name_len);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
workqueue-add-to_delayed_work-helper-function.patch
simplify-copy_thread.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix-checkpatch-fixes.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
arch-x86-mm-iomap_32c-fix-warning.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
leds-add-bd2802gu-led-driver.patch
flex-onenand-support-v2-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
xtensa-add-flat-support-checkpatch-fixes.patch
max3100-spi-uart-driver-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
kernel-auditscc-fix-warning.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
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
page-owner-tracking.patch
page-owner-tracking-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

