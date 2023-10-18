Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E88CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbjJRVhn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235247AbjJRVg5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A651128
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:36:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99FEC433C7;
        Wed, 18 Oct 2023 21:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664969;
        bh=lZ6Y+8xJiqEi41VeF4hnEJ+DV9qV24Qt5fQUMID44dc=;
        h=Date:To:From:Subject:From;
        b=ZOqvgrUwgiXqMyFBYFuqhKpn/m8LTDlBtaBXkBnDXzmApsTszy6mpdv+ttt87cfJD
         8gTVb45WaQbcKB2zRGboXOAyTHK1XyB7RaK0NHPvs0LWHJGgKOap3B4URZDpAQZmY6
         Sk84WjXNdKzaQ2vgT+V5BvlFCN2rP+xDMHJq4E4w=
Date:   Wed, 18 Oct 2023 14:36:09 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, djakov@kernel.org,
        aquini@redhat.com, audra@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-filter-out-timestamps-for-correct-collation.patch removed from -mm tree
Message-Id: <20231018213609.C99FEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/mm: filter out timestamps for correct collation
has been removed from the -mm tree.  Its filename was
     tools-mm-filter-out-timestamps-for-correct-collation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Georgi Djakov <djakov@kernel.org>
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


