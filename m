Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890CBC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 21:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244450AbhKXVNe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:13:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234102AbhKXVNd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 16:13:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9CD960FE7;
        Wed, 24 Nov 2021 21:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637788223;
        bh=FRIa40bb1bdOcXn+qevHgsEPrWh62WJc4K4TJ6JZSx8=;
        h=Date:From:To:Subject:From;
        b=cjC+oeSmtaF8H31SztgokStgWoXa7QyzavVXtNDXVPvWVRDg03k8lKUu3Sqdck+xt
         UzWcNwq1tZw6vPAxn70u5jLLCkWUZFbIHCQ32AzZFnBhRG55ZBXaV676dwFuzUCjxZ
         wm2YCHF7a1rItWRHRNew4i4tlOEd1YLshCQO1IaM=
Date:   Wed, 24 Nov 2021 13:10:22 -0800
From:   akpm@linux-foundation.org
To:     ch0.han@lge.com, mm-commits@vger.kernel.org, seanga2@gmail.com,
        tangbin@cmss.chinamobile.com, weizhenliang@huawei.com,
        zhangshengju@cmss.chinamobile.com
Subject:  +
 tools-vm-page_owner_sortc-support-sorting-by-stack-trace.patch added to -mm
 tree
Message-ID: <20211124211022.2GJ-I1Azv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: support sorting by stack trace
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-support-sorting-by-stack-trace.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-support-sorting-by-stack-trace.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-support-sorting-by-stack-trace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling.patch
tools-vm-page_owner_sortc-support-sorting-by-stack-trace.patch

