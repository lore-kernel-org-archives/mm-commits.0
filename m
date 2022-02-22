Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D97C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 04:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiBVEMk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 23:12:40 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBVEMk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 23:12:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31855E145
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 20:12:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66225615B5
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 04:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6696C340E8;
        Tue, 22 Feb 2022 04:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645502913;
        bh=wdNqT7n204Sv1YKTJP/IF2+ysVqAC4DRS77pkWib46M=;
        h=Date:To:From:Subject:From;
        b=JHkNfPTqSVxJhemfHyAA50TlL0A0lVG1y2HLpIxTa1aH4FfNIsKP24zCt+eQfyIaf
         GeIVjIrLqsUN9szzJHZZjtd8sUv/LwA818hFxhZgyRbMSpdfKZPqfcUAxHnmSrA4pW
         ZKslDxqibSU5MW0EiO+cAJjFQSSqhtOvWFbtrv7Q=
Date:   Mon, 21 Feb 2022 20:08:33 -0800
To:     mm-commits@vger.kernel.org, zhangyinan2019@email.szu.edu.cn,
        weizhenliang@huawei.com, tangbin@cmss.chinamobile.com,
        songmuchun@bytedance.com, sfr@canb.auug.org.au, seanga2@gmail.com,
        caoyixuan2019@email.szu.edu.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-page_owner_sortc-fix-the-instructions-for-use.patch added to -mm tree
Message-Id: <20220222040833.A6696C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: fix the instructions for use
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-fix-the-instructions-for-use.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-fix-the-instructions-for-use.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-fix-the-instructions-for-use.patch

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

tools-vm-page_owner_sortc-delete-invalid-duplicate-code.patch
mm-page_ownerc-record-tgid.patch
tools-vm-page_owner_sortc-fix-the-instructions-for-use.patch

