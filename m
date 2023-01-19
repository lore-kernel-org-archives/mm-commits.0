Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA28C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjASBRr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjASBPn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A792768439
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33DD561B08
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E478C433D2;
        Thu, 19 Jan 2023 01:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090892;
        bh=lzgWfW2oRcYnXiipKk5qRpiISZxFFyOXyntaSYzw7kI=;
        h=Date:To:From:Subject:From;
        b=JVttmE9ed8wk5oJyF/7lCxxwkhME59u4EO9ofbGaLFuwSUwZXC6Pp+ceP0B1dA9hx
         VO0UKZI7cKgyu5hN1HVGiCxlVOvPKrOT0s/LUbFr+KI6LBZ9GHo823O5RZJkusJIY0
         XuNoO1VSaTZlcKkBDi/4qKRfBYV0HrL9CvHgNx9Q=
Date:   Wed, 18 Jan 2023 17:14:52 -0800
To:     mm-commits@vger.kernel.org, iecedge@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-vm-page_owner_sort-free-memory-before-exit.patch removed from -mm tree
Message-Id: <20230119011452.8E478C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/vm/page_owner_sort: free memory before exit
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sort-free-memory-before-exit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jianlin Lv <iecedge@gmail.com>
Subject: tools/vm/page_owner_sort: free memory before exit
Date: Mon, 19 Dec 2022 16:49:17 +0000

Although when a process terminates, the kernel will removes memory
associated with that process, It's neither good style nor proper design to
leave it to kernel.  This patch free allocated memory before process exit.

Link: https://lkml.kernel.org/r/20221219164917.14132-1-iecedge@gmail.com
Signed-off-by: Jianlin Lv <iecedge@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |   65 ++++++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 20 deletions(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sort-free-memory-before-exit
+++ a/tools/vm/page_owner_sort.c
@@ -246,15 +246,16 @@ static int search_pattern(regex_t *patte
 	return 0;
 }
 
-static void check_regcomp(regex_t *pattern, const char *regex)
+static bool check_regcomp(regex_t *pattern, const char *regex)
 {
 	int err;
 
 	err = regcomp(pattern, regex, REG_EXTENDED | REG_NEWLINE);
 	if (err != 0 || pattern->re_nsub != 1) {
 		fprintf(stderr, "Invalid pattern %s code %d\n", regex, err);
-		exit(1);
+		return false;
 	}
+	return true;
 }
 
 static char **explode(char sep, const char *str, int *size)
@@ -494,28 +495,28 @@ static bool is_need(char *buf)
 	return true;
 }
 
-static void add_list(char *buf, int len, char *ext_buf)
+static bool add_list(char *buf, int len, char *ext_buf)
 {
 	if (list_size != 0 &&
 		len == list[list_size-1].len &&
 		memcmp(buf, list[list_size-1].txt, len) == 0) {
 		list[list_size-1].num++;
 		list[list_size-1].page_num += get_page_num(buf);
-		return;
+		return true;
 	}
 	if (list_size == max_size) {
 		fprintf(stderr, "max_size too small??\n");
-		exit(1);
+		return false;
 	}
 	if (!is_need(buf))
-		return;
+		return true;
 	list[list_size].pid = get_pid(buf);
 	list[list_size].tgid = get_tgid(buf);
 	list[list_size].comm = get_comm(buf);
 	list[list_size].txt = malloc(len+1);
 	if (!list[list_size].txt) {
 		fprintf(stderr, "Out of memory\n");
-		exit(1);
+		return false;
 	}
 	memcpy(list[list_size].txt, buf, len);
 	list[list_size].txt[len] = 0;
@@ -534,6 +535,7 @@ static void add_list(char *buf, int len,
 		printf("loaded %d\r", list_size);
 		fflush(stdout);
 	}
+	return true;
 }
 
 static bool parse_cull_args(const char *arg_str)
@@ -790,12 +792,19 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	check_regcomp(&order_pattern, "order\\s*([0-9]*),");
-	check_regcomp(&pid_pattern, "pid\\s*([0-9]*),");
-	check_regcomp(&tgid_pattern, "tgid\\s*([0-9]*) ");
-	check_regcomp(&comm_pattern, "tgid\\s*[0-9]*\\s*\\((.*)\\),\\s*ts");
-	check_regcomp(&ts_nsec_pattern, "ts\\s*([0-9]*)\\s*ns,");
-	check_regcomp(&free_ts_nsec_pattern, "free_ts\\s*([0-9]*)\\s*ns");
+	if (!check_regcomp(&order_pattern, "order\\s*([0-9]*),"))
+		goto out_order;
+	if (!check_regcomp(&pid_pattern, "pid\\s*([0-9]*),"))
+		goto out_pid;
+	if (!check_regcomp(&tgid_pattern, "tgid\\s*([0-9]*) "))
+		goto out_tgid;
+	if (!check_regcomp(&comm_pattern, "tgid\\s*[0-9]*\\s*\\((.*)\\),\\s*ts"))
+		goto out_comm;
+	if (!check_regcomp(&ts_nsec_pattern, "ts\\s*([0-9]*)\\s*ns,"))
+		goto out_ts;
+	if (!check_regcomp(&free_ts_nsec_pattern, "free_ts\\s*([0-9]*)\\s*ns"))
+		goto out_free_ts;
+
 	fstat(fileno(fin), &st);
 	max_size = st.st_size / 100; /* hack ... */
 
@@ -804,7 +813,7 @@ int main(int argc, char **argv)
 	ext_buf = malloc(BUF_SIZE);
 	if (!list || !buf || !ext_buf) {
 		fprintf(stderr, "Out of memory\n");
-		exit(1);
+		goto out_free;
 	}
 
 	for ( ; ; ) {
@@ -812,7 +821,8 @@ int main(int argc, char **argv)
 
 		if (buf_len < 0)
 			break;
-		add_list(buf, buf_len, ext_buf);
+		if (!add_list(buf, buf_len, ext_buf))
+			goto out_free;
 	}
 
 	printf("loaded %d\n", list_size);
@@ -862,11 +872,26 @@ int main(int argc, char **argv)
 			fprintf(fout, "\n");
 		}
 	}
-	regfree(&order_pattern);
-	regfree(&pid_pattern);
-	regfree(&tgid_pattern);
-	regfree(&comm_pattern);
-	regfree(&ts_nsec_pattern);
+
+out_free:
+	if (ext_buf)
+		free(ext_buf);
+	if (buf)
+		free(buf);
+	if (list)
+		free(list);
+out_free_ts:
 	regfree(&free_ts_nsec_pattern);
+out_ts:
+	regfree(&ts_nsec_pattern);
+out_comm:
+	regfree(&comm_pattern);
+out_tgid:
+	regfree(&tgid_pattern);
+out_pid:
+	regfree(&pid_pattern);
+out_order:
+	regfree(&order_pattern);
+
 	return 0;
 }
_

Patches currently in -mm which might be from iecedge@gmail.com are


