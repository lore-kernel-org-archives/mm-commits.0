From: akpm@linux-foundation.org
Subject: + backlight-fix-s6e63m0-device-attr-function-return-types.patch added to -mm tree
Date: Thu, 20 May 2010 14:13:48 -0700
Message-ID: <201005202113.o4KLDmjZ005613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938Ab0ETVOc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 17:14:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, inki.dae@samsung.com, rpurdie@rpsys.net


The patch titled
     backlight: fix s6e63m0 device attr function return types
has been added to the -mm tree.  Its filename is
     backlight-fix-s6e63m0-device-attr-function-return-types.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: fix s6e63m0 device attr function return types
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix device attribute functions return types.

drivers/video/backlight/s6e63m0.c:718: warning: initialization from incompatible pointer type
drivers/video/backlight/s6e63m0.c:718: warning: initialization from incompatible pointer type
drivers/video/backlight/s6e63m0.c:732: warning: initialization from incompatible pointer type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: InKi Dae  <inki.dae@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/s6e63m0.c~backlight-fix-s6e63m0-device-attr-function-return-types drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-fix-s6e63m0-device-attr-function-return-types
+++ a/drivers/video/backlight/s6e63m0.c
@@ -654,7 +654,7 @@ static const struct backlight_ops s6e63m
 	.update_status = s6e63m0_set_brightness,
 };
 
-static int s6e63m0_sysfs_show_gamma_mode(struct device *dev,
+static ssize_t s6e63m0_sysfs_show_gamma_mode(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
 	struct s6e63m0 *lcd = dev_get_drvdata(dev);
@@ -681,7 +681,7 @@ static int s6e63m0_sysfs_show_gamma_mode
 	return strlen(buf);
 }
 
-static int s6e63m0_sysfs_store_gamma_mode(struct device *dev,
+static ssize_t s6e63m0_sysfs_store_gamma_mode(struct device *dev,
 				       struct device_attribute *attr,
 				       const char *buf, size_t len)
 {
@@ -718,7 +718,7 @@ static int s6e63m0_sysfs_store_gamma_mod
 static DEVICE_ATTR(gamma_mode, 0644,
 		s6e63m0_sysfs_show_gamma_mode, s6e63m0_sysfs_store_gamma_mode);
 
-static int s6e63m0_sysfs_show_gamma_table(struct device *dev,
+static ssize_t s6e63m0_sysfs_show_gamma_table(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
 	struct s6e63m0 *lcd = dev_get_drvdata(dev);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
dib3000mc-reduce-large-stack-usage-fix.patch
media-ak881x-needs-slabh.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-fix-s6e63m0-kconfig.patch
backlight-fix-s6e63m0-device-attr-function-return-types.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
virtio_9ph-include-linux-typesh.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
ad525x_dpot-add-support-for-spi-parts-fix-ad525x_dpot-build.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
rtc-cmos-do-dev_set_drvdata-earlier-in-the-initialization.patch
documentation-submittingdrivers-resources.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
aio-fix-the-compat-vectored-operations-fix.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
numa-update-documentation-vm-numa-add-memoryless-node-info-fix1.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

