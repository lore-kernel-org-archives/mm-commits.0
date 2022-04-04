Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EADC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 23:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbiDDXVw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 19:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242361AbiDDXVT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 19:21:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C39CDFEE
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 16:19:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15F596171C
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 23:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FADC2BBE4;
        Mon,  4 Apr 2022 23:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649114360;
        bh=wR18uWHZsS4IYj/NM8pBuPzEtVs8dWAzDFMZBTuGhh8=;
        h=Date:To:From:Subject:From;
        b=pHea88IoUQZJ3fH8wOY0S7zxrXViIBu1rSQSxDAj9YAd3QFrOKE3kc4TpXPI9sdCm
         +Ck829FJoiQ7WjtXnY4bGH7NH6ZQe623HZ8qzyhlttijeo+FqUK7aE3edOsPTwkj1q
         z013mzgk42JpVIeGtvNqiHe+sIQWOOBibEu3m8Ts=
Date:   Mon, 04 Apr 2022 16:19:19 -0700
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn,
        zhangyinan2019@email.szu.edu.cn, yuhongf@szu.edu.cn,
        liuyongqiang13@huawei.com, hanshenghong2019@email.szu.edu.cn,
        caoyixuan2019@email.szu.edu.cn, yejiajian2018@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-page_owner_sortc-support-for-multi-value-selection-in-single-argument.patch added to -mm tree
Message-Id: <20220404231920.69FADC2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: support for multi-value selection in single argument
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-support-for-multi-value-selection-in-single-argument.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-support-for-multi-value-selection-in-single-argument.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-support-for-multi-value-selection-in-single-argument.patch

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
Subject: tools/vm/page_owner_sort.c: support for multi-value selection in single argument

When viewing page owner information, we may want to select blocks whose
PID/TGID/TASK_COMM_NAME appears in a user-specified list for data analysis
and aggregation.  But currently page_owner_sort only supports selecting
blocks associated with only one specified PID/TGID/TASK_COMM_NAME.

Therefore, following adjustments are made to fix the problem:

1. Enhance selecting function to support the selection of multiple
   PIDs/TGIDs/TASK_COMM_NAMEs.

The enhanced usages are as follows:

--pid <pidlist>         Select by pid. This selects the blocks whose PID
                        numbers appear in <pidlist>.
--tgid <tgidlist>       Select by tgid. This selects the blocks whose
                        TGID numbers appear in <tgidlist>.
--name <cmdlist>        Select by task command name. This selects the
                        blocks whose task command name appear in <cmdlist>.

Where <pidlist>, <tgidlist>, <cmdlist> are single arguments in the form of
a comma-separated list,which offers a way to specify individual selecting
rules.

For example, if you want to select blocks whose tgids are 1, 2 or 3, you
have to use 4 commands as follows:

        ./page_owner_sort <input> <output1> --tgid=1
        ./page_owner_sort <input> <output2> --tgid=2
        ./page_owner_sort <input> <output3> --tgid=3
        cat <output1> <output2> <output3> > <output>

With this patch, you can use only 1 command to obtain the same result as
above:

        ./page_owner_sort <input> <output1> --tgid=1,2,3

2. Update explanations of --pid, --tgid and --name in the function
   usage() and the document(Documents/vm/page_owner.rst).

This work is coauthored by
        Yixuan Cao
        Shenghong Han
        Yinan Zhang
        Chongxi Zhao
        Yuhong Feng
        Yongqiang Liu

Link: https://lkml.kernel.org/r/20220401024856.767-2-yejiajian2018@email.szu.edu.cn
Signed-off-by: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Cc: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Cc: Yuhong Feng <yuhongf@szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |   20 +++++--
 tools/vm/page_owner_sort.c      |   78 +++++++++++++++++++++---------
 2 files changed, 72 insertions(+), 26 deletions(-)

--- a/Documentation/vm/page_owner.rst~tools-vm-page_owner_sortc-support-for-multi-value-selection-in-single-argument
+++ a/Documentation/vm/page_owner.rst
@@ -129,7 +129,6 @@ Usage
 				Specify culling rules.Culling syntax is key[,key[,...]].Choose a
 				multi-letter key from the **STANDARD FORMAT SPECIFIERS** section.
 
-
 		<rules> is a single argument in the form of a comma-separated list,
 		which offers a way to specify individual culling rules.  The recognized
 		keywords are described in the **STANDARD FORMAT SPECIFIERS** section below.
@@ -137,7 +136,6 @@ Usage
 		the STANDARD SORT KEYS section below. Mixed use of abbreviated and
 		complete-form of keys is allowed.
 
-
 		Examples:
 				./page_owner_sort <input> <output> --cull=stacktrace
 				./page_owner_sort <input> <output> --cull=st,pid,name
@@ -147,9 +145,21 @@ Usage
 		-f		Filter out the information of blocks whose memory has been released.
 
 	Select:
-		--pid <PID>		Select by pid.
-		--tgid <TGID>		Select by tgid.
-		--name <command>	Select by task command name.
+		--pid <pidlist>		Select by pid. This selects the blocks whose process ID
+					numbers appear in <pidlist>.
+		--tgid <tgidlist>	Select by tgid. This selects the blocks whose thread
+					group ID numbers appear in <tgidlist>.
+		--name <cmdlist>	Select by task command name. This selects the blocks whose
+					task command name appear in <cmdlist>.
+
+		<pidlist>, <tgidlist>, <cmdlist> are single arguments in the form of a comma-separated list,
+		which offers a way to specify individual selecting rules.
+
+
+		Examples:
+				./page_owner_sort <input> <output> --pid=1
+				./page_owner_sort <input> <output> --tgid=1,2,3
+				./page_owner_sort <input> <output> --name name1,name2
 
 STANDARD FORMAT SPECIFIERS
 ==========================
--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-support-for-multi-value-selection-in-single-argument
+++ a/tools/vm/page_owner_sort.c
@@ -54,9 +54,12 @@ enum CULL_BIT {
 	CULL_STACKTRACE = 1<<5
 };
 struct filter_condition {
-	pid_t tgid;
-	pid_t pid;
-	char comm[TASK_COMM_LEN];
+	pid_t *tgids;
+	int tgids_size;
+	pid_t *pids;
+	int pids_size;
+	char **comms;
+	int comms_size;
 };
 static struct filter_condition fc;
 static regex_t order_pattern;
@@ -149,7 +152,6 @@ static int compare_free_ts(const void *p
 	return l1->free_ts_nsec < l2->free_ts_nsec ? -1 : 1;
 }
 
-
 static int compare_release(const void *p1, const void *p2)
 {
 	const struct block_list *l1 = p1, *l2 = p2;
@@ -161,7 +163,6 @@ static int compare_release(const void *p
 	return l1->free_ts_nsec ? 1 : -1;
 }
 
-
 static int compare_cull_condition(const void *p1, const void *p2)
 {
 	if (cull == 0)
@@ -344,22 +345,40 @@ static char *get_comm(char *buf)
 	return comm_str;
 }
 
+static bool match_num_list(int num, int *list, int list_size)
+{
+	for (int i = 0; i < list_size; ++i)
+		if (list[i] == num)
+			return true;
+	return false;
+}
+
+static bool match_str_list(const char *str, char **list, int list_size)
+{
+	for (int i = 0; i < list_size; ++i)
+		if (!strcmp(list[i], str))
+			return true;
+	return false;
+}
+
 static bool is_need(char *buf)
 {
 		if ((filter & FILTER_UNRELEASE) && get_free_ts_nsec(buf) != 0)
 			return false;
-		if ((filter & FILTER_PID) && get_pid(buf) != fc.pid)
+		if ((filter & FILTER_PID) && !match_num_list(get_pid(buf), fc.pids, fc.pids_size))
 			return false;
-		if ((filter & FILTER_TGID) && get_tgid(buf) != fc.tgid)
+		if ((filter & FILTER_TGID) &&
+			!match_num_list(get_tgid(buf), fc.tgids, fc.tgids_size))
 			return false;
 
 		char *comm = get_comm(buf);
 
 		if ((filter & FILTER_COMM) &&
-		strncmp(comm, fc.comm, TASK_COMM_LEN) != 0) {
+		!match_str_list(comm, fc.comms, fc.comms_size)) {
 			free(comm);
 			return false;
 		}
+		free(comm);
 		return true;
 }
 
@@ -428,6 +447,27 @@ static bool parse_cull_args(const char *
 	return true;
 }
 
+static int *parse_nums_list(char *arg_str, int *list_size)
+{
+	int size = 0;
+	char **args = explode(',', arg_str, &size);
+	int *list = calloc(size, sizeof(int));
+
+	errno = 0;
+	for (int i = 0; i < size; ++i) {
+		char *endptr = NULL;
+
+		list[i] = strtol(args[i], &endptr, 10);
+		if (errno != 0 || endptr == args[i] || *endptr != '\0') {
+			free(list);
+			return NULL;
+		}
+	}
+	*list_size = size;
+	free_explode(args, size);
+	return list;
+}
+
 #define BUF_SIZE	(128 * 1024)
 
 static void usage(void)
@@ -442,9 +482,9 @@ static void usage(void)
 		"-a\t\tSort by memory allocate time.\n"
 		"-r\t\tSort by memory release time.\n"
 		"-f\t\tFilter out the information of blocks whose memory has been released.\n"
-		"--pid <PID>\tSelect by pid. This selects the information of blocks whose process ID number equals to <PID>.\n"
-		"--tgid <TGID>\tSelect by tgid. This selects the information of blocks whose Thread Group ID number equals to <TGID>.\n"
-		"--name <command>\n\t\tSelect by command name. This selects the information of blocks whose command name identical to <command>.\n"
+		"--pid <pidlist>\tSelect by pid. This selects the information of blocks whose process ID numbers appear in <pidlist>.\n"
+		"--tgid <tgidlist>\tSelect by tgid. This selects the information of blocks whose Thread Group ID numbers appear in <tgidlist>.\n"
+		"--name <cmdlist>\n\t\tSelect by command name. This selects the information of blocks whose command name appears in <cmdlist>.\n"
 		"--cull <rules>\tCull by user-defined rules. <rules> is a single argument in the form of a comma-separated list with some common fields predefined\n"
 	);
 }
@@ -453,7 +493,7 @@ int main(int argc, char **argv)
 {
 	int (*cmp)(const void *, const void *) = compare_num;
 	FILE *fin, *fout;
-	char *buf, *endptr;
+	char *buf;
 	int ret, i, count;
 	struct stat st;
 	int opt;
@@ -496,9 +536,8 @@ int main(int argc, char **argv)
 			break;
 		case 1:
 			filter = filter | FILTER_PID;
-			errno = 0;
-			fc.pid = strtol(optarg, &endptr, 10);
-			if (errno != 0 || endptr == optarg || *endptr != '\0') {
+			fc.pids = parse_nums_list(optarg, &fc.pids_size);
+			if (fc.pids == NULL) {
 				fprintf(stderr, "wrong/invalid pid in from the command line:%s\n",
 						optarg);
 				exit(1);
@@ -506,9 +545,8 @@ int main(int argc, char **argv)
 			break;
 		case 2:
 			filter = filter | FILTER_TGID;
-			errno = 0;
-			fc.tgid = strtol(optarg, &endptr, 10);
-			if (errno != 0 || endptr == optarg || *endptr != '\0') {
+			fc.tgids = parse_nums_list(optarg, &fc.tgids_size);
+			if (fc.tgids == NULL) {
 				fprintf(stderr, "wrong/invalid tgid in from the command line:%s\n",
 						optarg);
 				exit(1);
@@ -516,8 +554,7 @@ int main(int argc, char **argv)
 			break;
 		case 3:
 			filter = filter | FILTER_COMM;
-			strncpy(fc.comm, optarg, TASK_COMM_LEN);
-			fc.comm[TASK_COMM_LEN-1] = '\0';
+			fc.comms = explode(',', optarg, &fc.comms_size);
 			break;
 		case 4:
 			if (!parse_cull_args(optarg)) {
@@ -564,7 +601,6 @@ int main(int argc, char **argv)
 		ret = read_block(buf, BUF_SIZE, fin);
 		if (ret < 0)
 			break;
-
 		add_list(buf, ret);
 	}
 
_

Patches currently in -mm which might be from yejiajian2018@email.szu.edu.cn are

tools-vm-page_owner_sortc-use-fprintf-to-send-error-messages-to-stderr.patch
tools-vm-page_owner_sortc-support-for-multi-value-selection-in-single-argument.patch
tools-vm-page_owner_sortc-support-sorting-blocks-by-multiple-keys.patch

