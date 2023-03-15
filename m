Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62ADBC61DA4
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 19:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbjCOTjI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 15:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbjCOTi7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 15:38:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F0039B9F
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 12:38:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3319B81F16
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 19:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE82C433D2;
        Wed, 15 Mar 2023 19:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678909134;
        bh=M1r0dlHe0kRoSUcRczVN2gD7VxwK1wPZbtTEI7m08Zk=;
        h=Date:To:From:Subject:From;
        b=RkX/K/wY6REttnw5hbPX3SmPjx9E5kpW4DoIycrponRPawtBPcgtXg/FUcHDFiiZL
         gtklcoRpV2rcg0OGcx85Mw12OEff7EDga/yu9jT1a4vhtFOKT+7vecL09bxXAYTaDc
         rQk+B5OGAvLPaI98KAy8rlo9eH912jJBMITbLOS4=
Date:   Wed, 15 Mar 2023 12:38:53 -0700
To:     mm-commits@vger.kernel.org, alexander.h.duyck@linux.intel.com,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_reporting-fix-max_order-usage-in-page_reporting_register.patch added to mm-unstable branch
Message-Id: <20230315193854.3CE82C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_reporting: fix MAX_ORDER usage in page_reporting_register()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_reporting-fix-max_order-usage-in-page_reporting_register.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_reporting-fix-max_order-usage-in-page_reporting_register.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/page_reporting: fix MAX_ORDER usage in page_reporting_register()
Date: Wed, 15 Mar 2023 14:31:30 +0300

MAX_ORDER is not inclusive: the maximum allocation order buddy allocator
can deliver is MAX_ORDER-1.

Fix MAX_ORDER usage in page_reporting_register().

Link: https://lkml.kernel.org/r/20230315113133.11326-8-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_reporting.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_reporting.c~mm-page_reporting-fix-max_order-usage-in-page_reporting_register
+++ a/mm/page_reporting.c
@@ -370,7 +370,7 @@ int page_reporting_register(struct page_
 	 */
 
 	if (page_reporting_order == -1) {
-		if (prdev->order > 0 && prdev->order <= MAX_ORDER)
+		if (prdev->order > 0 && prdev->order < MAX_ORDER)
 			page_reporting_order = prdev->order;
 		else
 			page_reporting_order = pageblock_order;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

sparc-mm-fix-max_order-usage-in-tsb_grow.patch
um-fix-max_order-usage-in-linux_main.patch
floppy-fix-max_order-usage.patch
drm-i915-fix-max_order-usage-in-i915_gem_object_get_pages_internal.patch
genwqe-fix-max_order-usage.patch
perf-core-fix-max_order-usage-in-rb_alloc_aux_page.patch
mm-page_reporting-fix-max_order-usage-in-page_reporting_register.patch
mm-slub-fix-max_order-usage-in-calculate_order.patch
iommu-fix-max_order-usage-in-__iommu_dma_alloc_pages.patch
mm-treewide-redefine-max_order-sanely.patch

