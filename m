Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72641C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 17:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344731AbiFCRrn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 13:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345305AbiFCRr0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 13:47:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F7756F9E
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 10:44:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 563FBB82435
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 17:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEC4C385A9;
        Fri,  3 Jun 2022 17:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654278246;
        bh=2zk7nC9EQThnXEkiPIbWukaDIV4DLXn8247Ef1Kh1Hw=;
        h=Date:To:From:Subject:From;
        b=U6l7eWnjpBdp15aD2mAW9MMa+Uhn4MqUK4R6DC3kdbU7ywVViBo5db6wDupfj+1tG
         67u8eBm1W5g6oclrTujzZoHLlPR7mWjMGD8as+wcbuEX2I8kiaUklbxk9bMkhLxC49
         rc6FzWUpND9VDCo4zlKoMHdlpF8S10RnQyak6mlQ=
Date:   Fri, 03 Jun 2022 10:44:05 -0700
To:     mm-commits@vger.kernel.org, matenajakub@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-merging-after-mremap-resize-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20220603174406.0AEC4C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-merging-after-mremap-resize-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-merging-after-mremap-resize-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-merging-after-mremap-resize-checkpatch-fixes.patch

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

mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-remove-the-vma-linked-list-fix-fix.patch
mm-remove-the-vma-linked-list-fix-fix-fix.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-introduce-clear_highpage_tagged-fix.patch
kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
squashfs-implement-readahead-checkpatch-fixes.patch

