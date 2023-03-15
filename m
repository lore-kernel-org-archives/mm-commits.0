Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79AD7C61DA4
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 19:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjCOTis (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 15:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbjCOTir (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 15:38:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE8C19F2F
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 12:38:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C120FB81F1D
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 19:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F31EC433D2;
        Wed, 15 Mar 2023 19:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678909123;
        bh=WN88nOsylLSu+F76qm6/8E4XvnqrOkdDJSWTZZAAAVs=;
        h=Date:To:From:Subject:From;
        b=oKjrxnxp8RFgiJoYgILo+JvPsQAxTJRzN3AWuviKTKfknUanAWMoimaThLso1ty4P
         cpP2Xwarc5EZlqdbaVU0ymChveKXZkxx98gAZz+yYNLfKFjHhP+uSU/rqVOK1VypQ9
         Wph9ePtu1FQJdNtsjRNmBGuHP7Km0lwuiY2iF0z8=
Date:   Wed, 15 Mar 2023 12:38:42 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mgorman@suse.de,
        david@redhat.com, davem@davemloft.net,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-mm-fix-max_order-usage-in-tsb_grow.patch added to mm-unstable branch
Message-Id: <20230315193843.4F31EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sparc/mm: fix MAX_ORDER usage in tsb_grow()
has been added to the -mm mm-unstable branch.  Its filename is
     sparc-mm-fix-max_order-usage-in-tsb_grow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc-mm-fix-max_order-usage-in-tsb_grow.patch

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
Subject: sparc/mm: fix MAX_ORDER usage in tsb_grow()
Date: Wed, 15 Mar 2023 14:31:24 +0300

Patch series "Fix confusion around MAX_ORDER".

MAX_ORDER currently defined as number of orders page allocator supports:
user can ask buddy allocator for page order between 0 and MAX_ORDER-1.

This definition is counter-intuitive and lead to number of bugs all over
the kernel.

Fix the bugs and then change the definition of MAX_ORDER to be
inclusive: the range of orders user can ask from buddy allocator is
0..MAX_ORDER now.


This patch (of 10):

MAX_ORDER is not inclusive: the maximum allocation order buddy allocator
can deliver is MAX_ORDER-1.

Fix MAX_ORDER usage in tsb_grow().

Link: https://lkml.kernel.org/r/20230315113133.11326-1-kirill.shutemov@linux.intel.com
Link: https://lkml.kernel.org/r/20230315113133.11326-2-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Miller <davem@davemloft.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/tsb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/mm/tsb.c~sparc-mm-fix-max_order-usage-in-tsb_grow
+++ a/arch/sparc/mm/tsb.c
@@ -402,8 +402,8 @@ void tsb_grow(struct mm_struct *mm, unsi
 	unsigned long new_rss_limit;
 	gfp_t gfp_flags;
 
-	if (max_tsb_size > (PAGE_SIZE << MAX_ORDER))
-		max_tsb_size = (PAGE_SIZE << MAX_ORDER);
+	if (max_tsb_size > (PAGE_SIZE << (MAX_ORDER - 1)))
+		max_tsb_size = (PAGE_SIZE << (MAX_ORDER - 1));
 
 	new_cache_index = 0;
 	for (new_size = 8192; new_size < max_tsb_size; new_size <<= 1UL) {
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

