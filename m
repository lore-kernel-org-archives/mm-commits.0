Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A2DCCA47A
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379801AbiFQCts (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379817AbiFQCtl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BF565428
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A219B826EF
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D818C3411A;
        Fri, 17 Jun 2022 02:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434176;
        bh=JHPQdYSfhhdGDQZn4rwAWK6J+x/EBAMihRk3OWv01ug=;
        h=Date:To:From:Subject:From;
        b=aOup79JAdwNLl87yRtwWqQQEYbb5D7rIK+sJiBT2+GRVYbHcemMzDvOqfR9mOCIvD
         f4a+V97eNRVgpPsZkUv2fz7iie7IPPz2h6El7GBzkfCyMSF1NQNt6YOTzEftLPuMRl
         2SAemYyjTN6rtSG3so9Mbob3RDVGv8zvzPr1un0s=
Date:   Thu, 16 Jun 2022 19:49:35 -0700
To:     mm-commits@vger.kernel.org, yee.lee@mediatek.com,
        catalin.marinas@arm.com, patrick.wang.shcn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-check-physical-address-when-scan.patch removed from -mm tree
Message-Id: <20220617024936.3D818C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kmemleak: check physical address when scan
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-check-physical-address-when-scan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Patrick Wang <patrick.wang.shcn@gmail.com>
Subject: mm: kmemleak: check physical address when scan
Date: Sat, 11 Jun 2022 11:55:51 +0800

Check the physical address of objects for its boundary when scan instead
of in kmemleak_*_phys().

Link: https://lkml.kernel.org/r/20220611035551.1823303-5-patrick.wang.shcn@gmail.com
Fixes: 23c2d497de21 ("mm: kmemleak: take a full lowmem check in kmemleak_*_phys()")
Signed-off-by: Patrick Wang <patrick.wang.shcn@gmail.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Yee Lee <yee.lee@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-check-physical-address-when-scan
+++ a/mm/kmemleak.c
@@ -1184,7 +1184,7 @@ void __ref kmemleak_alloc_phys(phys_addr
 {
 	pr_debug("%s(0x%pa, %zu)\n", __func__, &phys, size);
 
-	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
+	if (kmemleak_enabled)
 		/*
 		 * Create object with OBJECT_PHYS flag and
 		 * assume min_count 0.
@@ -1204,7 +1204,7 @@ void __ref kmemleak_free_part_phys(phys_
 {
 	pr_debug("%s(0x%pa)\n", __func__, &phys);
 
-	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
+	if (kmemleak_enabled)
 		delete_object_part((unsigned long)phys, size, true);
 }
 EXPORT_SYMBOL(kmemleak_free_part_phys);
@@ -1218,7 +1218,7 @@ void __ref kmemleak_ignore_phys(phys_add
 {
 	pr_debug("%s(0x%pa)\n", __func__, &phys);
 
-	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
+	if (kmemleak_enabled)
 		make_black_object((unsigned long)phys, true);
 }
 EXPORT_SYMBOL(kmemleak_ignore_phys);
@@ -1493,6 +1493,17 @@ static void kmemleak_scan(void)
 			dump_object_info(object);
 		}
 #endif
+
+		/* ignore objects outside lowmem (paint them black) */
+		if ((object->flags & OBJECT_PHYS) &&
+		   !(object->flags & OBJECT_NO_SCAN)) {
+			unsigned long phys = object->pointer;
+
+			if (PHYS_PFN(phys) < min_low_pfn ||
+			    PHYS_PFN(phys + object->size) >= max_low_pfn)
+				__paint_it(object, KMEMLEAK_BLACK);
+		}
+
 		/* reset the reference count (whiten the object) */
 		object->count = 0;
 		if (color_gray(object) && get_object(object))
_

Patches currently in -mm which might be from patrick.wang.shcn@gmail.com are


