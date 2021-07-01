Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFE3C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 751A261469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238454AbhGABxS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:53:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238452AbhGABxS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:53:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8852E6105A;
        Thu,  1 Jul 2021 01:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104248;
        bh=z3Z39tCLifEa5QUv67IYFRRwi8ywQ7lTDjexKpXSuhM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Spri/IJKJju+xA3f+ZNv/LzXi3EMBrOeyaelOw+ZV4s7+APWri7VkZt63e/o44faJ
         v0DSB04/IF0XgZkZi/JcaA8dnXZ/+U0P2Z91+ctGA3xz1yQxBKW5xc5OTB8K1k0fxC
         3KnIxdpRPf7YbM7VNV7dtr/h0AgwL4P3mZSD2EfQ=
Date:   Wed, 30 Jun 2021 18:50:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yuehaibing@huawei.com
Subject:  [patch 068/192] mm/compaction: use DEVICE_ATTR_WO macro
Message-ID: <20210701015048.s99_O6WH0%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
