Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC1EC43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356396AbiCYBLR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357148AbiCYBLC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:11:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAFD5EBEF
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:09:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E0ECB82708
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC43C340ED;
        Fri, 25 Mar 2022 01:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170566;
        bh=Qnwx+J5l/dtOtcYxIFAcjnMRGmQ4HPFaROuuT/nbJb8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=YkGwzapOViAjFuZrTHTZVwnimLWRXFf69Gd29gVH8ZkJuBsFU7P3w5qWKL/nyqkDG
         0QJsm+7iJIfMpPHgLcvIWN6tdHyzlcCLAtnK+Rch+JluGatQ748ylWRgOT2weByt7v
         /B5rHPH//osYKzjeqZEeDKmvP3HRqs0B1ydhAfrA=
Date:   Thu, 24 Mar 2022 18:09:26 -0700
To:     zhangyinan2019@email.szu.edu.cn, weizhenliang@huawei.com,
        sfr@canb.auug.org.au, caoyixuan2019@email.szu.edu.cn,
        yejiajian2018@email.szu.edu.cn, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 017/114] tools/vm/page_owner_sort.c: support sorting by tgid and update documentation
Message-Id: <20220325010926.9FC43C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: support sorting by tgid and update documentation

When the "page owner" information is read, the information sorted
by TGID is expected.

As a result, the following adjustments have been made:

1. Add a new -P option to sort the information of blocks by TGID in
   ascending order.

2. Adjust the order of member variables in block_list strust to avoid
   one 4 byte hole.

3. Add -P option explanation in the document.

Link: https://lkml.kernel.org/r/20220301151438.166118-3-yejiajian2018@email.szu.edu.cn
Signed-off-by: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    1 
 tools/vm/page_owner_sort.c      |   40 +++++++++++++++++++++++++++---
 2 files changed, 38 insertions(+), 3 deletions(-)

--- a/Documentation/vm/page_owner.rst~tools-vm-page_owner_sortc-support-sorting-by-tgid-and-update-documentation
+++ a/Documentation/vm/page_owner.rst
@@ -116,6 +116,7 @@ Usage
 		-a		Sort by memory allocation time.
 		-m		Sort by total memory.
 		-p		Sort by pid.
+		-P		Sort by tgid.
 		-r		Sort by memory release time.
 		-s		Sort by stack trace.
 		-t		Sort by times (default).
--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-support-sorting-by-tgid-and-update-documentation
+++ a/tools/vm/page_owner_sort.c
@@ -25,16 +25,18 @@
 struct block_list {
 	char *txt;
 	char *stacktrace;
+	__u64 ts_nsec;
+	__u64 free_ts_nsec;
 	int len;
 	int num;
 	int page_num;
 	pid_t pid;
-	__u64 ts_nsec;
-	__u64 free_ts_nsec;
+	pid_t tgid;
 };
 
 static regex_t order_pattern;
 static regex_t pid_pattern;
+static regex_t tgid_pattern;
 static regex_t ts_nsec_pattern;
 static regex_t free_ts_nsec_pattern;
 static struct block_list *list;
@@ -91,6 +93,13 @@ static int compare_pid(const void *p1, c
 	return l1->pid - l2->pid;
 }
 
+static int compare_tgid(const void *p1, const void *p2)
+{
+	const struct block_list *l1 = p1, *l2 = p2;
+
+	return l1->tgid - l2->tgid;
+}
+
 static int compare_ts(const void *p1, const void *p2)
 {
 	const struct block_list *l1 = p1, *l2 = p2;
@@ -170,6 +179,24 @@ static pid_t get_pid(char *buf)
 
 }
 
+static pid_t get_tgid(char *buf)
+{
+	pid_t tgid;
+	char tgid_str[FIELD_BUFF] = {0};
+	char *endptr;
+
+	search_pattern(&tgid_pattern, tgid_str, buf);
+	errno = 0;
+	tgid = strtol(tgid_str, &endptr, 10);
+	if (errno != 0 || endptr == tgid_str || *endptr != '\0') {
+		printf("wrong/invalid tgid in follow buf:\n%s\n", buf);
+		return -1;
+	}
+
+	return tgid;
+
+}
+
 static __u64 get_ts_nsec(char *buf)
 {
 	__u64 ts_nsec;
@@ -231,6 +258,7 @@ static void add_list(char *buf, int len)
 	list[list_size].txt[len] = 0;
 	list[list_size].stacktrace = strchr(list[list_size].txt, '\n') ?: "";
 	list[list_size].pid = get_pid(buf);
+	list[list_size].tgid = get_tgid(buf);
 	list[list_size].ts_nsec = get_ts_nsec(buf);
 	list[list_size].free_ts_nsec = get_free_ts_nsec(buf);
 	list_size++;
@@ -249,6 +277,7 @@ static void usage(void)
 		"-s	Sort by the stack trace.\n"
 		"-t	Sort by times (default).\n"
 		"-p	Sort by pid.\n"
+		"-P	Sort by tgid.\n"
 		"-a	Sort by memory allocate time.\n"
 		"-r	Sort by memory release time.\n"
 		"-c	Cull by comparing stacktrace instead of total block.\n"
@@ -268,7 +297,7 @@ int main(int argc, char **argv)
 	struct stat st;
 	int opt;
 
-	while ((opt = getopt(argc, argv, "acfmprst")) != -1)
+	while ((opt = getopt(argc, argv, "acfmprstP")) != -1)
 		switch (opt) {
 		case 'a':
 			cmp = compare_ts;
@@ -294,6 +323,9 @@ int main(int argc, char **argv)
 		case 't':
 			cmp = compare_num;
 			break;
+		case 'P':
+			cmp = compare_tgid;
+			break;
 		default:
 			usage();
 			exit(1);
@@ -314,6 +346,7 @@ int main(int argc, char **argv)
 
 	check_regcomp(&order_pattern, "order\\s*([0-9]*),");
 	check_regcomp(&pid_pattern, "pid\\s*([0-9]*),");
+	check_regcomp(&tgid_pattern, "tgid\\s*([0-9]*) ");
 	check_regcomp(&ts_nsec_pattern, "ts\\s*([0-9]*)\\s*ns,");
 	check_regcomp(&free_ts_nsec_pattern, "free_ts\\s*([0-9]*)\\s*ns");
 	fstat(fileno(fin), &st);
@@ -373,6 +406,7 @@ int main(int argc, char **argv)
 	}
 	regfree(&order_pattern);
 	regfree(&pid_pattern);
+	regfree(&tgid_pattern);
 	regfree(&ts_nsec_pattern);
 	regfree(&free_ts_nsec_pattern);
 	return 0;
_
