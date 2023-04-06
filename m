Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E52DAC77B71
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbjDFCpL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbjDFCok (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBC49034
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8A8264272
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3A3C433EF;
        Thu,  6 Apr 2023 02:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749074;
        bh=Ho3CCkts70L2eMclf+vYENhXozUfYH4GFGlB0EauKNc=;
        h=Date:To:From:Subject:From;
        b=nMR4U8wh6l87QnSCgdCpd8ewcVS3dNaTkIFDbOewKye/NxAVje8YlQKWNSOgx5139
         VEIxvW30E+01hJBV54vBQAdHmf5X8etT6h4bXfj0DTQLjGf64C67dt0aPbojnvueMH
         W8E/+DaKRSNleyjQO0fKUzB+zB6iWN695Y22vZvU=
Date:   Wed, 05 Apr 2023 19:44:33 -0700
To:     mm-commits@vger.kernel.org, haver@linux.ibm.com,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] genwqe-fix-max_order-usage.patch removed from -mm tree
Message-Id: <20230406024434.3D3A3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: genwqe: fix MAX_ORDER usage
has been removed from the -mm tree.  Its filename was
     genwqe-fix-max_order-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


