Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E8DC4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92F7A23137
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgLPEom (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:44:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgLPEom (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:44:42 -0500
Date:   Tue, 15 Dec 2020 20:44:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093841;
        bh=nK3mJsAGEc5JSmti7JtZDqPpcIcy47pmUm1zWVlxHmc=;
        h=From:To:Subject:In-Reply-To:From;
        b=IEoCSUXAAogsleAKfWwuToA8qEvl9rBbBe2ge2jutF9vpA2acVfUDbSJvTuosfXlZ
         0G82Bp9IBvEtYIpVKkfEVt2ynAQgi7jFFBaWE8dcbGA2Ig2BejOlOQOU0SGPep6afl
         u4gviIiGgLexGpzdmd3cIhJuGeyzY33txR3PGqQc=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 31/95] lib: cleanup kstrto*() usage
Message-ID: <20201216044400.HkFl2huRz%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
