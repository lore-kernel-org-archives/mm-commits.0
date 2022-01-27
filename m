Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4D7C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 22:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbiA0WQa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jan 2022 17:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235917AbiA0WQ3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jan 2022 17:16:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C585FC061714
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 14:16:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66E0961BBA
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 22:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB60C340E4;
        Thu, 27 Jan 2022 22:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643321788;
        bh=s0lc87lKjS6Hr+1s/sNUSu9u7i+UsMurh2z5RBDZ+Zs=;
        h=Date:From:To:Subject:From;
        b=HN5UOghjhhtZX1pI6ynh33tXuBlyvHvmoB2v9TSFjtA9ycupiydWvkeh19VvFpK/K
         JItSrZhAwnxIlKzcxWffHB4kJeasq1Fnd5p1+tWUpE+NR77Y/x3HW2kTKjBW9Mcfro
         kd5BEiOms+A4g0xmKMKaKdpb/uGjjO9ssj80G8CA=
Date:   Thu, 27 Jan 2022 14:16:28 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  + mm-mmzoneh-remove-unused-macros.patch added to -mm tree
Message-ID: <20220127221628.5nU4OC9e8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmzone.h: remove unused macros
has been added to the -mm tree.  Its filename is
     mm-mmzoneh-remove-unused-macros.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmzoneh-remove-unused-macros.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmzoneh-remove-unused-macros.patch

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
Subject: mm/mmzone.h: remove unused macros

Remove pgdat_page_nr, nid_page_nr and NODE_MEM_MAP. They are unused now.

Link: https://lkml.kernel.org/r/20220127093210.62293-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/include/linux/mmzone.h~mm-mmzoneh-remove-unused-macros
+++ a/include/linux/mmzone.h
@@ -931,12 +931,6 @@ typedef struct pglist_data {
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
 #define node_spanned_pages(nid)	(NODE_DATA(nid)->node_spanned_pages)
-#ifdef CONFIG_FLATMEM
-#define pgdat_page_nr(pgdat, pagenr)	((pgdat)->node_mem_map + (pagenr))
-#else
-#define pgdat_page_nr(pgdat, pagenr)	pfn_to_page((pgdat)->node_start_pfn + (pagenr))
-#endif
-#define nid_page_nr(nid, pagenr) 	pgdat_page_nr(NODE_DATA(nid),(pagenr))
 
 #define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
 #define node_end_pfn(nid) pgdat_end_pfn(NODE_DATA(nid))
@@ -1112,7 +1106,6 @@ static inline struct pglist_data *NODE_D
 {
 	return &contig_page_data;
 }
-#define NODE_MEM_MAP(nid)	mem_map
 
 #else /* CONFIG_NUMA */
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
mm-sparse-make-mminit_validate_memmodel_limits-static.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-mmzoneh-remove-unused-macros.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch

