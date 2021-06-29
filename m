Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF81C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBBC561D0F
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhF2Cmd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231768AbhF2Cmd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:42:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 991D461D11;
        Tue, 29 Jun 2021 02:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934405;
        bh=Kh+RozrDEmeS7HoyIOlvKb1BSpKQzI5rtJriSqiyOxM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pAbdFiX4CHaRwvXjppXwCMNJL/fSttYoYy81oOuScnkeZXaJ4ILvpB6luQ7a/zGPy
         W6v/6m3ds8NCBbEDcnOwjSp280oBactsO5YtklS/uSYLY1xDs6UsdhQ1BDUsWh9nkI
         uhTOf7vnXUOt8NvUVwb89Tq8GaslK+aVQmUTl03E=
Date:   Mon, 28 Jun 2021 19:40:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, yuehaibing@huawei.com
Subject:  [patch 130/192] mm/dmapool: use DEVICE_ATTR_RO macro
Message-ID: <20210629024005.M33PNIbP9%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
