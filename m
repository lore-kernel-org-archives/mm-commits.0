Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D70BCCA47A
	for <mm-commits@archiver.kernel.org>; Sat, 11 Jun 2022 21:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiFKVFb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Jun 2022 17:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiFKVFa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 11 Jun 2022 17:05:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E5E3E5EE
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 14:05:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7418461260
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 21:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B58C34116;
        Sat, 11 Jun 2022 21:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654981528;
        bh=vLZzl/CiHjEIa4cY63UO0wLo3Nnof/a+gAmBNJELAAM=;
        h=Date:To:From:Subject:From;
        b=vEXvGTrZZZ22ntxRy+5/8dCJ/dfE3cKJWA8Y2TbYND9Fn01gf7CcXeWgyd8IkNbTt
         xTr8lZbfdhoaCT08G+++rxnNyNRcZ69DSyFQ84CJuyVj4vEreE4fPcT9l8qtlY2c9L
         XVM7/rS3fwwrD8w73GIlDfTs6qm/CNdZ0kQI3Z5c=
Date:   Sat, 11 Jun 2022 14:05:28 -0700
To:     mm-commits@vger.kernel.org, yee.lee@mediatek.com,
        catalin.marinas@arm.com, patrick.wang.shcn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-check-physical-address-when-scan.patch added to mm-unstable branch
Message-Id: <20220611210528.C7B58C34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: check physical address when scan
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-check-physical-address-when-scan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-check-physical-address-when-scan.patch

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

mm-kmemleak-remove-kmemleak_not_leak_phys-and-the-min_count-argument-to-kmemleak_alloc_phys.patch
mm-kmemleak-add-object_phys-flag-for-objects-allocated-with-physical-address.patch
mm-kmemleak-add-rbtree-and-store-physical-address-for-objects-allocated-with-pa.patch
mm-kmemleak-check-physical-address-when-scan.patch

