Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF503C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 21:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244947AbiDNVOv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 17:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239334AbiDNVOu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 17:14:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD34DD64CC
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 14:12:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 784D9B82BB7
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 21:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11841C385A5;
        Thu, 14 Apr 2022 21:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649970742;
        bh=grjJI12AJn+K8PT89h3UAw5Ytv/QqURHs+WKhudApJw=;
        h=Date:To:From:Subject:From;
        b=bP6vSemSMDzJ5wYSWWhBw0kJVWo5P3gAJ0QBpHfgAV1PUszDvo30NYm1sAYA7F88l
         eXYCddNkYAqTqGJzS7Yge1xRddBCU54iV6IF/vbTG906Boe/KHcupG5y/J+HjQNI1e
         1M8OLLO8AQfLJ1f903uBCbHqY3ydgVxbgGQXlNfc=
Date:   Thu, 14 Apr 2022 14:12:21 -0700
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn,
        zhangyinan2019@email.szu.edu.cn, yuhongf@szu.edu.cn,
        yejiajian2018@email.szu.edu.cn, seanga2@gmail.com,
        liuyongqiang13@huawei.com, hanshenghong2019@email.szu.edu.cn,
        baihaowen@meizu.com, caoyixuan2019@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-page_owner_sortc-avoid-repeated-judgments.patch added to -mm tree
Message-Id: <20220414211222.11841C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: avoid repeated judgments
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-avoid-repeated-judgments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-avoid-repeated-judgments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-avoid-repeated-judgments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tools-vm-page_owner_sortc-provide-allocator-labelling-and-update-cull-and-sort-options.patch
tools-vm-page_owner_sortc-avoid-repeated-judgments.patch
mm-vmalloc-fix-a-comment.patch

