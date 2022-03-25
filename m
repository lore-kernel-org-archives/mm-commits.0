Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE923C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbiCYWn2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbiCYWnT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE8F209A5A
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59FC8B82A36
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AB6C340F0;
        Fri, 25 Mar 2022 22:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248103;
        bh=Jo9VI/p0JlRpcoRK6zAlHpwKRNo3E7q4RQDaLwh2040=;
        h=Date:To:From:Subject:From;
        b=M7lyufonq2t0sZbnhWm10xEVk2v/5nPS/Pq2cv2ocmD88tfXaODbd4ilaw0fVhb0q
         YGTdGaULJx/LFdgeqfj/ayILrvaUE0uwncVmKS9q+Rd59T0ZT9D9QePXH7PuSJVNvV
         sH8mPcB+MKqLf0zdE7TmXTkw8F61AejLX1IB0hYA=
Date:   Fri, 25 Mar 2022 15:41:42 -0700
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn,
        zhangyinan2019@email.szu.edu.cn, weizhenliang@huawei.com,
        sfr@canb.auug.org.au, seanga2@gmail.com,
        hanshenghong2019@email.szu.edu.cn, caoyixuan2019@email.szu.edu.cn,
        yejiajian2018@email.szu.edu.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tools-vm-page_owner_sort-support-for-sorting-by-task-command-name.patch removed from -mm tree
Message-Id: <20220325224142.F1AB6C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort: support for sorting by task command name
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sort-support-for-sorting-by-task-command-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort: support for sorting by task command name

When viewing page owner information, we may also need to the block to be
sorted by task command name.  Therefore, the following adjustments are
made:

1. Add a member variable to record task command name of block.

2. Add a new -n option to sort the information of blocks by task command
   name.

3. Add -n option explanation in the document.

Link: https://lkml.kernel.org/r/20220306030640.43054-2-yejiajian2018@email.szu.edu.cn
Signed-off-by: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sean Anderson <seanga2@gmail.com>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: <zhaochongxi2019@email.szu.edu.cn>
Cc: <hanshenghong2019@email.szu.edu.cn>
Cc: <zhangyinan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    1 
 tools/vm/page_owner_sort.c      |   35 +++++++++++++++++++++++++++++-
 2 files changed, 35 insertions(+), 1 deletion(-)

--- a/Documentation/vm/page_owner.rst~tools-vm-page_owner_sort-support-for-sorting-by-task-command-name
+++ a/Documentation/vm/page_owner.rst
@@ -117,6 +117,7 @@ Usage
 		-m		Sort by total memory.
 		-p		Sort by pid.
 		-P		Sort by tgid.
+		-n		Sort by task command name.
 		-r		Sort by memory release time.
 		-s		Sort by stack trace.
 		-t		Sort by times (default).
--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sort-support-for-sorting-by-task-command-name
+++ a/tools/vm/page_owner_sort.c
@@ -24,6 +24,7 @@
 
 struct block_list {
 	char *txt;
+	char *comm; // task command name
 	char *stacktrace;
 	__u64 ts_nsec;
 	__u64 free_ts_nsec;
@@ -37,6 +38,7 @@ struct block_list {
 static regex_t order_pattern;
 static regex_t pid_pattern;
 static regex_t tgid_pattern;
+static regex_t comm_pattern;
 static regex_t ts_nsec_pattern;
 static regex_t free_ts_nsec_pattern;
 static struct block_list *list;
@@ -102,6 +104,13 @@ static int compare_tgid(const void *p1,
 	return l1->tgid - l2->tgid;
 }
 
+static int compare_comm(const void *p1, const void *p2)
+{
+	const struct block_list *l1 = p1, *l2 = p2;
+
+	return strcmp(l1->comm, l2->comm);
+}
+
 static int compare_ts(const void *p1, const void *p2)
 {
 	const struct block_list *l1 = p1, *l2 = p2;
@@ -145,6 +154,7 @@ static void check_regcomp(regex_t *patte
 }
 
 # define FIELD_BUFF 25
+# define TASK_COMM_LEN 16
 
 static int get_page_num(char *buf)
 {
@@ -233,6 +243,22 @@ static __u64 get_free_ts_nsec(char *buf)
 	return free_ts_nsec;
 }
 
+static char *get_comm(char *buf)
+{
+	char *comm_str = malloc(TASK_COMM_LEN);
+
+	memset(comm_str, 0, TASK_COMM_LEN);
+
+	search_pattern(&comm_pattern, comm_str, buf);
+	errno = 0;
+	if (errno != 0) {
+		printf("wrong comm in follow buf:\n%s\n", buf);
+		return NULL;
+	}
+
+	return comm_str;
+}
+
 static void add_list(char *buf, int len)
 {
 	if (list_size != 0 &&
@@ -266,6 +292,7 @@ static void add_list(char *buf, int len)
 		list[list_size].stacktrace++;
 	list[list_size].pid = get_pid(buf);
 	list[list_size].tgid = get_tgid(buf);
+	list[list_size].comm = get_comm(buf);
 	list[list_size].ts_nsec = get_ts_nsec(buf);
 	list_size++;
 	if (list_size % 1000 == 0) {
@@ -284,6 +311,7 @@ static void usage(void)
 		"-t	Sort by times (default).\n"
 		"-p	Sort by pid.\n"
 		"-P	Sort by tgid.\n"
+		"-n	Sort by task command name.\n"
 		"-a	Sort by memory allocate time.\n"
 		"-r	Sort by memory release time.\n"
 		"-c	Cull by comparing stacktrace instead of total block.\n"
@@ -300,7 +328,7 @@ int main(int argc, char **argv)
 	struct stat st;
 	int opt;
 
-	while ((opt = getopt(argc, argv, "acfmprstP")) != -1)
+	while ((opt = getopt(argc, argv, "acfmnprstP")) != -1)
 		switch (opt) {
 		case 'a':
 			cmp = compare_ts;
@@ -329,6 +357,9 @@ int main(int argc, char **argv)
 		case 'P':
 			cmp = compare_tgid;
 			break;
+		case 'n':
+			cmp = compare_comm;
+			break;
 		default:
 			usage();
 			exit(1);
@@ -350,6 +381,7 @@ int main(int argc, char **argv)
 	check_regcomp(&order_pattern, "order\\s*([0-9]*),");
 	check_regcomp(&pid_pattern, "pid\\s*([0-9]*),");
 	check_regcomp(&tgid_pattern, "tgid\\s*([0-9]*) ");
+	check_regcomp(&comm_pattern, "tgid\\s*[0-9]*\\s*\\((.*)\\),\\s*ts");
 	check_regcomp(&ts_nsec_pattern, "ts\\s*([0-9]*)\\s*ns,");
 	check_regcomp(&free_ts_nsec_pattern, "free_ts\\s*([0-9]*)\\s*ns");
 	fstat(fileno(fin), &st);
@@ -408,6 +440,7 @@ int main(int argc, char **argv)
 	regfree(&order_pattern);
 	regfree(&pid_pattern);
 	regfree(&tgid_pattern);
+	regfree(&comm_pattern);
 	regfree(&ts_nsec_pattern);
 	regfree(&free_ts_nsec_pattern);
 	return 0;
_

Patches currently in -mm which might be from yejiajian2018@email.szu.edu.cn are


