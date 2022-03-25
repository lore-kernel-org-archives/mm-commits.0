Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AE0C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347627AbiCYBLE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353031AbiCYBK6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:10:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDA14F9E9
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:09:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29C6BB82708
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD81C340ED;
        Fri, 25 Mar 2022 01:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170557;
        bh=q0KIKYhayLcFYcLJFlPZg3SONzDI9uIqG/LXQ2otSmk=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=XVZtdfvCmPKlT+C+aw+AUGsdTQtFt/0r9Vf/eZirobI4MXGf3BGp6WkeLRvFXZM2k
         o/uINdNe9O5eJ/8tCV6WSbJd2P2O+uJBGboaW0EzDXmDZsvhDJW0WWbdgxh1vKnAnm
         XYKxfW0rd9TpmxpCIz+BPQW2xtosini9wA7LGZfc=
Date:   Thu, 24 Mar 2022 18:09:17 -0700
To:     zhangyinan2019@email.szu.edu.cn, weizhenliang@huawei.com,
        tangbin@cmss.chinamobile.com, songmuchun@bytedance.com,
        sfr@canb.auug.org.au, seanga2@gmail.com,
        caoyixuan2019@email.szu.edu.cn, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 014/114] tools/vm/page_owner_sort.c: fix the instructions for use
Message-Id: <20220325010917.BCD81C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
