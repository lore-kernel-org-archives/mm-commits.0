From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-video-add-support-for-the-solomon-ssd1307-oled-controller-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 07 Dec 2012 12:28:34 -0800
Message-ID: <20121207202834.A835E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:51768 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424191Ab2LGU2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2012 15:28:35 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so92823yen.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Dec 2012 12:28:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, FlorianSchandinat@gmx.de, brian@crystalfontz.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-video-add-support-for-the-solomon-ssd1307-oled-controller-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     drivers-video-add-support-for-the-solomon-ssd1307-oled-controller-checkpatch-fixes.patch

This patch was dropped because it was folded into drivers-video-add-support-for-the-solomon-ssd1307-oled-controller.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-video-add-support-for-the-solomon-ssd1307-oled-controller-checkpatch-fixes

WARNING: line over 80 characters
#150: FILE: drivers/video/ssd1307fb.c:58:
+static int ssd1307fb_write_array(struct i2c_client *client, u8 type, u8* cmd, u32 len)

ERROR: "foo* bar" should be "foo *bar"
#150: FILE: drivers/video/ssd1307fb.c:58:
+static int ssd1307fb_write_array(struct i2c_client *client, u8 type, u8* cmd, u32 len)

WARNING: line over 80 characters
#175: FILE: drivers/video/ssd1307fb.c:83:
+static inline int ssd1307fb_write_cmd_array(struct i2c_client *client, u8* cmd, u32 len)

ERROR: "foo* bar" should be "foo *bar"
#175: FILE: drivers/video/ssd1307fb.c:83:
+static inline int ssd1307fb_write_cmd_array(struct i2c_client *client, u8* cmd, u32 len)

WARNING: line over 80 characters
#185: FILE: drivers/video/ssd1307fb.c:93:
+static inline int ssd1307fb_write_data_array(struct i2c_client *client, u8* cmd, u32 len)

ERROR: "foo* bar" should be "foo *bar"
#185: FILE: drivers/video/ssd1307fb.c:93:
+static inline int ssd1307fb_write_data_array(struct i2c_client *client, u8* cmd, u32 len)

WARNING: line over 80 characters
#230: FILE: drivers/video/ssd1307fb.c:138:
+		ssd1307fb_write_cmd(par->client, SSD1307FB_START_PAGE_ADDRESS + (i + 1));

WARNING: line over 80 characters
#238: FILE: drivers/video/ssd1307fb.c:146:
+				u32 index = page_length + (SSD1307FB_WIDTH * k + j) / 8;

WARNING: line over 80 characters
#281: FILE: drivers/video/ssd1307fb.c:189:
+static void ssd1307fb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)

WARNING: line over 80 characters
#288: FILE: drivers/video/ssd1307fb.c:196:
+static void ssd1307fb_copyarea(struct fb_info *info, const struct fb_copyarea *area)

WARNING: line over 80 characters
#295: FILE: drivers/video/ssd1307fb.c:203:
+static void ssd1307fb_imageblit(struct fb_info *info, const struct fb_image *image)

WARNING: line over 80 characters
#322: FILE: drivers/video/ssd1307fb.c:230:
+static int __devinit ssd1307fb_probe(struct i2c_client *client, const struct i2c_device_id *id)

WARNING: line over 80 characters
#396: FILE: drivers/video/ssd1307fb.c:304:
+	dev_dbg(&client->dev, "Using PWM%d with a %dns period.\n", par->pwm->pwm, par->pwm_period);

WARNING: line over 80 characters
#430: FILE: drivers/video/ssd1307fb.c:338:
+	dev_info(&client->dev, "fb%d: %s framebuffer device registered, using %d bytes of video memory\n", info->node, info->fix.id, vmem_size);

total: 3 errors, 11 warnings, 446 lines checked

./patches/drivers-video-add-support-for-the-solomon-ssd1307-oled-controller.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Brian Lilly <brian@crystalfontz.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ssd1307fb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/ssd1307fb.c~drivers-video-add-support-for-the-solomon-ssd1307-oled-controller-checkpatch-fixes drivers/video/ssd1307fb.c
--- a/drivers/video/ssd1307fb.c~drivers-video-add-support-for-the-solomon-ssd1307-oled-controller-checkpatch-fixes
+++ a/drivers/video/ssd1307fb.c
@@ -55,7 +55,7 @@ static struct fb_var_screeninfo ssd1307f
 	.bits_per_pixel	= 1,
 };
 
-static int ssd1307fb_write_array(struct i2c_client *client, u8 type, u8* cmd, u32 len)
+static int ssd1307fb_write_array(struct i2c_client *client, u8 type, u8 *cmd, u32 len)
 {
 	u8 *buf;
 	int ret = 0;
@@ -80,7 +80,7 @@ error:
 	return ret;
 }
 
-static inline int ssd1307fb_write_cmd_array(struct i2c_client *client, u8* cmd, u32 len)
+static inline int ssd1307fb_write_cmd_array(struct i2c_client *client, u8 *cmd, u32 len)
 {
 	return ssd1307fb_write_array(client, SSD1307FB_COMMAND, cmd, len);
 }
@@ -90,7 +90,7 @@ static inline int ssd1307fb_write_cmd(st
 	return ssd1307fb_write_cmd_array(client, &cmd, 1);
 }
 
-static inline int ssd1307fb_write_data_array(struct i2c_client *client, u8* cmd, u32 len)
+static inline int ssd1307fb_write_data_array(struct i2c_client *client, u8 *cmd, u32 len)
 {
 	return ssd1307fb_write_array(client, SSD1307FB_DATA, cmd, len);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
drivers-video-add-support-for-the-solomon-ssd1307-oled-controller.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
irq-tsk-comm-is-an-array.patch
block-remove-deadlock-in-disk_clear_events-fix.patch
block-prevent-race-cleanup-fix.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
slub-slub-specific-propagation-changes-fix.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
thp-implement-splitting-pmd-for-huge-zero-page-fix.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
mm-introduce-new-field-managed_pages-to-struct-zone-fix.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
tmpfs-support-seek_data-and-seek_hole-reprise.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
pnpacpi-fix-incorrect-test_alpha-test.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

