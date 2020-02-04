From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 20/67] drivers/block/null_blk_main.c: fix layout
Date: Mon, 03 Feb 2020 17:34:49 -0800
Message-ID: <20200204013449.zoDu1dCU6%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgBDBeu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:34:50 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, linux-mm@kvack.org, mm-commits@vger.kernel.org, shli@fb.com, torvalds@linux-foundation.org

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
