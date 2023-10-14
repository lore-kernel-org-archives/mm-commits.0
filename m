Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BACFCDB465
	for <mm-commits@archiver.kernel.org>; Sat, 14 Oct 2023 22:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbjJNWQV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Oct 2023 18:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbjJNWQS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Oct 2023 18:16:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32740D6
        for <mm-commits@vger.kernel.org>; Sat, 14 Oct 2023 15:16:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625C0C433C8;
        Sat, 14 Oct 2023 22:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697321776;
        bh=y2RLE7pXaJEY/a58qfGl3hzLtPUnZwmCHCMRMb1o2hY=;
        h=Date:To:From:Subject:From;
        b=dwPAsLYGThjD+GDjdIqFMZPoVl1rxpvvzHzM4pwYNh0dh+KK52PsCc44hhCgahAPE
         1DxnMvlsSIys/cE93B38mW0T1Fn/2uiGYm2U1quTvqqB1mGrpBEu613TPGX7WlmYT+
         Pd4uZyksC12KnjVoHkuQQ28ZZBwY8l/s0kAMqeuA=
Date:   Sat, 14 Oct 2023 15:16:14 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, raquini@redhat.com,
        djakov@kernel.org, audra@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-filter-out-timestamps-for-correct-collation.patch added to mm-unstable branch
Message-Id: <20231014221616.625C0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/mm: filter out timestamps for correct collation
has been added to the -mm mm-unstable branch.  Its filename is
     tools-mm-filter-out-timestamps-for-correct-collation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-filter-out-timestamps-for-correct-collation.patch

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
Subject: tools/mm: filter out timestamps for correct collation
Date: Fri, 13 Oct 2023 15:03:47 -0400

With the introduction of allocation timestamps being included in
page_owner output, each record becomes unique due to the timestamp
nanosecond granularity.  Remove the check in add_list that tries to
collate each record during processing as the memcmp() is just additional
overhead at this point.

Also keep the allocation timestamps, but allow collation to occur without
consideration of the allocation timestamp except in the case were
allocation timestamps are requested by the user (the -a option).

Link: https://lkml.kernel.org/r/20231013190350.579407-4-audra@redhat.com
Signed-off-by: Audra Mitchell <audra@redhat.com>
Cc: Georgi Djakov <djakov@kernel.org>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-filter-out-timestamps-for-correct-collation
+++ a/tools/mm/page_owner_sort.c
@@ -203,6 +203,21 @@ static int compare_sort_condition(const
 	return cmp;
 }
 
+static int remove_pattern(regex_t *pattern, char *buf, int len)
+{
+	regmatch_t pmatch[2];
+	int err;
+
+	err = regexec(pattern, buf, 2, pmatch, REG_NOTBOL);
+	if (err != 0 || pmatch[1].rm_so == -1)
+		return len;
+
+	memcpy(buf + pmatch[1].rm_so,
+		buf + pmatch[1].rm_eo, len - pmatch[1].rm_eo);
+
+	return len - (pmatch[1].rm_eo - pmatch[1].rm_so);
+}
+
 static int search_pattern(regex_t *pattern, char *pattern_str, char *buf)
 {
 	int err, val_len;
@@ -443,13 +458,6 @@ static bool is_need(char *buf)
 
 static bool add_list(char *buf, int len, char *ext_buf)
 {
-	if (list_size != 0 &&
-		len == list[list_size-1].len &&
-		memcmp(buf, list[list_size-1].txt, len) == 0) {
-		list[list_size-1].num++;
-		list[list_size-1].page_num += get_page_num(buf);
-		return true;
-	}
 	if (list_size == max_size) {
 		fprintf(stderr, "max_size too small??\n");
 		return false;
@@ -465,6 +473,9 @@ static bool add_list(char *buf, int len,
 		return false;
 	}
 	memcpy(list[list_size].txt, buf, len);
+	if (sc.cmps[0] != compare_ts) {
+		len = remove_pattern(&ts_nsec_pattern, list[list_size].txt, len);
+	}
 	list[list_size].txt[len] = 0;
 	list[list_size].len = len;
 	list[list_size].num = 1;
_

Patches currently in -mm which might be from audra@redhat.com are

mm-page_owner-remove-free_ts-from-page_owner-output.patch
tools-mm-remove-references-to-free_ts-from-page_owner_sort.patch
tools-mm-filter-out-timestamps-for-correct-collation.patch
tools-mm-fix-the-default-case-for-page_owner_sort.patch
tools-mm-update-the-usage-output-to-be-more-organized.patch

