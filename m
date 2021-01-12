Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3247C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jan 2021 00:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A07222312E
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jan 2021 00:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388839AbhAMAms (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 19:42:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391950AbhALXuC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Jan 2021 18:50:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EF8023138;
        Tue, 12 Jan 2021 23:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610495362;
        bh=RDcIaqC9EWRiTftuo/Tl8jcOF/9zYknnO+03Bno0x6k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1uxqsSYK14GsNc3bX09iPRCjufcccpG+YCV/kEQZNVQtqumA6rvz45/il3XQMk9S+
         tbQSBJhIedltUXaElDzQQFsZhAXd8BUpidvdzS6TbqkH/9BquhNaOVHMzJP1btxbML
         siW2IqHgjKrMxnoHgwWg3jGgskgRbVG+I9sIy+ns=
Date:   Tue, 12 Jan 2021 15:49:21 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jack@suse.cz, jstancek@redhat.com,
        linux-mm@kvack.org, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        songliubraving@fb.com, torvalds@linux-foundation.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 06/10] mm: migrate: initialize err in
 do_migrate_pages
Message-ID: <20210112234921.ydOmosyOp%akpm@linux-foundation.org>
In-Reply-To: <20210112154839.abeb6e57de79480059fd9b0e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jan Stancek <jstancek@redhat.com>
Subject: mm: migrate: initialize err in do_migrate_pages

After commit 236c32eb1096 ("mm: migrate: clean up migrate_prep{_local}")',
do_migrate_pages can return uninitialized variable 'err' (which is
propagated to user-space as error) when 'from' and 'to' nodesets are
identical.  This can be reproduced with LTP migrate_pages01, which calls
migrate_pages() with same set for both old/new_nodes.

Add 'err' initialization back.

Link: https://lkml.kernel.org/r/456a021c7ef3636d7668cec9dcb4a446a4244812.1609855564.git.jstancek@redhat.com
Fixes: 236c32eb1096 ("mm: migrate: clean up migrate_prep{_local}")
Signed-off-by: Jan Stancek <jstancek@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-migrate-initialize-err-in-do_migrate_pages
+++ a/mm/mempolicy.c
@@ -1111,7 +1111,7 @@ int do_migrate_pages(struct mm_struct *m
 		     const nodemask_t *to, int flags)
 {
 	int busy = 0;
-	int err;
+	int err = 0;
 	nodemask_t tmp;
 
 	migrate_prep();
_
