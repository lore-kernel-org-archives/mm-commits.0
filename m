From: akpm@linux-foundation.org
Subject: [folded-merged]
 drivers-block-null_blk_mainc-fix-layout.patch removed from -mm tree
Date: Mon, 03 Feb 2020 17:06:51 -0800
Message-ID: <20200204010651.T-BsjtHOy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbgBDBGx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:06:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, mm-commits@vger.kernel.org, shli@fb.com


The patch titled
     Subject: drivers/block/null_blk_main.c: fix layout
has been removed from the -mm tree.  Its filename was
     drivers-block-null_blk_mainc-fix-layout.patch

This patch was dropped because it was folded into ipc-consolidate-all-xxxctl_down-functions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/block/null_blk_main.c: fix layout

Each line here overflows 80 cols by exactly one character.  Delete one tab
per line to fix.

Cc: Shaohua Li <shli@fb.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/null_blk_main.c |   56 ++++++++++++++++----------------
 1 file changed, 28 insertions(+), 28 deletions(-)

--- a/drivers/block/null_blk_main.c~drivers-block-null_blk_mainc-fix-layout
+++ a/drivers/block/null_blk_main.c
@@ -263,34 +263,34 @@ static ssize_t nullb_device_bool_attr_st
 }
 
 /* The following macro should only be used with TYPE = {uint, ulong, bool}. */
-#define NULLB_DEVICE_ATTR(NAME, TYPE, APPLY)					\
-static ssize_t									\
-nullb_device_##NAME##_show(struct config_item *item, char *page)		\
-{										\
-	return nullb_device_##TYPE##_attr_show(					\
-				to_nullb_device(item)->NAME, page);		\
-}										\
-static ssize_t									\
-nullb_device_##NAME##_store(struct config_item *item, const char *page,		\
-			    size_t count)					\
-{										\
-	int (*apply_fn)(struct nullb_device *dev, TYPE new_value) = APPLY;	\
-	struct nullb_device *dev = to_nullb_device(item);			\
-	TYPE new_value;								\
-	int ret;								\
-										\
-	ret = nullb_device_##TYPE##_attr_store(&new_value, page, count);	\
-	if (ret < 0)								\
-		return ret;							\
-	if (apply_fn)								\
-		ret = apply_fn(dev, new_value);					\
-	else if (test_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags)) 		\
-		ret = -EBUSY;							\
-	if (ret < 0)								\
-		return ret;							\
-	dev->NAME = new_value;							\
-	return count;								\
-}										\
+#define NULLB_DEVICE_ATTR(NAME, TYPE, APPLY)				\
+static ssize_t								\
+nullb_device_##NAME##_show(struct config_item *item, char *page)	\
+{									\
+	return nullb_device_##TYPE##_attr_show(				\
+				to_nullb_device(item)->NAME, page);	\
+}									\
+static ssize_t								\
+nullb_device_##NAME##_store(struct config_item *item, const char *page,	\
+			    size_t count)				\
+{									\
+	int (*apply_fn)(struct nullb_device *dev, TYPE new_value) = APPLY;\
+	struct nullb_device *dev = to_nullb_device(item);		\
+	TYPE new_value;							\
+	int ret;							\
+									\
+	ret = nullb_device_##TYPE##_attr_store(&new_value, page, count);\
+	if (ret < 0)							\
+		return ret;						\
+	if (apply_fn)							\
+		ret = apply_fn(dev, new_value);				\
+	else if (test_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags)) 	\
+		ret = -EBUSY;						\
+	if (ret < 0)							\
+		return ret;						\
+	dev->NAME = new_value;						\
+	return count;							\
+}									\
 CONFIGFS_ATTR(nullb_device_, NAME);
 
 static int nullb_apply_submit_queues(struct nullb_device *dev,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-consolidate-all-xxxctl_down-functions.patch
drivers-block-null_blk_mainc-fix-uninitialized-var-warnings.patch
