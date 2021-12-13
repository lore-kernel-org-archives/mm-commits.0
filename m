Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4068AC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 13 Dec 2021 21:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240899AbhLMVJg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Dec 2021 16:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243077AbhLMVJe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Dec 2021 16:09:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE71C061574
        for <mm-commits@vger.kernel.org>; Mon, 13 Dec 2021 13:09:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 118ABCE12C9
        for <mm-commits@vger.kernel.org>; Mon, 13 Dec 2021 21:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB54C34600;
        Mon, 13 Dec 2021 21:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639429770;
        bh=B+O9mgKkJrstjBpahDMcMmmNM2wQoAk/4Gsmms2U3XI=;
        h=Date:From:To:Subject:From;
        b=UkWH6s8MWRCT+qLXtCmztEenF2IoHEXCcRTU4dfHfM3vbaRowZLdGMsiEbhCLLECs
         MQb3wJA1LZz3CGRSgdRjygGFTjg5pZzP6YfVofHQ3Q98s+C9CltDbS0rXuMmvPGcWq
         xvDHPMw4f5t+s5urKobM+euvs6mvWIOpWaDLNt18=
Date:   Mon, 13 Dec 2021 13:09:29 -0800
From:   akpm@linux-foundation.org
To:     broonie@kernel.org, caoyixuan2019@email.szu.edu.cn,
        mm-commits@vger.kernel.org, seanga2@gmail.com,
        tangbin@cmss.chinamobile.com, weizhenliang@huawei.com,
        zhangyinan2019@email.szu.edu.cn
Subject:  +
 tools-vm-page_owner_sortc-delete-invalid-duplicate-code.patch added to -mm
 tree
Message-ID: <20211213210929.zGFyYmzLg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: delete invalid duplicate code
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-delete-invalid-duplicate-code.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-delete-invalid-duplicate-code.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-delete-invalid-duplicate-code.patch

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
Subject: tools/vm/page_owner_sort.c: delete invalid duplicate code

I noticed that there is two invalid lines of duplicate code.  It's better
to delete it.

Link: https://lkml.kernel.org/r/20211213095743.3630-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Mark Brown <broonie@kernel.org>
Cc: Sean Anderson <seanga2@gmail.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-delete-invalid-duplicate-code
+++ a/tools/vm/page_owner_sort.c
@@ -227,8 +227,6 @@ static void add_list(char *buf, int len)
 	list[list_size].pid = get_pid(buf);
 	list[list_size].ts_nsec = get_ts_nsec(buf);
 	list[list_size].free_ts_nsec = get_free_ts_nsec(buf);
-	memcpy(list[list_size].txt, buf, len);
-	list[list_size].txt[len] = 0;
 	list_size++;
 	if (list_size % 1000 == 0) {
 		printf("loaded %d\r", list_size);
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are

tools-vm-page_owner_sortc-delete-invalid-duplicate-code.patch

