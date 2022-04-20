Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDA1C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 22:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbiDTWau (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 18:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382826AbiDTWat (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 18:30:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FF041FA2
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 15:28:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C77561A2D
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 22:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F774C385A1;
        Wed, 20 Apr 2022 22:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650493681;
        bh=NVZ5NuK2OX53AFPObELJxFeZ03AGwvgvWRHblkvRC3A=;
        h=Date:To:From:Subject:From;
        b=ayxeW9+sbEuZv7/V6rfsvv6vz9LrY5WtVvH1d3ZxeOAvDI54ewe2lSBcPaGoes7TE
         4t/GeFqPxWExIBdnLscyeQG/mh9f6on6q0skrr/nZIj34A2QzGl5BdZclC5YInPcAK
         J9CiTovH3LYlMYzspQYngNJ6nuPpDrLVL8mQrg+0=
Date:   Wed, 20 Apr 2022 15:28:00 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, david@redhat.com,
        catalin.marinas@arm.com, ardb@kernel.org,
        anshuman.khandual@arm.com, mawupeng1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-calc-the-right-pfn-if-page-size-is-not-4k.patch added to -mm tree
Message-Id: <20220420222801.6F774C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: calc the right pfn if page size is not 4K
has been added to the -mm tree.  Its filename is
     mm-calc-the-right-pfn-if-page-size-is-not-4k.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-calc-the-right-pfn-if-page-size-is-not-4k.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-calc-the-right-pfn-if-page-size-is-not-4k.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: mm/page_alloc.c: calc the right pfn if page size is not 4K

Previous 0x100000 is used to check the 4G limit in
find_zone_movable_pfns_for_nodes().  This is right in x86 because the page
size can only be 4K.  But 16K and 64K are available in arm64.  So replace
it with PHYS_PFN(SZ_4G).

Link: https://lkml.kernel.org/r/20220414101314.1250667-8-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-calc-the-right-pfn-if-page-size-is-not-4k
+++ a/mm/page_alloc.c
@@ -7870,7 +7870,7 @@ static void __init find_zone_movable_pfn
 
 			usable_startpfn = memblock_region_memory_base_pfn(r);
 
-			if (usable_startpfn < 0x100000) {
+			if (usable_startpfn < PHYS_PFN(SZ_4G)) {
 				mem_below_4gb_not_mirrored = true;
 				continue;
 			}
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

mm-calc-the-right-pfn-if-page-size-is-not-4k.patch

