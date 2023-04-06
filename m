Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE51C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbjDFCds (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjDFCdg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:33:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645575FC3
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:33:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAF9262D65
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E33DC433D2;
        Thu,  6 Apr 2023 02:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680748414;
        bh=zL4hem9bPkCXuUKMP9YMOwtl34TC/on6YaAPOVki4JA=;
        h=Date:To:From:Subject:From;
        b=aB9i8Orj/Q3/HERHiVQgeU+CpB/mkbaeUmk4C0pLQ5xp12IoZ93OFiCLVLN46VvPM
         1qv6NjEGssV3+r74nx+lA1W9TYlU6FfUlNrVTL5BaspyB0CVr1PjiLTbhhM61o5TUj
         6Eu4tdjwO0YUF1mQ8ngRsIGlMRcMh20LyFUh5waA=
Date:   Wed, 05 Apr 2023 19:33:33 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, lkp@intel.com,
        kirill.shutemov@linux.intel.com, kirill@shutemov.name,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-treewide-redefine-max_order-sanely-fix.patch removed from -mm tree
Message-Id: <20230406023334.4E33DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-treewide-redefine-max_order-sanely-fix.txt
has been removed from the -mm tree.  Its filename was
     mm-treewide-redefine-max_order-sanely-fix.patch

This patch was dropped because it was folded into mm-treewide-redefine-max_order-sanely.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-treewide-redefine-max_order-sanely-fix.txt
Date: Wed, 15 Mar 2023 18:38:00 +0300

fix min() warning

Link: https://lkml.kernel.org/r/20230315153800.32wib3n5rickolvh@box
Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lore.kernel.org/oe-kbuild-all/202303152343.D93IbJmn-lkp@intel.com/
Signed-off-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memblock.c~mm-treewide-redefine-max_order-sanely-fix
+++ a/mm/memblock.c
@@ -2043,7 +2043,7 @@ static void __init __free_pages_memory(u
 	int order;
 
 	while (start < end) {
-		order = min(MAX_ORDER, __ffs(start));
+		order = min_t(int, MAX_ORDER, __ffs(start));
 
 		while (start + (1UL << order) > end)
 			order--;
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-treewide-redefine-max_order-sanely.patch
mm-treewide-redefine-max_order-sanely-fix-3.patch

