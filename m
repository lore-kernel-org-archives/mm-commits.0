Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C060C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 20:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F86164DCC
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 20:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhA1Ujf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jan 2021 15:39:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:54316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229831AbhA1Uja (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Jan 2021 15:39:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE95E64DCC;
        Thu, 28 Jan 2021 20:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611866329;
        bh=zk5Ya2cBNfVuTeHIzsKFrCdtL13ZETSYwTGvUAczjo8=;
        h=Date:From:To:Subject:From;
        b=vBX47fXqhgYuLSKEQgw6KhwYmbcNf2ZcSA5Pgy8DALEgHLJ+rTPNMC3/2hXBIFiow
         1t8DGoIwgeskyOTj/diJDqoga6DEEhJhvd3Z62YgQr5RFVKQH8awZ+iMyb5od2evd4
         nOvv07oLZntAYN47ud1vA5n6bmIkIffwybX9F5ZQ=
Date:   Thu, 28 Jan 2021 12:38:48 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        osalvador@suse.de, peterz@infradead.org,
        richard.weiyang@linux.alibaba.com, rppt@kernel.org,
        tglx@linutronix.de
Subject:  +
 =?US-ASCII?Q?mm-page=5Falloc-count-cma-pages-per-zone-and-print-them-i?=
 =?US-ASCII?Q?n-proc-zoneinfo-v2.patch?= added to -mm tree
Message-ID: <20210128203848.DTm_Nf6Wo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v2
has been added to the -mm tree.  Its filename is
     mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v2

- Print/track only with CONFIG_CMA
- Extend patch description

Link: https://lkml.kernel.org/r/20210128164533.18566-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/vmstat.c            |    9 ++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v2
+++ a/include/linux/mmzone.h
@@ -530,7 +530,9 @@ struct zone {
 	atomic_long_t		managed_pages;
 	unsigned long		spanned_pages;
 	unsigned long		present_pages;
+#ifdef CONFIG_CMA
 	unsigned long		cma_pages;
+#endif
 
 	const char		*name;
 
--- a/mm/vmstat.c~mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v2
+++ a/mm/vmstat.c
@@ -1637,16 +1637,19 @@ static void zoneinfo_show_print(struct s
 		   "\n        high     %lu"
 		   "\n        spanned  %lu"
 		   "\n        present  %lu"
-		   "\n        managed  %lu"
-		   "\n        cma      %lu",
+		   "\n        managed  %lu",
 		   zone_page_state(zone, NR_FREE_PAGES),
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
 		   zone->spanned_pages,
 		   zone->present_pages,
-		   zone_managed_pages(zone),
+		   zone_managed_pages(zone));
+#ifdef CONFIG_CMA
+	seq_printf(m,
+		   "\n        cma      %lu",
 		   zone->cma_pages);
+#endif
 
 	seq_printf(m,
 		   "\n        protection: (%ld",
_

Patches currently in -mm which might be from david@redhat.com are

video-fbdev-acornfb-remove-free_unused_pages.patch
mm-simplify-free_highmem_page-and-free_reserved_page.patch
mm-cma-expose-all-pages-to-the-buddy-if-activation-of-an-area-fails.patch
mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo.patch
mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v2.patch
mm-memory_hotplug-memhp_merge_resource-mhp_merge_resource.patch

