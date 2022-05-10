Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 809B5C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbiEJEPA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbiEJEOe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25CC235164
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ECDA615E8
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C93C385C2;
        Tue, 10 May 2022 04:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155833;
        bh=6zfLyClmScUd47NnY7wVGP/uKTDIuJyOQaabCVBUf3I=;
        h=Date:To:From:Subject:From;
        b=2a8YvuzOkMPZ2ou2cCVnyryblA3C4ccanwamEtGwT9wKu1Pm7BiZ/+zrdTXpdRk1o
         8B4Lv/U9aZoVtkZ/p64qBX8DODLBX2OJ1pyvbpCTGugZU4dn78TMbtwHeryRWtljYp
         ltig4Uq7EbwAIHCYTb13vGtcegj0KYV+HV+rZB/c=
Date:   Mon, 09 May 2022 21:10:33 -0700
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn,
        zhangyinan2019@email.szu.edu.cn, yuhongf@szu.edu.cn,
        yejiajian2018@email.szu.edu.cn, seanga2@gmail.com,
        liuyongqiang13@huawei.com, hanshenghong2019@email.szu.edu.cn,
        baihaowen@meizu.com, caoyixuan2019@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-vm-page_owner_sortc-avoid-repeated-judgments.patch removed from -mm tree
Message-Id: <20220510041033.D3C93C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/vm/page_owner_sort.c: avoid repeated judgments
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sortc-avoid-repeated-judgments.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: avoid repeated judgments

I noticed a detail that needs to be adjusted.  When judging whether a page
is allocated by vmalloc, the value of the variable "tmp" was repeatedly
judged, so the code was adjusted.

This work is coauthored by Yinan Zhang, Jiajian Ye, Shenghong Han, Chongxi
Zhao, Yuhong Feng and Yongqiang Liu.

Link: https://lkml.kernel.org/r/20220414042744.13896-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Cc: Haowen Bai <baihaowen@meizu.com>
Cc: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Sean Anderson <seanga2@gmail.com>
Cc: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Cc: Yuhong Feng <yuhongf@szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-avoid-repeated-judgments
+++ a/tools/vm/page_owner_sort.c
@@ -444,10 +444,8 @@ static int get_allocator(const char *buf
 			tmp--;
 		first_line = ++tmp;
 		tmp = strstr(tmp, "alloc_pages");
-		if (tmp) {
-			if (tmp && first_line <= tmp && tmp < second_line)
-				allocator |= ALLOCATOR_VMALLOC;
-		}
+		if (tmp && first_line <= tmp && tmp < second_line)
+			allocator |= ALLOCATOR_VMALLOC;
 	}
 	if (allocator == 0)
 		allocator = ALLOCATOR_OTHERS;
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are


