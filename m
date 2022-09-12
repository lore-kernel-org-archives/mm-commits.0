Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A8A1ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiILDc6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiILDa4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:30:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD50D10571
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41A286119D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA70C433B5;
        Mon, 12 Sep 2022 03:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953379;
        bh=Q7m4W/AGlwftJdNS1y8OHYVABLDLNd8gycQdW2B2+DI=;
        h=Date:To:From:Subject:From;
        b=ia0pjtxkd39Y5qatrLhGcChuzigp/SmF7E/q+TqM3W9QXJ0ReJsOtIAy+dWU49EC9
         5JtXeW3dDGc2upYi/VQxh1PaAlc+gYzreAN7Thwan8lPvdyO5eSWGN2/yEFiUWayX9
         6+yvKMV91sx1oz1D5GZKUIhZQt94OKTEQFBWGows=
Date:   Sun, 11 Sep 2022 20:29:38 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, minchan@kernel.org,
        iamjoonsoo.kim@lge.com, quic_yingangl@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_ownerc-add-llseek-for-page_owner.patch removed from -mm tree
Message-Id: <20220912032939.9BA70C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_owner.c: add llseek for page_owner
has been removed from the -mm tree.  Its filename was
     mm-page_ownerc-add-llseek-for-page_owner.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kassey Li <quic_yingangl@quicinc.com>
Subject: mm/page_owner.c: add llseek for page_owner
Date: Thu, 18 Aug 2022 10:24:25 +0800

It is too slow to dump all the pages, in some usage we just want to dump a
given start pfn, for example: a CMA range or a single page.

To speed up and save time, this change allows specifying of a start pfn by
adding llseek for page_owner.

Link: https://lkml.kernel.org/r/20220818022425.31056-1-quic_yingangl@quicinc.com
Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/page_owner.rst |    5 +++++
 mm/page_owner.c                 |   24 +++++++++++++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

--- a/Documentation/mm/page_owner.rst~mm-page_ownerc-add-llseek-for-page_owner
+++ a/Documentation/mm/page_owner.rst
@@ -94,6 +94,11 @@ Usage
 	Page allocated via order XXX, ...
 	PFN XXX ...
 	// Detailed stack
+    By default, it will do full pfn dump, to start with a given pfn,
+    page_owner supports fseek.
+
+    FILE *fp = fopen("/sys/kernel/debug/page_owner", "r");
+    fseek(fp, pfn_start, SEEK_SET);
 
    The ``page_owner_sort`` tool ignores ``PFN`` rows, puts the remaining rows
    in buf, uses regexp to extract the page order value, counts the times
--- a/mm/page_owner.c~mm-page_ownerc-add-llseek-for-page_owner
+++ a/mm/page_owner.c
@@ -516,8 +516,10 @@ read_page_owner(struct file *file, char
 		return -EINVAL;
 
 	page = NULL;
-	pfn = min_low_pfn + *ppos;
-
+	if (*ppos == 0)
+		pfn = min_low_pfn;
+	else
+		pfn = *ppos;
 	/* Find a valid PFN or the start of a MAX_ORDER_NR_PAGES area */
 	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
 		pfn++;
@@ -588,7 +590,7 @@ read_page_owner(struct file *file, char
 			goto ext_put_continue;
 
 		/* Record the next PFN to read in the file offset */
-		*ppos = (pfn - min_low_pfn) + 1;
+		*ppos = pfn + 1;
 
 		page_owner_tmp = *page_owner;
 		page_ext_put(page_ext);
@@ -601,6 +603,21 @@ ext_put_continue:
 	return 0;
 }
 
+static loff_t lseek_page_owner(struct file *file, loff_t offset, int orig)
+{
+	switch (orig) {
+	case SEEK_SET:
+		file->f_pos = offset;
+		break;
+	case SEEK_CUR:
+		file->f_pos += offset;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return file->f_pos;
+}
+
 static void init_pages_in_zone(pg_data_t *pgdat, struct zone *zone)
 {
 	unsigned long pfn = zone->zone_start_pfn;
@@ -693,6 +710,7 @@ static void init_early_allocated_pages(v
 
 static const struct file_operations proc_page_owner_operations = {
 	.read		= read_page_owner,
+	.llseek		= lseek_page_owner,
 };
 
 static int __init pageowner_init(void)
_

Patches currently in -mm which might be from quic_yingangl@quicinc.com are


