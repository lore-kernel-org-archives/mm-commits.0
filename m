Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC8EC4743C
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 04:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9439A608FE
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 04:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhFWEYJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 00:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhFWEYJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 00:24:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1D916135A;
        Wed, 23 Jun 2021 04:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624422112;
        bh=vqJmGenQShrjHe45vJJmX7HUmwI7sstH0h6NncrwDbg=;
        h=Date:From:To:Subject:From;
        b=ALGMOj52qdEdbPMXH4/ZIuIdUU8OqcLDa1TGKsnOOoJBpB4Dst6cD2vtZc/WxqvGC
         c1tECEmKKM/LVcGjwngLDurQMSY01NnNtPtentlxR+BmKQ755LAiAIAGxlzmVr0yVO
         dNRnvR43NVpxvQVO4EMQaStHHY/bA2o9miYrm9RM=
Date:   Tue, 22 Jun 2021 21:21:51 -0700
From:   akpm@linux-foundation.org
To:     alexanderduyck@fb.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, david@redhat.com, gshan@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, will@kernel.org
Subject:  +
 mm-page_reporting-allow-driver-to-specify-reporting-order.patch added to
 -mm tree
Message-ID: <20210623042151.4XBDmT99G%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_reporting: allow driver to specify reporting order
has been added to the -mm tree.  Its filename is
     mm-page_reporting-allow-driver-to-specify-reporting-order.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_reporting-allow-driver-to-specify-reporting-order.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_reporting-allow-driver-to-specify-reporting-order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -328,6 +328,10 @@ int page_reporting_register(struct page_
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
mm-page_reporting-export-reporting-order-as-module-parameter.patch
mm-page_reporting-allow-driver-to-specify-reporting-order.patch
virtio_balloon-specify-page-reporting-order-if-needed.patch

