Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F00CC6FA8B
	for <mm-commits@archiver.kernel.org>; Wed, 21 Sep 2022 19:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiIUTym (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Sep 2022 15:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiIUTyk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2022 15:54:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393871A800
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 12:54:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FCB2B832AC
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 19:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79E0C433D6;
        Wed, 21 Sep 2022 19:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663790074;
        bh=nWV9jEpZQXajQ4Cbg2f75oSHvNcJOXjAkHziKxJZptQ=;
        h=Date:To:From:Subject:From;
        b=qzukhP4yunCA5SKbWbxAmsdEqgIFit1DjoTMxeCvR32U/0ME2oXeHdti/FrhPuQkP
         f0ZE0n+AWgWNoM/PQ9dwU3dTLg7+U9k4uop04OXafnV9Atv4hmT1u5npu52qduhzPi
         +Xd9m+NloPlqY7erIWHFiWYPoHgkZsTCjAL+95hY=
Date:   Wed, 21 Sep 2022 12:54:33 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-return-err-value-when-call-kstrtoul-failed.patch added to mm-unstable branch
Message-Id: <20220921195434.A79E0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: return 'err' value when call kstrtoul() failed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-return-err-value-when-call-kstrtoul-failed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-return-err-value-when-call-kstrtoul-failed.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

mm-damon-simply-damon_ctx-check-in-damon_sysfs_before_terminate.patch
mm-damon-remove-duplicate-get_monitoring_region-definitions.patch
mm-damon-sysfs-change-few-functions-execute-order.patch
mm-damon-simplify-scheme-create-in-damon_lru_sort_apply_parameters.patch
mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly.patch
mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly-fix.patch
mm-damon-simplify-scheme-create-in-lru_sortc.patch
mm-damon-sysfs-return-err-value-when-call-kstrtoul-failed.patch

