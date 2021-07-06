Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 463A0C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F12A61057
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhGFTPt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhGFTPt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 657AC60C3D;
        Tue,  6 Jul 2021 19:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598790;
        bh=AkV25LtHDlpVUVzzV9H3KiK/hMTU3U6xH+bEjfvE19E=;
        h=Date:From:To:Subject:From;
        b=n64BmsHcK+LhXAJqN76XR/0WSyi4HUxAfQuAFyPbc137C+bBVdyv1gL89cFO2lVfS
         KCUhZlC9Uose8T2KKh/VtVZ1KyL3k9UehWFh2XZlz/RZ8wAWgOnqCd0bLkkVz0vWGZ
         7nb5+OTO7xk3rmr1Oo4VP1kYCjWqbBGbLumbJCbE=
Date:   Tue, 06 Jul 2021 12:13:10 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org,
        yuehaibing@huawei.com
Subject:  [merged] mm-dmapool-use-device_attr_ro-macro.patch
 removed from -mm tree
Message-ID: <20210706191310.m0j4IrtYS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool: use DEVICE_ATTR_RO macro
has been removed from the -mm tree.  Its filename was
     mm-dmapool-use-device_attr_ro-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: mm/dmapool: use DEVICE_ATTR_RO macro

Use DEVICE_ATTR_RO() helper instead of plain DEVICE_ATTR(), which makes
the code a bit shorter and easier to read.

Link: https://lkml.kernel.org/r/20210524112852.34716-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/dmapool.c~mm-dmapool-use-device_attr_ro-macro
+++ a/mm/dmapool.c
@@ -62,8 +62,7 @@ struct dma_page {		/* cacheable header f
 static DEFINE_MUTEX(pools_lock);
 static DEFINE_MUTEX(pools_reg_lock);
 
-static ssize_t
-show_pools(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t pools_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	unsigned temp;
 	unsigned size;
@@ -103,7 +102,7 @@ show_pools(struct device *dev, struct de
 	return PAGE_SIZE - size;
 }
 
-static DEVICE_ATTR(pools, 0444, show_pools, NULL);
+static DEVICE_ATTR_RO(pools);
 
 /**
  * dma_pool_create - Creates a pool of consistent memory blocks, for dma.
_

Patches currently in -mm which might be from yuehaibing@huawei.com are


