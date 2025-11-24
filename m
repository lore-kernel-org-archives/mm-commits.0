Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD2E2F7456
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025845; cv=none; b=mpGUcfexs8PpjNG/mAeIZVIZA3XiiRAg67djjNOBqiUULNVd1Avk3JTpbqyfrSwRG7VPt4kqntD9Lkabx6KuIBEB1SKDiaKKbiC3QScfX/mNnzKOeixjZHYb/IOvdv0H9Snn8PLeOlmcBdKI4K0HYdHiAEPn/Qff71NRbwvrwhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025845; c=relaxed/simple;
	bh=NznXMQziSDm1u5Rx/ILpoyT1/CQuzZp8iWh13nWdtD0=;
	h=Date:To:From:Subject:Message-Id; b=KhxvNGWcwRH+YTUIftkOIIDfzh6IkzzmhGQqp0e80lUlGMTnyMgErbtvz88F+CcYTX6dQbj2AwiAnVHJwSMfOBqsCpxdev8S2gaD/7peinLlZ2ulLxAyBuJHx532UiYHIhEtXKWbDoPvXzmXI3jSGP7bbQ279vaPj5ah1fPpl64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IiykzJeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IiykzJeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4DAC4CEF1;
	Mon, 24 Nov 2025 23:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025845;
	bh=NznXMQziSDm1u5Rx/ILpoyT1/CQuzZp8iWh13nWdtD0=;
	h=Date:To:From:Subject:From;
	b=IiykzJeo+ovA7PH1JNCidwXLRFBHkeqd4sEslGrWK+9p1J1VWpw1/FEVOLB9la7MA
	 AlkQOAtKKRUfBf+BBkqLgRCstbtqaJoWByPzQVYEDWteqKZ2gyP7tChO6zaNuVdZoN
	 9fgz6MdZpS4l6XeWtxWjL7uMJ+t+Q/kCumdp+rGs=
Date: Mon, 24 Nov 2025 15:10:44 -0800
To: mm-commits@vger.kernel.org,ywen.chen@foxmail.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-take-write-lock-in-wb-limit-store-handlers.patch removed from -mm tree
Message-Id: <20251124231045.1F4DAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: take write lock in wb limit store handlers
has been removed from the -mm tree.  Its filename was
     zram-take-write-lock-in-wb-limit-store-handlers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: take write lock in wb limit store handlers
Date: Sat, 22 Nov 2025 16:40:26 +0900

Write device attrs handlers should take write zram init_lock.  While at
it, fixup coding styles.

Link: https://lkml.kernel.org/r/20251122074029.3948921-4-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Yuwen Chen <ywen.chen@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-take-write-lock-in-wb-limit-store-handlers
+++ a/drivers/block/zram/zram_drv.c
@@ -521,7 +521,8 @@ struct zram_wb_req {
 };
 
 static ssize_t writeback_limit_enable_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+					    struct device_attribute *attr,
+					    const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	u64 val;
@@ -530,18 +531,19 @@ static ssize_t writeback_limit_enable_st
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
@@ -556,7 +558,8 @@ static ssize_t writeback_limit_enable_sh
 }
 
 static ssize_t writeback_limit_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	u64 val;
@@ -565,11 +568,11 @@ static ssize_t writeback_limit_store(str
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


