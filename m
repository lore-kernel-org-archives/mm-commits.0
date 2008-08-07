From: akpm@linux-foundation.org
Subject: + radeonfb-fix-engine-hangs-and-cache-flushing-checkpatch-fixes.patch added to -mm tree
Date: Wed, 06 Aug 2008 20:34:26 -0700
Message-ID: <200808070334.m773YQRU029714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753111AbYHGDe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 23:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org


The patch titled
     radeonfb-fix-engine-hangs-and-cache-flushing-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     radeonfb-fix-engine-hangs-and-cache-flushing-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeonfb-fix-engine-hangs-and-cache-flushing-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#143: FILE: drivers/video/aty/radeon_base.c:1463:
+		if (rinfo->family == CHIP_FAMILY_R200 || IS_R300_VARIANT(rinfo)) {

ERROR: code indent should use tabs where possible
#151: FILE: drivers/video/aty/radeon_base.c:2004:
+            (rinfo->family == CHIP_FAMILY_RS400) ||$

ERROR: spaces required around that '=' (ctx:VxV)
#182: FILE: drivers/video/aty/radeonfb.h:542:
+	for (i=0; i<2000000; i++) {
 	      ^

ERROR: spaces required around that '<' (ctx:VxV)
#182: FILE: drivers/video/aty/radeonfb.h:542:
+	for (i=0; i<2000000; i++) {
 	           ^

WARNING: space prohibited between function name and open parenthesis '('
#193: FILE: drivers/video/aty/radeonfb.h:550:
+static inline void radeon_engine_flush (struct radeonfb_info *rinfo)

ERROR: code indent should use tabs where possible
#201: FILE: drivers/video/aty/radeonfb.h:556:
+^I        ~RB2D_DC_FLUSH_ALL);$

WARNING: space prohibited between function name and open parenthesis '('
#206: FILE: drivers/video/aty/radeonfb.h:561:
+	_radeon_fifo_wait (rinfo, 64);

ERROR: spaces required around that '=' (ctx:VxV)
#209: FILE: drivers/video/aty/radeonfb.h:564:
+	for (i=0; i < 2000000; i++) {
 	      ^

total: 5 errors, 3 warnings, 188 lines checked

./patches/radeonfb-fix-engine-hangs-and-cache-flushing.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_base.c |    2 +-
 drivers/video/aty/radeonfb.h    |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/video/aty/radeon_base.c~radeonfb-fix-engine-hangs-and-cache-flushing-checkpatch-fixes drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-fix-engine-hangs-and-cache-flushing-checkpatch-fixes
+++ a/drivers/video/aty/radeon_base.c
@@ -2001,7 +2001,7 @@ static void radeon_identify_vram(struct 
             (rinfo->family == CHIP_FAMILY_RS200) ||
             (rinfo->family == CHIP_FAMILY_RS300) ||
             (rinfo->family == CHIP_FAMILY_RC410) ||
-            (rinfo->family == CHIP_FAMILY_RS400) ||
+	    (rinfo->family == CHIP_FAMILY_RS400) ||
 	    (rinfo->family == CHIP_FAMILY_RS480) ) {
           u32 tom = INREG(NB_TOM);
           tmp = ((((tom >> 16) - (tom & 0xffff) + 1) << 6) * 1024);
diff -puN drivers/video/aty/radeonfb.h~radeonfb-fix-engine-hangs-and-cache-flushing-checkpatch-fixes drivers/video/aty/radeonfb.h
--- a/drivers/video/aty/radeonfb.h~radeonfb-fix-engine-hangs-and-cache-flushing-checkpatch-fixes
+++ a/drivers/video/aty/radeonfb.h
@@ -539,7 +539,7 @@ static inline void _radeon_fifo_wait(str
 {
 	int i;
 
-	for (i=0; i<2000000; i++) {
+	for (i = 0; i < 2000000; i++) {
 		if ((INREG(RBBM_STATUS) & 0x7f) >= entries)
 			return;
 		udelay(1);
@@ -547,21 +547,21 @@ static inline void _radeon_fifo_wait(str
 	printk(KERN_ERR "radeonfb: FIFO Timeout !\n");
 }
 
-static inline void radeon_engine_flush (struct radeonfb_info *rinfo)
+static inline void radeon_engine_flush(struct radeonfb_info *rinfo)
 {
 	int i;
 
 	/* Initiate flush */
 	OUTREGP(DSTCACHE_CTLSTAT, RB2D_DC_FLUSH_ALL,
-	        ~RB2D_DC_FLUSH_ALL);
+		~RB2D_DC_FLUSH_ALL);
 
 	/* Ensure FIFO is empty, ie, make sure the flush commands
 	 * has reached the cache
 	 */
-	_radeon_fifo_wait (rinfo, 64);
+	_radeon_fifo_wait(rinfo, 64);
 
 	/* Wait for the flush to complete */
-	for (i=0; i < 2000000; i++) {
+	for (i = 0; i < 2000000; i++) {
 		if (!(INREG(DSTCACHE_CTLSTAT) & RB2D_DC_BUSY))
 			return;
 		udelay(1);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

radeonfb-fix-engine-hangs-and-cache-flushing-checkpatch-fixes.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
i2c-renesas-highlander-fpga-smbus-support-update-fix.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-kbuild-fixes.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
sched-type-fix.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver.patch
drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
scsi-megaraid_sas-add-the-new-controllers-support-checkpatch-fixes.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
h8300-generic_bug-support-checkpatch-fixes.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
devpts-switch-to-ida-checkpatch-fixes.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
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

