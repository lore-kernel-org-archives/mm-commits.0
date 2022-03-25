Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305FFC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbiCYWnC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbiCYWnC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18601208C14
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5776614A8
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B67C004DD;
        Fri, 25 Mar 2022 22:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248086;
        bh=yyb6PvzgRUjsYle1VduF/ErCUWQ6qqdUtxPQ9MMurQM=;
        h=Date:To:From:Subject:From;
        b=sRaQ5n+HGVz2sYYY4DwHiEqre8CXDLD1rkBeLwt/91y+1roQhYCOlFOHhNlVe7zro
         j4OHjM2WDcE6/qAtxAqm41FWNx1jPtdaW+9dcT9+3/R7RT+p77jiDKbZXe80NMQMZj
         f5CeOHPn25lmbuYzzzOl+Jg8pEZArHEDIbfga0bw=
Date:   Fri, 25 Mar 2022 15:41:25 -0700
To:     mm-commits@vger.kernel.org, zhangshengju@cmss.chinamobile.com,
        weizhenliang@huawei.com, tangbin@cmss.chinamobile.com,
        sfr@canb.auug.org.au, seanga2@gmail.com, ch0.han@lge.com,
        zhangyinan2019@email.szu.edu.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tools-vm-page_owner_sortc-add-switch-between-culling-by-stacktrace-and-txt.patch removed from -mm tree
Message-Id: <20220325224125.F0B67C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: add switch between culling by stacktrace and txt
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sortc-add-switch-between-culling-by-stacktrace-and-txt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: add switch between culling by stacktrace and txt

Culling by comparing stacktrace would casue loss of some information.  For
example, if there exists 2 blocks which have the same stacktrace and the
different head info

Page allocated via order 0, mask 0x108c48(...), pid 73696,
 ts 1578829190639010 ns, free_ts 1576583851324450 ns
 prep_new_page+0x80/0xb8
 get_page_from_freelist+0x924/0xee8
 __alloc_pages+0x138/0xc18
 alloc_pages+0x80/0xf0
 __page_cache_alloc+0x90/0xc8

Page allocated via order 0, mask 0x108c48(...), pid 61806,
 ts 1354113726046100 ns, free_ts 1354104926841400 ns
 prep_new_page+0x80/0xb8
 get_page_from_freelist+0x924/0xee8
 __alloc_pages+0x138/0xc18
 alloc_pages+0x80/0xf0
 __page_cache_alloc+0x90/0xc8

After culling, it would be like this

2 times, 2 pages:
Page allocated via order 0, mask 0x108c48(...), pid 73696,
 ts 1578829190639010 ns, free_ts 1576583851324450 ns
 prep_new_page+0x80/0xb8
 get_page_from_freelist+0x924/0xee8
 __alloc_pages+0x138/0xc18
 alloc_pages+0x80/0xf0
 __page_cache_alloc+0x90/0xc8

The info of second block missed.  So, add -c to turn on culling by
stacktrace.  By default, it will cull by txt.

Link: https://lkml.kernel.org/r/20211129145658.2491-1-zhangyinan2019@email.szu.edu.cn
Signed-off-by: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Changhee Han <ch0.han@lge.com>
Cc: Sean Anderson <seanga2@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-add-switch-between-culling-by-stacktrace-and-txt
+++ a/tools/vm/page_owner_sort.c
@@ -51,6 +51,13 @@ int read_block(char *buf, int buf_size,
 	return -1; /* EOF or no space left in buf. */
 }
 
+static int compare_txt(const void *p1, const void *p2)
+{
+	const struct block_list *l1 = p1, *l2 = p2;
+
+	return strcmp(l1->txt, l2->txt);
+}
+
 static int compare_stacktrace(const void *p1, const void *p2)
 {
 	const struct block_list *l1 = p1, *l2 = p2;
@@ -137,12 +144,14 @@ static void usage(void)
 		"-m	Sort by total memory.\n"
 		"-s	Sort by the stack trace.\n"
 		"-t	Sort by times (default).\n"
+		"-c	cull by comparing stacktrace instead of total block.\n"
 	);
 }
 
 int main(int argc, char **argv)
 {
 	int (*cmp)(const void *, const void *) = compare_num;
+	int cull_st = 0;
 	FILE *fin, *fout;
 	char *buf;
 	int ret, i, count;
@@ -151,7 +160,7 @@ int main(int argc, char **argv)
 	int err;
 	int opt;
 
-	while ((opt = getopt(argc, argv, "mst")) != -1)
+	while ((opt = getopt(argc, argv, "mstc")) != -1)
 		switch (opt) {
 		case 'm':
 			cmp = compare_page_num;
@@ -162,6 +171,9 @@ int main(int argc, char **argv)
 		case 't':
 			cmp = compare_num;
 			break;
+		case 'c':
+			cull_st = 1;
+			break;
 		default:
 			usage();
 			exit(1);
@@ -209,7 +221,10 @@ int main(int argc, char **argv)
 
 	printf("sorting ....\n");
 
-	qsort(list, list_size, sizeof(list[0]), compare_stacktrace);
+	if (cull_st == 1)
+		qsort(list, list_size, sizeof(list[0]), compare_stacktrace);
+	else
+		qsort(list, list_size, sizeof(list[0]), compare_txt);
 
 	list2 = malloc(sizeof(*list) * list_size);
 	if (!list2) {
@@ -219,9 +234,11 @@ int main(int argc, char **argv)
 
 	printf("culling\n");
 
+	long offset = cull_st ? &list[0].stacktrace - &list[0].txt : 0;
+
 	for (i = count = 0; i < list_size; i++) {
 		if (count == 0 ||
-		    strcmp(list2[count-1].stacktrace, list[i].stacktrace) != 0) {
+		    strcmp(*(&list2[count-1].txt+offset), *(&list[i].txt+offset)) != 0) {
 			list2[count++] = list[i];
 		} else {
 			list2[count-1].num += list[i].num;
_

Patches currently in -mm which might be from zhangyinan2019@email.szu.edu.cn are


