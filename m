From: akpm@linux-foundation.org
Subject: + zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch added to -mm tree
Date: Tue, 03 Mar 2015 14:01:56 -0800
Message-ID: <54f62f54.3qXAqBYTuAXiDsk2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506AbbCCWB5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 17:01:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: cosmetic ZRAM_ATTR_RO code formatting tweak
has been added to the -mm tree.  Its filename is
     zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: cosmetic ZRAM_ATTR_RO code formatting tweak

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
@@ -44,7 +44,7 @@ static const char *default_compressor =
 static unsigned int num_devices = 1;
 
 #define ZRAM_ATTR_RO(name)						\
-static ssize_t name##_show(struct device *d,		\
+static ssize_t name##_show(struct device *d,				\
 				struct device_attribute *attr, char *b)	\
 {									\
 	struct zram *zram = dev_to_zram(d);				\
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
cpumask-dont-perform-while-loop-in-cpumask_next_and.patch
lib-lz4-pull-out-constant-tables.patch

