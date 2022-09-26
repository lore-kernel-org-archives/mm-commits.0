Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19550C07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 21:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiIZVFA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 17:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiIZVE7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 17:04:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4943B1D5
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 14:04:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9636FB8112D
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 21:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DA0C433D6;
        Mon, 26 Sep 2022 21:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664226295;
        bh=DAChJHyt8RAP75H3RUvD9tYBJdQiW1hs/2lXqcXIFzA=;
        h=Date:To:From:Subject:From;
        b=sAiBEWRwJDLTF1siW9/GgeJ5qChUDjRPEb+9DjoQZii33qbCp15r3arGeG3Vmsx3n
         GypggARtMPVKiGGcIEtMy+IeXv1amVs68rKly2Is7htNwDT7MiV67e+vl8csbfMj7a
         UsxHMlbDFEiQf7IA3Hna334x5n5c1hWnlYT+ps8A=
Date:   Mon, 26 Sep 2022 14:04:54 -0700
To:     mm-commits@vger.kernel.org, matenajakub@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-merging-after-mremap-resize-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20220926210455.34DA0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-add-merging-after-mremap-resize-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-add-merging-after-mremap-resize-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-add-merging-after-mremap-resize.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-merging-after-mremap-resize-checkpatch-fixes
Date: Fri Jun  3 10:41:30 AM PDT 2022

WARNING: line length of 108 exceeds 100 columns
#97: FILE: tools/testing/selftests/vm/mremap_test.c:136:
+	char *start = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

WARNING: Missing a blank line after declarations
#98: FILE: tools/testing/selftests/vm/mremap_test.c:137:
+	char *start = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	munmap(start + page_size, page_size);

ERROR: space required before the open parenthesis '('
#107: FILE: tools/testing/selftests/vm/mremap_test.c:146:
+	while(getline(&line, &len, fp) != -1) {

ERROR: space required after that ',' (ctx:VxV)
#108: FILE: tools/testing/selftests/vm/mremap_test.c:147:
+		char *first = strtok(line,"- ");
 		                         ^

ERROR: space required after that ',' (ctx:VxV)
#110: FILE: tools/testing/selftests/vm/mremap_test.c:149:
+		char *second = strtok(NULL,"- ");
 		                          ^

WARNING: Missing a blank line after declarations
#112: FILE: tools/testing/selftests/vm/mremap_test.c:151:
+		void *second_val = (void *) strtol(second, NULL, 16);
+		if (first_val == start && second_val == start + 3 * page_size) {

total: 3 errors, 3 warnings, 113 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-add-merging-after-mremap-resize.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jakub Matěna <matenajakub@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mremap_test.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/vm/mremap_test.c~mm-add-merging-after-mremap-resize-checkpatch-fixes
+++ a/tools/testing/selftests/vm/mremap_test.c
@@ -132,8 +132,9 @@ static void mremap_expand_merge(unsigned
 	char *line = NULL;
 	size_t len = 0;
 	bool success = false;
+	char *start = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
-	char *start = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	munmap(start + page_size, page_size);
 	mremap(start, page_size, 2 * page_size, 0);
 
@@ -143,11 +144,12 @@ static void mremap_expand_merge(unsigned
 		return;
 	}
 
-	while(getline(&line, &len, fp) != -1) {
-		char *first = strtok(line,"- ");
-		void *first_val = (void *) strtol(first, NULL, 16);
-		char *second = strtok(NULL,"- ");
+	while (getline(&line, &len, fp) != -1) {
+		char *first = strtok(line, "- ");
+		void *first_val = (void *)strtol(first, NULL, 16);
+		char *second = strtok(NULL, "- ");
 		void *second_val = (void *) strtol(second, NULL, 16);
+
 		if (first_val == start && second_val == start + 3 * page_size) {
 			success = true;
 			break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-merging-after-mremap-resize.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix.patch
mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch
fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

