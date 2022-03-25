Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A95AC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbiCYBKN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234981AbiCYBKM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:10:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E1C43EC8
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:08:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A75D361831
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A30FC340EC;
        Fri, 25 Mar 2022 01:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170519;
        bh=QT7MNf/iW43UiJIAyKneys+4Rsw+spa+ycHtElpmdtA=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=K5GUhESeHjnX40BjqVCDyApHaXYRRldbc1eeIIi31ks+wHR2o52fbqg7AKKc0DQ4t
         jBED6OqV5uVf+2WC1wW6dp1J3DCqtflKdloj7Qg6BVI4cfrn/b0IXRtcskKIISr55L
         jk0vwqhUzWGFw8xaaKX4hbJHbpDarWxWLgXeQKpM=
Date:   Thu, 24 Mar 2022 18:08:38 -0700
To:     zhangyinan2019@email.szu.edu.cn, zhangshengju@cmss.chinamobile.com,
        weizhenliang@huawei.com, tangbin@cmss.chinamobile.com,
        sfr@canb.auug.org.au, ch0.han@lge.com, seanga2@gmail.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 001/114] tools/vm/page_owner_sort.c: sort by stacktrace before culling
Message-Id: <20220325010839.0A30FC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sean Anderson <seanga2@gmail.com>
Subject: tools/vm/page_owner_sort.c: sort by stacktrace before culling

The contents of page_owner have changed to include more information than
the stack trace.  On a modern kernel, the blocks look like

Page allocated via order 0, mask 0x0(), pid 1, ts 165564237 ns, free_ts 0 ns
 register_early_stack+0x4b/0x90
 init_page_owner+0x39/0x250
 kernel_init_freeable+0x11e/0x242
 kernel_init+0x16/0x130

Sorting by the contents of .txt will result in almost no repeated pages,
as the pid, ts, and free_ts will almost never be the same.  Instead, sort
by the contents of the stack trace, which we assume to be whatever is
after the first line.

[seanga2@gmail.com: fix NULL-pointer dereference when comparing stack traces]
  Link: https://lkml.kernel.org/r/20211125162653.1855958-1-seanga2@gmail.com
Link: https://lkml.kernel.org/r/20211124193709.1805776-1-seanga2@gmail.com
Signed-off-by: Sean Anderson <seanga2@gmail.com>
Signed-off-by: Sean Anderson <seanga2@gmail.com>
Cc: Changhee Han <ch0.han@lge.com>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling
+++ a/tools/vm/page_owner_sort.c
@@ -23,6 +23,7 @@
 
 struct block_list {
 	char *txt;
+	char *stacktrace;
 	int len;
 	int num;
 	int page_num;
@@ -51,11 +52,11 @@ int read_block(char *buf, int buf_size,
 	return -1; /* EOF or no space left in buf. */
 }
 
-static int compare_txt(const void *p1, const void *p2)
+static int compare_stacktrace(const void *p1, const void *p2)
 {
 	const struct block_list *l1 = p1, *l2 = p2;
 
-	return strcmp(l1->txt, l2->txt);
+	return strcmp(l1->stacktrace, l2->stacktrace);
 }
 
 static int compare_num(const void *p1, const void *p2)
@@ -121,6 +122,7 @@ static void add_list(char *buf, int len)
 	list[list_size].page_num = get_page_num(buf);
 	memcpy(list[list_size].txt, buf, len);
 	list[list_size].txt[len] = 0;
+	list[list_size].stacktrace = strchr(list[list_size].txt, '\n') ?: "";
 	list_size++;
 	if (list_size % 1000 == 0) {
 		printf("loaded %d\r", list_size);
@@ -199,7 +201,7 @@ int main(int argc, char **argv)
 
 	printf("sorting ....\n");
 
-	qsort(list, list_size, sizeof(list[0]), compare_txt);
+	qsort(list, list_size, sizeof(list[0]), compare_stacktrace);
 
 	list2 = malloc(sizeof(*list) * list_size);
 	if (!list2) {
@@ -211,7 +213,7 @@ int main(int argc, char **argv)
 
 	for (i = count = 0; i < list_size; i++) {
 		if (count == 0 ||
-		    strcmp(list2[count-1].txt, list[i].txt) != 0) {
+		    strcmp(list2[count-1].stacktrace, list[i].stacktrace) != 0) {
 			list2[count++] = list[i];
 		} else {
 			list2[count-1].num += list[i].num;
_
