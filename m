Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FFAECAAD3
	for <mm-commits@archiver.kernel.org>; Wed,  7 Sep 2022 23:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiIGXeP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Sep 2022 19:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiIGXeO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2022 19:34:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3A1C3F62
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 16:34:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1F3361B0A
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 23:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BC6C433D6;
        Wed,  7 Sep 2022 23:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662593652;
        bh=7XbGlaJIYO6HsFG1m1txXQBliXbtPNb8LGVf9BjZcps=;
        h=Date:To:From:Subject:From;
        b=Q4/+2rUsnyjJi1UCP4+fd8RIJafSe8hf7wYvKZed/5Vck7iDky8NiGCrjBkxFwEHC
         1TcQOA9zlq2yFdkTdNBHUNyg6U91KpYGgJFtwJEK9QeRzjWM0kHys0G3SCkMt1K22c
         H/KgSTZblDjNQz+OluXQu2Tar8zNEa9oPGJobZOM=
Date:   Wed, 07 Sep 2022 16:34:11 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, david@redhat.com, apopple@nvidia.com,
        chenwandun@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-avoid-unnecessary-page-table-walk-for-__get_user_pages.patch added to mm-unstable branch
Message-Id: <20220907233412.27BC6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: avoid unnecessary page table walk for __get_user_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-avoid-unnecessary-page-table-walk-for-__get_user_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-avoid-unnecessary-page-table-walk-for-__get_user_pages.patch

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
From: Chen Wandun <chenwandun@huawei.com>
Subject: mm: avoid unnecessary page table walk for __get_user_pages
Date: Tue, 6 Sep 2022 10:44:01 +0800

There is no need to walk page tables and find pages if faultin_page)_
succeeds and __get_user_pages)_ doesn't care about populating the pages[]
array.  So directly go on to handle the next page.

Link: https://lkml.kernel.org/r/20220906024401.133336-1-chenwandun@huawei.com
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-avoid-unnecessary-page-table-walk-for-__get_user_pages
+++ a/mm/gup.c
@@ -1175,7 +1175,10 @@ retry:
 					   PTR_ERR(page) == -EMLINK, locked);
 			switch (ret) {
 			case 0:
-				goto retry;
+				if (pages)
+					goto retry;
+				else
+					goto next_page;
 			case -EBUSY:
 			case -EAGAIN:
 				ret = 0;
_

Patches currently in -mm which might be from chenwandun@huawei.com are

mm-avoid-unnecessary-page-table-walk-for-__get_user_pages.patch

