Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED68C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 22:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40C9F61090
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 22:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243520AbhIWWyr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 18:54:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243499AbhIWWyr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 18:54:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A348D61050;
        Thu, 23 Sep 2021 22:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632437594;
        bh=pNzYaGj/XjMBKInJt+PgW0M088CFuMTNRQm5POJoqmA=;
        h=Date:From:To:Subject:From;
        b=aex3Qe0yGcP+bVaVpj1KPQ5hpXdks5yy1iubmrKa19CCc23+v0Y8MfxfebYXXn+FP
         ja4uepGT/p9d+GBnKmHrKTcCIh8ujdUp4ADP8nfEVOPPRJ3LPM3ytpDfJ/Xe0Vs/Yd
         qMg7O6K1AmafYEgZk7RE9a+eN/6tzS0O40y7gnNc=
Date:   Thu, 23 Sep 2021 15:53:14 -0700
From:   akpm@linux-foundation.org
To:     bgeffon@google.com, corbet@lwn.net, jsbarnes@google.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org, suleiman@google.com
Subject:  + zram-introduce-an-aged-idle-interface.patch added to
 -mm tree
Message-ID: <20210923225314.T7GFLmeEh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: introduce an aged idle interface
has been added to the -mm tree.  Its filename is
     zram-introduce-an-aged-idle-interface.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zram-introduce-an-aged-idle-interface.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zram-introduce-an-aged-idle-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: zram: introduce an aged idle interface

This change introduces an aged idle interface to the existing idle sysfs
file for zram.

When CONFIG_ZRAM_MEMORY_TRACKING is enabled the idle file now also accepts
an integer argument.  This integer is the age (in seconds) of pages to
mark as idle.  The idle file still supports 'all' as it always has.  This
new approach allows for much more control over which pages get marked as
idle.

Link: https://lkml.kernel.org/r/20210923130115.1344361-1-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Jesse Barnes <jsbarnes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |    8 ++
 drivers/block/zram/zram_drv.c               |   60 +++++++++++++-----
 2 files changed, 52 insertions(+), 16 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-introduce-an-aged-idle-interface
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -328,6 +328,14 @@ as idle::
 From now on, any pages on zram are idle pages. The idle mark
 will be removed until someone requests access of the block.
 IOW, unless there is access request, those pages are still idle pages.
+Additionally, when CONFIG_ZRAM_MEMORY_TRACKING is enabled pages can be
+marked as idle based on how long (in seconds) it's been since they were
+last accessed::
+
+        echo 86400 > /sys/block/zramX/idle
+
+In this example all pages which haven't been accessed in more than 86400
+seconds (one day) will be marked idle.
 
 Admin can request writeback of those idle pages at right timing via::
 
--- a/drivers/block/zram/zram_drv.c~zram-introduce-an-aged-idle-interface
+++ a/drivers/block/zram/zram_drv.c
@@ -291,22 +291,16 @@ static ssize_t mem_used_max_store(struct
 	return len;
 }
 
-static ssize_t idle_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+/*
+ * Mark all pages which are older than or equal to cutoff as IDLE.
+ * Callers should hold the zram init lock in read mode
+ **/
+static void mark_idle(struct zram *zram, ktime_t cutoff)
 {
-	struct zram *zram = dev_to_zram(dev);
+	int is_idle = 1;
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
 	int index;
 
-	if (!sysfs_streq(buf, "all"))
-		return -EINVAL;
-
-	down_read(&zram->init_lock);
-	if (!init_done(zram)) {
-		up_read(&zram->init_lock);
-		return -EINVAL;
-	}
-
 	for (index = 0; index < nr_pages; index++) {
 		/*
 		 * Do not mark ZRAM_UNDER_WB slot as ZRAM_IDLE to close race.
@@ -314,14 +308,48 @@ static ssize_t idle_store(struct device
 		 */
 		zram_slot_lock(zram, index);
 		if (zram_allocated(zram, index) &&
-				!zram_test_flag(zram, index, ZRAM_UNDER_WB))
-			zram_set_flag(zram, index, ZRAM_IDLE);
+				!zram_test_flag(zram, index, ZRAM_UNDER_WB)) {
+#ifdef CONFIG_ZRAM_MEMORY_TRACKING
+			is_idle = (!cutoff || ktime_after(cutoff, zram->table[index].ac_time));
+#endif
+			if (is_idle)
+				zram_set_flag(zram, index, ZRAM_IDLE);
+		}
 		zram_slot_unlock(zram, index);
 	}
+}
 
-	up_read(&zram->init_lock);
+static ssize_t idle_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	ktime_t cutoff_time = 0;
+	ssize_t rv = -EINVAL;
 
-	return len;
+	if (!sysfs_streq(buf, "all")) {
+#ifdef CONFIG_ZRAM_MEMORY_TRACKING
+		u64 age_sec;
+		/* If it did not parse as 'all' try to treat it as an integer */
+		if (!kstrtoull(buf, 0, &age_sec))
+			cutoff_time = ktime_sub(ktime_get_boottime(),
+					ns_to_ktime(age_sec * NSEC_PER_SEC));
+		else
+#endif
+			goto out;
+	}
+
+	down_read(&zram->init_lock);
+	if (!init_done(zram))
+		goto out_unlock;
+
+	/* A age_sec of 0 marks everything as idle, this is the "all" behavior */
+	mark_idle(zram, cutoff_time);
+	rv = len;
+
+out_unlock:
+	up_read(&zram->init_lock);
+out:
+	return rv;
 }
 
 #ifdef CONFIG_ZRAM_WRITEBACK
_

Patches currently in -mm which might be from bgeffon@google.com are

zram-introduce-an-aged-idle-interface.patch

