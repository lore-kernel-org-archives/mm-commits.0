Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 714EEC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244466AbiCYBKS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234981AbiCYBKR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:10:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEAA43EC8
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:08:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B92EB82708
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A32C340EC;
        Fri, 25 Mar 2022 01:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170522;
        bh=R1WsJkUBp+HpCUlaoEmtL0iQV4ETC4jKs4vtiwOJ2Ls=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Z245vGprD8r3NT48F773lPz1+sc++8amT089JdG39DO01BNWCcDGSNVCu0k6mFX1W
         kRqgypH7oASEYX4rjqsXUUVMPDiSSvmZEZ+w9v76q+2JJD55DNcjtzR74ajOlMocei
         Bpue579P1RQsqrn46A6lfHpUxq7IVJNTbJOzh6R8=
Date:   Thu, 24 Mar 2022 18:08:41 -0700
To:     zhangyinan2019@email.szu.edu.cn, zhangshengju@cmss.chinamobile.com,
        weizhenliang@huawei.com, tangbin@cmss.chinamobile.com,
        sfr@canb.auug.org.au, ch0.han@lge.com, seanga2@gmail.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 002/114] tools/vm/page_owner_sort.c: support sorting by stack trace
Message-Id: <20220325010842.06A32C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
