Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A29C49EA5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75C2E613B1
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhFXUKi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 16:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232120AbhFXUKh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 16:10:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D16961220;
        Thu, 24 Jun 2021 20:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624565297;
        bh=QCWIPTDmH7RKoJ+qXMrHPvwij7/xdlUf5bX9ErXACMY=;
        h=Date:From:To:Subject:From;
        b=R17eEKwNeLcTY9ymGAmvlEyKLP97YGqRMX1Dizph6/HedXVhfecKhuDXsVpQewxrr
         Bg0GgJONS2rNneM52qMhVsQi6sXlLp7jhqYIc6NLlSO4Z31eH/nmn0lHKuBwV256KL
         fqw6CjZ7oylxKCPM0cuumTyFeK1mSX5epPEG8CmI=
Date:   Thu, 24 Jun 2021 13:08:17 -0700
From:   akpm@linux-foundation.org
To:     alexanderduyck@fb.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, david@redhat.com, gshan@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, will@kernel.org
Subject:  [failures]
 mm-page_reporting-allow-driver-to-specify-reporting-order.patch removed
 from -mm tree
Message-ID: <20210624200817.afAhfZEVM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_reporting: allow driver to specify reporting order
has been removed from the -mm tree.  Its filename was
     mm-page_reporting-allow-driver-to-specify-reporting-order.patch

This patch was dropped because it had testing failures

------------------------------------------------------
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

Link: https://lkml.kernel.org/r/20210623023418.350616-4-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>\
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_reporting.h |    3 +++
 mm/page_reporting.c            |    4 ++++
 2 files changed, 7 insertions(+)

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
@@ -329,6 +329,10 @@ int page_reporting_register(struct page_
 		goto err_out;
 	}
 
+	/* Use the page reporting order if it's specified by driver */
+	page_reporting_order = prdev->order ?
+			       prdev->order : page_reporting_order;
+
 	/* initialize state and work structures */
 	atomic_set(&prdev->state, PAGE_REPORTING_IDLE);
 	INIT_DELAYED_WORK(&prdev->work, &page_reporting_process);
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-page_reporting-fix-code-style-in-__page_reporting_request.patch
virtio_balloon-specify-page-reporting-order-if-needed.patch

