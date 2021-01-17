Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE03DC433E6
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 02:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 884A022C97
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 02:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbhAQCMG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Jan 2021 21:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbhAQCMF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 16 Jan 2021 21:12:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CAE922C97;
        Sun, 17 Jan 2021 02:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610849456;
        bh=/6kq6W+8+EJcV97FGit5krZM9phjq/jPDWsWv+NpqeA=;
        h=Date:From:To:Subject:From;
        b=BBZRaKZ59iDzN1tU1c7ofVGSJORKnRIFVLdUFHI0kad0gPQpsbyXLJlk6RIZusXJN
         ibFA8qdBCfeWLPWZ+L0C5mYUsCC3ub7qQgfQezhl1EDEDUoReYABYQct+hCUQBh04v
         LD4JB8bibg7fKSVIsL5B98wgzcpC3azaXMiWaP6w=
Date:   Sat, 16 Jan 2021 18:10:56 -0800
From:   akpm@linux-foundation.org
To:     jack@suse.cz, jstancek@redhat.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, shy828301@gmail.com,
        songliubraving@fb.com, willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-migrate-initialize-err-in-do_migrate_pages.patch removed from -mm tree
Message-ID: <20210117021056.eXUu19N0g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: initialize err in do_migrate_pages
has been removed from the -mm tree.  Its filename was
     mm-migrate-initialize-err-in-do_migrate_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


