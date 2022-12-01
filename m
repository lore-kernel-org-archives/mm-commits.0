Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E963FC4332F
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 23:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbiLAXPS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Dec 2022 18:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLAXPQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2022 18:15:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D09F2CA
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 15:15:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD49262183
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 23:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5B3C433D6;
        Thu,  1 Dec 2022 23:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669936515;
        bh=WGk55dhsb4hzG2Mkr75EeS6ODK+F/6U8k4oN/piDPmM=;
        h=Date:To:From:Subject:From;
        b=b1iYJn5dhAGY6Yb46kBMllErvZBW/cx6yzhFNV+GgVNLq8IUSZ7W8uKnKzV2PYnjn
         wpiic7EmWMIjrGLVIubCCkjZ1Q1u2pJrdg34RyFi/d4QnDp6/iQikScRZtIkKkVT3q
         claJHkTmTu99r9RaR9F70/OYkwkXD9SjGXNg6wJI=
Date:   Thu, 01 Dec 2022 15:15:14 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        dan.j.williams@intel.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch removed from -mm tree
Message-Id: <20221201231515.3E5B3C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix
has been removed from the -mm tree.  Its filename was
     mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch

This patch was dropped because it was folded into mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix
Date: Sat Oct 22 04:31:31 PM PDT 2022

fix pgmap_request_folio() stub return type

Reported-by: kernel test robot <lkp@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memremap.h~mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix
+++ a/include/linux/memremap.h
@@ -255,7 +255,7 @@ static inline struct dev_pagemap *get_de
 static inline struct folio *pgmap_request_folio(struct dev_pagemap *pgmap,
 						pgoff_t pgmap_offset, int order)
 {
-	return false;
+	return NULL;
 }
 
 static inline bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-mm-align-larger-anonymous-mappings-on-thp-boundaries.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch

