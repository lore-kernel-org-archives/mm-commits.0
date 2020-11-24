Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2096CC2D0E4
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 02:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3C2E20720
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 02:45:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HqTV8Sff"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgKXCpM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 21:45:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbgKXCpL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 21:45:11 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B471120720;
        Tue, 24 Nov 2020 02:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606185910;
        bh=03pOwkrV5H1BorShpkwdTjyHMnIjrtnJvYBESJdM3Vg=;
        h=Date:From:To:Subject:From;
        b=HqTV8Sff71f01qGHgR13420a8KD45k2RmZROtGd4/pmxwoH9f4QAFOMK6rC4Vjyzp
         +9qrEDr7owyQlOJemG95/nNTSM5VPy6P73rNK8q7CRCBfiTl3NyQ450tFObyOtT9+n
         KKxQTgnUJs0d/PtevIrdadsozTyjylud8zvXByaE=
Date:   Mon, 23 Nov 2020 18:45:10 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org
Subject:  + lib-cleanup-kstrto-usage.patch added to -mm tree
Message-ID: <20201124024510.rXbAowod5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: cleanup kstrto*() usage
has been added to the -mm tree.  Its filename is
     lib-cleanup-kstrto-usage.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-cleanup-kstrto-usage.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-cleanup-kstrto-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: lib: cleanup kstrto*() usage

Use proper conversion functions.  kstrto*() variants exist for all
standard types.

Link: https://lkml.kernel.org/r/20201122123410.GB92364@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_firmware.c |    9 +++------
 lib/test_kmod.c     |   26 ++++++++++----------------
 2 files changed, 13 insertions(+), 22 deletions(-)

--- a/lib/test_firmware.c~lib-cleanup-kstrto-usage
+++ a/lib/test_firmware.c
@@ -364,18 +364,15 @@ static ssize_t test_dev_config_show_int(
 
 static int test_dev_config_update_u8(const char *buf, size_t size, u8 *cfg)
 {
+	u8 val;
 	int ret;
-	long new;
 
-	ret = kstrtol(buf, 10, &new);
+	ret = kstrtou8(buf, 10, &val);
 	if (ret)
 		return ret;
 
-	if (new > U8_MAX)
-		return -EINVAL;
-
 	mutex_lock(&test_fw_mutex);
-	*(u8 *)cfg = new;
+	*(u8 *)cfg = val;
 	mutex_unlock(&test_fw_mutex);
 
 	/* Always return full write size even if we didn't consume all */
--- a/lib/test_kmod.c~lib-cleanup-kstrto-usage
+++ a/lib/test_kmod.c
@@ -877,20 +877,17 @@ static int test_dev_config_update_uint_s
 					    int (*test_sync)(struct kmod_test_device *test_dev))
 {
 	int ret;
-	unsigned long new;
+	unsigned int val;
 	unsigned int old_val;
 
-	ret = kstrtoul(buf, 10, &new);
+	ret = kstrtouint(buf, 10, &val);
 	if (ret)
 		return ret;
 
-	if (new > UINT_MAX)
-		return -EINVAL;
-
 	mutex_lock(&test_dev->config_mutex);
 
 	old_val = *config;
-	*(unsigned int *)config = new;
+	*(unsigned int *)config = val;
 
 	ret = test_sync(test_dev);
 	if (ret) {
@@ -914,18 +911,18 @@ static int test_dev_config_update_uint_r
 					     unsigned int min,
 					     unsigned int max)
 {
+	unsigned int val;
 	int ret;
-	unsigned long new;
 
-	ret = kstrtoul(buf, 10, &new);
+	ret = kstrtouint(buf, 10, &val);
 	if (ret)
 		return ret;
 
-	if (new < min || new > max)
+	if (val < min || val > max)
 		return -EINVAL;
 
 	mutex_lock(&test_dev->config_mutex);
-	*config = new;
+	*config = val;
 	mutex_unlock(&test_dev->config_mutex);
 
 	/* Always return full write size even if we didn't consume all */
@@ -936,18 +933,15 @@ static int test_dev_config_update_int(st
 				      const char *buf, size_t size,
 				      int *config)
 {
+	int val;
 	int ret;
-	long new;
 
-	ret = kstrtol(buf, 10, &new);
+	ret = kstrtoint(buf, 10, &val);
 	if (ret)
 		return ret;
 
-	if (new < INT_MIN || new > INT_MAX)
-		return -EINVAL;
-
 	mutex_lock(&test_dev->config_mutex);
-	*config = new;
+	*config = val;
 	mutex_unlock(&test_dev->config_mutex);
 	/* Always return full write size even if we didn't consume all */
 	return size;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ramfs-support-o_tmpfile.patch
mm-cleanup-kstrto-usage.patch
lib-cleanup-kstrto-usage.patch

