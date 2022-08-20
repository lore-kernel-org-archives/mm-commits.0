Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C8EC25B08
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 21:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiHTVnG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Aug 2022 17:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiHTVnG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Aug 2022 17:43:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE2D27FED
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 14:43:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9612F609D0
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 21:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB56C433C1;
        Sat, 20 Aug 2022 21:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661031784;
        bh=7em3WfDIZgC+EYmfcywndBBPMRuPcgxMJz35liEWWzo=;
        h=Date:To:From:Subject:From;
        b=Tkn4RVipnNhNxon8dcd11YISnHSdPIV5vGr2YWJEJKi6hBS1EDRbv+mQxfgCM2mwP
         rxm7d3DzkfCv2SsVe+eVY7xKfj7sgHn7/T+dhdXrgN4XRZPHz/aJ8kHR0hqPOX7zxh
         RgKUfY44uZdJTXMcBbSK7uAqYuxA9hwJ5kiFWNR0=
Date:   Sat, 20 Aug 2022 14:43:03 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, minchan@kernel.org,
        iamjoonsoo.kim@lge.com, quic_yingangl@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ownerc-add-llseek-for-page_owner.patch added to mm-unstable branch
Message-Id: <20220820214303.DEB56C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner.c: add llseek for page_owner
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_ownerc-add-llseek-for-page_owner.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ownerc-add-llseek-for-page_owner.patch

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
 			goto loop;
 
 		/* Record the next PFN to read in the file offset */
-		*ppos = (pfn - min_low_pfn) + 1;
+		*ppos = pfn + 1;
 
 		page_owner_tmp = *page_owner;
 		page_ext_put(page_ext);
@@ -601,6 +603,21 @@ loop:
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

mm-page_ownerc-add-llseek-for-page_owner.patch

