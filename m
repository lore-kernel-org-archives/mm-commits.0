Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FAD7C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 01:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbiA0Bgo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jan 2022 20:36:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52100 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiA0Bgo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jan 2022 20:36:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22BE0B81EE8
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 01:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63CDC340E3;
        Thu, 27 Jan 2022 01:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643247401;
        bh=JdwjMUFo6MzIW7CvLqOH4b9xdzl74ip9goEn8BwTAmE=;
        h=Date:From:To:Subject:From;
        b=ahs24PEduGHK0RGN4IDxAr6t9M3+dTWF+oYUt9gEsE6wEwK6WFNlE/vfofW4Sss2g
         aS30k7yljWP2jCigs7ou8G7MiKEvDHZfjGATGcN5WRl87gBqris+Q+pnzWjm4I0nZA
         thEpipMAE3htg1CPXjVSurBY4KtLKJPPvdzxLkiI=
Date:   Wed, 26 Jan 2022 17:36:41 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com
Subject:  +
 =?US-ASCII?Q?mm-memremap-avoid-calling-kasan=5Fremove=5Fzero=5Fshadow-for?=
 =?US-ASCII?Q?-device-private-memory.patch?= added to -mm tree
Message-ID: <20220127013641.mZ73P_HE2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap: avoid calling kasan_remove_zero_shadow() for device private memory
has been added to the -mm tree.  Its filename is
     mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -302,7 +302,8 @@ static int pagemap_range(struct dev_page
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

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch

