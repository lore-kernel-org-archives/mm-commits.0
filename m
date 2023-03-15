Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6001C6FD1D
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 19:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbjCOTi7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 15:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjCOTiw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 15:38:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8143C5BD92
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 12:38:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1741F61E65
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 19:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69834C433D2;
        Wed, 15 Mar 2023 19:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678909130;
        bh=N4dDsJRfEjOW/wHn2kPtfjc+JjWTruR/MrdgrlXusnc=;
        h=Date:To:From:Subject:From;
        b=JvHA7dYi5T090+lJaqA/Q2qkwe5qA1ku57HSgL9eJupCjxamdUz/ZH/a78iqIHRuo
         Z9lyDY9NhSdkBNP/19N2rppKlrFWRuv6B4pktQxjHkUUFh/zfd6pxMlPefjziT/N1h
         Qsv+pMpcjPwbEym7rGCiiQTcbifbJA+CEsI1syyE=
Date:   Wed, 15 Mar 2023 12:38:49 -0700
To:     mm-commits@vger.kernel.org, haver@linux.ibm.com,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + genwqe-fix-max_order-usage.patch added to mm-unstable branch
Message-Id: <20230315193850.69834C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: genwqe: fix MAX_ORDER usage
has been added to the -mm mm-unstable branch.  Its filename is
     genwqe-fix-max_order-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/genwqe-fix-max_order-usage.patch

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
Subject: genwqe: fix MAX_ORDER usage
Date: Wed, 15 Mar 2023 14:31:28 +0300

MAX_ORDER is not inclusive: the maximum allocation order buddy allocator
can deliver is MAX_ORDER-1.

Fix MAX_ORDER usage in genwqe driver.

Link: https://lkml.kernel.org/r/20230315113133.11326-6-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Frank Haverkamp <haver@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/genwqe/card_dev.c   |    2 +-
 drivers/misc/genwqe/card_utils.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/misc/genwqe/card_dev.c~genwqe-fix-max_order-usage
+++ a/drivers/misc/genwqe/card_dev.c
@@ -443,7 +443,7 @@ static int genwqe_mmap(struct file *filp
 	if (vsize == 0)
 		return -EINVAL;
 
-	if (get_order(vsize) > MAX_ORDER)
+	if (get_order(vsize) >= MAX_ORDER)
 		return -ENOMEM;
 
 	dma_map = kzalloc(sizeof(struct dma_mapping), GFP_KERNEL);
--- a/drivers/misc/genwqe/card_utils.c~genwqe-fix-max_order-usage
+++ a/drivers/misc/genwqe/card_utils.c
@@ -308,7 +308,7 @@ int genwqe_alloc_sync_sgl(struct genwqe_
 	sgl->write = write;
 	sgl->sgl_size = genwqe_sgl_size(sgl->nr_pages);
 
-	if (get_order(sgl->sgl_size) > MAX_ORDER) {
+	if (get_order(sgl->sgl_size) >= MAX_ORDER) {
 		dev_err(&pci_dev->dev,
 			"[%s] err: too much memory requested!\n", __func__);
 		return ret;
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

