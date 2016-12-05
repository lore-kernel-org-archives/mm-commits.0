From: akpm@linux-foundation.org
Subject: + zram-restrict-add-remove-attributes-to-root-only.patch added to -mm tree
Date: Mon, 05 Dec 2016 12:58:19 -0800
Message-ID: <5845d4eb.8Qu4KOciq9goEBtb%akpm__8804.0565293797$1480971512$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46844 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbcLEU57 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Dec 2016 15:57:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org, minchan@kernel.org, stable@vger.kernel.org, steven@stebalien.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: restrict add/remove attributes to root only
has been added to the -mm tree.  Its filename is
     zram-restrict-add-remove-attributes-to-root-only.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-restrict-add-remove-attributes-to-root-only.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-restrict-add-remove-attributes-to-root-only.patch

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
Subject: zram: restrict add/remove attributes to root only

zram hot_add sysfs attribute is a very 'special' attribute - reading from
it creates a new uninitialized zram device.  This file, by a mistake, can
be read by a 'normal' user at the moment, while only root must be able to
create a new zram device, therefore hot_add attribute must have S_IRUSR
mode, not S_IRUGO.

Fixes: 6566d1a32bf72 ("zram: add dynamic device add/remove functionality")
Link: http://lkml.kernel.org/r/20161205155845.20129-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Steven Allen <steven@stebalien.com>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>    [4.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-restrict-add-remove-attributes-to-root-only drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-restrict-add-remove-attributes-to-root-only
+++ a/drivers/block/zram/zram_drv.c
@@ -1413,8 +1413,15 @@ static ssize_t hot_remove_store(struct c
 	return ret ? ret : count;
 }
 
+/*
+ * NOTE: hot_add attribute is not the usual read-only sysfs
+ * attribute. In a sence that reading from this file does alter
+ * the state of your system -- it creates a new un-initialized
+ * zram device and returns back this device's device_id (or an
+ * error code if it fails to create a new device).
+ */
 static struct class_attribute zram_control_class_attrs[] = {
-	__ATTR_RO(hot_add),
+	__ATTR(hot_add, 0400, hot_add_show, NULL),
 	__ATTR_WO(hot_remove),
 	__ATTR_NULL,
 };
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-restrict-add-remove-attributes-to-root-only.patch

