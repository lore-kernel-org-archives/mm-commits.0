From: akpm@linux-foundation.org
Subject: [patch 1/3] zram: restrict add/remove attributes to root only
Date: Wed, 07 Dec 2016 14:44:31 -0800
Message-ID: <584890cf.oORz+Nnc3G2B55zs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33388 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933635AbcLGWn7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2016 17:43:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org, minchan@kernel.org, stable@vger.kernel.org, steven@stebalien.com

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: restrict add/remove attributes to root only

zram hot_add sysfs attribute is a very 'special' attribute - reading from
it creates a new uninitialized zram device.  This file, by a mistake, can
be read by a 'normal' user at the moment, while only root must be able to
create a new zram device, therefore hot_add attribute must have S_IRUSR
mode, not S_IRUGO.

[akpm@linux-foundation.org: s/sence/sense/, reflow comment to use 80 cols]
Fixes: 6566d1a32bf72 ("zram: add dynamic device add/remove functionality")
Link: http://lkml.kernel.org/r/20161205155845.20129-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Steven Allen <steven@stebalien.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>    [4.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-restrict-add-remove-attributes-to-root-only drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-restrict-add-remove-attributes-to-root-only
+++ a/drivers/block/zram/zram_drv.c
@@ -1413,8 +1413,14 @@ static ssize_t hot_remove_store(struct c
 	return ret ? ret : count;
 }
 
+/*
+ * NOTE: hot_add attribute is not the usual read-only sysfs attribute. In a
+ * sense that reading from this file does alter the state of your system -- it
+ * creates a new un-initialized zram device and returns back this device's
+ * device_id (or an error code if it fails to create a new device).
+ */
 static struct class_attribute zram_control_class_attrs[] = {
-	__ATTR_RO(hot_add),
+	__ATTR(hot_add, 0400, hot_add_show, NULL),
 	__ATTR_WO(hot_remove),
 	__ATTR_NULL,
 };
_
