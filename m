Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45086C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15F8760FD9
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhEHWce (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:32:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhEHWcd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:32:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54ADB61402;
        Sat,  8 May 2021 22:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513091;
        bh=pQt0+1b/BnT9Qw0aunb5x+SmX72/FsbqX/eM2rlf1mI=;
        h=Date:From:To:Subject:From;
        b=p6nKAJDTJXcFz/EA7y2CkA9REWyW6VtyW/prY6sOeoNKNcIQMOR3z6xxr+Y0+cLAj
         oQ9jYChNmp3W94f0yeW1X025sww5Qk/GGMN7SNIOJPxHLxvPsfUeTD7J9LBDjmxTJT
         VgUN5WFtxo7oocYsmWzoWRMspJVbCF7J+sLULtao=
Date:   Sat, 08 May 2021 15:31:30 -0700
From:   akpm@linux-foundation.org
To:     huxiang@uniontech.com, mm-commits@vger.kernel.org
Subject:  [to-be-updated]
 mm-page_alloc-redundant-definition-variables-of-pfn-in-for-loop.patch
 removed from -mm tree
Message-ID: <20210508223130.48Apw8nAA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: redundant definition variables of pfn in for loop
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-redundant-definition-variables-of-pfn-in-for-loop.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: huxiang <huxiang@uniontech.com>
Subject: mm/page_alloc: redundant definition variables of pfn in for loop

This variable pfn is defined repeatedly, so it can be deleted.

Link: https://lkml.kernel.org/r/20210401022802.10358-1-huxiang@uniontech.com
Signed-off-by: huxiang <huxiang@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-redundant-definition-variables-of-pfn-in-for-loop
+++ a/mm/page_alloc.c
@@ -3322,7 +3322,7 @@ void free_unref_page_list(struct list_he
 
 	local_irq_save(flags);
 	list_for_each_entry_safe(page, next, list, lru) {
-		unsigned long pfn = page_private(page);
+		pfn = page_private(page);
 
 		set_page_private(page, 0);
 		trace_mm_page_free_batched(page);
_

Patches currently in -mm which might be from huxiang@uniontech.com are


