Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC8FEC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  7 Dec 2021 00:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359387AbhLGAwA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Dec 2021 19:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbhLGAv7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Dec 2021 19:51:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACC7C061746
        for <mm-commits@vger.kernel.org>; Mon,  6 Dec 2021 16:48:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 711CBCE194B
        for <mm-commits@vger.kernel.org>; Tue,  7 Dec 2021 00:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4A3C004DD;
        Tue,  7 Dec 2021 00:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638838106;
        bh=10cQvIHh6eDAs7EmoQESDxvLG9hfZhthVUOp3AoBn1Y=;
        h=Date:From:To:Subject:From;
        b=k3q9TU9UOxtKHZQd95I12rLYpl8BDgUWQ4VMmVFUodBt2Ce5x+TEquZHZj4mZMqAT
         0ig+pB2nmDVKRentBJS/AgHU/UU39cTcrzi189GoGz9NXvfNAcCtIS3V9sDUHdqh5H
         KbcAl+wrHj70RdLYQ7jSzvXX+eSpIddPaNHhZ46I=
Date:   Mon, 06 Dec 2021 16:48:25 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn
Subject:  +
 tools-vm-page_owner_sortc-support-sorting-pid-and-time.patch added to -mm
 tree
Message-ID: <20211207004825.ZMtcU8uYz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: support sorting pid and time
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-support-sorting-pid-and-time.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-support-sorting-pid-and-time.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-support-sorting-pid-and-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: support sorting pid and time

When viewing the page owner information, we expect that the information
can be sorted by PID, so that we can quickly combine PID with the program
to check the information together.

We also expect that the information can be sorted by time.  Time sorting
helps to view the running status of the program according to the time
interval when the program hangs up.

Finally, we hope to pass the page_ owner_ Sort.  C can reduce part of the
output and only output the plate information whose memory has not been
released, which can make us locate the problem of the program faster. 
Therefore, the following adjustments have been made:

1. Add the static functions search_pattern and check_regcomp to
   improve the cleanliness.

2. Add member attributes and their corresponding sorting methods.  In
   terms of comparison time, int will overflow because the data of ull is
   too large, so the ternary operator is used

3. Add the -f parameter to filter out the information of blocks whose
   memory has not been released

Link: https://lkml.kernel.org/r/20211206165653.5093-1-zhaochongxi2019@email.szu.edu.cn
Signed-off-by: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |  177 +++++++++++++++++++++++++++++------
 1 file changed, 148 insertions(+), 29 deletions(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-support-sorting-pid-and-time
+++ a/tools/vm/page_owner_sort.c
@@ -20,6 +20,7 @@
 #include <string.h>
 #include <regex.h>
 #include <errno.h>
+#include <linux/types.h>
 
 struct block_list {
 	char *txt;
@@ -27,9 +28,15 @@ struct block_list {
 	int len;
 	int num;
 	int page_num;
+	pid_t pid;
+	__u64 ts_nsec;
+	__u64 free_ts_nsec;
 };
 
 static regex_t order_pattern;
+static regex_t pid_pattern;
+static regex_t ts_nsec_pattern;
+static regex_t free_ts_nsec_pattern;
 static struct block_list *list;
 static int list_size;
 static int max_size;
@@ -79,34 +86,124 @@ static int compare_page_num(const void *
 	return l2->page_num - l1->page_num;
 }
 
-static int get_page_num(char *buf)
+static int compare_pid(const void *p1, const void *p2)
 {
-	int err, val_len, order_val;
-	char order_str[4] = {0};
-	char *endptr;
+	const struct block_list *l1 = p1, *l2 = p2;
+
+	return l1->pid - l2->pid;
+}
+
+static int compare_ts(const void *p1, const void *p2)
+{
+	const struct block_list *l1 = p1, *l2 = p2;
+
+	return l1->ts_nsec < l2->ts_nsec ? -1 : 1;
+}
+
+static int compare_free_ts(const void *p1, const void *p2)
+{
+	const struct block_list *l1 = p1, *l2 = p2;
+
+	return l1->free_ts_nsec < l2->free_ts_nsec ? -1 : 1;
+}
+
+static int search_pattern(regex_t *pattern, char *pattern_str, char *buf)
+{
+	int err, val_len;
 	regmatch_t pmatch[2];
 
-	err = regexec(&order_pattern, buf, 2, pmatch, REG_NOTBOL);
+	err = regexec(pattern, buf, 2, pmatch, REG_NOTBOL);
 	if (err != 0 || pmatch[1].rm_so == -1) {
-		printf("no order pattern in %s\n", buf);
-		return 0;
+		printf("no matching pattern in %s\n", buf);
+		return -1;
 	}
 	val_len = pmatch[1].rm_eo - pmatch[1].rm_so;
-	if (val_len > 2) /* max_order should not exceed 2 digits */
-		goto wrong_order;
 
-	memcpy(order_str, buf + pmatch[1].rm_so, val_len);
+	memcpy(pattern_str, buf + pmatch[1].rm_so, val_len);
+
+	return 0;
+}
+
+static void check_regcomp(regex_t *pattern, const char *regex)
+{
+	int err;
+
+	err = regcomp(pattern, regex, REG_EXTENDED | REG_NEWLINE);
+	if (err != 0 || pattern->re_nsub != 1) {
+		printf("Invalid pattern %s code %d\n", regex, err);
+		exit(1);
+	}
+}
+
+# define FIELD_BUFF 25
+
+static int get_page_num(char *buf)
+{
+	int order_val;
+	char order_str[FIELD_BUFF] = {0};
+	char *endptr;
 
+	search_pattern(&order_pattern, order_str, buf);
 	errno = 0;
 	order_val = strtol(order_str, &endptr, 10);
-	if (errno != 0 || endptr == order_str || *endptr != '\0')
-		goto wrong_order;
+	if (order_val > 64 || errno != 0 || endptr == order_str || *endptr != '\0') {
+		printf("wrong order in follow buf:\n%s\n", buf);
+		return 0;
+	}
 
 	return 1 << order_val;
+}
 
-wrong_order:
-	printf("wrong order in follow buf:\n%s\n", buf);
-	return 0;
+static pid_t get_pid(char *buf)
+{
+	pid_t pid;
+	char pid_str[FIELD_BUFF] = {0};
+	char *endptr;
+
+	search_pattern(&pid_pattern, pid_str, buf);
+	errno = 0;
+	pid = strtol(pid_str, &endptr, 10);
+	if (errno != 0 || endptr == pid_str || *endptr != '\0') {
+		printf("wrong/invalid pid in follow buf:\n%s\n", buf);
+		return -1;
+	}
+
+	return pid;
+
+}
+
+static __u64 get_ts_nsec(char *buf)
+{
+	__u64 ts_nsec;
+	char ts_nsec_str[FIELD_BUFF] = {0};
+	char *endptr;
+
+	search_pattern(&ts_nsec_pattern, ts_nsec_str, buf);
+	errno = 0;
+	ts_nsec = strtoull(ts_nsec_str, &endptr, 10);
+	if (errno != 0 || endptr == ts_nsec_str || *endptr != '\0') {
+		printf("wrong ts_nsec in follow buf:\n%s\n", buf);
+		return -1;
+	}
+
+	return ts_nsec;
+}
+
+static __u64 get_free_ts_nsec(char *buf)
+{
+	__u64 free_ts_nsec;
+	char free_ts_nsec_str[FIELD_BUFF] = {0};
+	char *endptr;
+
+	search_pattern(&free_ts_nsec_pattern, free_ts_nsec_str, buf);
+	errno = 0;
+	free_ts_nsec = strtoull(free_ts_nsec_str, &endptr, 10);
+	if (errno != 0 || endptr == free_ts_nsec_str || *endptr != '\0') {
+		printf("wrong free_ts_nsec in follow buf:\n%s\n", buf);
+		return -1;
+	}
+
+	return free_ts_nsec;
 }
 
 static void add_list(char *buf, int len)
@@ -129,6 +226,11 @@ static void add_list(char *buf, int len)
 	memcpy(list[list_size].txt, buf, len);
 	list[list_size].txt[len] = 0;
 	list[list_size].stacktrace = strchr(list[list_size].txt, '\n') ?: "";
+	list[list_size].pid = get_pid(buf);
+	list[list_size].ts_nsec = get_ts_nsec(buf);
+	list[list_size].free_ts_nsec = get_free_ts_nsec(buf);
+	memcpy(list[list_size].txt, buf, len);
+	list[list_size].txt[len] = 0;
 	list_size++;
 	if (list_size % 1000 == 0) {
 		printf("loaded %d\r", list_size);
@@ -144,6 +246,9 @@ static void usage(void)
 		"-m	Sort by total memory.\n"
 		"-s	Sort by the stack trace.\n"
 		"-t	Sort by times (default).\n"
+		"-p	Sort by pid.\n"
+		"-a	Sort by memory allocate time.\n"
+		"-r	Sort by memory release time.\n"
 		"-c	cull by comparing stacktrace instead of total block.\n"
 	);
 }
@@ -152,28 +257,40 @@ int main(int argc, char **argv)
 {
 	int (*cmp)(const void *, const void *) = compare_num;
 	int cull_st = 0;
+	int filter = 0;
 	FILE *fin, *fout;
 	char *buf;
 	int ret, i, count;
 	struct block_list *list2;
 	struct stat st;
-	int err;
 	int opt;
 
-	while ((opt = getopt(argc, argv, "mstc")) != -1)
+	while ((opt = getopt(argc, argv, "acfmprst")) != -1)
 		switch (opt) {
+		case 'a':
+			cmp = compare_ts;
+			break;
+		case 'c':
+			cull_st = 1;
+			break;
+		case 'f':
+			filter = 1;
+			break;
 		case 'm':
 			cmp = compare_page_num;
 			break;
+		case 'p':
+			cmp = compare_pid;
+			break;
+		case 'r':
+			cmp = compare_free_ts;
+			break;
 		case 's':
 			cmp = compare_stacktrace;
 			break;
 		case 't':
 			cmp = compare_num;
 			break;
-		case 'c':
-			cull_st = 1;
-			break;
 		default:
 			usage();
 			exit(1);
@@ -192,13 +309,10 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	err = regcomp(&order_pattern, "order\\s*([0-9]*),", REG_EXTENDED|REG_NEWLINE);
-	if (err != 0 || order_pattern.re_nsub != 1) {
-		printf("%s: Invalid pattern 'order\\s*([0-9]*),' code %d\n",
-			argv[0], err);
-		exit(1);
-	}
-
+	check_regcomp(&order_pattern, "order\\s*([0-9]*),");
+	check_regcomp(&pid_pattern, "pid\\s*([0-9]*),");
+	check_regcomp(&ts_nsec_pattern, "ts\\s*([0-9]*)\\s*ns,");
+	check_regcomp(&free_ts_nsec_pattern, "free_ts\\s*([0-9]*)\\s*ns");
 	fstat(fileno(fin), &st);
 	max_size = st.st_size / 100; /* hack ... */
 
@@ -248,10 +362,15 @@ int main(int argc, char **argv)
 
 	qsort(list2, count, sizeof(list[0]), cmp);
 
-	for (i = 0; i < count; i++)
+	for (i = 0; i < count; i++) {
+		if (filter == 1 && list2[i].free_ts_nsec != 0)
+			continue;
 		fprintf(fout, "%d times, %d pages:\n%s\n",
 				list2[i].num, list2[i].page_num, list2[i].txt);
-
+	}
 	regfree(&order_pattern);
+	regfree(&pid_pattern);
+	regfree(&ts_nsec_pattern);
+	regfree(&free_ts_nsec_pattern);
 	return 0;
 }
_

Patches currently in -mm which might be from zhaochongxi2019@email.szu.edu.cn are

tools-vm-page_owner_sortc-support-sorting-pid-and-time.patch

