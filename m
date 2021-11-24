Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1BDC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 21:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244117AbhKXVNb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:13:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234102AbhKXVNb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 16:13:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 046F860FDA;
        Wed, 24 Nov 2021 21:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637788221;
        bh=n7fz7brzLukESifJ4VwTVgHzm6S45upWuwKA8MqHL+o=;
        h=Date:From:To:Subject:From;
        b=gMkpbj5dm8txhDyq9CzApXAw95eqS5HUeU4c0zN9lYe5zfxKuOKtoMaHb1zJ6Qwzi
         kiUUjbk56Br1UQ6RMwDaxDMXg7IVwe/mgE06sNPW73nGzMgTenQMA3yVr/qkZCUxb9
         YnS/GjXDFYKVV9eEghEXn0oB8ZmpiOypzxpdDxnU=
Date:   Wed, 24 Nov 2021 13:10:20 -0800
From:   akpm@linux-foundation.org
To:     ch0.han@lge.com, mm-commits@vger.kernel.org, seanga2@gmail.com,
        tangbin@cmss.chinamobile.com, weizhenliang@huawei.com,
        zhangshengju@cmss.chinamobile.com
Subject:  +
 tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling.patch added to
 -mm tree
Message-ID: <20211124211020.NtfAHnrg5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: sort by stacktrace before culling
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: https://lkml.kernel.org/r/20211124193709.1805776-1-seanga2@gmail.com
Signed-off-by: Sean Anderson <seanga2@gmail.com>
Cc: Changhee Han <ch0.han@lge.com>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
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
+	return strcmp(l1->stacktrace ?: "", l2->stacktrace ?: "");
 }
 
 static int compare_num(const void *p1, const void *p2)
@@ -121,6 +122,7 @@ static void add_list(char *buf, int len)
 	list[list_size].page_num = get_page_num(buf);
 	memcpy(list[list_size].txt, buf, len);
 	list[list_size].txt[len] = 0;
+	list[list_size].stacktrace = strchr(list[list_size].txt, '\n');
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

Patches currently in -mm which might be from seanga2@gmail.com are

tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling.patch
tools-vm-page_owner_sortc-support-sorting-by-stack-trace.patch

