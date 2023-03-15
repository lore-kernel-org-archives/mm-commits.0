Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B43C6FD1D
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 19:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjCOTiv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 15:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbjCOTit (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 15:38:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74F4279AE
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 12:38:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D8DAB81F1E
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 19:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088E3C433EF;
        Wed, 15 Mar 2023 19:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678909125;
        bh=GU9BCrHbhEcPC7SLxoVCfqI/2dqFtytqq5BkvN5jI7c=;
        h=Date:To:From:Subject:From;
        b=fcsf8wQe/3m6OhWi8mqfIdwgVhhdnMo65gpVSOlZPovtUfSTErIH1DxNMKmtY8Fl+
         Uxl9JbpNkMbFHuDhZiC5ESxU3iFiUCGzROIqe6O4kvBPu+iiAHuiKd51AE82oaT/Gh
         t/BCs/Kq5xBswA31smJUjWL9QpGLLigxTXUCpo+I=
Date:   Wed, 15 Mar 2023 12:38:44 -0700
To:     mm-commits@vger.kernel.org, richard@nod.at,
        johannes@sipsolutions.net, anton.ivanov@cambridgegreys.com,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + um-fix-max_order-usage-in-linux_main.patch added to mm-unstable branch
Message-Id: <20230315193845.088E3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: um: fix MAX_ORDER usage in linux_main()
has been added to the -mm mm-unstable branch.  Its filename is
     um-fix-max_order-usage-in-linux_main.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/um-fix-max_order-usage-in-linux_main.patch

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
Subject: um: fix MAX_ORDER usage in linux_main()
Date: Wed, 15 Mar 2023 14:31:25 +0300

MAX_ORDER is not inclusive: the maximum allocation order buddy allocator
can deliver is MAX_ORDER-1.

Fix MAX_ORDER usage in linux_main().

Link: https://lkml.kernel.org/r/20230315113133.11326-3-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/um_arch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/um/kernel/um_arch.c~um-fix-max_order-usage-in-linux_main
+++ a/arch/um/kernel/um_arch.c
@@ -368,10 +368,10 @@ int __init linux_main(int argc, char **a
 	max_physmem = TASK_SIZE - uml_physmem - iomem_size - MIN_VMALLOC;
 
 	/*
-	 * Zones have to begin on a 1 << MAX_ORDER page boundary,
+	 * Zones have to begin on a 1 << MAX_ORDER-1 page boundary,
 	 * so this makes sure that's true for highmem
 	 */
-	max_physmem &= ~((1 << (PAGE_SHIFT + MAX_ORDER)) - 1);
+	max_physmem &= ~((1 << (PAGE_SHIFT + MAX_ORDER - 1)) - 1);
 	if (physmem_size + iomem_size > max_physmem) {
 		highmem = physmem_size + iomem_size - max_physmem;
 		physmem_size -= highmem;
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

