Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B60C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357163AbiCYBLP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356396AbiCYBLA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:11:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C63F5E168
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:09:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6EF9CCE25B0
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F96FC340ED;
        Fri, 25 Mar 2022 01:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170563;
        bh=I4n0cuNWnNTimok2wV5y+1RxmAXDYMxo3HM9EsyIPJQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=WRVkTICiONqznF4aeqYSAu1Gu3yYiUGMYAqmwjqnocvozIYJAdS6BagrFrXkiqgwM
         MPPsxF0Mnc2n67T/OCjvlEJeAaNZbDrDkE6wrOzu+M4gFy9npNNOrttMkMOLhmgcnN
         HPz5A4DRNemoFf9zrU10R3e6OOF/PSgPuugV/ycU=
Date:   Thu, 24 Mar 2022 18:09:23 -0700
To:     zhangyinan2019@email.szu.edu.cn, weizhenliang@huawei.com,
        sfr@canb.auug.org.au, caoyixuan2019@email.szu.edu.cn,
        yejiajian2018@email.szu.edu.cn, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 016/114] tools/vm/page_owner_sort.c: add a security check
Message-Id: <20220325010923.9F96FC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: add a security check

Add a security check after using malloc() to allocate memory.

Link: https://lkml.kernel.org/r/20220301151438.166118-2-yejiajian2018@email.szu.edu.cn
Signed-off-by: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-add-a-security-check
+++ a/tools/vm/page_owner_sort.c
@@ -217,7 +217,13 @@ static void add_list(char *buf, int len)
 		printf("max_size too small??\n");
 		exit(1);
 	}
+
 	list[list_size].txt = malloc(len+1);
+	if (!list[list_size].txt) {
+		printf("Out of memory\n");
+		exit(1);
+	}
+
 	list[list_size].len = len;
 	list[list_size].num = 1;
 	list[list_size].page_num = get_page_num(buf);
_
