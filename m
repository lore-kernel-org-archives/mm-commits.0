Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F375C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbiEJERW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235964AbiEJEQa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9E12397AB
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:12:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B2CCB81AFA
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6EAC385C2;
        Tue, 10 May 2022 04:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155924;
        bh=0ozdNuOOwZ7ooJenYgNlNCAT2JwD7gSB7SgyXj//pik=;
        h=Date:To:From:Subject:From;
        b=teMDHty3tOnSqK3HC7hX5xdtWRmy0fN1HpN2f/07UYybSI6i28DQAhBB9bzu9gmW1
         28cV6S4zY8MzyIJ6j7ae9JKrBPsUl+Uxm2le0/07+0JVV3IdAnJpc5j+KiJR1voUnP
         IGOUGIrNhPw0ZEGBGiHzHL06owNN2rGxv7OxB8JQ=
Date:   Mon, 09 May 2022 21:12:04 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, david@redhat.com,
        catalin.marinas@arm.com, ardb@kernel.org,
        anshuman.khandual@arm.com, mawupeng1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-calc-the-right-pfn-if-page-size-is-not-4k.patch removed from -mm tree
Message-Id: <20220510041204.AD6EAC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc.c: calc the right pfn if page size is not 4K
has been removed from the -mm tree.  Its filename was
     mm-calc-the-right-pfn-if-page-size-is-not-4k.patch

This patch was dropped because it was merged into mm-stable

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
@@ -7821,7 +7821,7 @@ static void __init find_zone_movable_pfn
 
 			usable_startpfn = memblock_region_memory_base_pfn(r);
 
-			if (usable_startpfn < 0x100000) {
+			if (usable_startpfn < PHYS_PFN(SZ_4G)) {
 				mem_below_4gb_not_mirrored = true;
 				continue;
 			}
_

Patches currently in -mm which might be from mawupeng1@huawei.com are


