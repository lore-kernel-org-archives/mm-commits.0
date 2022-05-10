Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDEBC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbiEJEPR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235960AbiEJEOq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A83B1EECB
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBB98615DA
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6B9C385C5;
        Tue, 10 May 2022 04:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155849;
        bh=uqSHvzoV1DwW9ycxE1gcDbtEj9lyqdxxXLe4ZKFuiu4=;
        h=Date:To:From:Subject:From;
        b=c+eEsl8Ht7Gypi83RxpzgjL82NzBVAZFmS9T9n+5aqduCYvT+Wa4CMUONcoDIqUjZ
         BoIS9dElIFhRkr6Bpu8IE8D33i2URHGpGQwZSHWlH8saeVmdxF0NnuQEIabUYgGkpx
         hnbWWS4NykIaH3XosRJvkn6OsibXyGY5yjmDEOOQ=
Date:   Mon, 09 May 2022 21:10:48 -0700
To:     mm-commits@vger.kernel.org, caoyixuan2019@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-fix-a-comment.patch removed from -mm tree
Message-Id: <20220510041049.4A6B9C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: fix a comment
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-a-comment.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: mm/vmalloc: fix a comment

The sentence
"but the mempolcy want to alloc memory by interleaving"
should be rephrased with
"but the mempolicy wants to alloc memory by interleaving"
where "mempolicy" is a struct name.

This work is coauthored by
Yinan Zhang
Jiajian Ye
Shenghong Han
Chongxi Zhao
Yuhong Feng
Yongqiang Liu

Link: https://lkml.kernel.org/r/20220401064543.4447-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-a-comment
+++ a/mm/vmalloc.c
@@ -2895,7 +2895,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			/* memory allocation should consider mempolicy, we can't
 			 * wrongly use nearest node when nid == NUMA_NO_NODE,
 			 * otherwise memory may be allocated in only one node,
-			 * but mempolcy want to alloc memory by interleaving.
+			 * but mempolicy wants to alloc memory by interleaving.
 			 */
 			if (IS_ENABLED(CONFIG_NUMA) && nid == NUMA_NO_NODE)
 				nr = alloc_pages_bulk_array_mempolicy(bulk_gfp,
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are


