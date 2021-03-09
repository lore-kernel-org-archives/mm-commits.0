Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E86C433E6
	for <mm-commits@archiver.kernel.org>; Tue,  9 Mar 2021 00:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54EE3652A8
	for <mm-commits@archiver.kernel.org>; Tue,  9 Mar 2021 00:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCIAnt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 19:43:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229582AbhCIAn2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 19:43:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A2096528A;
        Tue,  9 Mar 2021 00:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615250607;
        bh=NwBcKR+QMbc2gL+Tx12bzUDMW07oOhY0t2Q6+RfMUsI=;
        h=Date:From:To:Subject:From;
        b=lyrduBuXWEmyXAcQSe/PifQ56lcK/DVmAOABLsUoV1D8buuBWAzp+KlfLFFXChrpk
         G2SrfO+TSaV3goVSiSyAqykzedi2AJC/OM2lpMqoo6/ZH68k/lALd/H5waybzNAh+Y
         xqrHvOLp/8dZKf8clhz9AG9e2rJ5vphM6XQiU0gg=
Date:   Mon, 08 Mar 2021 16:43:26 -0800
From:   akpm@linux-foundation.org
To:     georgi.djakov@linaro.org, mm-commits@vger.kernel.org,
        vbabka@suse.cz
Subject:  +
 mm-page_owner-record-the-timestamp-of-all-pages-during-free.patch added to
 -mm tree
Message-ID: <20210309004326.M_rrImRZI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: record the timestamp of all pages during free
has been added to the -mm tree.  Its filename is
     mm-page_owner-record-the-timestamp-of-all-pages-during-free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-record-the-timestamp-of-all-pages-during-free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-record-the-timestamp-of-all-pages-during-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Georgi Djakov <georgi.djakov@linaro.org>
Subject: mm/page_owner: record the timestamp of all pages during free

Collect the time when each allocation is freed, to help with memory
analysis with kdump/ramdump.  Add the timestamp also in the page_owner
debugfs file and print it in dump_page().

Having another timestamp when we free the page helps for debugging page
migration issues.  For example both alloc and free timestamps being the
same can gave hints that there is an issue with migrating memory, as
opposed to a page just being dropped during migration.

Link: https://lkml.kernel.org/r/20210203175905.12267-1-georgi.djakov@linaro.org
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    2 +-
 mm/page_owner.c                 |   12 ++++++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

--- a/Documentation/vm/page_owner.rst~mm-page_owner-record-the-timestamp-of-all-pages-during-free
+++ a/Documentation/vm/page_owner.rst
@@ -47,7 +47,7 @@ size change due to this facility.
 
    text    data     bss     dec     hex filename
    48800   2445     644   51889    cab1 mm/page_alloc.o
-   6574     108      29    6711    1a37 mm/page_owner.o
+   6662     108      29    6799    1a8f mm/page_owner.o
    1025       8       8    1041     411 mm/page_ext.o
 
 Although, roughly, 8 KB code is added in total, page_alloc.o increase by
--- a/mm/page_owner.c~mm-page_owner-record-the-timestamp-of-all-pages-during-free
+++ a/mm/page_owner.c
@@ -27,6 +27,7 @@ struct page_owner {
 	depot_stack_handle_t handle;
 	depot_stack_handle_t free_handle;
 	u64 ts_nsec;
+	u64 free_ts_nsec;
 	pid_t pid;
 };
 
@@ -148,6 +149,7 @@ void __reset_page_owner(struct page *pag
 	struct page_ext *page_ext;
 	depot_stack_handle_t handle = 0;
 	struct page_owner *page_owner;
+	u64 free_ts_nsec = local_clock();
 
 	handle = save_stack(GFP_NOWAIT | __GFP_NOWARN);
 
@@ -158,6 +160,7 @@ void __reset_page_owner(struct page *pag
 		__clear_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
 		page_owner = get_page_owner(page_ext);
 		page_owner->free_handle = handle;
+		page_owner->free_ts_nsec = free_ts_nsec;
 		page_ext = page_ext_next(page_ext);
 	}
 }
@@ -243,6 +246,7 @@ void __copy_page_owner(struct page *oldp
 	new_page_owner->handle = old_page_owner->handle;
 	new_page_owner->pid = old_page_owner->pid;
 	new_page_owner->ts_nsec = old_page_owner->ts_nsec;
+	new_page_owner->free_ts_nsec = old_page_owner->ts_nsec;
 
 	/*
 	 * We don't clear the bit on the oldpage as it's going to be freed
@@ -356,10 +360,10 @@ print_page_owner(char __user *buf, size_
 		return -ENOMEM;
 
 	ret = snprintf(kbuf, count,
-			"Page allocated via order %u, mask %#x(%pGg), pid %d, ts %llu ns\n",
+			"Page allocated via order %u, mask %#x(%pGg), pid %d, ts %llu ns, free_ts %llu ns\n",
 			page_owner->order, page_owner->gfp_mask,
 			&page_owner->gfp_mask, page_owner->pid,
-			page_owner->ts_nsec);
+			page_owner->ts_nsec, page_owner->free_ts_nsec);
 
 	if (ret >= count)
 		goto err;
@@ -435,9 +439,9 @@ void __dump_page_owner(struct page *page
 	else
 		pr_alert("page_owner tracks the page as freed\n");
 
-	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, ts %llu\n",
+	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, ts %llu, free_ts %llu\n",
 		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
-		 page_owner->pid, page_owner->ts_nsec);
+		 page_owner->pid, page_owner->ts_nsec, page_owner->free_ts_nsec);
 
 	handle = READ_ONCE(page_owner->handle);
 	if (!handle) {
_

Patches currently in -mm which might be from georgi.djakov@linaro.org are

mm-page_owner-record-the-timestamp-of-all-pages-during-free.patch

