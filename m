Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6993AC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 22:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbhK2W0M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 17:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbhK2WXV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 17:23:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13103C06FD6E
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 12:19:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 24FC0CE169C
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 20:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D257DC53FAD;
        Mon, 29 Nov 2021 20:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638217186;
        bh=zmr3Lb9va0rVn4f6dSk2yfgmSBlFwhI6ufmZWByNtHU=;
        h=Date:From:To:Subject:From;
        b=xF75xrbCGeLn4cEtEK3mu41Wc0iYlVgHKo9tVxtShYhcQgcSN9n2s7oubDi5BXNNf
         Wz9UjZ+sgcYDnMrWFF69HooQd4Ss3JD7MhO0FaiepIZzlqTjc0J3CQQ5LzczAad5or
         2HjmEN0Evh8ZeKBDIwTq7fZQibp289e0fKmvHPEY=
Date:   Mon, 29 Nov 2021 12:19:45 -0800
From:   akpm@linux-foundation.org
To:     ch0.han@lge.com, mm-commits@vger.kernel.org, seanga2@gmail.com,
        sfr@canb.auug.org.au, tangbin@cmss.chinamobile.com,
        weizhenliang@huawei.com, zhangshengju@cmss.chinamobile.com,
        zhangyinan2019@email.szu.edu.cn
Subject:  +
 =?US-ASCII?Q?tools-vm-page=5Fowner=5Fsortc-add-switch-between-culling-by-?=
 =?US-ASCII?Q?stacktrace-and-txt.patch?= added to -mm tree
Message-ID: <20211129201945.-16BT1ZAE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: add switch between culling by stacktrace and txt
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-add-switch-between-culling-by-stacktrace-and-txt.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-add-switch-between-culling-by-stacktrace-and-txt.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-add-switch-between-culling-by-stacktrace-and-txt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tools-vm-page_owner_sortc-add-switch-between-culling-by-stacktrace-and-txt.patch

