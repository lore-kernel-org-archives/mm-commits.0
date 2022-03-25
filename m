Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8B6C43219
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbiCYWn1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233922AbiCYWnU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31055209A63
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1F9A614BD
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F8FC340ED;
        Fri, 25 Mar 2022 22:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248104;
        bh=hSpShI55X3ggYQ71z/gzRKdF1bO+nJjqwl22tdhn2Fg=;
        h=Date:To:From:Subject:From;
        b=sMgWSk6lDI9Tm67h4W2vxhoOUlMCbISEdvtgk7UAcyACCvDpHL9acjChkPSvlCFwh
         U2UCMDn2fAEw1GnVCU/HUKNIsX79OHoDE+JXGcB4OVr4vzjS9SDLnLMRxz7qwBP2DU
         kx7lg0GVmu8oZvim+K8BLnHMYUG8GT1c9Pw5rcks=
Date:   Fri, 25 Mar 2022 15:41:43 -0700
To:     mm-commits@vger.kernel.org, weizhenliang@huawei.com,
        sfr@canb.auug.org.au, seanga2@gmail.com,
        yejiajian2018@email.szu.edu.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tools-vm-page_owner_sortc-support-for-selecting-by-pid-tgid-or-task-command-name.patch removed from -mm tree
Message-Id: <20220325224144.14F8FC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: support for selecting by PID, TGID or task command name
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sortc-support-for-selecting-by-pid-tgid-or-task-command-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: support for selecting by PID, TGID or task command name

When viewing page owner information, we may also need to select the blocks
by PID, TGID or task command name, which helps to get more accurate page
allocation information as needed.

Therefore, following adjustments are made:

1. Add three new options, including --pid, --tgid and --name, to support
the selection of information blocks by a specific pid, tgid and task
command name. In addtion, multiple options are allowed to be used at the
same time.

	./page_owner_sort [input] [output] --pid <PID>
	./page_owner_sort [input] [output] --tgid <TGID>
	./page_owner_sort [input] [output] --name <TASK_COMMAND_NAME>

Assuming a scenario when a multi-threaded program, ./demo (PID = 5280),
is running, and ./demo creates a child process (PID = 5281).

	$ps
	PID   TTY        TIME   CMD
	5215  pts/0    00:00:00  bash
	5280  pts/0    00:00:00  ./demo
	5281  pts/0    00:00:00  ./demo
	5282  pts/0    00:00:00  ps

It would be better to filter out the records with tgid=5280 and the
task name "demo" when debugging the parent process, and the specific
usage is

	./page_owner_sort [input] [output] --tgid 5280 --name demo

2. Add explanations of three new options, including --pid, --tgid
and --name, to the document.

This work is coauthored by
	Shenghong Han <hanshenghong2019@email.szu.edu.cn>,
	Yixuan Cao <caoyixuan2019@email.szu.edu.cn>,
	Yinan Zhang <zhangyinan2019@email.szu.edu.cn>,
	Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>,
	Yuhong Feng <yuhongf@szu.edu.cn>.

Link: https://lkml.kernel.org/r/1646835223-7584-1-git-send-email-yejiajian2018@email.szu.edu.cn
Signed-off-by: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Sean Anderson <seanga2@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    6 +
 tools/vm/page_owner_sort.c      |  118 +++++++++++++++++++++++-------
 2 files changed, 98 insertions(+), 26 deletions(-)

--- a/Documentation/vm/page_owner.rst~tools-vm-page_owner_sortc-support-for-selecting-by-pid-tgid-or-task-command-name
+++ a/Documentation/vm/page_owner.rst
@@ -129,3 +129,9 @@ Usage
 
 	Filter:
 		-f		Filter out the information of blocks whose memory has been released.
+
+	Select:
+		--pid <PID>			Select by pid.
+		--tgid <TGID>		Select by tgid.
+		--name <command>	Select by task command name.
+
--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-support-for-selecting-by-pid-tgid-or-task-command-name
+++ a/tools/vm/page_owner_sort.c
@@ -21,6 +21,12 @@
 #include <regex.h>
 #include <errno.h>
 #include <linux/types.h>
+#include <getopt.h>
+
+#define bool int
+#define true 1
+#define false 0
+#define TASK_COMM_LEN 16
 
 struct block_list {
 	char *txt;
@@ -34,7 +40,18 @@ struct block_list {
 	pid_t pid;
 	pid_t tgid;
 };
-
+enum FILTER_BIT {
+	FILTER_UNRELEASE = 1<<1,
+	FILTER_PID = 1<<2,
+	FILTER_TGID = 1<<3,
+	FILTER_TASK_COMM_NAME = 1<<4
+};
+struct filter_condition {
+	pid_t tgid;
+	pid_t pid;
+	char comm[TASK_COMM_LEN];
+};
+static struct filter_condition fc;
 static regex_t order_pattern;
 static regex_t pid_pattern;
 static regex_t tgid_pattern;
@@ -154,7 +171,6 @@ static void check_regcomp(regex_t *patte
 }
 
 # define FIELD_BUFF 25
-# define TASK_COMM_LEN 16
 
 static int get_page_num(char *buf)
 {
@@ -259,11 +275,30 @@ static char *get_comm(char *buf)
 	return comm_str;
 }
 
+static bool is_need(char *buf)
+{
+		if ((filter & FILTER_UNRELEASE) != 0 && get_free_ts_nsec(buf) != 0)
+			return false;
+		if ((filter & FILTER_PID) != 0 && get_pid(buf) != fc.pid)
+			return false;
+		if ((filter & FILTER_TGID) != 0 && get_tgid(buf) != fc.tgid)
+			return false;
+
+		char *comm = get_comm(buf);
+
+		if ((filter & FILTER_TASK_COMM_NAME) != 0  &&
+		strncmp(comm, fc.comm, TASK_COMM_LEN) != 0) {
+			free(comm);
+			return false;
+		}
+		return true;
+}
+
 static void add_list(char *buf, int len)
 {
 	if (list_size != 0 &&
-	    len == list[list_size-1].len &&
-	    memcmp(buf, list[list_size-1].txt, len) == 0) {
+		len == list[list_size-1].len &&
+		memcmp(buf, list[list_size-1].txt, len) == 0) {
 		list[list_size-1].num++;
 		list[list_size-1].page_num += get_page_num(buf);
 		return;
@@ -272,28 +307,27 @@ static void add_list(char *buf, int len)
 		printf("max_size too small??\n");
 		exit(1);
 	}
-
-	list[list_size].free_ts_nsec = get_free_ts_nsec(buf);
-	if (filter == 1 && list[list_size].free_ts_nsec != 0)
+	if (!is_need(buf))
 		return;
+	list[list_size].pid = get_pid(buf);
+	list[list_size].tgid = get_tgid(buf);
+	list[list_size].comm = get_comm(buf);
 	list[list_size].txt = malloc(len+1);
 	if (!list[list_size].txt) {
 		printf("Out of memory\n");
 		exit(1);
 	}
-
+	memcpy(list[list_size].txt, buf, len);
+	list[list_size].txt[len] = 0;
 	list[list_size].len = len;
 	list[list_size].num = 1;
 	list[list_size].page_num = get_page_num(buf);
-	memcpy(list[list_size].txt, buf, len);
-	list[list_size].txt[len] = 0;
+
 	list[list_size].stacktrace = strchr(list[list_size].txt, '\n') ?: "";
 	if (*list[list_size].stacktrace == '\n')
 		list[list_size].stacktrace++;
-	list[list_size].pid = get_pid(buf);
-	list[list_size].tgid = get_tgid(buf);
-	list[list_size].comm = get_comm(buf);
 	list[list_size].ts_nsec = get_ts_nsec(buf);
+	list[list_size].free_ts_nsec = get_free_ts_nsec(buf);
 	list_size++;
 	if (list_size % 1000 == 0) {
 		printf("loaded %d\r", list_size);
@@ -306,16 +340,19 @@ static void add_list(char *buf, int len)
 static void usage(void)
 {
 	printf("Usage: ./page_owner_sort [OPTIONS] <input> <output>\n"
-		"-m	Sort by total memory.\n"
-		"-s	Sort by the stack trace.\n"
-		"-t	Sort by times (default).\n"
-		"-p	Sort by pid.\n"
-		"-P	Sort by tgid.\n"
-		"-n	Sort by task command name.\n"
-		"-a	Sort by memory allocate time.\n"
-		"-r	Sort by memory release time.\n"
-		"-c	Cull by comparing stacktrace instead of total block.\n"
-		"-f	Filter out the information of blocks whose memory has been released.\n"
+		"-m\t\tSort by total memory.\n"
+		"-s\t\tSort by the stack trace.\n"
+		"-t\t\tSort by times (default).\n"
+		"-p\t\tSort by pid.\n"
+		"-P\t\tSort by tgid.\n"
+		"-n\t\tSort by task command name.\n"
+		"-a\t\tSort by memory allocate time.\n"
+		"-r\t\tSort by memory release time.\n"
+		"-c\t\tCull by comparing stacktrace instead of total block.\n"
+		"-f\t\tFilter out the information of blocks whose memory has been released.\n"
+		"--pid <PID>\tSelect by pid. This selects the information of blocks whose process ID number equals to <PID>.\n"
+		"--tgid <TGID>\tSelect by tgid. This selects the information of blocks whose Thread Group ID number equals to <TGID>.\n"
+		"--name <command>\n\t\tSelect by command name. This selects the information of blocks whose command name identical to <command>.\n"
 	);
 }
 
@@ -323,12 +360,18 @@ int main(int argc, char **argv)
 {
 	int (*cmp)(const void *, const void *) = compare_num;
 	FILE *fin, *fout;
-	char *buf;
+	char *buf, *endptr;
 	int ret, i, count;
 	struct stat st;
 	int opt;
+	struct option longopts[] = {
+		{ "pid", required_argument, NULL, 1 },
+		{ "tgid", required_argument, NULL, 2 },
+		{ "name", required_argument, NULL, 3 },
+		{ 0, 0, 0, 0},
+	};
 
-	while ((opt = getopt(argc, argv, "acfmnprstP")) != -1)
+	while ((opt = getopt_long(argc, argv, "acfmnprstP", longopts, NULL)) != -1)
 		switch (opt) {
 		case 'a':
 			cmp = compare_ts;
@@ -337,7 +380,7 @@ int main(int argc, char **argv)
 			cull_st = 1;
 			break;
 		case 'f':
-			filter = 1;
+			filter = filter | FILTER_UNRELEASE;
 			break;
 		case 'm':
 			cmp = compare_page_num;
@@ -360,6 +403,29 @@ int main(int argc, char **argv)
 		case 'n':
 			cmp = compare_comm;
 			break;
+		case 1:
+			filter = filter | FILTER_PID;
+			errno = 0;
+			fc.pid = strtol(optarg, &endptr, 10);
+			if (errno != 0 || endptr == optarg || *endptr != '\0') {
+				printf("wrong/invalid pid in from the command line:%s\n", optarg);
+				exit(1);
+			}
+			break;
+		case 2:
+			filter = filter | FILTER_TGID;
+			errno = 0;
+			fc.tgid = strtol(optarg, &endptr, 10);
+			if (errno != 0 || endptr == optarg || *endptr != '\0') {
+				printf("wrong/invalid tgid in from the command line:%s\n", optarg);
+				exit(1);
+			}
+			break;
+		case 3:
+			filter = filter | FILTER_TASK_COMM_NAME;
+			strncpy(fc.comm, optarg, TASK_COMM_LEN);
+			fc.comm[TASK_COMM_LEN-1] = '\0';
+			break;
 		default:
 			usage();
 			exit(1);
_

Patches currently in -mm which might be from yejiajian2018@email.szu.edu.cn are


