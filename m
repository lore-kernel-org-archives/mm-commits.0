Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23349C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 23:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235561AbiDDXVx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 19:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242774AbiDDXVW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 19:21:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B84DFE7
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 16:19:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29B17B81AB7
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 23:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF813C2BBE4;
        Mon,  4 Apr 2022 23:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649114362;
        bh=a8rD+H+EuvCHEunzDA9tlCzRTNBeuzS3Gaqlt5/rdAE=;
        h=Date:To:From:Subject:From;
        b=Wc8V30rD89Y48kyD78B5jQG3TjvD3Z9xyTQqkxfFmZNFED7eDAprQ+Gq0Q709XbWL
         SghUKpCX+2AJedy/u6N89H5i/QwRrNO30CfRtWYJj5cr51G3+mjIjwSv0Y12Tk/ix2
         f1yQXDl1bvM8ae3XLSCSc1uIuRFGZ1iEqxc2bN7g=
Date:   Mon, 04 Apr 2022 16:19:22 -0700
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn,
        zhangyinan2019@email.szu.edu.cn, yuhongf@szu.edu.cn,
        liuyongqiang13@huawei.com, hanshenghong2019@email.szu.edu.cn,
        caoyixuan2019@email.szu.edu.cn, yejiajian2018@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-page_owner_sortc-support-sorting-blocks-by-multiple-keys.patch added to -mm tree
Message-Id: <20220404231922.BF813C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: support sorting blocks by multiple keys
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-support-sorting-blocks-by-multiple-keys.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-support-sorting-blocks-by-multiple-keys.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-support-sorting-blocks-by-multiple-keys.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: support sorting blocks by multiple keys

When viewing page owner information, we may want to sort blocks of
information by multiple keys, since one single key does not uniquely
identify a block. Therefore, following adjustments are made:

1. Add a new --sort option to support sorting blocks of information by
multiple keys.

	./page_owner_sort <input> <output> --sort=<order>
	./page_owner_sort <input> <output> --sort <order>

<order> is a single argument in the form of a comma-separated list,
which offers a way to specify sorting order.

Sorting syntax is [+|-]key[,[+|-]key[,...]]. The ascending or descending
order can be specified by adding the + (ascending, default) or - (descend
-ing) prefix to the key:

	./page_owner_sort <input> <output> [option] --sort -key1,+key2,key3...

For example, to sort the blocks first by task command name in lexicographic
order and then by pid in ascending numerical order, use the following:

	./page_owner_sort <input> <output> --sort=name,+pid

To sort the blocks first by pid in ascending order and then by timestamp
of the page when it is allocated in descending order, use the following:

	./page_owner_sort <input> <output> --sort=pid,-alloc_ts

2. Add explanations of a newly added --sort option in the function usage()
and the document(Documentation/vm/page_owner.rst).

This work is coauthored by
	Yixuan Cao
	Shenghong Han
	Yinan Zhang
	Chongxi Zhao
	Yuhong Feng
	Yongqiang Liu

Link: https://lkml.kernel.org/r/20220401024856.767-3-yejiajian2018@email.szu.edu.cn
Signed-off-by: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Cc: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Cc: Yuhong Feng <yuhongf@szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |   24 ++++
 tools/vm/page_owner_sort.c      |  164 +++++++++++++++++++++++++-----
 2 files changed, 165 insertions(+), 23 deletions(-)

--- a/Documentation/vm/page_owner.rst~tools-vm-page_owner_sortc-support-sorting-blocks-by-multiple-keys
+++ a/Documentation/vm/page_owner.rst
@@ -121,6 +121,14 @@ Usage
 		-r		Sort by memory release time.
 		-s		Sort by stack trace.
 		-t		Sort by times (default).
+		--sort <order>	Specify sorting order.  Sorting syntax is [+|-]key[,[+|-]key[,...]].
+				Choose a key from the **STANDARD FORMAT SPECIFIERS** section. The "+" is
+				optional since default direction is increasing numerical or lexicographic
+				order. Mixed use of abbreviated and complete-form of keys is allowed.
+
+		Examples:
+				./page_owner_sort <input> <output> --sort=n,+pid,-tgid
+				./page_owner_sort <input> <output> --sort=at
 
    additional function:
 
@@ -164,9 +172,23 @@ Usage
 STANDARD FORMAT SPECIFIERS
 ==========================
 
+For --sort option:
+
+	KEY		LONG		DESCRIPTION
+	p		pid		process ID
+	tg		tgid		thread group ID
+	n		name		task command name
+	st		stacktrace	stack trace of the page allocation
+	T		txt		full text of block
+	ft		free_ts		timestamp of the page when it was released
+	at		alloc_ts	timestamp of the page when it was allocated
+
+For --curl option:
+
 	KEY		LONG		DESCRIPTION
 	p		pid		process ID
 	tg		tgid		thread group ID
 	n		name		task command name
 	f		free		whether the page has been released or not
-	st		stacktrace	stace trace of the page allocation
+	st		stacktrace	stack trace of the page allocation
+
--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-support-sorting-blocks-by-multiple-keys
+++ a/tools/vm/page_owner_sort.c
@@ -53,15 +53,29 @@ enum CULL_BIT {
 	CULL_COMM = 1<<4,
 	CULL_STACKTRACE = 1<<5
 };
+enum ARG_TYPE {
+	ARG_TXT, ARG_COMM, ARG_STACKTRACE, ARG_ALLOC_TS, ARG_FREE_TS,
+	ARG_CULL_TIME, ARG_PAGE_NUM, ARG_PID, ARG_TGID, ARG_UNKNOWN, ARG_FREE
+};
+enum SORT_ORDER {
+	SORT_ASC = 1,
+	SORT_DESC = -1,
+};
 struct filter_condition {
-	pid_t *tgids;
-	int tgids_size;
 	pid_t *pids;
-	int pids_size;
+	pid_t *tgids;
 	char **comms;
+	int pids_size;
+	int tgids_size;
 	int comms_size;
 };
+struct sort_condition {
+	int (**cmps)(const void *, const void *);
+	int *signs;
+	int size;
+};
 static struct filter_condition fc;
+static struct sort_condition sc;
 static regex_t order_pattern;
 static regex_t pid_pattern;
 static regex_t tgid_pattern;
@@ -107,14 +121,14 @@ static int compare_num(const void *p1, c
 {
 	const struct block_list *l1 = p1, *l2 = p2;
 
-	return l2->num - l1->num;
+	return l1->num - l2->num;
 }
 
 static int compare_page_num(const void *p1, const void *p2)
 {
 	const struct block_list *l1 = p1, *l2 = p2;
 
-	return l2->page_num - l1->page_num;
+	return l1->page_num - l2->page_num;
 }
 
 static int compare_pid(const void *p1, const void *p2)
@@ -180,6 +194,16 @@ static int compare_cull_condition(const
 	return 0;
 }
 
+static int compare_sort_condition(const void *p1, const void *p2)
+{
+	int cmp = 0;
+
+	for (int i = 0; i < sc.size; ++i)
+		if (cmp == 0)
+			cmp = sc.signs[i] * sc.cmps[i](p1, p2);
+	return cmp;
+}
+
 static int search_pattern(regex_t *pattern, char *pattern_str, char *buf)
 {
 	int err, val_len;
@@ -345,6 +369,29 @@ static char *get_comm(char *buf)
 	return comm_str;
 }
 
+static int get_arg_type(const char *arg)
+{
+	if (!strcmp(arg, "pid") || !strcmp(arg, "p"))
+		return ARG_PID;
+	else if (!strcmp(arg, "tgid") || !strcmp(arg, "tg"))
+		return ARG_TGID;
+	else if (!strcmp(arg, "name") || !strcmp(arg, "n"))
+		return  ARG_COMM;
+	else if (!strcmp(arg, "stacktrace") || !strcmp(arg, "st"))
+		return ARG_STACKTRACE;
+	else if (!strcmp(arg, "free") || !strcmp(arg, "f"))
+		return ARG_FREE;
+	else if (!strcmp(arg, "txt") || !strcmp(arg, "T"))
+		return ARG_TXT;
+	else if (!strcmp(arg, "free_ts") || !strcmp(arg, "ft"))
+		return ARG_FREE_TS;
+	else if (!strcmp(arg, "alloc_ts") || !strcmp(arg, "at"))
+		return ARG_ALLOC_TS;
+	else {
+		return ARG_UNKNOWN;
+	}
+}
+
 static bool match_num_list(int num, int *list, int list_size)
 {
 	for (int i = 0; i < list_size; ++i)
@@ -428,21 +475,86 @@ static bool parse_cull_args(const char *
 	int size = 0;
 	char **args = explode(',', arg_str, &size);
 
-	for (int i = 0; i < size; ++i)
-		if (!strcmp(args[i], "pid") || !strcmp(args[i], "p"))
+	for (int i = 0; i < size; ++i) {
+		int arg_type = get_arg_type(args[i]);
+
+		if (arg_type == ARG_PID)
 			cull |= CULL_PID;
-		else if (!strcmp(args[i], "tgid") || !strcmp(args[i], "tg"))
+		else if (arg_type == ARG_TGID)
 			cull |= CULL_TGID;
-		else if (!strcmp(args[i], "name") || !strcmp(args[i], "n"))
+		else if (arg_type == ARG_COMM)
 			cull |= CULL_COMM;
-		else if (!strcmp(args[i], "stacktrace") || !strcmp(args[i], "st"))
+		else if (arg_type == ARG_STACKTRACE)
 			cull |= CULL_STACKTRACE;
-		else if (!strcmp(args[i], "free") || !strcmp(args[i], "f"))
+		else if (arg_type == ARG_FREE)
 			cull |= CULL_UNRELEASE;
 		else {
 			free_explode(args, size);
 			return false;
 		}
+	}
+	free_explode(args, size);
+	return true;
+}
+
+static void set_single_cmp(int (*cmp)(const void *, const void *), int sign)
+{
+	if (sc.signs == NULL || sc.size < 1)
+		sc.signs = calloc(1, sizeof(int));
+	sc.signs[0] = sign;
+	if (sc.cmps == NULL || sc.size < 1)
+		sc.cmps = calloc(1, sizeof(int *));
+	sc.cmps[0] = cmp;
+	sc.size = 1;
+}
+
+static bool parse_sort_args(const char *arg_str)
+{
+	int size = 0;
+
+	if (sc.size != 0) { /* reset sort_condition */
+		free(sc.signs);
+		free(sc.cmps);
+		size = 0;
+	}
+
+	char **args = explode(',', arg_str, &size);
+
+	sc.signs = calloc(size, sizeof(int));
+	sc.cmps = calloc(size, sizeof(int *));
+	for (int i = 0; i < size; ++i) {
+		int offset = 0;
+
+		sc.signs[i] = SORT_ASC;
+		if (args[i][0] == '-' || args[i][0] == '+') {
+			if (args[i][0] == '-')
+				sc.signs[i] = SORT_DESC;
+			offset = 1;
+		}
+
+		int arg_type = get_arg_type(args[i]+offset);
+
+		if (arg_type == ARG_PID)
+			sc.cmps[i] = compare_pid;
+		else if (arg_type == ARG_TGID)
+			sc.cmps[i] = compare_tgid;
+		else if (arg_type == ARG_COMM)
+			sc.cmps[i] = compare_comm;
+		else if (arg_type == ARG_STACKTRACE)
+			sc.cmps[i] = compare_stacktrace;
+		else if (arg_type == ARG_ALLOC_TS)
+			sc.cmps[i] = compare_ts;
+		else if (arg_type == ARG_FREE_TS)
+			sc.cmps[i] = compare_free_ts;
+		else if (arg_type == ARG_TXT)
+			sc.cmps[i] = compare_txt;
+		else {
+			free_explode(args, size);
+			sc.size = 0;
+			return false;
+		}
+	}
+	sc.size = size;
 	free_explode(args, size);
 	return true;
 }
@@ -485,13 +597,13 @@ static void usage(void)
 		"--pid <pidlist>\tSelect by pid. This selects the information of blocks whose process ID numbers appear in <pidlist>.\n"
 		"--tgid <tgidlist>\tSelect by tgid. This selects the information of blocks whose Thread Group ID numbers appear in <tgidlist>.\n"
 		"--name <cmdlist>\n\t\tSelect by command name. This selects the information of blocks whose command name appears in <cmdlist>.\n"
-		"--cull <rules>\tCull by user-defined rules. <rules> is a single argument in the form of a comma-separated list with some common fields predefined\n"
+		"--cull <rules>\tCull by user-defined rules.<rules> is a single argument in the form of a comma-separated list with some common fields predefined\n"
+		"--sort <order>\tSpecify sort order as: [+|-]key[,[+|-]key[,...]]\n"
 	);
 }
 
 int main(int argc, char **argv)
 {
-	int (*cmp)(const void *, const void *) = compare_num;
 	FILE *fin, *fout;
 	char *buf;
 	int ret, i, count;
@@ -502,37 +614,38 @@ int main(int argc, char **argv)
 		{ "tgid", required_argument, NULL, 2 },
 		{ "name", required_argument, NULL, 3 },
 		{ "cull",  required_argument, NULL, 4 },
+		{ "sort",  required_argument, NULL, 5 },
 		{ 0, 0, 0, 0},
 	};
 
 	while ((opt = getopt_long(argc, argv, "afmnprstP", longopts, NULL)) != -1)
 		switch (opt) {
 		case 'a':
-			cmp = compare_ts;
+			set_single_cmp(compare_ts, SORT_ASC);
 			break;
 		case 'f':
 			filter = filter | FILTER_UNRELEASE;
 			break;
 		case 'm':
-			cmp = compare_page_num;
+			set_single_cmp(compare_page_num, SORT_DESC);
 			break;
 		case 'p':
-			cmp = compare_pid;
+			set_single_cmp(compare_pid, SORT_ASC);
 			break;
 		case 'r':
-			cmp = compare_free_ts;
+			set_single_cmp(compare_free_ts, SORT_ASC);
 			break;
 		case 's':
-			cmp = compare_stacktrace;
+			set_single_cmp(compare_stacktrace, SORT_ASC);
 			break;
 		case 't':
-			cmp = compare_num;
+			set_single_cmp(compare_num, SORT_DESC);
 			break;
 		case 'P':
-			cmp = compare_tgid;
+			set_single_cmp(compare_tgid, SORT_ASC);
 			break;
 		case 'n':
-			cmp = compare_comm;
+			set_single_cmp(compare_comm, SORT_ASC);
 			break;
 		case 1:
 			filter = filter | FILTER_PID;
@@ -563,6 +676,13 @@ int main(int argc, char **argv)
 				exit(1);
 			}
 			break;
+		case 5:
+			if (!parse_sort_args(optarg)) {
+				fprintf(stderr, "wrong argument after --sort option:%s\n",
+						optarg);
+				exit(1);
+			}
+			break;
 		default:
 			usage();
 			exit(1);
@@ -622,7 +742,7 @@ int main(int argc, char **argv)
 		}
 	}
 
-	qsort(list, count, sizeof(list[0]), cmp);
+	qsort(list, count, sizeof(list[0]), compare_sort_condition);
 
 	for (i = 0; i < count; i++) {
 		if (cull == 0)
_

Patches currently in -mm which might be from yejiajian2018@email.szu.edu.cn are

tools-vm-page_owner_sortc-use-fprintf-to-send-error-messages-to-stderr.patch
tools-vm-page_owner_sortc-support-for-multi-value-selection-in-single-argument.patch
tools-vm-page_owner_sortc-support-sorting-blocks-by-multiple-keys.patch

