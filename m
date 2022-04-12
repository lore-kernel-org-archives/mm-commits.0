Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082ACC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 23:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiDLXTG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiDLXSq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 19:18:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1B96E55D
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 16:13:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3D0AB81CA2
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 23:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D565C385A5;
        Tue, 12 Apr 2022 23:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649805216;
        bh=Igp4kG3JUdZLPEmw9g4VjDmIFUtZ2Ei/fjA1a8ApFz4=;
        h=Date:To:From:Subject:From;
        b=Cs/rilFtgOFNo0zSJUC1DTBGNHSSJJl20I3sbvrwm9zCoM1j07LeAaAlcQjkAaOwv
         xARbZgssJhDhuGtOLkPyJmEAFdeKSIwTgwnfi1GBJN5Rz1dXQdGlcbN+AYD9JKyp6v
         B1N1KgE4mPA8SFSxSuHNnpMvjVKAMn8H21wpeuaY=
Date:   Tue, 12 Apr 2022 16:13:34 -0700
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn,
        zhangyinan2019@email.szu.edu.cn, yuhongf@szu.edu.cn,
        yejiajian2018@email.szu.edu.cn, seanga2@gmail.com,
        liuyongqiang13@huawei.com, hanshenghong2019@email.szu.edu.cn,
        baihaowen@meizu.com, caoyixuan2019@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-page_owner_sortc-provide-allocator-labelling-and-update-cull-and-sort-options.patch added to -mm tree
Message-Id: <20220412231336.6D565C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: provide allocator labelling and update --cull and --sort options
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-provide-allocator-labelling-and-update-cull-and-sort-options.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-provide-allocator-labelling-and-update-cull-and-sort-options.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-provide-allocator-labelling-and-update-cull-and-sort-options.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: provide allocator labelling and update --cull and --sort options

An application is suspected of having memory leak when its memory
consumption is high and keeps increasing.  There are several commonly used
memory allocators: slab, cma, vmalloc, etc.  The memory leak
identification can be sped up if the page information allocated by an
allocator can be analyzed separately.

This patch provides supports for memory allocator labelling for slab,
vmalloc, and cma.  The pages allocated by slab and cma can be confirmed
from the "PFN" line according to the kernel codes, and the label of the
vmalloc allocator can be obtained by analyzing the stack trace.  Thanks
for Vlastimil Babka's constructive suggestions.

Based on Yinan Zhang's study, the call chain of vmalloc() is vmalloc() ->
...  -> __vmalloc_node_range() -> __vmalloc_area_node(). 
__vmalloc_area_node() requests memory through the interface of buddy
allocation system.  In the current version, __vmalloc_area_node() uses
four interfaces: alloc_pages_bulk_array_mempolicy(),
alloc_pages_bulk_array_node(), alloc_pages() and alloc_pages_node().  By
disassembling the code, we find that __vmalloc_area_node() is expanded in
__vmalloc_node_range().  So __vmalloc_area_node is not in the stack trace.

On the test machine, the stack trace of pages allocated by vmalloc has the
following four forms:

__alloc_pages_bulk+0x230/0x6a0
__vmalloc_node_range+0x19c/0x598

alloc_pages_bulk_array_mempolicy+0xbc/0x278
__vmalloc_node_range+0x1e8/0x598

__alloc_pages+0x160/0x2b0
__vmalloc_node_range+0x234/0x598

alloc_pages+0xac/0x150
__vmalloc_node_range+0x44c/0x598

Therefore, in two consecutive lines of stacktrace, if the first line
contains the word "alloc_pages" and the second line contains the word
"__vmalloc_node_range", it can be determined that the page is allocated by
vmalloc.  And the function offset and size are not the same on different
machines, so there is no need to match them.

At the same time, this patch updates the --cull and --sort options to
support allocator-based merge statistics and sorting.  The added functions
are fully compatible with the original work.  When using, you can use
"allocator", or abbreviated as "ator".  Relevant updates have also been
made in the documentation(Documentation/vm/page_owner.rst).

Example:
./page_owner_sort <input> <output> --cull=st,pid,name,allocator
./page_owner_sort <input> <output> --sort=ator,pid,name

This work is coauthored by Jiajian Ye, Yinan Zhang, Shenghong Han,
Chongxi Zhao, Yuhong Feng and Yongqiang Liu.

Link: https://lkml.kernel.org/r/20220410132932.9402-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Cc: Haowen Bai <baihaowen@meizu.com>
Cc: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Sean Anderson <seanga2@gmail.com>
Cc: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Cc: Yuhong Feng <yuhongf@szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/vm/page_owner.rst~tools-vm-page_owner_sortc-provide-allocator-labelling-and-update-cull-and-sort-options
+++ a/Documentation/vm/page_owner.rst
@@ -182,6 +182,7 @@ For --sort option:
 	T		txt		full text of block
 	ft		free_ts		timestamp of the page when it was released
 	at		alloc_ts	timestamp of the page when it was allocated
+        ator            allocator       memory allocator for pages
 
 For --curl option:
 
@@ -191,4 +192,4 @@ For --curl option:
 	n		name		task command name
 	f		free		whether the page has been released or not
 	st		stacktrace	stack trace of the page allocation
-
+        ator            allocator       memory allocator for pages
--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-provide-allocator-labelling-and-update-cull-and-sort-options
+++ a/tools/vm/page_owner_sort.c
@@ -39,6 +39,7 @@ struct block_list {
 	int page_num;
 	pid_t pid;
 	pid_t tgid;
+	int allocator;
 };
 enum FILTER_BIT {
 	FILTER_UNRELEASE = 1<<1,
@@ -51,11 +52,19 @@ enum CULL_BIT {
 	CULL_PID = 1<<2,
 	CULL_TGID = 1<<3,
 	CULL_COMM = 1<<4,
-	CULL_STACKTRACE = 1<<5
+	CULL_STACKTRACE = 1<<5,
+	CULL_ALLOCATOR = 1<<6
+};
+enum ALLOCATOR_BIT {
+	ALLOCATOR_CMA = 1<<1,
+	ALLOCATOR_SLAB = 1<<2,
+	ALLOCATOR_VMALLOC = 1<<3,
+	ALLOCATOR_OTHERS = 1<<4
 };
 enum ARG_TYPE {
 	ARG_TXT, ARG_COMM, ARG_STACKTRACE, ARG_ALLOC_TS, ARG_FREE_TS,
-	ARG_CULL_TIME, ARG_PAGE_NUM, ARG_PID, ARG_TGID, ARG_UNKNOWN, ARG_FREE
+	ARG_CULL_TIME, ARG_PAGE_NUM, ARG_PID, ARG_TGID, ARG_UNKNOWN, ARG_FREE,
+	ARG_ALLOCATOR
 };
 enum SORT_ORDER {
 	SORT_ASC = 1,
@@ -89,15 +98,20 @@ static int cull;
 static int filter;
 static bool debug_on;
 
-int read_block(char *buf, int buf_size, FILE *fin)
+static void set_single_cmp(int (*cmp)(const void *, const void *), int sign);
+
+int read_block(char *buf, char *ext_buf, int buf_size, FILE *fin)
 {
 	char *curr = buf, *const buf_end = buf + buf_size;
 
 	while (buf_end - curr > 1 && fgets(curr, buf_end - curr, fin)) {
-		if (*curr == '\n') /* empty line */
+		if (*curr == '\n') { /* empty line */
 			return curr - buf;
-		if (!strncmp(curr, "PFN", 3))
+		}
+		if (!strncmp(curr, "PFN", 3)) {
+			strcpy(ext_buf, curr);
 			continue;
+		}
 		curr += strlen(curr);
 	}
 
@@ -146,6 +160,13 @@ static int compare_tgid(const void *p1,
 	return l1->tgid - l2->tgid;
 }
 
+static int compare_allocator(const void *p1, const void *p2)
+{
+	const struct block_list *l1 = p1, *l2 = p2;
+
+	return l1->allocator - l2->allocator;
+}
+
 static int compare_comm(const void *p1, const void *p2)
 {
 	const struct block_list *l1 = p1, *l2 = p2;
@@ -192,6 +213,8 @@ static int compare_cull_condition(const
 		return compare_comm(p1, p2);
 	if ((cull & CULL_UNRELEASE) && compare_release(p1, p2))
 		return compare_release(p1, p2);
+	if ((cull & CULL_ALLOCATOR) && compare_allocator(p1, p2))
+		return compare_allocator(p1, p2);
 	return 0;
 }
 
@@ -395,11 +418,42 @@ static int get_arg_type(const char *arg)
 		return ARG_FREE_TS;
 	else if (!strcmp(arg, "alloc_ts") || !strcmp(arg, "at"))
 		return ARG_ALLOC_TS;
+	else if (!strcmp(arg, "allocator") || !strcmp(arg, "ator"))
+		return ARG_ALLOCATOR;
 	else {
 		return ARG_UNKNOWN;
 	}
 }
 
+static int get_allocator(const char *buf, const char *migrate_info)
+{
+	char *tmp, *first_line, *second_line;
+	int allocator = 0;
+
+	if (strstr(migrate_info, "CMA"))
+		allocator |= ALLOCATOR_CMA;
+	if (strstr(migrate_info, "slab"))
+		allocator |= ALLOCATOR_SLAB;
+	tmp = strstr(buf, "__vmalloc_node_range");
+	if (tmp) {
+		second_line = tmp;
+		while (*tmp != '\n')
+			tmp--;
+		tmp--;
+		while (*tmp != '\n')
+			tmp--;
+		first_line = ++tmp;
+		tmp = strstr(tmp, "alloc_pages");
+		if (tmp) {
+			if (tmp && first_line <= tmp && tmp < second_line)
+				allocator |= ALLOCATOR_VMALLOC;
+		}
+	}
+	if (allocator == 0)
+		allocator = ALLOCATOR_OTHERS;
+	return allocator;
+}
+
 static bool match_num_list(int num, int *list, int list_size)
 {
 	for (int i = 0; i < list_size; ++i)
@@ -437,7 +491,7 @@ static bool is_need(char *buf)
 		return true;
 }
 
-static void add_list(char *buf, int len)
+static void add_list(char *buf, int len, char *ext_buf)
 {
 	if (list_size != 0 &&
 		len == list[list_size-1].len &&
@@ -471,6 +525,7 @@ static void add_list(char *buf, int len)
 		list[list_size].stacktrace++;
 	list[list_size].ts_nsec = get_ts_nsec(buf);
 	list[list_size].free_ts_nsec = get_free_ts_nsec(buf);
+	list[list_size].allocator = get_allocator(buf, ext_buf);
 	list_size++;
 	if (list_size % 1000 == 0) {
 		printf("loaded %d\r", list_size);
@@ -496,12 +551,16 @@ static bool parse_cull_args(const char *
 			cull |= CULL_STACKTRACE;
 		else if (arg_type == ARG_FREE)
 			cull |= CULL_UNRELEASE;
+		else if (arg_type == ARG_ALLOCATOR)
+			cull |= CULL_ALLOCATOR;
 		else {
 			free_explode(args, size);
 			return false;
 		}
 	}
 	free_explode(args, size);
+	if (sc.size == 0)
+		set_single_cmp(compare_num, SORT_DESC);
 	return true;
 }
 
@@ -556,6 +615,8 @@ static bool parse_sort_args(const char *
 			sc.cmps[i] = compare_free_ts;
 		else if (arg_type == ARG_TXT)
 			sc.cmps[i] = compare_txt;
+		else if (arg_type == ARG_ALLOCATOR)
+			sc.cmps[i] = compare_allocator;
 		else {
 			free_explode(args, size);
 			sc.size = 0;
@@ -588,6 +649,19 @@ static int *parse_nums_list(char *arg_st
 	return list;
 }
 
+static void print_allocator(FILE *out, int allocator)
+{
+	fprintf(out, "allocated by ");
+	if (allocator & ALLOCATOR_CMA)
+		fprintf(out, "CMA ");
+	if (allocator & ALLOCATOR_SLAB)
+		fprintf(out, "SLAB ");
+	if (allocator & ALLOCATOR_VMALLOC)
+		fprintf(out, "VMALLOC ");
+	if (allocator & ALLOCATOR_OTHERS)
+		fprintf(out, "OTHERS ");
+}
+
 #define BUF_SIZE	(128 * 1024)
 
 static void usage(void)
@@ -614,8 +688,8 @@ static void usage(void)
 int main(int argc, char **argv)
 {
 	FILE *fin, *fout;
-	char *buf;
-	int ret, i, count;
+	char *buf, *ext_buf;
+	int i, count;
 	struct stat st;
 	int opt;
 	struct option longopts[] = {
@@ -724,16 +798,18 @@ int main(int argc, char **argv)
 
 	list = malloc(max_size * sizeof(*list));
 	buf = malloc(BUF_SIZE);
-	if (!list || !buf) {
+	ext_buf = malloc(BUF_SIZE);
+	if (!list || !buf || !ext_buf) {
 		fprintf(stderr, "Out of memory\n");
 		exit(1);
 	}
 
 	for ( ; ; ) {
-		ret = read_block(buf, BUF_SIZE, fin);
-		if (ret < 0)
+		int buf_len = read_block(buf, ext_buf, BUF_SIZE, fin);
+
+		if (buf_len < 0)
 			break;
-		add_list(buf, ret);
+		add_list(buf, buf_len, ext_buf);
 	}
 
 	printf("loaded %d\n", list_size);
@@ -757,9 +833,11 @@ int main(int argc, char **argv)
 	qsort(list, count, sizeof(list[0]), compare_sort_condition);
 
 	for (i = 0; i < count; i++) {
-		if (cull == 0)
-			fprintf(fout, "%d times, %d pages:\n%s\n",
-					list[i].num, list[i].page_num, list[i].txt);
+		if (cull == 0) {
+			fprintf(fout, "%d times, %d pages, ", list[i].num, list[i].page_num);
+			print_allocator(fout, list[i].allocator);
+			fprintf(fout, ":\n%s\n", list[i].txt);
+		}
 		else {
 			fprintf(fout, "%d times, %d pages",
 					list[i].num, list[i].page_num);
@@ -769,6 +847,10 @@ int main(int argc, char **argv)
 				fprintf(fout, ", TGID %d", list[i].pid);
 			if (cull & CULL_COMM || filter & FILTER_COMM)
 				fprintf(fout, ", task_comm_name: %s", list[i].comm);
+			if (cull & CULL_ALLOCATOR) {
+				fprintf(fout, ", ");
+				print_allocator(fout, list[i].allocator);
+			}
 			if (cull & CULL_UNRELEASE)
 				fprintf(fout, " (%s)",
 						list[i].free_ts_nsec ? "UNRELEASED" : "RELEASED");
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are

tools-vm-page_owner_sortc-provide-allocator-labelling-and-update-cull-and-sort-options.patch
mm-vmalloc-fix-a-comment.patch

