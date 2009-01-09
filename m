From: akpm@linux-foundation.org
Subject: - raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 09 Jan 2009 12:29:25 -0800
Message-ID: <200901092029.n09KTPoc025675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857AbZAIUjI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 15:39:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, viro@ZenIV.linux.org.ukviro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch

This patch was dropped because it was folded into raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: open brace '{' following struct go on the same line
#246: FILE: drivers/char/raw.c:249:
+struct raw32_config_request
+{

ERROR: code indent should use tabs where possible
#247: FILE: drivers/char/raw.c:250:
+        compat_int_t^Iraw_minor;$

ERROR: code indent should use tabs where possible
#248: FILE: drivers/char/raw.c:251:
+        compat_u64^Iblock_major;$

ERROR: code indent should use tabs where possible
#249: FILE: drivers/char/raw.c:252:
+        compat_u64^Iblock_minor;$

total: 4 errors, 0 warnings, 358 lines checked

./patches/raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/raw.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/char/raw.c~raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes drivers/char/raw.c
--- a/drivers/char/raw.c~raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes
+++ a/drivers/char/raw.c
@@ -245,11 +245,10 @@ static int raw_ctl_ioctl(struct inode *i
 }
 
 #ifdef CONFIG_COMPAT
-struct raw32_config_request
-{
-        compat_int_t	raw_minor;
-        compat_u64	block_major;
-        compat_u64	block_minor;
+struct raw32_config_request {
+	compat_int_t	raw_minor;
+	compat_u64	block_major;
+	compat_u64	block_minor;
 };
 
 static long raw_ctl_compat_ioctl(struct file *file, unsigned int cmd,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
clocksource-pass-clocksource-to-read-callback.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

