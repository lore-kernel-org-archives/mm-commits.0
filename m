Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 211AEC433DB
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 00:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D270722D75
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 00:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbhAGA0J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jan 2021 19:26:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:55804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbhAGA0J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Jan 2021 19:26:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1E2822D75;
        Thu,  7 Jan 2021 00:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609979128;
        bh=1QyADNiec2IWzjb+It9E1Oa5ukNeHTzl65yekaNMs+U=;
        h=Date:From:To:Subject:From;
        b=LqBpFqLAO8pAK2XMUoV1VqerOmUrhhmqG8YP3iQUXC3ywz+Slyi2sPTPK5/1j2d0o
         1VRGg5tmnmf7BBjRRra+jzp6n0+4NQK59pRv5VeXfAnaxBl/0hDBT8zQLV8amyUL8m
         GLAH/jEetq+I2osRM8Awn777EwF6a6hYWJMhvUa4=
Date:   Wed, 06 Jan 2021 16:25:27 -0800
From:   akpm@linux-foundation.org
To:     jack@suse.cz, jstancek@redhat.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, shy828301@gmail.com,
        songliubraving@fb.com, willy@infradead.org, ziy@nvidia.com
Subject:  + mm-migrate-initialize-err-in-do_migrate_pages.patch
 added to -mm tree
Message-ID: <20210107002527.i0i5aOj6u%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: initialize err in do_migrate_pages
has been added to the -mm tree.  Its filename is
     mm-migrate-initialize-err-in-do_migrate_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-initialize-err-in-do_migrate_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-initialize-err-in-do_migrate_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from jstancek@redhat.com are

mm-migrate-initialize-err-in-do_migrate_pages.patch

