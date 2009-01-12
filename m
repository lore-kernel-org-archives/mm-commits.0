From: akpm@linux-foundation.org
Subject: [withdrawn] nr_blockdev_pages-in_interrupt-warning.patch removed from -mm tree
Date: Mon, 12 Jan 2009 14:06:04 -0800
Message-ID: <200901122206.n0CM64IX007996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753221AbZALWGG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 17:06:06 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0CM64jW007287
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2009 14:06:05 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     a
has been removed from the -mm tree.  Its filename was
     nr_blockdev_pages-in_interrupt-warning.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: a
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/block_dev.c~nr_blockdev_pages-in_interrupt-warning fs/block_dev.c
--- a/fs/block_dev.c~nr_blockdev_pages-in_interrupt-warning
+++ a/fs/block_dev.c
@@ -24,6 +24,8 @@
 #include <linux/uio.h>
 #include <linux/namei.h>
 #include <linux/log2.h>
+#include <linux/hardirq.h>
+
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -410,6 +412,9 @@ long nr_blockdev_pages(void)
 {
 	struct block_device *bdev;
 	long ret = 0;
+
+	WARN_ON(in_interrupt());
+
 	spin_lock(&bdev_lock);
 	list_for_each_entry(bdev, &all_bdevs, bd_list) {
 		ret += bdev->bd_inode->i_mapping->nrpages;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
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

