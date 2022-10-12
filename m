Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FD9C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJLWV1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJLWV0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:21:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AFE3A49D
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:21:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 583C6B818EA
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84D4C433B5;
        Wed, 12 Oct 2022 22:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665613283;
        bh=SBBb2ACQ8lYj598+rdDfg86QsWRjVxrmp4c2rbM2RkA=;
        h=Date:To:From:Subject:From;
        b=kZ2jsoExX10RdK4sf3b8fCzw8b5Uz5KY4/0lXlXpIEDn+ozeuTupKBU+igi/scLum
         TogCGrx+fJkqxMj3TmthLo/EQp5rRy3VyRPY2yT50rmFZmaJc6OEmSS0h5VHd0G8Nc
         K2jre/2Q3Sy083ozMUCz/ZNhAkSYe5qtXYmLmIkY=
Date:   Wed, 12 Oct 2022 15:21:22 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        tglx@linutronix.de, lkp@intel.com, ira.weiny@intel.com, hch@lst.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix.patch removed from -mm tree
Message-Id: <20221012222122.E84D4C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix
has been removed from the -mm tree.  Its filename was
     highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix.patch

This patch was dropped because it was folded into highmem-fix-kmap_to_page-for-kmap_local_page-addresses.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix
Date: Mon Oct 10 01:12:33 PM PDT 2022

fix warning

mm/highmem.c:164:7: warning: Local variable 'i' shadows outer variable [shadowVariable]

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/highmem.c~highmem-fix-kmap_to_page-for-kmap_local_page-addresses-fix
+++ a/mm/highmem.c
@@ -160,11 +160,8 @@ struct page *__kmap_to_page(void *vaddr)
 
 	/* kmap() mappings */
 	if (WARN_ON_ONCE(addr >= PKMAP_ADDR(0) &&
-			 addr < PKMAP_ADDR(LAST_PKMAP))) {
-		int i = PKMAP_NR(addr);
-
-		return pte_page(pkmap_page_table[i]);
-	}
+			 addr < PKMAP_ADDR(LAST_PKMAP)))
+		return pte_page(pkmap_page_table[PKMAP_NR(addr)]);
 
 	/* kmap_local_page() mappings */
 	if (WARN_ON_ONCE(base >= __fix_to_virt(FIX_KMAP_END) &&
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix-2.patch
highmem-fix-kmap_to_page-for-kmap_local_page-addresses.patch

