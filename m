Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28BEC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82178223C8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgLODQe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:16:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727584AbgLODPo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:15:44 -0500
Date:   Mon, 14 Dec 2020 19:15:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002104;
        bh=3ettw/Jabd+YzXlBoUPUUrPfGJd1IfCcFkqvs8N/4fo=;
        h=From:To:Subject:In-Reply-To:From;
        b=UUOQoBNKFZuzHT2ya83UeiPBdnCc2+7SjG8Z0cYvckw/S13bxfDT1EPIzfHlCPvqc
         DV8jB8Zjf2xQRJ4N8egEckIlnl/SzuQMufZ9HR7Vii8PHJK9jVomiH9aBI7NTw4coV
         HzTc+yjvV/TgxC1CGRv/W7XoXQ7fsiGoE8PGkvDI=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 200/200] mm: cleanup kstrto*() usage
Message-ID: <20201215031503.kxArEpIOW%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: mm: cleanup kstrto*() usage

Range checks can folded into proper conversion function.  kstrto*() exist
for all arithmetic types.

Link: https://lkml.kernel.org/r/20201122123759.GC92364@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   18 +++++++++---------
 mm/ksm.c        |   18 +++++++++---------
 2 files changed, 18 insertions(+), 18 deletions(-)

--- a/mm/khugepaged.c~mm-cleanup-kstrto-usage
+++ a/mm/khugepaged.c
@@ -133,11 +133,11 @@ static ssize_t scan_sleep_millisecs_stor
 					  struct kobj_attribute *attr,
 					  const char *buf, size_t count)
 {
-	unsigned long msecs;
+	unsigned int msecs;
 	int err;
 
-	err = kstrtoul(buf, 10, &msecs);
-	if (err || msecs > UINT_MAX)
+	err = kstrtouint(buf, 10, &msecs);
+	if (err)
 		return -EINVAL;
 
 	khugepaged_scan_sleep_millisecs = msecs;
@@ -161,11 +161,11 @@ static ssize_t alloc_sleep_millisecs_sto
 					   struct kobj_attribute *attr,
 					   const char *buf, size_t count)
 {
-	unsigned long msecs;
+	unsigned int msecs;
 	int err;
 
-	err = kstrtoul(buf, 10, &msecs);
-	if (err || msecs > UINT_MAX)
+	err = kstrtouint(buf, 10, &msecs);
+	if (err)
 		return -EINVAL;
 
 	khugepaged_alloc_sleep_millisecs = msecs;
@@ -188,11 +188,11 @@ static ssize_t pages_to_scan_store(struc
 				   struct kobj_attribute *attr,
 				   const char *buf, size_t count)
 {
+	unsigned int pages;
 	int err;
-	unsigned long pages;
 
-	err = kstrtoul(buf, 10, &pages);
-	if (err || !pages || pages > UINT_MAX)
+	err = kstrtouint(buf, 10, &pages);
+	if (err || !pages)
 		return -EINVAL;
 
 	khugepaged_pages_to_scan = pages;
--- a/mm/ksm.c~mm-cleanup-kstrto-usage
+++ a/mm/ksm.c
@@ -2840,11 +2840,11 @@ static ssize_t sleep_millisecs_store(str
 				     struct kobj_attribute *attr,
 				     const char *buf, size_t count)
 {
-	unsigned long msecs;
+	unsigned int msecs;
 	int err;
 
-	err = kstrtoul(buf, 10, &msecs);
-	if (err || msecs > UINT_MAX)
+	err = kstrtouint(buf, 10, &msecs);
+	if (err)
 		return -EINVAL;
 
 	ksm_thread_sleep_millisecs = msecs;
@@ -2864,11 +2864,11 @@ static ssize_t pages_to_scan_store(struc
 				   struct kobj_attribute *attr,
 				   const char *buf, size_t count)
 {
+	unsigned int nr_pages;
 	int err;
-	unsigned long nr_pages;
 
-	err = kstrtoul(buf, 10, &nr_pages);
-	if (err || nr_pages > UINT_MAX)
+	err = kstrtouint(buf, 10, &nr_pages);
+	if (err)
 		return -EINVAL;
 
 	ksm_thread_pages_to_scan = nr_pages;
@@ -2886,11 +2886,11 @@ static ssize_t run_show(struct kobject *
 static ssize_t run_store(struct kobject *kobj, struct kobj_attribute *attr,
 			 const char *buf, size_t count)
 {
+	unsigned int flags;
 	int err;
-	unsigned long flags;
 
-	err = kstrtoul(buf, 10, &flags);
-	if (err || flags > UINT_MAX)
+	err = kstrtouint(buf, 10, &flags);
+	if (err)
 		return -EINVAL;
 	if (flags > KSM_RUN_UNMERGE)
 		return -EINVAL;
_
