Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E39B5C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 23:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239268AbiDDXVx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 19:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242553AbiDDXVT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 19:21:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14834DFE7
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 16:19:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD458B81AB4
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 23:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743B5C340F3;
        Mon,  4 Apr 2022 23:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649114358;
        bh=BqNyXrCK9k+e42xPPe0nnXQnquShhgBu+5mpbXFqWXg=;
        h=Date:To:From:Subject:From;
        b=zZJ0d6Vhv+RUdi2IyraEcpgTbXor8SMTwMjIcD2I1mss0BfXN2WyW2BwX2CYwOXhO
         xciDt2CvmtZSKaEtlCMrqO/ZgyA9JYBT7Aa2ldm1RNw7WF4HaW7Byrec4FvYeWzYGG
         JQFmqQz5QKcrfVNcsb5gVxFUulNp1uUA8juhcxts=
Date:   Mon, 04 Apr 2022 16:19:17 -0700
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn,
        zhangyinan2019@email.szu.edu.cn, yuhongf@szu.edu.cn,
        liuyongqiang13@huawei.com, hanshenghong2019@email.szu.edu.cn,
        caoyixuan2019@email.szu.edu.cn, yejiajian2018@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-page_owner_sortc-use-fprintf-to-send-error-messages-to-stderr.patch added to -mm tree
Message-Id: <20220404231918.743B5C340F3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: use fprintf() to send error messages to stderr
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-use-fprintf-to-send-error-messages-to-stderr.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-use-fprintf-to-send-error-messages-to-stderr.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-use-fprintf-to-send-error-messages-to-stderr.patch

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
Subject: tools/vm/page_owner_sort.c: use fprintf() to send error messages to stderr

Error messages should be send to stderr using fprintf() instead of
printf().

This work is coauthored by
        Yixuan Cao
        Shenghong Han
        Yinan Zhang
        Chongxi Zhao
        Yuhong Feng
        Yongqiang Liu

Link: https://lkml.kernel.org/r/20220401024856.767-1-yejiajian2018@email.szu.edu.cn
Signed-off-by: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Cc: Yuhong Feng <yuhongf@szu.edu.cn>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-use-fprintf-to-send-error-messages-to-stderr
+++ a/tools/vm/page_owner_sort.c
@@ -186,7 +186,7 @@ static int search_pattern(regex_t *patte
 
 	err = regexec(pattern, buf, 2, pmatch, REG_NOTBOL);
 	if (err != 0 || pmatch[1].rm_so == -1) {
-		printf("no matching pattern in %s\n", buf);
+		fprintf(stderr, "no matching pattern in %s\n", buf);
 		return -1;
 	}
 	val_len = pmatch[1].rm_eo - pmatch[1].rm_so;
@@ -202,7 +202,7 @@ static void check_regcomp(regex_t *patte
 
 	err = regcomp(pattern, regex, REG_EXTENDED | REG_NEWLINE);
 	if (err != 0 || pattern->re_nsub != 1) {
-		printf("Invalid pattern %s code %d\n", regex, err);
+		fprintf(stderr, "Invalid pattern %s code %d\n", regex, err);
 		exit(1);
 	}
 }
@@ -251,7 +251,7 @@ static int get_page_num(char *buf)
 	errno = 0;
 	order_val = strtol(order_str, &endptr, 10);
 	if (order_val > 64 || errno != 0 || endptr == order_str || *endptr != '\0') {
-		printf("wrong order in follow buf:\n%s\n", buf);
+		fprintf(stderr, "wrong order in follow buf:\n%s\n", buf);
 		return 0;
 	}
 
@@ -268,7 +268,7 @@ static pid_t get_pid(char *buf)
 	errno = 0;
 	pid = strtol(pid_str, &endptr, 10);
 	if (errno != 0 || endptr == pid_str || *endptr != '\0') {
-		printf("wrong/invalid pid in follow buf:\n%s\n", buf);
+		fprintf(stderr, "wrong/invalid pid in follow buf:\n%s\n", buf);
 		return -1;
 	}
 
@@ -286,7 +286,7 @@ static pid_t get_tgid(char *buf)
 	errno = 0;
 	tgid = strtol(tgid_str, &endptr, 10);
 	if (errno != 0 || endptr == tgid_str || *endptr != '\0') {
-		printf("wrong/invalid tgid in follow buf:\n%s\n", buf);
+		fprintf(stderr, "wrong/invalid tgid in follow buf:\n%s\n", buf);
 		return -1;
 	}
 
@@ -304,7 +304,7 @@ static __u64 get_ts_nsec(char *buf)
 	errno = 0;
 	ts_nsec = strtoull(ts_nsec_str, &endptr, 10);
 	if (errno != 0 || endptr == ts_nsec_str || *endptr != '\0') {
-		printf("wrong ts_nsec in follow buf:\n%s\n", buf);
+		fprintf(stderr, "wrong ts_nsec in follow buf:\n%s\n", buf);
 		return -1;
 	}
 
@@ -321,7 +321,7 @@ static __u64 get_free_ts_nsec(char *buf)
 	errno = 0;
 	free_ts_nsec = strtoull(free_ts_nsec_str, &endptr, 10);
 	if (errno != 0 || endptr == free_ts_nsec_str || *endptr != '\0') {
-		printf("wrong free_ts_nsec in follow buf:\n%s\n", buf);
+		fprintf(stderr, "wrong free_ts_nsec in follow buf:\n%s\n", buf);
 		return -1;
 	}
 
@@ -337,7 +337,7 @@ static char *get_comm(char *buf)
 	search_pattern(&comm_pattern, comm_str, buf);
 	errno = 0;
 	if (errno != 0) {
-		printf("wrong comm in follow buf:\n%s\n", buf);
+		fprintf(stderr, "wrong comm in follow buf:\n%s\n", buf);
 		return NULL;
 	}
 
@@ -373,7 +373,7 @@ static void add_list(char *buf, int len)
 		return;
 	}
 	if (list_size == max_size) {
-		printf("max_size too small??\n");
+		fprintf(stderr, "max_size too small??\n");
 		exit(1);
 	}
 	if (!is_need(buf))
@@ -383,7 +383,7 @@ static void add_list(char *buf, int len)
 	list[list_size].comm = get_comm(buf);
 	list[list_size].txt = malloc(len+1);
 	if (!list[list_size].txt) {
-		printf("Out of memory\n");
+		fprintf(stderr, "Out of memory\n");
 		exit(1);
 	}
 	memcpy(list[list_size].txt, buf, len);
@@ -499,7 +499,8 @@ int main(int argc, char **argv)
 			errno = 0;
 			fc.pid = strtol(optarg, &endptr, 10);
 			if (errno != 0 || endptr == optarg || *endptr != '\0') {
-				printf("wrong/invalid pid in from the command line:%s\n", optarg);
+				fprintf(stderr, "wrong/invalid pid in from the command line:%s\n",
+						optarg);
 				exit(1);
 			}
 			break;
@@ -508,7 +509,8 @@ int main(int argc, char **argv)
 			errno = 0;
 			fc.tgid = strtol(optarg, &endptr, 10);
 			if (errno != 0 || endptr == optarg || *endptr != '\0') {
-				printf("wrong/invalid tgid in from the command line:%s\n", optarg);
+				fprintf(stderr, "wrong/invalid tgid in from the command line:%s\n",
+						optarg);
 				exit(1);
 			}
 			break;
@@ -519,7 +521,7 @@ int main(int argc, char **argv)
 			break;
 		case 4:
 			if (!parse_cull_args(optarg)) {
-				printf("wrong argument after --cull in from the command line:%s\n",
+				fprintf(stderr, "wrong argument after --cull option:%s\n",
 						optarg);
 				exit(1);
 			}
@@ -554,7 +556,7 @@ int main(int argc, char **argv)
 	list = malloc(max_size * sizeof(*list));
 	buf = malloc(BUF_SIZE);
 	if (!list || !buf) {
-		printf("Out of memory\n");
+		fprintf(stderr, "Out of memory\n");
 		exit(1);
 	}
 
_

Patches currently in -mm which might be from yejiajian2018@email.szu.edu.cn are

tools-vm-page_owner_sortc-use-fprintf-to-send-error-messages-to-stderr.patch
tools-vm-page_owner_sortc-support-for-multi-value-selection-in-single-argument.patch
tools-vm-page_owner_sortc-support-sorting-blocks-by-multiple-keys.patch

