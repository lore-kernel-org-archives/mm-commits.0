From: akpm@linux-foundation.org
Subject: [folded] drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch removed from -mm tree
Date: Mon, 25 Jul 2011 16:59:38 -0700
Message-ID: <201107252359.p6PNxcNY006385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752185Ab1GYX7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 19:59:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dg77.kim@samsung.com, greg@kroah.com, kyungmin.park@samsung.com, mk7.kang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     drivers-misc-add-support-the-fsa9480-usb-switch-fix
has been removed from the -mm tree.  Its filename was
     drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch

This patch was dropped because it was folded into drivers-misc-add-support-the-fsa9480-usb-switch.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-misc-add-support-the-fsa9480-usb-switch-fix
From: Andrew Morton <akpm@linux-foundation.org>

make a couple of things static

Cc: Donggeun Kim <dg77.kim@samsung.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Minkyu Kang <mk7.kang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/fsa9480.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/fsa9480.c~drivers-misc-add-support-the-fsa9480-usb-switch-fix drivers/misc/fsa9480.c
--- a/drivers/misc/fsa9480.c~drivers-misc-add-support-the-fsa9480-usb-switch-fix
+++ a/drivers/misc/fsa9480.c
@@ -145,7 +145,7 @@ static int fsa9480_read_irq(struct i2c_c
 	return ret;
 }
 
-void fsa9480_set_switch(const char *buf)
+static void fsa9480_set_switch(const char *buf)
 {
 	struct fsa9480_usbsw *usbsw = chip;
 	struct i2c_client *client = usbsw->client;
@@ -179,7 +179,7 @@ void fsa9480_set_switch(const char *buf)
 	fsa9480_write_reg(client, FSA9480_REG_CTRL, value);
 }
 
-ssize_t fsa9480_get_switch(char *buf)
+static ssize_t fsa9480_get_switch(char *buf)
 {
 	struct fsa9480_usbsw *usbsw = chip;
 	struct i2c_client *client = usbsw->client;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch
mm-make-some-struct-pages-const.patch
mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch
xtensa-prevent-arbitrary-read-in-ptrace.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines.patch
pagewalk-add-locking-rule-comments.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young.patch
drivers-misc-add-support-the-fsa9480-usb-switch.patch
lib-make-_tolower-public-checkpatch-fixes.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
drivers-connector-cn_procc-remove-unused-local.patch
drivers-staging-gma500-psb_intel_displayc-fix-bad-udelay.patch

