Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC7FC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbiCYWnY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiCYWnS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1C5209A56
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E015B82A1C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF091C004DD;
        Fri, 25 Mar 2022 22:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248102;
        bh=QKt+iTqAEo+EDw66bDlGdiv6fEXw2Dw/TZcNCys04Y4=;
        h=Date:To:From:Subject:From;
        b=e03pAu8n6unmu1k8ltQmOxlbYg/cAZ5x2t9xfGcct7yWh042qZ+3APFbn2TZW+iJa
         wFelv8Yl1RpdGwdRjKQj4xEiIGPxoqG/ILgmG1t5MaZLECMMdufSunBiHvZL59hEzn
         kB8zkKwT0FYTmzhXNKYq1u8fIgkERS+2OPdvPw+U=
Date:   Fri, 25 Mar 2022 15:41:41 -0700
To:     mm-commits@vger.kernel.org, zhangyinan2019@email.szu.edu.cn,
        weizhenliang@huawei.com, sfr@canb.auug.org.au, seanga2@gmail.com,
        hanshenghong2019@email.szu.edu.cn, caoyixuan2019@email.szu.edu.cn,
        yejiajian2018@email.szu.edu.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tools-vm-page_owner_sort-fix-three-trivival-places.patch removed from -mm tree
Message-Id: <20220325224141.DF091C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort: fix three trivival places
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sort-fix-three-trivival-places.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort: fix three trivival places

The following adjustments are made:

1. Instead of using another array to cull the blocks after sorting,
   reuse the old array.  So there is no need to malloc a new array.

2. When enabling '-f' option to filter out the blocks which have been
   released, only add those have not been released in the list, rather
   than add all of blocks in the list and then do the filtering when
   printing the result.

3. When enabling '-c' option to cull the blocks by comparing
   stacktrace, print the stacetrace rather than the total block.

Link: https://lkml.kernel.org/r/20220306030640.43054-1-yejiajian2018@email.szu.edu.cn
Signed-off-by: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: <hanshenghong2019@email.szu.edu.cn>
Cc: Sean Anderson <seanga2@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: <zhangyinan2019@email.szu.edu.cn>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |   37 +++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sort-fix-three-trivival-places
+++ a/tools/vm/page_owner_sort.c
@@ -42,6 +42,8 @@ static regex_t free_ts_nsec_pattern;
 static struct block_list *list;
 static int list_size;
 static int max_size;
+static int cull_st;
+static int filter;
 
 int read_block(char *buf, int buf_size, FILE *fin)
 {
@@ -245,6 +247,9 @@ static void add_list(char *buf, int len)
 		exit(1);
 	}
 
+	list[list_size].free_ts_nsec = get_free_ts_nsec(buf);
+	if (filter == 1 && list[list_size].free_ts_nsec != 0)
+		return;
 	list[list_size].txt = malloc(len+1);
 	if (!list[list_size].txt) {
 		printf("Out of memory\n");
@@ -257,10 +262,11 @@ static void add_list(char *buf, int len)
 	memcpy(list[list_size].txt, buf, len);
 	list[list_size].txt[len] = 0;
 	list[list_size].stacktrace = strchr(list[list_size].txt, '\n') ?: "";
+	if (*list[list_size].stacktrace == '\n')
+		list[list_size].stacktrace++;
 	list[list_size].pid = get_pid(buf);
 	list[list_size].tgid = get_tgid(buf);
 	list[list_size].ts_nsec = get_ts_nsec(buf);
-	list[list_size].free_ts_nsec = get_free_ts_nsec(buf);
 	list_size++;
 	if (list_size % 1000 == 0) {
 		printf("loaded %d\r", list_size);
@@ -288,12 +294,9 @@ static void usage(void)
 int main(int argc, char **argv)
 {
 	int (*cmp)(const void *, const void *) = compare_num;
-	int cull_st = 0;
-	int filter = 0;
 	FILE *fin, *fout;
 	char *buf;
 	int ret, i, count;
-	struct block_list *list2;
 	struct stat st;
 	int opt;
 
@@ -376,11 +379,7 @@ int main(int argc, char **argv)
 	else
 		qsort(list, list_size, sizeof(list[0]), compare_txt);
 
-	list2 = malloc(sizeof(*list) * list_size);
-	if (!list2) {
-		printf("Out of memory\n");
-		exit(1);
-	}
+
 
 	printf("culling\n");
 
@@ -388,21 +387,23 @@ int main(int argc, char **argv)
 
 	for (i = count = 0; i < list_size; i++) {
 		if (count == 0 ||
-		    strcmp(*(&list2[count-1].txt+offset), *(&list[i].txt+offset)) != 0) {
-			list2[count++] = list[i];
+		    strcmp(*(&list[count-1].txt+offset), *(&list[i].txt+offset)) != 0) {
+			list[count++] = list[i];
 		} else {
-			list2[count-1].num += list[i].num;
-			list2[count-1].page_num += list[i].page_num;
+			list[count-1].num += list[i].num;
+			list[count-1].page_num += list[i].page_num;
 		}
 	}
 
-	qsort(list2, count, sizeof(list[0]), cmp);
+	qsort(list, count, sizeof(list[0]), cmp);
 
 	for (i = 0; i < count; i++) {
-		if (filter == 1 && list2[i].free_ts_nsec != 0)
-			continue;
-		fprintf(fout, "%d times, %d pages:\n%s\n",
-				list2[i].num, list2[i].page_num, list2[i].txt);
+		if (cull_st == 0)
+			fprintf(fout, "%d times, %d pages:\n%s\n",
+					list[i].num, list[i].page_num, list[i].txt);
+		else
+			fprintf(fout, "%d times, %d pages:\n%s\n",
+					list[i].num, list[i].page_num, list[i].stacktrace);
 	}
 	regfree(&order_pattern);
 	regfree(&pid_pattern);
_

Patches currently in -mm which might be from yejiajian2018@email.szu.edu.cn are


