From: akpm@linux-foundation.org
Subject: [to-be-updated]
 zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch removed from -mm
 tree
Date: Wed, 22 Apr 2015 13:29:57 -0700
Message-ID: <553804c5.vuslveq8ZOvBwUih%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbbDVU36 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 16:29:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: cosmetic ZRAM_ATTR_RO code formatting tweak
has been removed from the -mm tree.  Its filename was
     zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: cosmetic ZRAM_ATTR_RO code formatting tweak

We currently don't support zram on-demand device creation.  The only way
to have N zram devices is to specify num_devices module parameter (default
value 1).  That means that if, for some reason, at some point, user wants
to have N + 1 devies he/she must umount all the existing devices, unload
the module, load the module passing num_devices equals to N + 1.  And do
this again, if needed.

This patchset introduces zram-control sysfs class, which has two sysfs
attrs:

 - zram_add     -- add a new specific (device_id) zram device
 - zram_remove  -- remove a specific (device_id) zram device

    Usage example:
        # add a new specific zram device
        echo 4 > /sys/class/zram-control/zram_add

        # remove a specific zram device
        echo 4 > /sys/class/zram-control/zram_remove


The patchset also does some cleanups and huge code reorganization.


This patch (of 8):

Fix a misplaced backslash.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-cosmetic-zram_attr_ro-code-formatting-tweak drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-cosmetic-zram_attr_ro-code-formatting-tweak
+++ a/drivers/block/zram/zram_drv.c
@@ -49,7 +49,7 @@ static inline void deprecated_attr_warn(
 }
 
 #define ZRAM_ATTR_RO(name)						\
-static ssize_t name##_show(struct device *d,		\
+static ssize_t name##_show(struct device *d,				\
 				struct device_attribute *attr, char *b)	\
 {									\
 	struct zram *zram = dev_to_zram(d);				\
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch

