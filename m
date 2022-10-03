Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7262DC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiJCVPg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiJCVOB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3855F5467B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 948BCCE0E6D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09E7C433D7;
        Mon,  3 Oct 2022 21:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831366;
        bh=h5ufOKQFtKppgZL66iEnNKMeOFtpWB0RDVmE+1KaBmY=;
        h=Date:To:From:Subject:From;
        b=lnaV5vo3Ny9KEbJGK2ORh2ItqhhgMELDSUSg0ky4HGwvHEiK98fOD+fcmd9GLkIBR
         8AWq0gLlivAl6zUnq9phLlbJQGEOA2weOCoEA4prMliqzdQR5qLEJPiSAkIj0l2v5E
         /NRQeXofOoDCdE2/3+fAyFYIQoJ2rskn0rnoVYyE=
Date:   Mon, 03 Oct 2022 14:09:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-ensure-kswapd-doesnt-accidentally-go-to-sleep.patch removed from -mm tree
Message-Id: <20221003210926.C09E7C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: ensure kswapd doesn't accidentally go to sleep
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-ensure-kswapd-doesnt-accidentally-go-to-sleep.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: ensure kswapd doesn't accidentally go to sleep
Date: Fri, 16 Sep 2022 15:22:42 +0800

Patch series "A few cleanup patches for mm", v2.

This series contains a few cleanup patches to remove the obsolete comments
and functions, use helper macro to improve readability and so on.  More
details can be found in the respective changelogs.


This patch (of 16):

If ALLOC_KSWAPD is set, wake_all_kswapds() will be called to ensure kswapd
doesn't accidentally go to sleep.  But when reserve_flags is set,
alloc_flags will be overwritten and ALLOC_KSWAPD is thus lost.  Preserve
the ALLOC_KSWAPD flag in alloc_flags to ensure kswapd won't go to sleep
accidentally.

Link: https://lkml.kernel.org/r/20220916072257.9639-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220916072257.9639-2-linmiaohe@huawei.com
Fixes: 0a79cdad5eb2 ("mm: use alloc_flags to record if kswapd can wake")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-ensure-kswapd-doesnt-accidentally-go-to-sleep
+++ a/mm/page_alloc.c
@@ -5156,7 +5156,8 @@ retry:
 
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
-		alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, reserve_flags);
+		alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, reserve_flags) |
+					  (alloc_flags & ALLOC_KSWAPD);
 
 	/*
 	 * Reset the nodemask and zonelist iterators if memory policies can be
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


