Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B7CC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 23:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiDLX3e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiDLX20 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 19:28:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0603A0BD1
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 15:32:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77FD8B8206C
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 22:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30620C385A5;
        Tue, 12 Apr 2022 22:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649802756;
        bh=tjdOV2JUMcGSbd40g89PE2BwjOLN82WdTdjEHAU5WsE=;
        h=Date:To:From:Subject:From;
        b=Lmdn5YUpJSEMf2VepaoevHQTsJ5+j6AltkIZskI235qhjsKm5LyrNTF5zHMHvzUIz
         jzK6MVWiLmyaPkTwtq8KX9i2EEnvtIJgp9rN6qpMWCkhwf7EumwdChmdeTJH0VGOtA
         5XoIGriJnINv5Cda6VgxWEJigRO8NmxWFPbbmeyA=
Date:   Tue, 12 Apr 2022 15:32:35 -0700
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn,
        zhangyinan2019@email.szu.edu.cn, yuhongf@szu.edu.cn,
        yejiajian2018@email.szu.edu.cn, seanga2@gmail.com,
        liuyongqiang13@huawei.com, hanshenghong2019@email.szu.edu.cn,
        caoyixuan2019@email.szu.edu.cn, baihaowen@meizu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-page_owner-support-debug-log-to-avoid-huge-log-print.patch added to -mm tree
Message-Id: <20220412223236.30620C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner: support debug log to avoid huge log print
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner-support-debug-log-to-avoid-huge-log-print.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner-support-debug-log-to-avoid-huge-log-print.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner-support-debug-log-to-avoid-huge-log-print.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Haowen Bai <baihaowen@meizu.com>
Subject: tools/vm/page_owner: support debug log to avoid huge log print

As normal usage, tool will print huge parser log and spend a lot of time
printing, so it would be preferable add "-d" debug control to avoid this
problem.

Link: https://lkml.kernel.org/r/1649672446-5685-1-git-send-email-baihaowen@meizu.com
Signed-off-by: Haowen Bai <baihaowen@meizu.com>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Cc: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Cc: Yuhong Feng <yuhongf@szu.edu.cn>
Cc: Sean Anderson <seanga2@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner-support-debug-log-to-avoid-huge-log-print
+++ a/tools/vm/page_owner_sort.c
@@ -87,6 +87,7 @@ static int list_size;
 static int max_size;
 static int cull;
 static int filter;
+static bool debug_on;
 
 int read_block(char *buf, int buf_size, FILE *fin)
 {
@@ -211,7 +212,8 @@ static int search_pattern(regex_t *patte
 
 	err = regexec(pattern, buf, 2, pmatch, REG_NOTBOL);
 	if (err != 0 || pmatch[1].rm_so == -1) {
-		fprintf(stderr, "no matching pattern in %s\n", buf);
+		if (debug_on)
+			fprintf(stderr, "no matching pattern in %s\n", buf);
 		return -1;
 	}
 	val_len = pmatch[1].rm_eo - pmatch[1].rm_so;
@@ -276,7 +278,8 @@ static int get_page_num(char *buf)
 	errno = 0;
 	order_val = strtol(order_str, &endptr, 10);
 	if (order_val > 64 || errno != 0 || endptr == order_str || *endptr != '\0') {
-		fprintf(stderr, "wrong order in follow buf:\n%s\n", buf);
+		if (debug_on)
+			fprintf(stderr, "wrong order in follow buf:\n%s\n", buf);
 		return 0;
 	}
 
@@ -293,7 +296,8 @@ static pid_t get_pid(char *buf)
 	errno = 0;
 	pid = strtol(pid_str, &endptr, 10);
 	if (errno != 0 || endptr == pid_str || *endptr != '\0') {
-		fprintf(stderr, "wrong/invalid pid in follow buf:\n%s\n", buf);
+		if (debug_on)
+			fprintf(stderr, "wrong/invalid pid in follow buf:\n%s\n", buf);
 		return -1;
 	}
 
@@ -311,7 +315,8 @@ static pid_t get_tgid(char *buf)
 	errno = 0;
 	tgid = strtol(tgid_str, &endptr, 10);
 	if (errno != 0 || endptr == tgid_str || *endptr != '\0') {
-		fprintf(stderr, "wrong/invalid tgid in follow buf:\n%s\n", buf);
+		if (debug_on)
+			fprintf(stderr, "wrong/invalid tgid in follow buf:\n%s\n", buf);
 		return -1;
 	}
 
@@ -329,7 +334,8 @@ static __u64 get_ts_nsec(char *buf)
 	errno = 0;
 	ts_nsec = strtoull(ts_nsec_str, &endptr, 10);
 	if (errno != 0 || endptr == ts_nsec_str || *endptr != '\0') {
-		fprintf(stderr, "wrong ts_nsec in follow buf:\n%s\n", buf);
+		if (debug_on)
+			fprintf(stderr, "wrong ts_nsec in follow buf:\n%s\n", buf);
 		return -1;
 	}
 
@@ -346,7 +352,8 @@ static __u64 get_free_ts_nsec(char *buf)
 	errno = 0;
 	free_ts_nsec = strtoull(free_ts_nsec_str, &endptr, 10);
 	if (errno != 0 || endptr == free_ts_nsec_str || *endptr != '\0') {
-		fprintf(stderr, "wrong free_ts_nsec in follow buf:\n%s\n", buf);
+		if (debug_on)
+			fprintf(stderr, "wrong free_ts_nsec in follow buf:\n%s\n", buf);
 		return -1;
 	}
 
@@ -362,7 +369,8 @@ static char *get_comm(char *buf)
 	search_pattern(&comm_pattern, comm_str, buf);
 	errno = 0;
 	if (errno != 0) {
-		fprintf(stderr, "wrong comm in follow buf:\n%s\n", buf);
+		if (debug_on)
+			fprintf(stderr, "wrong comm in follow buf:\n%s\n", buf);
 		return NULL;
 	}
 
@@ -594,6 +602,7 @@ static void usage(void)
 		"-a\t\tSort by memory allocate time.\n"
 		"-r\t\tSort by memory release time.\n"
 		"-f\t\tFilter out the information of blocks whose memory has been released.\n"
+		"-d\t\tPrint debug information.\n"
 		"--pid <pidlist>\tSelect by pid. This selects the information of blocks whose process ID numbers appear in <pidlist>.\n"
 		"--tgid <tgidlist>\tSelect by tgid. This selects the information of blocks whose Thread Group ID numbers appear in <tgidlist>.\n"
 		"--name <cmdlist>\n\t\tSelect by command name. This selects the information of blocks whose command name appears in <cmdlist>.\n"
@@ -618,11 +627,14 @@ int main(int argc, char **argv)
 		{ 0, 0, 0, 0},
 	};
 
-	while ((opt = getopt_long(argc, argv, "afmnprstP", longopts, NULL)) != -1)
+	while ((opt = getopt_long(argc, argv, "adfmnprstP", longopts, NULL)) != -1)
 		switch (opt) {
 		case 'a':
 			set_single_cmp(compare_ts, SORT_ASC);
 			break;
+		case 'd':
+			debug_on = true;
+			break;
 		case 'f':
 			filter = filter | FILTER_UNRELEASE;
 			break;
_

Patches currently in -mm which might be from baihaowen@meizu.com are

tools-vm-page_owner-support-debug-log-to-avoid-huge-log-print.patch
kernel-pid_namespace-use-null-instead-of-using-plain-integer-as-pointer.patch

