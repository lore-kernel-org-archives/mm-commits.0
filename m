Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BA2C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbiGRAdQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbiGRAdH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:33:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9DC140C4
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5618160FB0
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83BBC341C0;
        Mon, 18 Jul 2022 00:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104366;
        bh=kUQPi3DZfxs63yr3YWcGwQKYwJ5QWgLH5GuopX8XgVU=;
        h=Date:To:From:Subject:From;
        b=wIzNsiKo41bxk9xcZrlW9B6x6ZkaRYT5Ai8pkrcg94IGJInXc5esgf79i2XhD+8VI
         vIod5L9dcojXakRBhupjJ3uaoSb8jh79ULyl4Cz+tlWP8fEbLsc3PW+dtz1yBeqGG0
         E372wi5i1ifHzDpE5vvYID77ZR6nqwBVi1ZMp9yQ=
Date:   Sun, 17 Jul 2022 17:32:46 -0700
To:     mm-commits@vger.kernel.org, yj.chiang@mediatek.com,
        tzimmermann@suse.de, thunder.leizhen@huawei.com,
        matthias.bgg@gmail.com, jacob.e.keller@intel.com,
        hdegoede@redhat.com, mark-pk.tsai@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-devres-use-numa-aware-allocation.patch removed from -mm tree
Message-Id: <20220718003246.A83BBC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib: devres: use numa aware allocation
has been removed from the -mm tree.  Its filename was
     lib-devres-use-numa-aware-allocation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: lib: devres: use numa aware allocation
Date: Fri, 8 Jul 2022 21:19:47 +0800

Allocate device resource from local node memory when the numa locality of
the device is specified.

Link: https://lkml.kernel.org/r/20220708131952.14500-1-mark-pk.tsai@mediatek.com
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: YJ Chiang <yj.chiang@mediatek.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/devres.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/lib/devres.c~lib-devres-use-numa-aware-allocation
+++ a/lib/devres.c
@@ -29,7 +29,8 @@ static void __iomem *__devm_ioremap(stru
 {
 	void __iomem **ptr, *addr = NULL;
 
-	ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
+	ptr = devres_alloc_node(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL,
+				dev_to_node(dev));
 	if (!ptr)
 		return NULL;
 
@@ -292,7 +293,8 @@ void __iomem *devm_ioport_map(struct dev
 {
 	void __iomem **ptr, *addr;
 
-	ptr = devres_alloc(devm_ioport_map_release, sizeof(*ptr), GFP_KERNEL);
+	ptr = devres_alloc_node(devm_ioport_map_release, sizeof(*ptr), GFP_KERNEL,
+				dev_to_node(dev));
 	if (!ptr)
 		return NULL;
 
@@ -366,7 +368,8 @@ void __iomem * const *pcim_iomap_table(s
 	if (dr)
 		return dr->table;
 
-	new_dr = devres_alloc(pcim_iomap_release, sizeof(*new_dr), GFP_KERNEL);
+	new_dr = devres_alloc_node(pcim_iomap_release, sizeof(*new_dr), GFP_KERNEL,
+				   dev_to_node(&pdev->dev));
 	if (!new_dr)
 		return NULL;
 	dr = devres_get(&pdev->dev, new_dr, NULL, NULL);
@@ -548,7 +551,8 @@ int devm_arch_phys_wc_add(struct device
 	int *mtrr;
 	int ret;
 
-	mtrr = devres_alloc(devm_arch_phys_ac_add_release, sizeof(*mtrr), GFP_KERNEL);
+	mtrr = devres_alloc_node(devm_arch_phys_ac_add_release, sizeof(*mtrr), GFP_KERNEL,
+				 dev_to_node(dev));
 	if (!mtrr)
 		return -ENOMEM;
 
@@ -593,7 +597,8 @@ int devm_arch_io_reserve_memtype_wc(stru
 	struct arch_io_reserve_memtype_wc_devres *dr;
 	int ret;
 
-	dr = devres_alloc(devm_arch_io_free_memtype_wc_release, sizeof(*dr), GFP_KERNEL);
+	dr = devres_alloc_node(devm_arch_io_free_memtype_wc_release, sizeof(*dr), GFP_KERNEL,
+			       dev_to_node(dev));
 	if (!dr)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from mark-pk.tsai@mediatek.com are


