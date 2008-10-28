From: akpm@linux-foundation.org
Subject: - add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix.patch removed from -mm tree
Date: Tue, 28 Oct 2008 13:36:20 -0700
Message-ID: <200810282036.m9SKaK47021795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752829AbYJ1UhK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 16:37:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, agust@denx.de, avorontsov@ru.mvista.com, dbaryshkov@gmail.com, krzysztof.h1@poczta.fm, m.fortini@selcomgroup.com, mm-commits@vger.kernel.org


The patch titled
     add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix
has been removed from the -mm tree.  Its filename was
     add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/video/mb862xx/mb862xxfb.h:65:2: error: #error "Select Lime GDC or CoralP/Carmine support, but not both together"
drivers/video/mb862xx/mb862xxfb.c:549: warning: 'struct of_device' declared inside parameter list
drivers/video/mb862xx/mb862xxfb.c:549: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/video/mb862xx/mb862xxfb.c: In function 'of_platform_mb862xx_probe':
drivers/video/mb862xx/mb862xxfb.c:551: error: dereferencing pointer to incomplete type
drivers/video/mb862xx/mb862xxfb.c:552: error: dereferencing pointer to incomplete type
drivers/video/mb862xx/mb862xxfb.c:559: error: implicit declaration of function 'of_address_to_resource'
drivers/video/mb862xx/mb862xxfb.c:574: error: implicit declaration of function 'irq_of_parse_and_map'
drivers/video/mb862xx/mb862xxfb.c:575: error: 'NO_IRQ' undeclared (first use in this function)
drivers/video/mb862xx/mb862xxfb.c:575: error: (Each undeclared identifier is reported only once
drivers/video/mb862xx/mb862xxfb.c:575: error: for each function it appears in.)
drivers/video/mb862xx/mb862xxfb.c:664: error: implicit declaration of function 'irq_dispose_mapping'
drivers/video/mb862xx/mb862xxfb.c: At top level:
drivers/video/mb862xx/mb862xxfb.c:671: warning: 'struct of_device' declared inside parameter list
drivers/video/mb862xx/mb862xxfb.c: In function 'of_platform_mb862xx_remove':
drivers/video/mb862xx/mb862xxfb.c:673: error: dereferencing pointer to incomplete type
drivers/video/mb862xx/mb862xxfb.c:691: error: dereferencing pointer to incomplete type
drivers/video/mb862xx/mb862xxfb.c:699: error: dereferencing pointer to incomplete type
drivers/video/mb862xx/mb862xxfb.c: At top level:
drivers/video/mb862xx/mb862xxfb.c:719: error: variable 'of_platform_mb862xxfb_driver' has initializer but incomplete type
drivers/video/mb862xx/mb862xxfb.c:720: error: unknown field 'owner' specified in initializer
drivers/video/mb862xx/mb862xxfb.c:720: warning: excess elements in struct initializer
drivers/video/mb862xx/mb862xxfb.c:720: warning: (near initialization for 'of_platform_mb862xxfb_driver')
drivers/video/mb862xx/mb862xxfb.c:721: error: unknown field 'name' specified in initializer
drivers/video/mb862xx/mb862xxfb.c:721: warning: excess elements in struct initializer
drivers/video/mb862xx/mb862xxfb.c:721: warning: (near initialization for 'of_platform_mb862xxfb_driver')
drivers/video/mb862xx/mb862xxfb.c:722: error: unknown field 'match_table' specified in initializer
drivers/video/mb862xx/mb862xxfb.c:722: warning: excess elements in struct initializer
drivers/video/mb862xx/mb862xxfb.c:722: warning: (near initialization for 'of_platform_mb862xxfb_driver')
drivers/video/mb862xx/mb862xxfb.c:723: error: unknown field 'probe' specified in initializer
drivers/video/mb862xx/mb862xxfb.c:723: warning: excess elements in struct initializer
drivers/video/mb862xx/mb862xxfb.c:723: warning: (near initialization for 'of_platform_mb862xxfb_driver')
drivers/video/mb862xx/mb862xxfb.c:724: error: unknown field 'remove' specified in initializer
drivers/video/mb862xx/mb862xxfb.c:724: warning: excess elements in struct initializer
drivers/video/mb862xx/mb862xxfb.c:724: warning: (near initialization for 'of_platform_mb862xxfb_driver')
drivers/video/mb862xx/mb862xxfb.c: In function 'mb862xxfb_init':
drivers/video/mb862xx/mb862xxfb.c:1038: error: implicit declaration of function 'of_register_platform_driver'
drivers/video/mb862xx/mb862xxfb.c: In function 'mb862xxfb_exit':
drivers/video/mb862xx/mb862xxfb.c:1049: error: implicit declaration of function 'of_unregister_platform_driver'

nfi is this is correct...

Cc: Anatolij Gustschin <agust@denx.de>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Matteo Fortini <m.fortini@selcomgroup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/Kconfig~add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix drivers/video/Kconfig
--- a/drivers/video/Kconfig~add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix
+++ a/drivers/video/Kconfig
@@ -2086,6 +2086,7 @@ config FB_METRONOME
 config FB_MB862XX
 	tristate "Fujitsu MB862xx GDC support"
 	depends on FB
+	depends on OF
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
fs-remove-prepare_write-commit_write-fix.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace-checkpatch-fixes.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
pci-uninline-pci_ioremap_bar.patch
autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
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

