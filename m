From: akpm@linux-foundation.org
Subject: [merged] drivers-net-82596c-suppress-warnings.patch removed from -mm tree
Date: Tue, 26 May 2009 12:35:36 -0700
Message-ID: <200905261935.n4QJZaix006424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755824AbZEZTnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     drivers/net/82596.c: suppress warnings
has been removed from the -mm tree.  Its filename was
     drivers-net-82596c-suppress-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/82596.c: suppress warnings
From: Andrew Morton <akpm@linux-foundation.org>

i386 allmodconfig:

drivers/net/82596.c: In function 'init_rx_bufs':
drivers/net/82596.c:544: warning: cast to pointer from integer of different size
drivers/net/82596.c:545: warning: cast to pointer from integer of different size
drivers/net/82596.c:548: warning: cast to pointer from integer of different size
drivers/net/82596.c:557: warning: cast to pointer from integer of different size
drivers/net/82596.c:565: warning: cast to pointer from integer of different size
drivers/net/82596.c:569: warning: cast to pointer from integer of different size
drivers/net/82596.c:575: warning: cast to pointer from integer of different size
drivers/net/82596.c: In function 'rebuild_rx_bufs':
drivers/net/82596.c:606: warning: cast to pointer from integer of different size
drivers/net/82596.c:608: warning: cast to pointer from integer of different size
drivers/net/82596.c: In function 'init_i596_mem':
drivers/net/82596.c:680: warning: cast to pointer from integer of different size
drivers/net/82596.c:681: warning: cast to pointer from integer of different size
drivers/net/82596.c: In function 'i596_rx':
drivers/net/82596.c:818: warning: cast to pointer from integer of different size
drivers/net/82596.c: In function 'i596_add_cmd':
drivers/net/82596.c:975: warning: cast to pointer from integer of different size
drivers/net/82596.c:979: warning: cast to pointer from integer of different size
drivers/net/82596.c: In function 'i596_start_xmit':
drivers/net/82596.c:1088: warning: cast to pointer from integer of different size
drivers/net/82596.c:1099: warning: cast to pointer from integer of different size
drivers/net/82596.c: In function 'i596_interrupt':
drivers/net/82596.c:1404: warning: cast to pointer from integer of different size

(ugh)

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/82596.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/net/82596.c~drivers-net-82596c-suppress-warnings drivers/net/82596.c
--- a/drivers/net/82596.c~drivers-net-82596c-suppress-warnings
+++ a/drivers/net/82596.c
@@ -122,13 +122,13 @@ static char version[] __initdata =
 #define ISCP_BUSY	0x00010000
 #define MACH_IS_APRICOT	0
 #else
-#define WSWAPrfd(x)     ((struct i596_rfd *)(x))
-#define WSWAPrbd(x)     ((struct i596_rbd *)(x))
-#define WSWAPiscp(x)    ((struct i596_iscp *)(x))
-#define WSWAPscb(x)     ((struct i596_scb *)(x))
-#define WSWAPcmd(x)     ((struct i596_cmd *)(x))
-#define WSWAPtbd(x)     ((struct i596_tbd *)(x))
-#define WSWAPchar(x)    ((char *)(x))
+#define WSWAPrfd(x)     ((struct i596_rfd *)((long)x))
+#define WSWAPrbd(x)     ((struct i596_rbd *)((long)x))
+#define WSWAPiscp(x)    ((struct i596_iscp *)((long)x))
+#define WSWAPscb(x)     ((struct i596_scb *)((long)x))
+#define WSWAPcmd(x)     ((struct i596_cmd *)((long)x))
+#define WSWAPtbd(x)     ((struct i596_tbd *)((long)x))
+#define WSWAPchar(x)    ((char *)((long)x))
 #define ISCP_BUSY	0x0001
 #define MACH_IS_APRICOT	1
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
mtd-flex-onenand-support.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
drivers-usb-serial-sierrac-fix-printk-warning.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
revert-fbdev-uninline-lock_fb_info.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
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

