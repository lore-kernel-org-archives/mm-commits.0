Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABB1C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 23:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiLAXPX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Dec 2022 18:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLAXPT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2022 18:15:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAC12CA
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 15:15:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E47B8B81F50
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 23:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826AAC433C1;
        Thu,  1 Dec 2022 23:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669936516;
        bh=R9/Kqw0q/gu0vuXq1l5NhsV9W7RxAL47TVPvioS29kI=;
        h=Date:To:From:Subject:From;
        b=LN2WyPj5X5Wm/CtuO3bvg/NG8rH926aFgYJ1Gm3qseiOtr83a+uDUmii+7F/3ZCAW
         dnC54fOlLxbmJlFKB36SdkdcM+L7a7iO3n/1vu8xpdhSkrYjrR16SORXCcylKZuf1s
         f15eGjqPiqiLGZ419rocYuTM9KktlJeTh7P3S60o=
Date:   Thu, 01 Dec 2022 15:15:15 -0800
To:     mm-commits@vger.kernel.org, yang.lee@linux.alibaba.com,
        Felix.Kuehling@amd.com, dan.j.williams@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch removed from -mm tree
Message-Id: <20221201231516.826AAC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2
has been removed from the -mm tree.  Its filename was
     mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch

This patch was dropped because it was folded into mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2
Date: Thu Oct 27 11:53:07 AM PDT 2022

fix whitespace, per Felix and Yang Li

Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -328,8 +328,8 @@ svm_migrate_copy_to_vram(struct amdgpu_d
 
 		dst[i] = cursor.start + (j << PAGE_SHIFT);
 		migrate->dst[i] = svm_migrate_addr_to_pfn(adev, dst[i]);
-			svm_migrate_get_vram_page(&kfddev->pgmap, prange,
-						  migrate->dst[i]);
+		svm_migrate_get_vram_page(&kfddev->pgmap, prange,
+					  migrate->dst[i]);
 		migrate->dst[i] = migrate_pfn(migrate->dst[i]);
 
 		spage = migrate_pfn_to_page(migrate->src[i]);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-mm-align-larger-anonymous-mappings-on-thp-boundaries.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch

