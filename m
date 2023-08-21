Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C08BEE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbjHUUlv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjHUUko (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDC5CD4
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32B8C614EC
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2E9C433C7;
        Mon, 21 Aug 2023 20:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650429;
        bh=BVBq7AkzeJJOtBz4luWJxRUG+3pmy03ZHuIPFFtkdws=;
        h=Date:To:From:Subject:From;
        b=0QFtLcX1N4eXf5IPqLMvWMo+lux48JssWlnw+nD3RYItMsYGuU4clAkleg6MrdgyP
         6zOPdQ8/m0zUZMo/gsjm65WqwW1fSP0FWfcTfhAFXhy6dUkSfV0D3whQNuaJPlMltT
         3h35sWwfW1qSUT8AkeRTt58NUFnl9p9Djueg1wGQ=
Date:   Mon, 21 Aug 2023 13:40:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        david@redhat.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmemc-use-helper-macro-k.patch removed from -mm tree
Message-Id: <20230821204029.8A2E9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem.c: use helper macro K()
has been removed from the -mm tree.  Its filename was
     mm-shmemc-use-helper-macro-k.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/shmem.c: use helper macro K()
Date: Fri, 4 Aug 2023 09:25:56 +0800

Use helper macro K() to improve code readability.  No functional
modification involved.

Link: https://lkml.kernel.org/r/20230804012559.2617515-5-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmemc-use-helper-macro-k
+++ a/mm/shmem.c
@@ -3864,8 +3864,7 @@ static int shmem_show_options(struct seq
 	struct mempolicy *mpol;
 
 	if (sbinfo->max_blocks != shmem_default_max_blocks())
-		seq_printf(seq, ",size=%luk",
-			sbinfo->max_blocks << (PAGE_SHIFT - 10));
+		seq_printf(seq, ",size=%luk", K(sbinfo->max_blocks));
 	if (sbinfo->max_inodes != shmem_default_max_inodes())
 		seq_printf(seq, ",nr_inodes=%lu", sbinfo->max_inodes);
 	if (sbinfo->mode != (0777 | S_ISVTX))
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


