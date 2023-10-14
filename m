Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 729D0CDB465
	for <mm-commits@archiver.kernel.org>; Sat, 14 Oct 2023 22:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjJNWQR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Oct 2023 18:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbjJNWQQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Oct 2023 18:16:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D99E3
        for <mm-commits@vger.kernel.org>; Sat, 14 Oct 2023 15:16:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CE3C433C8;
        Sat, 14 Oct 2023 22:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697321773;
        bh=/GWAJSjWtdjSxgcOZWNxG1L/dVTHiq4odcyW+7UX2I0=;
        h=Date:To:From:Subject:From;
        b=pzWuOQaM01soy8IyWxgxzhKCKcrva83c2ReyJ11B+TxJGmB7hhmYOyi86ChaRwbQH
         V8d7jaqTtWKqMZg4ndHZkZFi8UAozRBlftkVxrwagNafqNqf6u5QijjEv2ookpoBu4
         hVOJYl2Y1zWe4TyIirl5TDQFGk4UOdBuzKWV5mz4=
Date:   Sat, 14 Oct 2023 15:16:10 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, raquini@redhat.com,
        djakov@kernel.org, audra@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-remove-references-to-free_ts-from-page_owner_sort.patch added to mm-unstable branch
Message-Id: <20231014221613.02CE3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/mm: remove references to free_ts from page_owner_sort
has been added to the -mm mm-unstable branch.  Its filename is
     tools-mm-remove-references-to-free_ts-from-page_owner_sort.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-remove-references-to-free_ts-from-page_owner_sort.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Audra Mitchell <audra@redhat.com>
Subject: tools/mm: remove references to free_ts from page_owner_sort
Date: Fri, 13 Oct 2023 15:03:46 -0400

With the removal of free timestamps from page_owner output, we no longer
need to handle this case or the "unreleased" case.  Remove all references
to both cases.

Link: https://lkml.kernel.org/r/20231013190350.579407-3-audra@redhat.com
Signed-off-by: Audra Mitchell <audra@redhat.com>
Cc: Georgi Djakov <djakov@kernel.org>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |   98 ++++-------------------------------
 1 file changed, 12 insertions(+), 86 deletions(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-remove-references-to-free_ts-from-page_owner_sort
+++ a/tools/mm/page_owner_sort.c
@@ -33,7 +33,6 @@ struct block_list {
 	char *comm; // task command name
 	char *stacktrace;
 	__u64 ts_nsec;
-	__u64 free_ts_nsec;
 	int len;
 	int num;
 	int page_num;
@@ -42,18 +41,16 @@ struct block_list {
 	int allocator;
 };
 enum FILTER_BIT {
-	FILTER_UNRELEASE = 1<<1,
-	FILTER_PID = 1<<2,
-	FILTER_TGID = 1<<3,
-	FILTER_COMM = 1<<4
+	FILTER_PID = 1<<1,
+	FILTER_TGID = 1<<2,
+	FILTER_COMM = 1<<3
 };
 enum CULL_BIT {
-	CULL_UNRELEASE = 1<<1,
-	CULL_PID = 1<<2,
-	CULL_TGID = 1<<3,
-	CULL_COMM = 1<<4,
-	CULL_STACKTRACE = 1<<5,
-	CULL_ALLOCATOR = 1<<6
+	CULL_PID = 1<<1,
+	CULL_TGID = 1<<2,
+	CULL_COMM = 1<<3,
+	CULL_STACKTRACE = 1<<4,
+	CULL_ALLOCATOR = 1<<5
 };
 enum ALLOCATOR_BIT {
 	ALLOCATOR_CMA = 1<<1,
@@ -62,9 +59,8 @@ enum ALLOCATOR_BIT {
 	ALLOCATOR_OTHERS = 1<<4
 };
 enum ARG_TYPE {
-	ARG_TXT, ARG_COMM, ARG_STACKTRACE, ARG_ALLOC_TS, ARG_FREE_TS,
-	ARG_CULL_TIME, ARG_PAGE_NUM, ARG_PID, ARG_TGID, ARG_UNKNOWN, ARG_FREE,
-	ARG_ALLOCATOR
+	ARG_TXT, ARG_COMM, ARG_STACKTRACE, ARG_ALLOC_TS, ARG_CULL_TIME,
+	ARG_PAGE_NUM, ARG_PID, ARG_TGID, ARG_UNKNOWN, ARG_ALLOCATOR
 };
 enum SORT_ORDER {
 	SORT_ASC = 1,
@@ -90,7 +86,6 @@ static regex_t pid_pattern;
 static regex_t tgid_pattern;
 static regex_t comm_pattern;
 static regex_t ts_nsec_pattern;
-static regex_t free_ts_nsec_pattern;
 static struct block_list *list;
 static int list_size;
 static int max_size;
@@ -181,24 +176,6 @@ static int compare_ts(const void *p1, co
 	return l1->ts_nsec < l2->ts_nsec ? -1 : 1;
 }
 
-static int compare_free_ts(const void *p1, const void *p2)
-{
-	const struct block_list *l1 = p1, *l2 = p2;
-
-	return l1->free_ts_nsec < l2->free_ts_nsec ? -1 : 1;
-}
-
-static int compare_release(const void *p1, const void *p2)
-{
-	const struct block_list *l1 = p1, *l2 = p2;
-
-	if (!l1->free_ts_nsec && !l2->free_ts_nsec)
-		return 0;
-	if (l1->free_ts_nsec && l2->free_ts_nsec)
-		return 0;
-	return l1->free_ts_nsec ? 1 : -1;
-}
-
 static int compare_cull_condition(const void *p1, const void *p2)
 {
 	if (cull == 0)
@@ -211,8 +188,6 @@ static int compare_cull_condition(const
 		return compare_tgid(p1, p2);
 	if ((cull & CULL_COMM) && compare_comm(p1, p2))
 		return compare_comm(p1, p2);
-	if ((cull & CULL_UNRELEASE) && compare_release(p1, p2))
-		return compare_release(p1, p2);
 	if ((cull & CULL_ALLOCATOR) && compare_allocator(p1, p2))
 		return compare_allocator(p1, p2);
 	return 0;
@@ -366,24 +341,6 @@ static __u64 get_ts_nsec(char *buf)
 	return ts_nsec;
 }
 
-static __u64 get_free_ts_nsec(char *buf)
-{
-	__u64 free_ts_nsec;
-	char free_ts_nsec_str[FIELD_BUFF] = {0};
-	char *endptr;
-
-	search_pattern(&free_ts_nsec_pattern, free_ts_nsec_str, buf);
-	errno = 0;
-	free_ts_nsec = strtoull(free_ts_nsec_str, &endptr, 10);
-	if (errno != 0 || endptr == free_ts_nsec_str || *endptr != '\0') {
-		if (debug_on)
-			fprintf(stderr, "wrong free_ts_nsec in follow buf:\n%s\n", buf);
-		return -1;
-	}
-
-	return free_ts_nsec;
-}
-
 static char *get_comm(char *buf)
 {
 	char *comm_str = malloc(TASK_COMM_LEN);
@@ -411,12 +368,8 @@ static int get_arg_type(const char *arg)
 		return  ARG_COMM;
 	else if (!strcmp(arg, "stacktrace") || !strcmp(arg, "st"))
 		return ARG_STACKTRACE;
-	else if (!strcmp(arg, "free") || !strcmp(arg, "f"))
-		return ARG_FREE;
 	else if (!strcmp(arg, "txt") || !strcmp(arg, "T"))
 		return ARG_TXT;
-	else if (!strcmp(arg, "free_ts") || !strcmp(arg, "ft"))
-		return ARG_FREE_TS;
 	else if (!strcmp(arg, "alloc_ts") || !strcmp(arg, "at"))
 		return ARG_ALLOC_TS;
 	else if (!strcmp(arg, "allocator") || !strcmp(arg, "ator"))
@@ -471,13 +424,6 @@ static bool match_str_list(const char *s
 
 static bool is_need(char *buf)
 {
-	__u64 ts_nsec, free_ts_nsec;
-
-	ts_nsec = get_ts_nsec(buf);
-	free_ts_nsec = get_free_ts_nsec(buf);
-
-	if ((filter & FILTER_UNRELEASE) && free_ts_nsec != 0 && ts_nsec < free_ts_nsec)
-		return false;
 	if ((filter & FILTER_PID) && !match_num_list(get_pid(buf), fc.pids, fc.pids_size))
 		return false;
 	if ((filter & FILTER_TGID) &&
@@ -528,7 +474,6 @@ static bool add_list(char *buf, int len,
 	if (*list[list_size].stacktrace == '\n')
 		list[list_size].stacktrace++;
 	list[list_size].ts_nsec = get_ts_nsec(buf);
-	list[list_size].free_ts_nsec = get_free_ts_nsec(buf);
 	list[list_size].allocator = get_allocator(buf, ext_buf);
 	list_size++;
 	if (list_size % 1000 == 0) {
@@ -554,8 +499,6 @@ static bool parse_cull_args(const char *
 			cull |= CULL_COMM;
 		else if (arg_type == ARG_STACKTRACE)
 			cull |= CULL_STACKTRACE;
-		else if (arg_type == ARG_FREE)
-			cull |= CULL_UNRELEASE;
 		else if (arg_type == ARG_ALLOCATOR)
 			cull |= CULL_ALLOCATOR;
 		else {
@@ -616,8 +559,6 @@ static bool parse_sort_args(const char *
 			sc.cmps[i] = compare_stacktrace;
 		else if (arg_type == ARG_ALLOC_TS)
 			sc.cmps[i] = compare_ts;
-		else if (arg_type == ARG_FREE_TS)
-			sc.cmps[i] = compare_free_ts;
 		else if (arg_type == ARG_TXT)
 			sc.cmps[i] = compare_txt;
 		else if (arg_type == ARG_ALLOCATOR)
@@ -679,8 +620,6 @@ static void usage(void)
 		"-P\t\tSort by tgid.\n"
 		"-n\t\tSort by task command name.\n"
 		"-a\t\tSort by memory allocate time.\n"
-		"-r\t\tSort by memory release time.\n"
-		"-f\t\tFilter out the information of blocks whose memory has been released.\n"
 		"-d\t\tPrint debug information.\n"
 		"--pid <pidlist>\tSelect by pid. This selects the information of blocks whose process ID numbers appear in <pidlist>.\n"
 		"--tgid <tgidlist>\tSelect by tgid. This selects the information of blocks whose Thread Group ID numbers appear in <tgidlist>.\n"
@@ -706,7 +645,7 @@ int main(int argc, char **argv)
 		{ 0, 0, 0, 0},
 	};
 
-	while ((opt = getopt_long(argc, argv, "adfmnprstP", longopts, NULL)) != -1)
+	while ((opt = getopt_long(argc, argv, "admnpstP", longopts, NULL)) != -1)
 		switch (opt) {
 		case 'a':
 			set_single_cmp(compare_ts, SORT_ASC);
@@ -714,18 +653,12 @@ int main(int argc, char **argv)
 		case 'd':
 			debug_on = true;
 			break;
-		case 'f':
-			filter = filter | FILTER_UNRELEASE;
-			break;
 		case 'm':
 			set_single_cmp(compare_page_num, SORT_DESC);
 			break;
 		case 'p':
 			set_single_cmp(compare_pid, SORT_ASC);
 			break;
-		case 'r':
-			set_single_cmp(compare_free_ts, SORT_ASC);
-			break;
 		case 's':
 			set_single_cmp(compare_stacktrace, SORT_ASC);
 			break;
@@ -800,10 +733,8 @@ int main(int argc, char **argv)
 		goto out_tgid;
 	if (!check_regcomp(&comm_pattern, "tgid\\s*[0-9]*\\s*\\((.*)\\),\\s*ts"))
 		goto out_comm;
-	if (!check_regcomp(&ts_nsec_pattern, "ts\\s*([0-9]*)\\s*ns,"))
+	if (!check_regcomp(&ts_nsec_pattern, "ts\\s*([0-9]*)\\s*ns"))
 		goto out_ts;
-	if (!check_regcomp(&free_ts_nsec_pattern, "free_ts\\s*([0-9]*)\\s*ns"))
-		goto out_free_ts;
 
 	fstat(fileno(fin), &st);
 	max_size = st.st_size / 100; /* hack ... */
@@ -864,9 +795,6 @@ int main(int argc, char **argv)
 				fprintf(fout, ", ");
 				print_allocator(fout, list[i].allocator);
 			}
-			if (cull & CULL_UNRELEASE)
-				fprintf(fout, " (%s)",
-						list[i].free_ts_nsec ? "UNRELEASED" : "RELEASED");
 			if (cull & CULL_STACKTRACE)
 				fprintf(fout, ":\n%s", list[i].stacktrace);
 			fprintf(fout, "\n");
@@ -880,8 +808,6 @@ out_free:
 		free(buf);
 	if (list)
 		free(list);
-out_free_ts:
-	regfree(&free_ts_nsec_pattern);
 out_ts:
 	regfree(&ts_nsec_pattern);
 out_comm:
_

Patches currently in -mm which might be from audra@redhat.com are

mm-page_owner-remove-free_ts-from-page_owner-output.patch
tools-mm-remove-references-to-free_ts-from-page_owner_sort.patch
tools-mm-filter-out-timestamps-for-correct-collation.patch
tools-mm-fix-the-default-case-for-page_owner_sort.patch
tools-mm-update-the-usage-output-to-be-more-organized.patch

