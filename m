Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AAB2C2B9F7
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 23:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02622613D5
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 23:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhEXXzA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 May 2021 19:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhEXXy7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 May 2021 19:54:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3217613D5;
        Mon, 24 May 2021 23:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621900404;
        bh=TLl75kYUthKOmQ0zgnEsuHf4hQUbAwdHUUvYuhLIMvA=;
        h=Date:From:To:Subject:From;
        b=oLOTr9Ugneq1iZ6ML6wBARz+1VITj7QzYFxQH2IencOPf44Y6McrQBR44abdeh3uT
         JEbRieaMT2hv96NYviB1zDPMoQ/Til+4cmLkhoeuU6+4UE59IIQOyV9LKpTXriUl+l
         wDhwNbqCCyuW4JavCo9lkk0kb+lXU+5wS7jDac0A=
Date:   Mon, 24 May 2021 16:53:24 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org,
        yuehaibing@huawei.com
Subject:  + mm-dmapool-use-device_attr_ro-macro.patch added to -mm
 tree
Message-ID: <20210524235324.8iZkCWLZ-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool: use DEVICE_ATTR_RO macro
has been added to the -mm tree.  Its filename is
     mm-dmapool-use-device_attr_ro-macro.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dmapool-use-device_attr_ro-macro.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dmapool-use-device_attr_ro-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-dmapool-use-device_attr_ro-macro.patch

