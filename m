Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9309CC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Dec 2021 04:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbhLHEdV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Dec 2021 23:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbhLHEdV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2021 23:33:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AEEC061574
        for <mm-commits@vger.kernel.org>; Tue,  7 Dec 2021 20:29:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42C28B81113
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 04:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9844C341C3;
        Wed,  8 Dec 2021 04:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638937788;
        bh=d35gdTsceasoWYGYtRZ9J7H/dbmyXH3M7jm/h26UWDE=;
        h=Date:From:To:Subject:From;
        b=gmXGCSPZe7eogrQRPSN3TD99BDyf69PQ3t/PsfmHFZwsHEC6sPtP2xN2ra4i68OMJ
         h1VFc8Rfw7fQfQQfGp+/BYw2ekH5DftJol8iTltujJfCpmNdd/fLe5e3R29TSrCDET
         lASdOXlmB5YUSreCOavjWssmpcbxe2xNyQKtTa+Q=
Date:   Tue, 07 Dec 2021 20:29:47 -0800
From:   akpm@linux-foundation.org
To:     chi.minghao@zte.com.cn, david@redhat.com,
        mm-commits@vger.kernel.org, zealci@zte.com.cm
Subject:  + mm-remove-unneeded-variable.patch added to -mm tree
Message-ID: <20211208042947.jUoNtLXej%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/truncate.c: remove unneeded variable
has been added to the -mm tree.  Its filename is
     mm-remove-unneeded-variable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unneeded-variable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unneeded-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: chiminghao <chi.minghao@zte.com.cn>
Subject: mm/truncate.c: remove unneeded variable

Return value directly instead of taking this in another redundant
variable.

Link: https://lkml.kernel.org/r/20211207083222.401594-1-chi.minghao@zte.com.cn
Signed-off-by: chiminghao <chi.minghao@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cm>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/truncate.c~mm-remove-unneeded-variable
+++ a/mm/truncate.c
@@ -205,7 +205,6 @@ static void truncate_cleanup_page(struct
 static int
 invalidate_complete_page(struct address_space *mapping, struct page *page)
 {
-	int ret;
 
 	if (page->mapping != mapping)
 		return 0;
@@ -213,9 +212,7 @@ invalidate_complete_page(struct address_
 	if (page_has_private(page) && !try_to_release_page(page, 0))
 		return 0;
 
-	ret = remove_mapping(mapping, page);
-
-	return ret;
+	return remove_mapping(mapping, page);
 }
 
 int truncate_inode_page(struct address_space *mapping, struct page *page)
_

Patches currently in -mm which might be from chi.minghao@zte.com.cn are

mm-remove-unneeded-variable.patch
selftests-vm-use-swap-to-make-code-cleaner.patch

