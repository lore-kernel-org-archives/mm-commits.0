Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478C4349B0B
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 18:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763489562; cv=none; b=pAqefFkRzfzqR7VBR/Drgcln5wNWR8S9gsaZRamHnoSzndXB62phojBxquo2bgQO+PXcBGNZoDe8SciymIrK1g6/M9MoKoVq9CUUwCIiZoZXocDZptVKwoOnB1FPFf/o79zJOv1VLWdNpark31lvwWZUYEEvpRFSStVzrr2q4t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763489562; c=relaxed/simple;
	bh=D0JQzare9i1eWnP8+IRuHPy+ZYh7OOEB5AmZ0lvgRd8=;
	h=Date:To:From:Subject:Message-Id; b=eFwQhMKJNQXjWc5VKWG8i3tEDswTvJWAwwZsPgq5H5i4W8mSsXYRCI3E7HYnfj30/YcbhH/7xrZd7p/6MAzdxcOkMQyYNuFbLATl1CXF08IXJYfvYqYLN8tJ1LEKq9+rmZtYjmZHw6JnjNteAcR8mH1i1QDGBMppDIkkaIPJJsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qB5svMnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qB5svMnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D698BC16AAE;
	Tue, 18 Nov 2025 18:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763489561;
	bh=D0JQzare9i1eWnP8+IRuHPy+ZYh7OOEB5AmZ0lvgRd8=;
	h=Date:To:From:Subject:From;
	b=qB5svMnqml8wT9hSH5LyfVNQT7Jwe7WmCFd6wdMk7YC0DTR6E2/3YZUCjI2jvFHj7
	 y9cXJ/Pnn7gDsAO35Ia1LtuhwW4BNeAVy8AlZBOMpCVfGyP6Ye00cnMda5mPhwvnYG
	 QM5/D4m/u9V/sCGydRiQdIotZ0THTvW0yRb9d29o=
Date: Tue, 18 Nov 2025 10:12:40 -0800
To: mm-commits@vger.kernel.org,ywen.chen@foxmail.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-take-write-lock-in-wb-limit-store-handlers.patch added to mm-unstable branch
Message-Id: <20251118181241.D698BC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: take write lock in wb limit store handlers
has been added to the -mm mm-unstable branch.  Its filename is
     zram-take-write-lock-in-wb-limit-store-handlers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-take-write-lock-in-wb-limit-store-handlers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: take write lock in wb limit store handlers
Date: Tue, 18 Nov 2025 16:29:57 +0900

Write device attrs handlers should take write zram init_lock.  While at
it, fixup coding styles.

Link: https://lkml.kernel.org/r/20251118073000.1928107-4-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Yuwen Chen <ywen.chen@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-take-write-lock-in-wb-limit-store-handlers
+++ a/drivers/block/zram/zram_drv.c
@@ -519,7 +519,8 @@ struct zram_wb_req {
 };
 
 static ssize_t writeback_limit_enable_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+					    struct device_attribute *attr,
+					    const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	u64 val;
@@ -528,18 +529,19 @@ static ssize_t writeback_limit_enable_st
 	if (kstrtoull(buf, 10, &val))
 		return ret;
 
-	down_read(&zram->init_lock);
+	down_write(&zram->init_lock);
 	spin_lock(&zram->wb_limit_lock);
 	zram->wb_limit_enable = val;
 	spin_unlock(&zram->wb_limit_lock);
-	up_read(&zram->init_lock);
+	up_write(&zram->init_lock);
 	ret = len;
 
 	return ret;
 }
 
 static ssize_t writeback_limit_enable_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+					   struct device_attribute *attr,
+					   char *buf)
 {
 	bool val;
 	struct zram *zram = dev_to_zram(dev);
@@ -554,7 +556,8 @@ static ssize_t writeback_limit_enable_sh
 }
 
 static ssize_t writeback_limit_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	u64 val;
@@ -563,11 +566,11 @@ static ssize_t writeback_limit_store(str
 	if (kstrtoull(buf, 10, &val))
 		return ret;
 
-	down_read(&zram->init_lock);
+	down_write(&zram->init_lock);
 	spin_lock(&zram->wb_limit_lock);
 	zram->bd_wb_limit = val;
 	spin_unlock(&zram->wb_limit_lock);
-	up_read(&zram->init_lock);
+	up_write(&zram->init_lock);
 	ret = len;
 
 	return ret;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-add-writeback-batch-size-device-attr.patch
zram-take-write-lock-in-wb-limit-store-handlers.patch
zram-drop-wb_limit_lock.patch
zram-rework-bdev-block-allocation.patch
zram-read-slot-block-idx-under-slot-lock.patch

