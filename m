Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D7ACC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348928AbiCYBLF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357142AbiCYBK6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:10:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FCA580F8
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:09:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 056A1B82707
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0303C340EC;
        Fri, 25 Mar 2022 01:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170560;
        bh=oMks0NwgJ+vcKBdS+9v/+XKkQeSFmsxtBamyoI9531E=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=fXO9/WHIk5cPKi/zv6KC0e4CLYe84b3I3p8AdwoxIIDlJiIWSPilj7ixRVqhHrs5x
         tmaD2Uu09hGTfhQPFajyP6TSQk0JQ84l8XfDw53h2LOZMNn9cKAf8cxqBhL9pYazlO
         ZjGknx29monTZaFE3uxDemk0+Dvhp0Lp+wF1/iN4=
Date:   Thu, 24 Mar 2022 18:09:20 -0700
To:     zhangyinan2019@email.szu.edu.cn, weizhenliang@huawei.com,
        sfr@canb.auug.org.au, caoyixuan2019@email.szu.edu.cn,
        yejiajian2018@email.szu.edu.cn, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 015/114] tools/vm/page_owner_sort.c: fix comments
Message-Id: <20220325010920.B0303C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: fix comments

Two adjustments are made:

1. Correct a grammatical error: replace the "what" in "Do the job what
   you want to debug" with "that".

2. Replace "has not been" with "has been" in the description of the -f
   option: According to Commit b1c9ba071e7d ("tools/vm/page_owner_sort.c:
   fix the instructions for use"), the description of the "-f" option is
   "Filter out the information of blocks whose memory has been released."

Link: https://lkml.kernel.org/r/20220301151438.166118-1-yejiajian2018@email.szu.edu.cn
Signed-off-by: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/vm/page_owner.rst~tools-vm-page_owner_sortc-fix-comments
+++ a/Documentation/vm/page_owner.rst
@@ -78,7 +78,7 @@ Usage
 
 2) Enable page owner: add "page_owner=on" to boot cmdline.
 
-3) Do the job what you want to debug
+3) Do the job that you want to debug.
 
 4) Analyze information from page owner::
 
@@ -126,4 +126,4 @@ Usage
 		-c		Cull by comparing stacktrace instead of total block.
 
 	Filter:
-		-f		Filter out the information of blocks whose memory has not been released.
+		-f		Filter out the information of blocks whose memory has been released.
_
