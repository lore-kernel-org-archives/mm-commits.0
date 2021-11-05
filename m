Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C890C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26E3C6126A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhKEUph (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233648AbhKEUpg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:45:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1041A61262;
        Fri,  5 Nov 2021 20:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144976;
        bh=NdXlU74NTWYD8cSkdCUS09bFpTGLqdSV68+IKtH5ugk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=d8ng3W/M/+h3BbP9KdZ+4ExvETS2A0LaElp0oViz3Bnh+vyTg//42SKg+mRJXbn0f
         zfLAHZLEa7qJ2n0Ino118R1rvHSC8LVjo4kswv6/VR1D9+GmucN3TrBZOCYWbjkdtH
         4AOGVv7eP6Pt01zF0Pctj4hCOQ1wuYZHscmKoJPU=
Date:   Fri, 05 Nov 2021 13:42:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, nixiaoming@huawei.com,
        tangbin@cmss.chinamobile.com, torvalds@linux-foundation.org,
        weizhenliang@huawei.com, zhangshengju@cmss.chinamobile.com
Subject:  [patch 158/262] tools/vm/page_owner_sort.c: count and
 sort by mem
Message-ID: <20211105204255.iNP0h-4F-%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhenliang Wei <weizhenliang@huawei.com>
Subject: tools/vm/page_owner_sort.c: count and sort by mem

When viewing page owner information, we may be more concerned about the
total memory rather than the times of stack appears.  Therefore, the
following adjustments are made:

1. Added the statistics on the total number of pages.

2. Added the optional parameter "-m" to configure the program to sort by
   memory (total pages).

The general output of page_owner is as follows:

	Page allocated via order XXX, ...
	PFN XXX ...
	 // Detailed stack

	Page allocated via order XXX, ...
	PFN XXX ...
	 // Detailed stack

The original page_owner_sort ignores PFN rows, puts the remaining rows
in buf, counts the times of buf, and finally sorts them according to
the times. General output:

	XXX times:
	Page allocated via order XXX, ...
	 // Detailed stack

Now, we use regexp to extract the page order value from the buf,
and count the total pages for the buf. General output:

	XXX times, XXX pages:
	Page allocated via order XXX, ...
	 // Detailed stack

By default, it is still sorted by the times of buf;
If you want to sort by the pages nums of buf, use the new -m parameter.

Link: https://lkml.kernel.org/r/1631678242-41033-1-git-send-email-weizhenliang@huawei.com
Signed-off-by: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |   23 +++++++
 tools/vm/page_owner_sort.c      |   94 +++++++++++++++++++++++++++---
 2 files changed, 107 insertions(+), 10 deletions(-)

--- a/Documentation/vm/page_owner.rst~tools-vm-page_owner_sortc-count-and-sort-by-mem
+++ a/Documentation/vm/page_owner.rst
@@ -85,5 +85,26 @@ Usage
 	cat /sys/kernel/debug/page_owner > page_owner_full.txt
 	./page_owner_sort page_owner_full.txt sorted_page_owner.txt
 
+   The general output of ``page_owner_full.txt`` is as follows:
+
+	Page allocated via order XXX, ...
+	PFN XXX ...
+	 // Detailed stack
+
+	Page allocated via order XXX, ...
+	PFN XXX ...
+	 // Detailed stack
+
+   The ``page_owner_sort`` tool ignores ``PFN`` rows, puts the remaining rows
+   in buf, uses regexp to extract the page order value, counts the times
+   and pages of buf, and finally sorts them according to the times.
+
    See the result about who allocated each page
-   in the ``sorted_page_owner.txt``.
+   in the ``sorted_page_owner.txt``. General output:
+
+	XXX times, XXX pages:
+	Page allocated via order XXX, ...
+	 // Detailed stack
+
+   By default, ``page_owner_sort`` is sorted according to the times of buf.
+   If you want to sort by the pages nums of buf, use the ``-m`` parameter.
--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-count-and-sort-by-mem
+++ a/tools/vm/page_owner_sort.c
@@ -5,6 +5,8 @@
  * Example use:
  * cat /sys/kernel/debug/page_owner > page_owner_full.txt
  * ./page_owner_sort page_owner_full.txt sorted_page_owner.txt
+ * Or sort by total memory:
+ * ./page_owner_sort -m page_owner_full.txt sorted_page_owner.txt
  *
  * See Documentation/vm/page_owner.rst
 */
@@ -16,14 +18,18 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <string.h>
+#include <regex.h>
+#include <errno.h>
 
 struct block_list {
 	char *txt;
 	int len;
 	int num;
+	int page_num;
 };
 
-
+static int sort_by_memory;
+static regex_t order_pattern;
 static struct block_list *list;
 static int list_size;
 static int max_size;
@@ -59,12 +65,50 @@ static int compare_num(const void *p1, c
 	return l2->num - l1->num;
 }
 
+static int compare_page_num(const void *p1, const void *p2)
+{
+	const struct block_list *l1 = p1, *l2 = p2;
+
+	return l2->page_num - l1->page_num;
+}
+
+static int get_page_num(char *buf)
+{
+	int err, val_len, order_val;
+	char order_str[4] = {0};
+	char *endptr;
+	regmatch_t pmatch[2];
+
+	err = regexec(&order_pattern, buf, 2, pmatch, REG_NOTBOL);
+	if (err != 0 || pmatch[1].rm_so == -1) {
+		printf("no order pattern in %s\n", buf);
+		return 0;
+	}
+	val_len = pmatch[1].rm_eo - pmatch[1].rm_so;
+	if (val_len > 2) /* max_order should not exceed 2 digits */
+		goto wrong_order;
+
+	memcpy(order_str, buf + pmatch[1].rm_so, val_len);
+
+	errno = 0;
+	order_val = strtol(order_str, &endptr, 10);
+	if (errno != 0 || endptr == order_str || *endptr != '\0')
+		goto wrong_order;
+
+	return 1 << order_val;
+
+wrong_order:
+	printf("wrong order in follow buf:\n%s\n", buf);
+	return 0;
+}
+
 static void add_list(char *buf, int len)
 {
 	if (list_size != 0 &&
 	    len == list[list_size-1].len &&
 	    memcmp(buf, list[list_size-1].txt, len) == 0) {
 		list[list_size-1].num++;
+		list[list_size-1].page_num += get_page_num(buf);
 		return;
 	}
 	if (list_size == max_size) {
@@ -74,6 +118,7 @@ static void add_list(char *buf, int len)
 	list[list_size].txt = malloc(len+1);
 	list[list_size].len = len;
 	list[list_size].num = 1;
+	list[list_size].page_num = get_page_num(buf);
 	memcpy(list[list_size].txt, buf, len);
 	list[list_size].txt[len] = 0;
 	list_size++;
@@ -85,6 +130,13 @@ static void add_list(char *buf, int len)
 
 #define BUF_SIZE	(128 * 1024)
 
+static void usage(void)
+{
+	printf("Usage: ./page_owner_sort [-m] <input> <output>\n"
+		"-m	Sort by total memory. If this option is unset, sort by times\n"
+	);
+}
+
 int main(int argc, char **argv)
 {
 	FILE *fin, *fout;
@@ -92,21 +144,39 @@ int main(int argc, char **argv)
 	int ret, i, count;
 	struct block_list *list2;
 	struct stat st;
+	int err;
+	int opt;
 
-	if (argc < 3) {
-		printf("Usage: ./program <input> <output>\n");
-		perror("open: ");
+	while ((opt = getopt(argc, argv, "m")) != -1)
+		switch (opt) {
+		case 'm':
+			sort_by_memory = 1;
+			break;
+		default:
+			usage();
+			exit(1);
+		}
+
+	if (optind >= (argc - 1)) {
+		usage();
 		exit(1);
 	}
 
-	fin = fopen(argv[1], "r");
-	fout = fopen(argv[2], "w");
+	fin = fopen(argv[optind], "r");
+	fout = fopen(argv[optind + 1], "w");
 	if (!fin || !fout) {
-		printf("Usage: ./program <input> <output>\n");
+		usage();
 		perror("open: ");
 		exit(1);
 	}
 
+	err = regcomp(&order_pattern, "order\\s*([0-9]*),", REG_EXTENDED|REG_NEWLINE);
+	if (err != 0 || order_pattern.re_nsub != 1) {
+		printf("%s: Invalid pattern 'order\\s*([0-9]*),' code %d\n",
+			argv[0], err);
+		exit(1);
+	}
+
 	fstat(fileno(fin), &st);
 	max_size = st.st_size / 100; /* hack ... */
 
@@ -145,13 +215,19 @@ int main(int argc, char **argv)
 			list2[count++] = list[i];
 		} else {
 			list2[count-1].num += list[i].num;
+			list2[count-1].page_num += list[i].page_num;
 		}
 	}
 
-	qsort(list2, count, sizeof(list[0]), compare_num);
+	if (sort_by_memory)
+		qsort(list2, count, sizeof(list[0]), compare_page_num);
+	else
+		qsort(list2, count, sizeof(list[0]), compare_num);
 
 	for (i = 0; i < count; i++)
-		fprintf(fout, "%d times:\n%s\n", list2[i].num, list2[i].txt);
+		fprintf(fout, "%d times, %d pages:\n%s\n",
+				list2[i].num, list2[i].page_num, list2[i].txt);
 
+	regfree(&order_pattern);
 	return 0;
 }
_
