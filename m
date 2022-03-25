Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD50C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbiCYWn1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbiCYWnP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8007209A44
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 468E7CE2B8C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5D0C004DD;
        Fri, 25 Mar 2022 22:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248097;
        bh=ggkc9SqLGdQVntuEF8TOq3DaCP6SuL8FFOOW00fTlcU=;
        h=Date:To:From:Subject:From;
        b=yaShZFr9Hi++Lspcv5c9a6GCYuXcOxJUZ09VzclYvnhzNikAAgZw/kpsqpRjswt1w
         9SuXFvwDZlKIrZqquSL4+l/rhaBG4ZAWfMWjWNj6ZDyMrjs+veUOIuvK13Q1WzfOl/
         TRpnu9/n/U3zzycVa4VkIpgZTf5L8DCyYqX6mJxM=
Date:   Fri, 25 Mar 2022 15:41:37 -0700
To:     mm-commits@vger.kernel.org, zhangyinan2019@email.szu.edu.cn,
        weizhenliang@huawei.com, tangbin@cmss.chinamobile.com,
        songmuchun@bytedance.com, sfr@canb.auug.org.au, seanga2@gmail.com,
        caoyixuan2019@email.szu.edu.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tools-vm-page_owner_sortc-fix-the-instructions-for-use.patch removed from -mm tree
Message-Id: <20220325224137.CD5D0C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: fix the instructions for use
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sortc-fix-the-instructions-for-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: fix the instructions for use

I noticed a discrepancy between the usage method and the code logic.

If we enable the -f option, it should be "Filter out the information of
blocks whose memory has been released".

Link: https://lkml.kernel.org/r/20220219143106.2805-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sean Anderson <seanga2@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-fix-the-instructions-for-use
+++ a/tools/vm/page_owner_sort.c
@@ -246,7 +246,7 @@ static void usage(void)
 		"-a	Sort by memory allocate time.\n"
 		"-r	Sort by memory release time.\n"
 		"-c	Cull by comparing stacktrace instead of total block.\n"
-		"-f	Filter out the information of blocks whose memory has not been released.\n"
+		"-f	Filter out the information of blocks whose memory has been released.\n"
 	);
 }
 
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are


