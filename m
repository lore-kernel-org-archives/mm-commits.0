Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAC3C48BC2
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 04:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACBED6135A
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 04:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhFWEYG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 00:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhFWEYG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 00:24:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC4C160720;
        Wed, 23 Jun 2021 04:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624422109;
        bh=MYosILNRrKwFsco9ZXeuaAHBPFSot4VIvQ0xTN/Ku90=;
        h=Date:From:To:Subject:From;
        b=iZFFtCyRqHKlQYLY4S4TTtoTQTyBCIET/6YVDV0wbt/q1tpyiDUO0hiBpj1T98zPb
         5/UTeD0qLkNeytF4FZhtW3lLOBieGJpautqaBmsUx11fMyhmxRqlCIX25Je9rP/9pO
         ehtELj0VKjNLxpSOlqcOlILgnBNCqfmZzlO81dIU=
Date:   Tue, 22 Jun 2021 21:21:48 -0700
From:   akpm@linux-foundation.org
To:     alexanderduyck@fb.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, david@redhat.com, gshan@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, will@kernel.org
Subject:  +
 mm-page_reporting-export-reporting-order-as-module-parameter.patch added to
 -mm tree
Message-ID: <20210623042148.w-M4RDjnx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_reporting: export reporting order as module parameter
has been added to the -mm tree.  Its filename is
     mm-page_reporting-export-reporting-order-as-module-parameter.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_reporting-export-reporting-order-as-module-parameter.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_reporting-export-reporting-order-as-module-parameter.patch

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
Subject: mm/page_reporting: export reporting order as module parameter

The macro PAGE_REPORTING_MIN_ORDER is defined as the page reporting
threshold.  It can't be adjusted at runtime.

This introduces a variable (@page_reporting_order) to replace the marcro
(PAGE_REPORTING_MIN_ORDER).  It's also exported so that the page reporting
order can be adjusted at runtime.

Link: https://lkml.kernel.org/r/20210623023418.350616-3-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    6 ++++++
 mm/page_reporting.c                             |    8 ++++++--
 mm/page_reporting.h                             |    5 ++---
 3 files changed, 14 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-page_reporting-export-reporting-order-as-module-parameter
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -3566,6 +3566,12 @@
 			off: turn off poisoning (default)
 			on: turn on poisoning
 
+	page_reporting.page_reporting_order=
+			[KNL] Minimal page reporting order
+			Format: <integer>
+			Adjust the minimal page reporting order. The page
+			reporting is disabled when it exceeds (MAX_ORDER-1).
+
 	panic=		[KNL] Kernel behaviour on panic: delay <timeout>
 			timeout > 0: seconds before rebooting
 			timeout = 0: wait forever
--- a/mm/page_reporting.c~mm-page_reporting-export-reporting-order-as-module-parameter
+++ a/mm/page_reporting.c
@@ -10,6 +10,10 @@
 #include "page_reporting.h"
 #include "internal.h"
 
+unsigned int page_reporting_order = pageblock_order;
+module_param(page_reporting_order, uint, 0644);
+MODULE_PARM_DESC(page_reporting_order, "Set page reporting order");
+
 #define PAGE_REPORTING_DELAY	(2 * HZ)
 static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
 
@@ -229,7 +233,7 @@ page_reporting_process_zone(struct page_
 
 	/* Generate minimum watermark to be able to guarantee progress */
 	watermark = low_wmark_pages(zone) +
-		    (PAGE_REPORTING_CAPACITY << PAGE_REPORTING_MIN_ORDER);
+		    (PAGE_REPORTING_CAPACITY << page_reporting_order);
 
 	/*
 	 * Cancel request if insufficient free memory or if we failed
@@ -239,7 +243,7 @@ page_reporting_process_zone(struct page_
 		return err;
 
 	/* Process each free list starting from lowest order/mt */
-	for (order = PAGE_REPORTING_MIN_ORDER; order < MAX_ORDER; order++) {
+	for (order = page_reporting_order; order < MAX_ORDER; order++) {
 		for (mt = 0; mt < MIGRATE_TYPES; mt++) {
 			/* We do not pull pages from the isolate free list */
 			if (is_migrate_isolate(mt))
--- a/mm/page_reporting.h~mm-page_reporting-export-reporting-order-as-module-parameter
+++ a/mm/page_reporting.h
@@ -10,10 +10,9 @@
 #include <linux/pgtable.h>
 #include <linux/scatterlist.h>
 
-#define PAGE_REPORTING_MIN_ORDER	pageblock_order
-
 #ifdef CONFIG_PAGE_REPORTING
 DECLARE_STATIC_KEY_FALSE(page_reporting_enabled);
+extern unsigned int page_reporting_order;
 void __page_reporting_notify(void);
 
 static inline bool page_reported(struct page *page)
@@ -38,7 +37,7 @@ static inline void page_reporting_notify
 		return;
 
 	/* Determine if we have crossed reporting threshold */
-	if (order < PAGE_REPORTING_MIN_ORDER)
+	if (order < page_reporting_order)
 		return;
 
 	/* This will add a few cycles, but should be called infrequently */
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-page_reporting-fix-code-style-in-__page_reporting_request.patch
mm-page_reporting-export-reporting-order-as-module-parameter.patch
mm-page_reporting-allow-driver-to-specify-reporting-order.patch
virtio_balloon-specify-page-reporting-order-if-needed.patch

