From: akpm@linux-foundation.org
Subject: - drivers-mfd-tc6393xbc-doesnt-compile-on-i386.patch removed from -mm tree
Date: Fri, 25 Jul 2008 19:10:38 -0700
Message-ID: <200807260223.m6Q2NK7l011222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316AbYGZCXi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 22:23:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dbaryshkov@gmail.com, rmk@arm.linux.org.uk, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     drivers/mfd/tc6393xb.c doesn't compile on i386
has been removed from the -mm tree.  Its filename was
     drivers-mfd-tc6393xbc-doesnt-compile-on-i386.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mfd/tc6393xb.c doesn't compile on i386
From: Andrew Morton <akpm@linux-foundation.org>

drivers/mfd/tc6393xb.c:93: error: field 'gpio' has incomplete type
drivers/mfd/tc6393xb.c: In function 'tc6393xb_gpio_get':
drivers/mfd/tc6393xb.c:171: warning: type defaults to 'int' in declaration of '__mptr'
drivers/mfd/tc6393xb.c:171: warning: initialization from incompatible pointer type
drivers/mfd/tc6393xb.c: In function '__tc6393xb_gpio_set':
drivers/mfd/tc6393xb.c:181: warning: type defaults to 'int' in declaration of '__mptr'
drivers/mfd/tc6393xb.c:181: warning: initialization from incompatible pointer type
drivers/mfd/tc6393xb.c: In function 'tc6393xb_gpio_set':
drivers/mfd/tc6393xb.c:196: warning: type defaults to 'int' in declaration of '__mptr'
drivers/mfd/tc6393xb.c:196: warning: initialization from incompatible pointer type
drivers/mfd/tc6393xb.c: In function 'tc6393xb_gpio_direction_input':
drivers/mfd/tc6393xb.c:209: warning: type defaults to 'int' in declaration of '__mptr'
drivers/mfd/tc6393xb.c:209: warning: initialization from incompatible pointer type
drivers/mfd/tc6393xb.c: In function 'tc6393xb_gpio_direction_output':
drivers/mfd/tc6393xb.c:227: warning: type defaults to 'int' in declaration of '__mptr'
drivers/mfd/tc6393xb.c:227: warning: initialization from incompatible pointer type
drivers/mfd/tc6393xb.c: In function 'tc6393xb_register_gpio':
drivers/mfd/tc6393xb.c:254: error: implicit declaration of function 'gpiochip_add'
drivers/mfd/tc6393xb.c: In function 'tc6393xb_attach_irq':
drivers/mfd/tc6393xb.c:324: error: implicit declaration of function 'set_irq_flags'
drivers/mfd/tc6393xb.c:324: error: 'IRQF_VALID' undeclared (first use in this function)
drivers/mfd/tc6393xb.c:324: error: (Each undeclared identifier is reported only once
drivers/mfd/tc6393xb.c:324: error: for each function it appears in.)
drivers/mfd/tc6393xb.c:324: error: 'IRQF_PROBE' undeclared (first use in this function)
drivers/mfd/tc6393xb.c:327: error: 'IRQT_FALLING' undeclared (first use in this function)
drivers/mfd/tc6393xb.c: In function 'tc6393xb_probe':
drivers/mfd/tc6393xb.c:481: error: implicit declaration of function 'gpiochip_remove'

Something like this...

Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mfd/Kconfig~drivers-mfd-tc6393xbc-doesnt-compile-on-i386 drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~drivers-mfd-tc6393xbc-doesnt-compile-on-i386
+++ a/drivers/mfd/Kconfig
@@ -44,6 +44,7 @@ config HTC_EGPIO
 
 config HTC_PASIC3
 	tristate "HTC PASIC3 LED/DS1WM chip support"
+	depends on ARM
 	help
 	  This core driver provides register access for the LED/DS1WM
 	  chips labeled "AIC2" and "AIC3", found on HTC Blueangel and
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uninline-arch_pick_mmap_layout.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary.patch
tpm-increase-size-of-internal-tpm-response-buffers.patch
memstick-allow-set_param-method-to-return-an-error-code.patch
memstick-use-fully-asynchronous-request-processing.patch
full-conversion-to-early_initcall-interface-remove-old-interface.patch
mm-introduce-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast.patch
mm-speculative-page-references.patch
slb-drop-kmem-cache-argument-from-constructor.patch
video-console-sticonrec-make-code-static.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
linux-next-fixups.patch
linux-next-rejects.patch
next-remove-localversion.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
pci-make-pci_register_driver-a-macro.patch
drivers-mfd-tc6393xbc-doesnt-compile-on-i386.patch
x86-pci-replace-dbg-with-pr_debug-fix.patch
x86-pci-replace-dbg-with-pr_debug-fix-2.patch
include-asm-generic-pgtable-nopmdh-macros-are-noxious-reason-435.patch
arch-x86-pci-i386c-fix-printk-warnings.patch
drm-fix-sparc64-build.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-jg-misc.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
bridge-send-correct-mtu-value-in-pmtu-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
drivers-net-wireless-iwlwifi-iwl-ledc-printk-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
ftrace-disable-function-tracing-bringing-up-new-cpu-fix.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
gru-driver-v3-hardware-data-structures-fix.patch
gru-driver-v3-hardware-data-structures-fix-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
define-page_file_cache-function-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-units-fix.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-page-statistics-units-fix.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
introduce-__get_user_pages-fix.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
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

