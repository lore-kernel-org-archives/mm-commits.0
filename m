Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476E4C00140
	for <mm-commits@archiver.kernel.org>; Sun, 21 Aug 2022 23:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiHUXct (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 21 Aug 2022 19:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiHUXct (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 21 Aug 2022 19:32:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21257183AB
        for <mm-commits@vger.kernel.org>; Sun, 21 Aug 2022 16:32:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8A85B80E26
        for <mm-commits@vger.kernel.org>; Sun, 21 Aug 2022 23:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C5BC433D6;
        Sun, 21 Aug 2022 23:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661124765;
        bh=rkK1MaEIaVuqXw1812srgwvNJz5MSXBaAtkHV4y2+i4=;
        h=Date:To:From:Subject:From;
        b=XGQg0c+b771SVGmCi1ykNzWkC2VJUm6fK+abD4EuMkRyiH2Vv0yfnGj+p4X6zM8nA
         nAKNQ1KnaLGnIM89UUN0s/IhWaCxlfnPo9X9BN5mash/kMVAh/bk6jLUhaigLKaWgm
         xhQ5F8EqBWZNHvF9gFZg9GNnoneMBZ0DfKfcVeKo=
Date:   Sun, 21 Aug 2022 16:32:44 -0700
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        hughd@google.com, david@redhat.com, apopple@nvidia.com,
        syoshida@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix.patch added to mm-unstable branch
Message-Id: <20220821233245.67C5BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: Fix return value for __gup_longterm_locked()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix.patch

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
From: Shigeru Yoshida <syoshida@redhat.com>
Subject: mm/gup.c: Fix return value for __gup_longterm_locked()
Date: Mon, 22 Aug 2022 03:35:47 +0900

__get_user_pages_locked() may return the number of pages less than
nr_pages.  So __gup_longterm_locked() have to return the number of pages
__get_user_pages_locked() returns if it succeeded, not nr_pages passed.

Link: https://lkml.kernel.org/r/20220821183547.950370-1-syoshida@redhat.com
Fixes: 61c63c2076d9 (mm/gup.c: simplify and fix check_and_migrate_movable_pages() return codes)
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reported-by: syzbot+616ff0452fec30f4dcfd@syzkaller.appspotmail.com
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/gup.c~mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix
+++ a/mm/gup.c
@@ -2068,22 +2068,22 @@ static long __gup_longterm_locked(struct
 				  unsigned int gup_flags)
 {
 	unsigned int flags;
-	long rc;
+	long rc, nr_pinned_pages;
 
 	if (!(gup_flags & FOLL_LONGTERM))
 		return __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
 					       NULL, gup_flags);
 	flags = memalloc_pin_save();
 	do {
-		rc = __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
-					     NULL, gup_flags);
-		if (rc <= 0)
+		nr_pinned_pages = __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
+							  NULL, gup_flags);
+		if (nr_pinned_pages <= 0)
 			break;
-		rc = check_and_migrate_movable_pages(rc, pages, gup_flags);
+		rc = check_and_migrate_movable_pages(nr_pinned_pages, pages, gup_flags);
 	} while (rc == -EAGAIN);
 	memalloc_pin_restore(flags);
 
-	return rc ? rc : nr_pages;
+	return rc ? rc : nr_pinned_pages;
 }
 
 static bool is_valid_gup_flags(unsigned int gup_flags)
_

Patches currently in -mm which might be from syoshida@redhat.com are

mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix.patch

