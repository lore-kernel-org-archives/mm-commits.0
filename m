Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0676C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbiCYWnE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbiCYWnD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9425E208C11
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45C86B82A2F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE57AC340ED;
        Fri, 25 Mar 2022 22:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248084;
        bh=Sv/Hf7z8l3Aa7qEdh6i/n8zU3g+Jxi0MnwFxjRVVuoA=;
        h=Date:To:From:Subject:From;
        b=rjJBgbG5/PdW9mlCcMdn6iQA4bt3unHPrBgi4CmUU81eSUr9EzdzWYJJQzGrzVwKQ
         l9mr++wO0j6olWv6+1JGNGugWxZmJc5VIqdaT/lCC+kCESU794SS4OpXiwuq/N0PMd
         GKKNOy7pgl0riPDZO1YLlmpqyp1xkPXRFvDn3k+M=
Date:   Fri, 25 Mar 2022 15:41:24 -0700
To:     mm-commits@vger.kernel.org, zhangyinan2019@email.szu.edu.cn,
        zhangshengju@cmss.chinamobile.com, weizhenliang@huawei.com,
        tangbin@cmss.chinamobile.com, sfr@canb.auug.org.au,
        ch0.han@lge.com, seanga2@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tools-vm-page_owner_sortc-support-sorting-by-stack-trace.patch removed from -mm tree
Message-Id: <20220325224124.BE57AC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: support sorting by stack trace
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sortc-support-sorting-by-stack-trace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sean Anderson <seanga2@gmail.com>
Subject: tools/vm/page_owner_sort.c: support sorting by stack trace

This adds the ability to sort by stacktraces.  This is helpful when
comparing multiple dumps of page_owner taken at different times, since
blocks will not be reordered if they were allocated/free'd.

Link: https://lkml.kernel.org/r/20211124193709.1805776-2-seanga2@gmail.com
Signed-off-by: Sean Anderson <seanga2@gmail.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Changhee Han <ch0.han@lge.com>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-support-sorting-by-stack-trace
+++ a/tools/vm/page_owner_sort.c
@@ -29,7 +29,6 @@ struct block_list {
 	int page_num;
 };
 
-static int sort_by_memory;
 static regex_t order_pattern;
 static struct block_list *list;
 static int list_size;
@@ -134,13 +133,16 @@ static void add_list(char *buf, int len)
 
 static void usage(void)
 {
-	printf("Usage: ./page_owner_sort [-m] <input> <output>\n"
-		"-m	Sort by total memory. If this option is unset, sort by times\n"
+	printf("Usage: ./page_owner_sort [OPTIONS] <input> <output>\n"
+		"-m	Sort by total memory.\n"
+		"-s	Sort by the stack trace.\n"
+		"-t	Sort by times (default).\n"
 	);
 }
 
 int main(int argc, char **argv)
 {
+	int (*cmp)(const void *, const void *) = compare_num;
 	FILE *fin, *fout;
 	char *buf;
 	int ret, i, count;
@@ -149,10 +151,16 @@ int main(int argc, char **argv)
 	int err;
 	int opt;
 
-	while ((opt = getopt(argc, argv, "m")) != -1)
+	while ((opt = getopt(argc, argv, "mst")) != -1)
 		switch (opt) {
 		case 'm':
-			sort_by_memory = 1;
+			cmp = compare_page_num;
+			break;
+		case 's':
+			cmp = compare_stacktrace;
+			break;
+		case 't':
+			cmp = compare_num;
 			break;
 		default:
 			usage();
@@ -221,10 +229,7 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (sort_by_memory)
-		qsort(list2, count, sizeof(list[0]), compare_page_num);
-	else
-		qsort(list2, count, sizeof(list[0]), compare_num);
+	qsort(list2, count, sizeof(list[0]), cmp);
 
 	for (i = 0; i < count; i++)
 		fprintf(fout, "%d times, %d pages:\n%s\n",
_

Patches currently in -mm which might be from seanga2@gmail.com are


