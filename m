Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E86BDC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiJCVOV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiJCVLu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED8C52445
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37BCFB8160E
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40D9C433B5;
        Mon,  3 Oct 2022 21:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831260;
        bh=L35HBUsWN9Z8J7Fs9jiMCmJXzxyD1o508Q7/V21Jyi4=;
        h=Date:To:From:Subject:From;
        b=F5wybYd0jZz4NlFCA5gw4k5bOG6NnMD+JRh/CoCpYxfjmb5xeyISOh3S2D+F3omXx
         CkGshwxnI4kXPEm2V4EkxkU8n6OKtOY2e85Wiv/9WhuRG5qmaZV+TZKPv5V7aVsI6q
         qJRf8NHRJQvb4xzV38/9qHD3ZxvfPMkhqYanV8wg=
Date:   Mon, 03 Oct 2022 14:07:40 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        corbet@lwn.net, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-use-kstrtobool-for-swapaccount-param-parsing.patch removed from -mm tree
Message-Id: <20221003210740.C40D9C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcontrol: use kstrtobool for swapaccount param parsing
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-use-kstrtobool-for-swapaccount-param-parsing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/memcontrol: use kstrtobool for swapaccount param parsing
Date: Tue, 13 Sep 2022 15:13:58 +0800

Use kstrtobool which is more powerful to handle all kinds of parameters
like 'Yy1Nn0' or [oO][NnFf] for "on" and "off".

Link: https://lkml.kernel.org/r/20220913071358.1812206-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-use-kstrtobool-for-swapaccount-param-parsing
+++ a/mm/memcontrol.c
@@ -7507,10 +7507,10 @@ bool mem_cgroup_swap_full(struct folio *
 
 static int __init setup_swap_account(char *s)
 {
-	if (!strcmp(s, "1"))
-		cgroup_memory_noswap = false;
-	else if (!strcmp(s, "0"))
-		cgroup_memory_noswap = true;
+	bool res;
+
+	if (!kstrtobool(s, &res))
+		cgroup_memory_noswap = !res;
 	return 1;
 }
 __setup("swapaccount=", setup_swap_account);
_

Patches currently in -mm which might be from liushixin2@huawei.com are


