Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD623C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 19:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238515AbiGHT45 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 15:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238512AbiGHT44 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 15:56:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD3772ECA
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 12:56:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6786EB8294E
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 19:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06791C341C0;
        Fri,  8 Jul 2022 19:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657310213;
        bh=U1ZdF9KQSqaVHbvAicItpcD+5Q+2JU6MaXTv9smB0i0=;
        h=Date:To:From:Subject:From;
        b=ElW1UwuTGZTGPU8mSjt9n3rWMQw9cjq35HNeBFRDuaktydCoc4fNSriwYX0xq+5oV
         Jt9ohqlAMDVMux36JFisKTKYm4WwdOAa7euuATJqBuHGxRNwM3RsFTxwYTNT/3Oky5
         shfdTMlFvdfi3mJmedVd1krdqUTU2RM7wUKgp4sY=
Date:   Fri, 08 Jul 2022 12:56:52 -0700
To:     mm-commits@vger.kernel.org, yj.chiang@mediatek.com,
        tzimmermann@suse.de, thunder.leizhen@huawei.com,
        matthias.bgg@gmail.com, jacob.e.keller@intel.com,
        hdegoede@redhat.com, mark-pk.tsai@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-devres-use-numa-aware-allocation.patch added to mm-nonmm-unstable branch
Message-Id: <20220708195653.06791C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: devres: use numa aware allocation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-devres-use-numa-aware-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-devres-use-numa-aware-allocation.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

lib-devres-use-numa-aware-allocation.patch

