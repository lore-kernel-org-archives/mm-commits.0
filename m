Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8E4C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A958C61C91
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhGFTVa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231802AbhGFTV3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:21:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A40661C96;
        Tue,  6 Jul 2021 19:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599130;
        bh=Tj07B7GMtxdHTb43MdKMW2EqI25ItrSlHHtQvePK34o=;
        h=Date:From:To:Subject:From;
        b=FGtKzynU8niBc0aWmuQrEIFQWwqYtbTXBvd+PiustHJ1Xi4vX+McjIOAEO363/G6u
         y8+FmqBNlEdwR4cmfNArqCp0xE/WWhX/t+1fGBXwZxnEvvCWKbYLeFAQWnt21zhMZj
         DA4AzHT42YcFM0vXnLkM35TRwIi0UqMzBeM7IWyo=
Date:   Tue, 06 Jul 2021 12:18:50 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        yuehaibing@huawei.com
Subject:  [merged] mm-compaction-use-device_attr_wo-macro.patch
 removed from -mm tree
Message-ID: <20210706191850.uFAyNEDRd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: use DEVICE_ATTR_WO macro
has been removed from the -mm tree.  Its filename was
     mm-compaction-use-device_attr_wo-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: mm/compaction: use DEVICE_ATTR_WO macro

Use DEVICE_ATTR_WO helper instead of plain DEVICE_ATTR, which makes the
code a bit shorter and easier to read.

Link: https://lkml.kernel.org/r/20210523064521.32912-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/compaction.c~mm-compaction-use-device_attr_wo-macro
+++ a/mm/compaction.c
@@ -2722,9 +2722,9 @@ int sysctl_compaction_handler(struct ctl
 }
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
-static ssize_t sysfs_compact_node(struct device *dev,
-			struct device_attribute *attr,
-			const char *buf, size_t count)
+static ssize_t compact_store(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t count)
 {
 	int nid = dev->id;
 
@@ -2737,7 +2737,7 @@ static ssize_t sysfs_compact_node(struct
 
 	return count;
 }
-static DEVICE_ATTR(compact, 0200, NULL, sysfs_compact_node);
+static DEVICE_ATTR_WO(compact);
 
 int compaction_register_node(struct node *node)
 {
_

Patches currently in -mm which might be from yuehaibing@huawei.com are


