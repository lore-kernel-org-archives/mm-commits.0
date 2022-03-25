Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB07C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 00:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244435AbiCYA3u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 20:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240633AbiCYA3s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 20:29:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF9A3FD9D
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 17:28:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F30FF617E2
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 00:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A1EC340EC;
        Fri, 25 Mar 2022 00:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648168094;
        bh=sWTNAFnGbnvfTRTtPP8wyKIJU42O3DDcBL0w8+mTxaQ=;
        h=Date:To:From:Subject:From;
        b=PJCFdcuwCkO051zS5gqdV3JtxZ7LMp4dyVMhgP9mFhFfb2NmEgNDkyGaHZAiiNCcz
         DiRdXmKjA+hRqjmXVOlW+7pb//wCiIlwum1s12R5UAPLQ11urIpaiC8QLJnOlA95rJ
         TtBUK/F2ppyZs4//1Wph20B0uBYAZFkGeBomVr8E=
Date:   Thu, 24 Mar 2022 17:28:13 -0700
To:     mm-commits@vger.kernel.org, zhangyinan2019@email.szu.edu.cn,
        zhangshengju@cmss.chinamobile.com, weizhenliang@huawei.com,
        tangbin@cmss.chinamobile.com, sfr@canb.auug.org.au,
        ch0.han@lge.com, seanga2@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling-fix.patch removed from -mm tree
Message-Id: <20220325002814.45A1EC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: fix NULL-pointer dereference when comparing stack traces
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling-fix.patch

This patch was dropped because it was folded into tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling.patch

------------------------------------------------------
From: Sean Anderson <seanga2@gmail.com>
Subject: tools/vm/page_owner_sort.c: fix NULL-pointer dereference when comparing stack traces

If there is no newline in a block, then strchr returns NULL.  We check for
this in stacktrace_compare, but not when culling.  Fix this (and any
future bugs like it) by replacing NULL stack traces with "" in add_list.

Link: https://lkml.kernel.org/r/20211125162653.1855958-1-seanga2@gmail.com
Fixes: d0abbab9e9e9 ("tools/vm/page_owner_sort.c: sort by stacktrace before culling")
Signed-off-by: Sean Anderson <seanga2@gmail.com>
Cc: Changhee Han <ch0.han@lge.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Sean Anderson <seanga2@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling-fix
+++ a/tools/vm/page_owner_sort.c
@@ -56,7 +56,7 @@ static int compare_stacktrace(const void
 {
 	const struct block_list *l1 = p1, *l2 = p2;
 
-	return strcmp(l1->stacktrace ?: "", l2->stacktrace ?: "");
+	return strcmp(l1->stacktrace, l2->stacktrace);
 }
 
 static int compare_num(const void *p1, const void *p2)
@@ -122,7 +122,7 @@ static void add_list(char *buf, int len)
 	list[list_size].page_num = get_page_num(buf);
 	memcpy(list[list_size].txt, buf, len);
 	list[list_size].txt[len] = 0;
-	list[list_size].stacktrace = strchr(list[list_size].txt, '\n');
+	list[list_size].stacktrace = strchr(list[list_size].txt, '\n') ?: "";
 	list_size++;
 	if (list_size % 1000 == 0) {
 		printf("loaded %d\r", list_size);
_

Patches currently in -mm which might be from seanga2@gmail.com are

tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling.patch
tools-vm-page_owner_sortc-support-sorting-by-stack-trace.patch

