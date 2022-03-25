Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F67EC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbiCYWn3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233924AbiCYWnW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BEB209A6C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D694361582
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A509C36AE2;
        Fri, 25 Mar 2022 22:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248105;
        bh=KvxGuddRAJks3V0H9gibyunRWGgjwkMu0ye+1PWg4RU=;
        h=Date:To:From:Subject:From;
        b=llPbWVlIba9kY33PBcN427J+ovphGTsMxDMWytLZktsv16aeiBZJSKkHhDWn0Q3By
         +/XV6khQTpOaGtC9OMiAifSec2NeCdzNqW4mTVU9JvqRZDmOxZBCQxvMcZSVwTi6RS
         WIGk/rCZotrn0G4k9jEhKnTcJPikZmIj+gbtT+Fs=
Date:   Fri, 25 Mar 2022 15:41:44 -0700
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn,
        zhangyinan2019@email.szu.edu.cn, yuhongf@szu.edu.cn,
        sfr@canb.auug.org.au, seanga2@gmail.com,
        hanshenghong2019@email.szu.edu.cn, caoyixuan2019@email.szu.edu.cn,
        yejiajian2018@email.szu.edu.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tools-vm-page_owner_sortc-support-for-user-defined-culling-rules.patch removed from -mm tree
Message-Id: <20220325224145.3A509C36AE2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: support for user-defined culling rules
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sortc-support-for-user-defined-culling-rules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: support for user-defined culling rules

When viewing page owner information, we may want to cull blocks of
information with our own rules.  So it is important to enhance culling
function to provide the support for customizing culling rules.  Therefore,
following adjustments are made:

1. Add --cull option to support the culling of blocks of information
with user-defined culling rules.

	./page_owner_sort <input> <output> --cull=<rules>
	./page_owner_sort <input> <output> --cull <rules>

<rules> is a single argument in the form of a comma-separated list to
specify individual culling rules, by the sequence of keys k1,k2, .... 
Mixed use of abbreviated and complete-form of keys is allowed.

For reference, please see the document(Documentation/vm/page_owner.rst).

Now, assuming two blocks in the input file are as follows:

	Page allocated via order 0, mask xxxx, pid 1, tgid 1 (task_name_demo)
	PFN xxxx
	 prep_new_page+0xd0/0xf8
	 get_page_from_freelist+0x4a0/0x1290
	 __alloc_pages+0x168/0x340
	 alloc_pages+0xb0/0x158

	Page allocated via order 0, mask xxxx, pid 32, tgid 32 (task_name_demo)
	PFN xxxx
	 prep_new_page+0xd0/0xf8
	 get_page_from_freelist+0x4a0/0x1290
	 __alloc_pages+0x168/0x340
	 alloc_pages+0xb0/0x158

If we want to cull the blocks by stacktrace and task command name, we can
use this command:

	./page_owner_sort <input> <output> --cull=stacktrace,name

The output would be like:

	2 times, 2 pages, task_comm_name: task_name_demo
	 prep_new_page+0xd0/0xf8
	 get_page_from_freelist+0x4a0/0x1290
	 __alloc_pages+0x168/0x340
	 alloc_pages+0xb0/0x158

As we can see, these two blocks are culled successfully, for they share
the same pid and task command name.

However, if we want to cull the blocks by pid, stacktrace and task command
name, we can this command:

	./page_owner_sort <input> <output> --cull=stacktrace,name,pid

The output would be like:

	1 times, 1 pages, PID 1, task_comm_name: task_name_demo
	 prep_new_page+0xd0/0xf8
	 get_page_from_freelist+0x4a0/0x1290
	 __alloc_pages+0x168/0x340
	 alloc_pages+0xb0/0x158

	1 times, 1 pages, PID 32, task_comm_name: task_name_demo
	 prep_new_page+0xd0/0xf8
	 get_page_from_freelist+0x4a0/0x1290
	 __alloc_pages+0x168/0x340
	 alloc_pages+0xb0/0x158

As we can see, these two blocks are failed to cull, for their PIDs are
different.

2. Add explanations of --cull options to the document.

This work is coauthored by
	Yixuan Cao
	Shenghong Han
	Yinan Zhang
	Chongxi Zhao
	Yuhong Feng

Link: https://lkml.kernel.org/r/20220312145834.624-1-yejiajian2018@email.szu.edu.cn
Signed-off-by: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Cc: Yuhong Feng <yuhongf@szu.edu.cn>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sean Anderson <seanga2@gmail.com>			
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |   31 ++++++
 tools/vm/page_owner_sort.c      |  150 +++++++++++++++++++++++++-----
 2 files changed, 159 insertions(+), 22 deletions(-)

--- a/Documentation/vm/page_owner.rst~tools-vm-page_owner_sortc-support-for-user-defined-culling-rules
+++ a/Documentation/vm/page_owner.rst
@@ -126,12 +126,41 @@ Usage
 
 	Cull:
 		-c		Cull by comparing stacktrace instead of total block.
+		--cull <rules>
+				Specify culling rules.Culling syntax is key[,key[,...]].Choose a
+				multi-letter key from the **STANDARD FORMAT SPECIFIERS** section.
+
+
+		<rules> is a single argument in the form of a comma-separated list,
+		which offers a way to specify individual culling rules.  The recognized
+		keywords are described in the **STANDARD FORMAT SPECIFIERS** section below.
+		<rules> can be specified by the sequence of keys k1,k2, ..., as described in
+		the STANDARD SORT KEYS section below. Mixed use of abbreviated and
+		complete-form of keys is allowed.
+
+
+		Examples:
+				./page_owner_sort <input> <output> --cull=stacktrace
+				./page_owner_sort <input> <output> --cull=st,pid,name
+				./page_owner_sort <input> <output> --cull=n,f
 
 	Filter:
 		-f		Filter out the information of blocks whose memory has been released.
 
 	Select:
-		--pid <PID>			Select by pid.
+		--pid <PID>		Select by pid.
 		--tgid <TGID>		Select by tgid.
 		--name <command>	Select by task command name.
 
+STANDARD FORMAT SPECIFIERS
+==========================
+
+	KEY		LONG		DESCRIPTION
+	p		pid		process ID
+	tg		tgid		thread group ID
+	n		name		task command name
+	f		free		whether the page has been released or not
+	st		stacktrace	stace trace of the page allocation
+
+
+
--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-support-for-user-defined-culling-rules
+++ a/tools/vm/page_owner_sort.c
@@ -44,7 +44,14 @@ enum FILTER_BIT {
 	FILTER_UNRELEASE = 1<<1,
 	FILTER_PID = 1<<2,
 	FILTER_TGID = 1<<3,
-	FILTER_TASK_COMM_NAME = 1<<4
+	FILTER_COMM = 1<<4
+};
+enum CULL_BIT {
+	CULL_UNRELEASE = 1<<1,
+	CULL_PID = 1<<2,
+	CULL_TGID = 1<<3,
+	CULL_COMM = 1<<4,
+	CULL_STACKTRACE = 1<<5
 };
 struct filter_condition {
 	pid_t tgid;
@@ -61,7 +68,7 @@ static regex_t free_ts_nsec_pattern;
 static struct block_list *list;
 static int list_size;
 static int max_size;
-static int cull_st;
+static int cull;
 static int filter;
 
 int read_block(char *buf, int buf_size, FILE *fin)
@@ -142,6 +149,36 @@ static int compare_free_ts(const void *p
 	return l1->free_ts_nsec < l2->free_ts_nsec ? -1 : 1;
 }
 
+
+static int compare_release(const void *p1, const void *p2)
+{
+	const struct block_list *l1 = p1, *l2 = p2;
+
+	if (!l1->free_ts_nsec && !l2->free_ts_nsec)
+		return 0;
+	if (l1->free_ts_nsec && l2->free_ts_nsec)
+		return 0;
+	return l1->free_ts_nsec ? 1 : -1;
+}
+
+
+static int compare_cull_condition(const void *p1, const void *p2)
+{
+	if (cull == 0)
+		return compare_txt(p1, p2);
+	if ((cull & CULL_STACKTRACE) && compare_stacktrace(p1, p2))
+		return compare_stacktrace(p1, p2);
+	if ((cull & CULL_PID) && compare_pid(p1, p2))
+		return compare_pid(p1, p2);
+	if ((cull & CULL_TGID) && compare_tgid(p1, p2))
+		return compare_tgid(p1, p2);
+	if ((cull & CULL_COMM) && compare_comm(p1, p2))
+		return compare_comm(p1, p2);
+	if ((cull & CULL_UNRELEASE) && compare_release(p1, p2))
+		return compare_release(p1, p2);
+	return 0;
+}
+
 static int search_pattern(regex_t *pattern, char *pattern_str, char *buf)
 {
 	int err, val_len;
@@ -170,6 +207,38 @@ static void check_regcomp(regex_t *patte
 	}
 }
 
+static char **explode(char sep, const char *str, int *size)
+{
+	int count = 0, len = strlen(str);
+	int lastindex = -1, j = 0;
+
+	for (int i = 0; i < len; i++)
+		if (str[i] == sep)
+			count++;
+	char **ret = calloc(++count, sizeof(char *));
+
+	for (int i = 0; i < len; i++) {
+		if (str[i] == sep) {
+			ret[j] = calloc(i - lastindex, sizeof(char));
+			memcpy(ret[j++], str + lastindex + 1, i - lastindex - 1);
+			lastindex = i;
+		}
+	}
+	if (lastindex <= len - 1) {
+		ret[j] = calloc(len - lastindex, sizeof(char));
+		memcpy(ret[j++], str + lastindex + 1, strlen(str) - 1 - lastindex);
+	}
+	*size = j;
+	return ret;
+}
+
+static void free_explode(char **arr, int size)
+{
+	for (int i = 0; i < size; i++)
+		free(arr[i]);
+	free(arr);
+}
+
 # define FIELD_BUFF 25
 
 static int get_page_num(char *buf)
@@ -277,16 +346,16 @@ static char *get_comm(char *buf)
 
 static bool is_need(char *buf)
 {
-		if ((filter & FILTER_UNRELEASE) != 0 && get_free_ts_nsec(buf) != 0)
+		if ((filter & FILTER_UNRELEASE) && get_free_ts_nsec(buf) != 0)
 			return false;
-		if ((filter & FILTER_PID) != 0 && get_pid(buf) != fc.pid)
+		if ((filter & FILTER_PID) && get_pid(buf) != fc.pid)
 			return false;
-		if ((filter & FILTER_TGID) != 0 && get_tgid(buf) != fc.tgid)
+		if ((filter & FILTER_TGID) && get_tgid(buf) != fc.tgid)
 			return false;
 
 		char *comm = get_comm(buf);
 
-		if ((filter & FILTER_TASK_COMM_NAME) != 0  &&
+		if ((filter & FILTER_COMM) &&
 		strncmp(comm, fc.comm, TASK_COMM_LEN) != 0) {
 			free(comm);
 			return false;
@@ -335,6 +404,30 @@ static void add_list(char *buf, int len)
 	}
 }
 
+static bool parse_cull_args(const char *arg_str)
+{
+	int size = 0;
+	char **args = explode(',', arg_str, &size);
+
+	for (int i = 0; i < size; ++i)
+		if (!strcmp(args[i], "pid") || !strcmp(args[i], "p"))
+			cull |= CULL_PID;
+		else if (!strcmp(args[i], "tgid") || !strcmp(args[i], "tg"))
+			cull |= CULL_TGID;
+		else if (!strcmp(args[i], "name") || !strcmp(args[i], "n"))
+			cull |= CULL_COMM;
+		else if (!strcmp(args[i], "stacktrace") || !strcmp(args[i], "st"))
+			cull |= CULL_STACKTRACE;
+		else if (!strcmp(args[i], "free") || !strcmp(args[i], "f"))
+			cull |= CULL_UNRELEASE;
+		else {
+			free_explode(args, size);
+			return false;
+		}
+	free_explode(args, size);
+	return true;
+}
+
 #define BUF_SIZE	(128 * 1024)
 
 static void usage(void)
@@ -353,6 +446,7 @@ static void usage(void)
 		"--pid <PID>\tSelect by pid. This selects the information of blocks whose process ID number equals to <PID>.\n"
 		"--tgid <TGID>\tSelect by tgid. This selects the information of blocks whose Thread Group ID number equals to <TGID>.\n"
 		"--name <command>\n\t\tSelect by command name. This selects the information of blocks whose command name identical to <command>.\n"
+		"--cull <rules>\tCull by user-defined rules. <rules> is a single argument in the form of a comma-separated list with some common fields predefined\n"
 	);
 }
 
@@ -368,6 +462,7 @@ int main(int argc, char **argv)
 		{ "pid", required_argument, NULL, 1 },
 		{ "tgid", required_argument, NULL, 2 },
 		{ "name", required_argument, NULL, 3 },
+		{ "cull",  required_argument, NULL, 4 },
 		{ 0, 0, 0, 0},
 	};
 
@@ -377,7 +472,7 @@ int main(int argc, char **argv)
 			cmp = compare_ts;
 			break;
 		case 'c':
-			cull_st = 1;
+			cull = cull | CULL_STACKTRACE;
 			break;
 		case 'f':
 			filter = filter | FILTER_UNRELEASE;
@@ -422,10 +517,17 @@ int main(int argc, char **argv)
 			}
 			break;
 		case 3:
-			filter = filter | FILTER_TASK_COMM_NAME;
+			filter = filter | FILTER_COMM;
 			strncpy(fc.comm, optarg, TASK_COMM_LEN);
 			fc.comm[TASK_COMM_LEN-1] = '\0';
 			break;
+		case 4:
+			if (!parse_cull_args(optarg)) {
+				printf("wrong argument after --cull in from the command line:%s\n",
+						optarg);
+				exit(1);
+			}
+			break;
 		default:
 			usage();
 			exit(1);
@@ -472,20 +574,13 @@ int main(int argc, char **argv)
 
 	printf("sorting ....\n");
 
-	if (cull_st == 1)
-		qsort(list, list_size, sizeof(list[0]), compare_stacktrace);
-	else
-		qsort(list, list_size, sizeof(list[0]), compare_txt);
-
-
+	qsort(list, list_size, sizeof(list[0]), compare_cull_condition);
 
 	printf("culling\n");
 
-	long offset = cull_st ? &list[0].stacktrace - &list[0].txt : 0;
-
 	for (i = count = 0; i < list_size; i++) {
 		if (count == 0 ||
-		    strcmp(*(&list[count-1].txt+offset), *(&list[i].txt+offset)) != 0) {
+		    compare_cull_condition((void *)(&list[count-1]), (void *)(&list[i])) != 0) {
 			list[count++] = list[i];
 		} else {
 			list[count-1].num += list[i].num;
@@ -496,12 +591,25 @@ int main(int argc, char **argv)
 	qsort(list, count, sizeof(list[0]), cmp);
 
 	for (i = 0; i < count; i++) {
-		if (cull_st == 0)
+		if (cull == 0)
 			fprintf(fout, "%d times, %d pages:\n%s\n",
 					list[i].num, list[i].page_num, list[i].txt);
-		else
-			fprintf(fout, "%d times, %d pages:\n%s\n",
-					list[i].num, list[i].page_num, list[i].stacktrace);
+		else {
+			fprintf(fout, "%d times, %d pages",
+					list[i].num, list[i].page_num);
+			if (cull & CULL_PID || filter & FILTER_PID)
+				fprintf(fout, ", PID %d", list[i].pid);
+			if (cull & CULL_TGID || filter & FILTER_TGID)
+				fprintf(fout, ", TGID %d", list[i].pid);
+			if (cull & CULL_COMM || filter & FILTER_COMM)
+				fprintf(fout, ", task_comm_name: %s", list[i].comm);
+			if (cull & CULL_UNRELEASE)
+				fprintf(fout, " (%s)",
+						list[i].free_ts_nsec ? "UNRELEASED" : "RELEASED");
+			if (cull & CULL_STACKTRACE)
+				fprintf(fout, ":\n%s", list[i].stacktrace);
+			fprintf(fout, "\n");
+		}
 	}
 	regfree(&order_pattern);
 	regfree(&pid_pattern);
_

Patches currently in -mm which might be from yejiajian2018@email.szu.edu.cn are


