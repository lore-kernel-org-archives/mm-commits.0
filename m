Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C03C11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F150F61D06
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhF2Chw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231823AbhF2Chu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:37:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16AE461D03;
        Tue, 29 Jun 2021 02:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934123;
        bh=uK0vqUV5XlURDJYnUk/CTr0GZMB10MWdtWUOrju/YxY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=12ZtBJzadGeDXZjDtK0O/5j17IZ8b1AvJPUyrT5oP2xxWfvtvelc6B1K5eSexCW5g
         WWp39qRcklgY8kQQEmc87NDMdnCiA3WedTtktRn8Wos5Rj0vwkk3qzyrnpC/L5d6GB
         35D0BMHvByzVA2YCXK+3HaCd1T3dvnKtH/2dYkc8=
Date:   Mon, 28 Jun 2021 19:35:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexanderduyck@fb.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com,
        david@redhat.com, gshan@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mst@redhat.com,
        torvalds@linux-foundation.org, will@kernel.org
Subject:  [patch 040/192] mm/page_reporting: allow driver to
 specify reporting order
Message-ID: <20210629023522.OzFzy73av%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Gavin Shan <gshan@redhat.com>
Subject: mm/page_reporting: allow driver to specify reporting order

The page reporting order (threshold) is sticky to @pageblock_order by
default.  The page reporting can never be triggered because the freeing
page can't come up with a free area like that huge.  The situation becomes
worse when the system memory becomes heavily fragmented.

For example, the following configurations are used on ARM64 when 64KB base
page size is enabled.  In this specific case, the page reporting won't be
triggered until the freeing page comes up with a 512MB free area.  That's
hard to be met, especially when the system memory becomes heavily
fragmented.

   PAGE_SIZE:          64KB
   HPAGE_SIZE:         512MB
   pageblock_order:    13       (512MB)
   MAX_ORDER:          14

This allows the drivers to specify the page reporting order when the page
reporting device is registered.  It falls back to @pageblock_order if it's
not specified by the driver.  The existing users (hv_balloon and
virtio_balloon) don't specify it and @pageblock_order is still taken as
their page reporting order.  So this shouldn't introduce any functional
changes.

Link: https://lkml.kernel.org/r/20210625014710.42954-4-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_reporting.h |    3 +++
 mm/page_reporting.c            |    6 ++++++
 2 files changed, 9 insertions(+)

--- a/include/linux/page_reporting.h~mm-page_reporting-allow-driver-to-specify-reporting-order
+++ a/include/linux/page_reporting.h
@@ -18,6 +18,9 @@ struct page_reporting_dev_info {
 
 	/* Current state of page reporting */
 	atomic_t state;
+
+	/* Minimal order of page reporting */
+	unsigned int order;
 };
 
 /* Tear-down and bring-up for page reporting devices */
--- a/mm/page_reporting.c~mm-page_reporting-allow-driver-to-specify-reporting-order
+++ a/mm/page_reporting.c
@@ -329,6 +329,12 @@ int page_reporting_register(struct page_
 		goto err_out;
 	}
 
+	/*
+	 * Update the page reporting order if it's specified by driver.
+	 * Otherwise, it falls back to @pageblock_order.
+	 */
+	page_reporting_order = prdev->order ? : pageblock_order;
+
 	/* initialize state and work structures */
 	atomic_set(&prdev->state, PAGE_REPORTING_IDLE);
 	INIT_DELAYED_WORK(&prdev->work, &page_reporting_process);
_
