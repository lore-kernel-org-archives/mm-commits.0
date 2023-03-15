Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4CCC61DA4
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 19:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbjCOTi6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 15:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbjCOTiw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 15:38:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DAC279AE
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 12:38:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4A44B81F1F
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 19:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828CAC433D2;
        Wed, 15 Mar 2023 19:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678909128;
        bh=BSdjzwwkiDEmJmghqk9pMcnTxZ7D7iJheyP8OpY5yFU=;
        h=Date:To:From:Subject:From;
        b=2NFXoxwwniDaMO8z/MGvTrSxF8AMRcSrFtfc8ZSce3Nhs249J2W70SxxJ2w2ShVrN
         dvywJRUoj1Er0dgf0FZ/UbbdwHSYYinkCmlEk0tCqcAygE8q7JH2makF5wQ1UrFux9
         /e+GFQBNBZ6QJ6oYwINN5jt2RdtVSpYFWnl/szfI=
Date:   Wed, 15 Mar 2023 12:38:48 -0700
To:     mm-commits@vger.kernel.org, tvrtko.ursulin@intel.com,
        rodrigo.vivi@intel.com, joonas.lahtinen@linux.intel.com,
        jani.nikula@linux.intel.com, kirill.shutemov@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-i915-fix-max_order-usage-in-i915_gem_object_get_pages_internal.patch added to mm-unstable branch
Message-Id: <20230315193848.828CAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm/i915: fix MAX_ORDER usage in i915_gem_object_get_pages_internal()
has been added to the -mm mm-unstable branch.  Its filename is
     drm-i915-fix-max_order-usage-in-i915_gem_object_get_pages_internal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-i915-fix-max_order-usage-in-i915_gem_object_get_pages_internal.patch

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
Subject: drm/i915: fix MAX_ORDER usage in i915_gem_object_get_pages_internal()
Date: Wed, 15 Mar 2023 14:31:27 +0300

MAX_ORDER is not inclusive: the maximum allocation order buddy allocator
can deliver is MAX_ORDER-1.

Fix MAX_ORDER usage in i915_gem_object_get_pages_internal().

Link: https://lkml.kernel.org/r/20230315113133.11326-5-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_internal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_internal.c~drm-i915-fix-max_order-usage-in-i915_gem_object_get_pages_internal
+++ a/drivers/gpu/drm/i915/gem/i915_gem_internal.c
@@ -36,7 +36,7 @@ static int i915_gem_object_get_pages_int
 	struct sg_table *st;
 	struct scatterlist *sg;
 	unsigned int npages; /* restricted by sg_alloc_table */
-	int max_order = MAX_ORDER;
+	int max_order = MAX_ORDER - 1;
 	unsigned int max_segment;
 	gfp_t gfp;
 
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

