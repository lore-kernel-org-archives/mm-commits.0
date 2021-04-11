Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18225C433ED
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D975660FD8
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbhDKWnh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Apr 2021 18:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235417AbhDKWng (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Apr 2021 18:43:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98F6A608FC;
        Sun, 11 Apr 2021 22:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618180999;
        bh=pHXhzTwQnW/nPih6iOd6t4FXR8+MgWjjGOZeSSpDHlg=;
        h=Date:From:To:Subject:From;
        b=wRVCY52jkACIx+RDZso8/I2UMlTrrey41S/xTfNf02wuLnOFUECdeR4dTeewFYjRE
         xN8RXsxn+ikPmasypMBRUESf5VlmJYbDhLsOYTQWwhWzB1llvJXHAh2Yq/Cms7x3Y9
         cUs0MHZNR/0FGG+un9SbWoNlxDR2tHwd9WPVn57U=
Date:   Sun, 11 Apr 2021 15:43:19 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zhangshaokun@hisilicon.com,
        willy@infradead.org, sunrui26@huawei.com
Subject:  + mm-filemap-update-stale-comment.patch added to -mm tree
Message-ID: <20210411224319.jt1Qq%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: Update stale comment
has been added to the -mm tree.  Its filename is
     mm-filemap-update-stale-comment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-update-stale-comment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-update-stale-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rui Sun <sunrui26@huawei.com>
Subject: mm/filemap: Update stale comment

Commit a6de4b4873e1 ("mm: convert find_get_entry to return the head page")
uses @index instead of @offset, but the comment is stale, update it.

Link: https://lkml.kernel.org/r/1617948260-50724-1-git-send-email-zhangshaokun@hisilicon.com
Signed-off-by: Rui Sun <sunrui26@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-update-stale-comment
+++ a/mm/filemap.c
@@ -1690,7 +1690,7 @@ EXPORT_SYMBOL(page_cache_prev_miss);
  * @mapping: the address_space to search
  * @index: The page cache index.
  *
- * Looks up the page cache slot at @mapping & @offset.  If there is a
+ * Looks up the page cache slot at @mapping & @index.  If there is a
  * page cache page, the head page is returned with an increased refcount.
  *
  * If the slot holds a shadow entry of a previously evicted page, or a
_

Patches currently in -mm which might be from sunrui26@huawei.com are

mm-filemap-update-stale-comment.patch

