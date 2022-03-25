Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D2DFC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357331AbiCYBcB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357330AbiCYBbs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD723204F
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:29:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5FEDB82725
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F51C340EC;
        Fri, 25 Mar 2022 01:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171796;
        bh=NhAVR+sOOdD3AanSQ7x+cq7oo85zD6qE2EOG/DgWySs=;
        h=Date:To:From:Subject:From;
        b=Xkp01nGohsyclqApyGyXzXJPGpvGPfEQ9oP3Vi2nYCQMLNKSCyvXukMcWjI9TRfQW
         OikptyRHGzjCUdhtCEmtyX7xUXhZMzlnme8BexI/iA6Z4w7ouTfnssqLdejIqD5Vi0
         e7k+9GE+EfT39FukAagQWvTcaFPok+AnYMog2mGQ=
Date:   Thu, 24 Mar 2022 18:29:55 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch removed from -mm tree
Message-Id: <20220325012956.60F51C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap: avoid calling kasan_remove_zero_shadow() for device private memory
has been removed from the -mm tree.  Its filename was
     mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memremap: avoid calling kasan_remove_zero_shadow() for device private memory

For device private memory, we do not create a linear mapping for the
memory because the device memory is un-accessible.  Thus we do not add
kasan zero shadow for it.  So it's unnecessary to do
kasan_remove_zero_shadow() for it.

Link: https://lkml.kernel.org/r/20220126092602.1425-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memremap.c~mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory
+++ a/mm/memremap.c
@@ -282,7 +282,8 @@ static int pagemap_range(struct dev_page
 	return 0;
 
 err_add_memory:
-	kasan_remove_zero_shadow(__va(range->start), range_len(range));
+	if (!is_private)
+		kasan_remove_zero_shadow(__va(range->start), range_len(range));
 err_kasan:
 	untrack_pfn(NULL, PHYS_PFN(range->start), range_len(range));
 err_pfn_remap:
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

