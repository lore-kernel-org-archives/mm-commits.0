Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DE8CDB465
	for <mm-commits@archiver.kernel.org>; Sat, 14 Oct 2023 22:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjJNWQ2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Oct 2023 18:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbjJNWQ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Oct 2023 18:16:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0992E5
        for <mm-commits@vger.kernel.org>; Sat, 14 Oct 2023 15:16:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA10AC433C8;
        Sat, 14 Oct 2023 22:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697321783;
        bh=kK2xtaevIfwOS09eEbEycFBicagTrkFYV2pPFixrw0o=;
        h=Date:To:From:Subject:From;
        b=TgRPQ+NYk8093uhxxLmAhWoDpppwWGo8FPwNyEGNTAOtYREPpqJWybrGb53K4GMBY
         yD1uunyewvjYwMGdm2ood+onuAdTlBptqcPyQ81RN14DkFHHepAoZq+O0avnsigLyr
         gas8q3xVKNPq8PgHgknQGPQ5ctkIvr4SpqXAP7Sw=
Date:   Sat, 14 Oct 2023 15:16:17 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, raquini@redhat.com,
        djakov@kernel.org, audra@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-fix-the-default-case-for-page_owner_sort.patch added to mm-unstable branch
Message-Id: <20231014221622.EA10AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/mm: fix the default case for page_owner_sort
has been added to the -mm mm-unstable branch.  Its filename is
     tools-mm-fix-the-default-case-for-page_owner_sort.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-fix-the-default-case-for-page_owner_sort.patch

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
Subject: tools/mm: fix the default case for page_owner_sort
Date: Fri, 13 Oct 2023 15:03:48 -0400

With the additional commands and timestamps added to the tool, the default
case (-t) has been broken.  Now that the allocation timestamps are saved
outside of the txt field, allow us to properly sort the data by number of
times the record has been seen.  Furthermore prevent the misuse of the
commandline arguments so only one compare option can be used.

Link: https://lkml.kernel.org/r/20231013190350.579407-5-audra@redhat.com
Signed-off-by: Audra Mitchell <audra@redhat.com>
Cc: Georgi Djakov <djakov@kernel.org>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |   61 ++++++++++++++++++++++++++++++-----
 1 file changed, 53 insertions(+), 8 deletions(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-fix-the-default-case-for-page_owner_sort
+++ a/tools/mm/page_owner_sort.c
@@ -66,6 +66,16 @@ enum SORT_ORDER {
 	SORT_ASC = 1,
 	SORT_DESC = -1,
 };
+enum COMP_FLAG {
+	COMP_NO_FLAG = 0,
+	COMP_ALLOC = 1<<0,
+	COMP_PAGE_NUM = 1<<1,
+	COMP_PID = 1<<2,
+	COMP_STACK = 1<<3,
+	COMP_NUM = 1<<4,
+	COMP_TGID = 1<<5,
+	COMP_COMM = 1<<6
+};
 struct filter_condition {
 	pid_t *pids;
 	pid_t *tgids;
@@ -644,7 +654,7 @@ int main(int argc, char **argv)
 {
 	FILE *fin, *fout;
 	char *buf, *ext_buf;
-	int i, count;
+	int i, count, compare_flag;
 	struct stat st;
 	int opt;
 	struct option longopts[] = {
@@ -656,31 +666,33 @@ int main(int argc, char **argv)
 		{ 0, 0, 0, 0},
 	};
 
+	compare_flag = COMP_NO_FLAG;
+
 	while ((opt = getopt_long(argc, argv, "admnpstP", longopts, NULL)) != -1)
 		switch (opt) {
 		case 'a':
-			set_single_cmp(compare_ts, SORT_ASC);
+			compare_flag |= COMP_ALLOC;
 			break;
 		case 'd':
 			debug_on = true;
 			break;
 		case 'm':
-			set_single_cmp(compare_page_num, SORT_DESC);
+			compare_flag |= COMP_PAGE_NUM;
 			break;
 		case 'p':
-			set_single_cmp(compare_pid, SORT_ASC);
+			compare_flag |= COMP_PID;
 			break;
 		case 's':
-			set_single_cmp(compare_stacktrace, SORT_ASC);
+			compare_flag |= COMP_STACK;
 			break;
 		case 't':
-			set_single_cmp(compare_num, SORT_DESC);
+			compare_flag |= COMP_NUM;
 			break;
 		case 'P':
-			set_single_cmp(compare_tgid, SORT_ASC);
+			compare_flag |= COMP_TGID;
 			break;
 		case 'n':
-			set_single_cmp(compare_comm, SORT_ASC);
+			compare_flag |= COMP_COMM;
 			break;
 		case 1:
 			filter = filter | FILTER_PID;
@@ -727,6 +739,39 @@ int main(int argc, char **argv)
 		usage();
 		exit(1);
 	}
+
+	/* Only one compare option is allowed, yet we also want handle the
+	 * default case were no option is provided, but we still want to
+	 * match the behavior of the -t option (compare by number of times
+	 * a record is seen
+	 */
+	switch (compare_flag) {
+	case COMP_ALLOC:
+		set_single_cmp(compare_ts, SORT_ASC);
+		break;
+	case COMP_PAGE_NUM:
+		set_single_cmp(compare_page_num, SORT_DESC);
+		break;
+	case COMP_PID:
+		set_single_cmp(compare_pid, SORT_ASC);
+		break;
+	case COMP_STACK:
+		set_single_cmp(compare_stacktrace, SORT_ASC);
+		break;
+	case COMP_NO_FLAG:
+	case COMP_NUM:
+		set_single_cmp(compare_num, SORT_DESC);
+		break;
+	case COMP_TGID:
+		set_single_cmp(compare_tgid, SORT_ASC);
+		break;
+	case COMP_COMM:
+		set_single_cmp(compare_comm, SORT_ASC);
+		break;
+	default:
+		usage();
+		exit(1);
+	}
 
 	fin = fopen(argv[optind], "r");
 	fout = fopen(argv[optind + 1], "w");
_

Patches currently in -mm which might be from audra@redhat.com are

mm-page_owner-remove-free_ts-from-page_owner-output.patch
tools-mm-remove-references-to-free_ts-from-page_owner_sort.patch
tools-mm-filter-out-timestamps-for-correct-collation.patch
tools-mm-fix-the-default-case-for-page_owner_sort.patch
tools-mm-update-the-usage-output-to-be-more-organized.patch

