Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43CDC7618A
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 19:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjCOTjJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 15:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbjCOTjA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 15:39:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77A2279AE
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 12:38:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82727B81F1F
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 19:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153A5C433EF;
        Wed, 15 Mar 2023 19:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678909136;
        bh=urPS8a1TVmdqWUjhIMOiyeUnxQTrGuRRQfnXvG6SYZU=;
        h=Date:To:From:Subject:From;
        b=f7VInMF3e9Vm91uLP3OaIdZ7+IoH/QYr0AHcZdb01ZPy96lrCaSDGel7NRnpj2A9l
         cky88vUWhr8P7xbX0k6GKbe0MYZ0LYVGjjMtEYPdEfF6H7b5SrqytrSOqIJYCZKVUj
         USNL2XQERjvivGMeAZVKy9XOWex8qKPTltNRRrfw=
Date:   Wed, 15 Mar 2023 12:38:55 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, penberg@kernel.org,
        cl@linux.com, kirill.shutemov@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-slub-fix-max_order-usage-in-calculate_order.patch added to mm-unstable branch
Message-Id: <20230315193856.153A5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: fix MAX_ORDER usage in calculate_order()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-slub-fix-max_order-usage-in-calculate_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-slub-fix-max_order-usage-in-calculate_order.patch

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
Subject: mm/slub: fix MAX_ORDER usage in calculate_order()
Date: Wed, 15 Mar 2023 14:31:31 +0300

MAX_ORDER is not inclusive: the maximum allocation order buddy allocator
can deliver is MAX_ORDER-1.

Fix MAX_ORDER usage in calculate_order().

Link: https://lkml.kernel.org/r/20230315113133.11326-9-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-max_order-usage-in-calculate_order
+++ a/mm/slub.c
@@ -4171,7 +4171,7 @@ static inline int calculate_order(unsign
 	/*
 	 * Doh this slab cannot be placed using slub_max_order.
 	 */
-	order = calc_slab_order(size, 1, MAX_ORDER, 1);
+	order = calc_slab_order(size, 1, MAX_ORDER - 1, 1);
 	if (order < MAX_ORDER)
 		return order;
 	return -ENOSYS;
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

