From: akpm@linux-foundation.org
Subject: [folded] drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch removed from -mm tree
Date: Tue, 22 Mar 2011 16:02:47 -0700
Message-ID: <201103222302.p2MN2lec000387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755683Ab1CVXKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 19:10:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@linux.intel.com, axel.lin@gmail.com, kalhan.trisal@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix
has been removed from the -mm tree.  Its filename was
     drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch

This patch was dropped because it was folded into drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix
From: Andrew Morton <akpm@linux-foundation.org>

make `ret' signed

Cc: Alan Cox <alan@linux.intel.com>
Cc: Axel Lin <axel.lin@gmail.com>
Cc: Kalhan Trisal <kalhan.trisal@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hmc6352.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/hmc6352.c~drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix drivers/misc/hmc6352.c
--- a/drivers/misc/hmc6352.c~drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix
+++ a/drivers/misc/hmc6352.c
@@ -75,7 +75,7 @@ static ssize_t compass_heading_data_show
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	unsigned char i2c_data[2];
-	unsigned int ret;
+	int ret;
 
 	mutex_lock(&compass_mutex);
 	ret = compass_command(client, 'A');
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-asm-generic-unistdh-fix-syncfs-syscall-number.patch
leds-convert-bd2802-driver-to-dev_pm_ops.patch
mm-vmap-area-cache.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-batch-free-pcp-list-if-possible.patch
pagewalk-only-split-huge-pages-when-necessary.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch
mm-add-__gfp_other_node-flag.patch
mm-use-__gfp_other_node-for-transparent-huge-pages.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch
kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix.patch

