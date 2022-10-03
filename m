Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32CC1C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJCVQh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiJCVOg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122351D31B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A7326118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7226C433D6;
        Mon,  3 Oct 2022 21:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831388;
        bh=LP8IQqi8g8JNUQPLCcXZ8k1YuR5BUNG/ig/Q9sdEJfM=;
        h=Date:To:From:Subject:From;
        b=Wm3vTabdDjueGbT1L+nZPvt9my3l5jDH6c3fiQC0sheU7bFOVW/A4dH9OI3JP8RLF
         q81TF3WyEkTU34ZcouUgezT2YfLTXQ6/W4EFULjaEzbz0OL0xrTAsxSPFvnGvc4Mpe
         pssgB8WTRh8I7fdU8bZzIQ0Qik2YI/Mj/lTTUS3k=
Date:   Mon, 03 Oct 2022 14:09:48 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-return-err-value-when-call-kstrtoul-failed.patch removed from -mm tree
Message-Id: <20221003210948.D7226C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: return 'err' value when call kstrtoul() failed
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-return-err-value-when-call-kstrtoul-failed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon/sysfs: return 'err' value when call kstrtoul() failed
Date: Tue, 20 Sep 2022 16:35:30 +0000

We had better return the 'err' value when calling kstrtoul() failed, so
the user will know why it really fails, there do little change, let it
return the 'err' value when failed.

Link: https://lkml.kernel.org/r/6329ebe0.050a0220.ec4bd.297cSMTPIN_ADDED_BROKEN@mx.google.com
Suggested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   46 +++++++++++++--------------------------------
 1 file changed, 14 insertions(+), 32 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-return-err-value-when-call-kstrtoul-failed
+++ a/mm/damon/sysfs.c
@@ -58,7 +58,7 @@ static ssize_t min_store(struct kobject
 
 	err = kstrtoul(buf, 0, &min);
 	if (err)
-		return -EINVAL;
+		return err;
 
 	range->min = min;
 	return count;
@@ -83,7 +83,7 @@ static ssize_t max_store(struct kobject
 
 	err = kstrtoul(buf, 0, &max);
 	if (err)
-		return -EINVAL;
+		return err;
 
 	range->max = max;
 	return count;
@@ -291,9 +291,7 @@ static ssize_t interval_us_store(struct
 			struct damon_sysfs_watermarks, kobj);
 	int err = kstrtoul(buf, 0, &watermarks->interval_us);
 
-	if (err)
-		return -EINVAL;
-	return count;
+	return err ? err : count;
 }
 
 static ssize_t high_show(struct kobject *kobj,
@@ -312,9 +310,7 @@ static ssize_t high_store(struct kobject
 			struct damon_sysfs_watermarks, kobj);
 	int err = kstrtoul(buf, 0, &watermarks->high);
 
-	if (err)
-		return -EINVAL;
-	return count;
+	return err ? err : count;
 }
 
 static ssize_t mid_show(struct kobject *kobj,
@@ -333,9 +329,7 @@ static ssize_t mid_store(struct kobject
 			struct damon_sysfs_watermarks, kobj);
 	int err = kstrtoul(buf, 0, &watermarks->mid);
 
-	if (err)
-		return -EINVAL;
-	return count;
+	return err ? err : count;
 }
 
 static ssize_t low_show(struct kobject *kobj,
@@ -354,9 +348,7 @@ static ssize_t low_store(struct kobject
 			struct damon_sysfs_watermarks, kobj);
 	int err = kstrtoul(buf, 0, &watermarks->low);
 
-	if (err)
-		return -EINVAL;
-	return count;
+	return err ? err : count;
 }
 
 static void damon_sysfs_watermarks_release(struct kobject *kobj)
@@ -437,9 +429,7 @@ static ssize_t sz_permil_store(struct ko
 			struct damon_sysfs_weights, kobj);
 	int err = kstrtouint(buf, 0, &weights->sz);
 
-	if (err)
-		return -EINVAL;
-	return count;
+	return err ? err : count;
 }
 
 static ssize_t nr_accesses_permil_show(struct kobject *kobj,
@@ -458,9 +448,7 @@ static ssize_t nr_accesses_permil_store(
 			struct damon_sysfs_weights, kobj);
 	int err = kstrtouint(buf, 0, &weights->nr_accesses);
 
-	if (err)
-		return -EINVAL;
-	return count;
+	return err ? err : count;
 }
 
 static ssize_t age_permil_show(struct kobject *kobj,
@@ -479,9 +467,7 @@ static ssize_t age_permil_store(struct k
 			struct damon_sysfs_weights, kobj);
 	int err = kstrtouint(buf, 0, &weights->age);
 
-	if (err)
-		return -EINVAL;
-	return count;
+	return err ? err : count;
 }
 
 static void damon_sysfs_weights_release(struct kobject *kobj)
@@ -1111,9 +1097,7 @@ static ssize_t start_store(struct kobjec
 			struct damon_sysfs_region, kobj);
 	int err = kstrtoul(buf, 0, &region->start);
 
-	if (err)
-		return -EINVAL;
-	return count;
+	return err ? err : count;
 }
 
 static ssize_t end_show(struct kobject *kobj, struct kobj_attribute *attr,
@@ -1132,9 +1116,7 @@ static ssize_t end_store(struct kobject
 			struct damon_sysfs_region, kobj);
 	int err = kstrtoul(buf, 0, &region->end);
 
-	if (err)
-		return -EINVAL;
-	return count;
+	return err ? err : count;
 }
 
 static void damon_sysfs_region_release(struct kobject *kobj)
@@ -1528,7 +1510,7 @@ static ssize_t sample_us_store(struct ko
 	int err = kstrtoul(buf, 0, &us);
 
 	if (err)
-		return -EINVAL;
+		return err;
 
 	intervals->sample_us = us;
 	return count;
@@ -1552,7 +1534,7 @@ static ssize_t aggr_us_store(struct kobj
 	int err = kstrtoul(buf, 0, &us);
 
 	if (err)
-		return -EINVAL;
+		return err;
 
 	intervals->aggr_us = us;
 	return count;
@@ -1576,7 +1558,7 @@ static ssize_t update_us_store(struct ko
 	int err = kstrtoul(buf, 0, &us);
 
 	if (err)
-		return -EINVAL;
+		return err;
 
 	intervals->update_us = us;
 	return count;
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-move-sz_damon_region-to-damon_sz_region.patch
mm-damon-use-damon_sz_region-in-appropriate-place.patch

