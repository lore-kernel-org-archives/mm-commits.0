Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E71ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 00:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiILAhS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 20:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiILAhR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 20:37:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC27D2558B
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 17:37:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67C8F61147
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 00:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CC0C433D6;
        Mon, 12 Sep 2022 00:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662943035;
        bh=zZXiFCSuL8e4ZzoguOmjgMEl51dOy2bdjJ7gJBMHoaY=;
        h=Date:To:From:Subject:From;
        b=jgIQJX8mVfLL+9rQOmehRwTJOs6sJYW8pScAFCJHW4uyp+mcQS69Qpv+TI3L6X2ub
         gMLKsiJd10TmfDz9MaTd71VU1443AKqTdn5/kWcgzMSOLSLOB0smwVrpEi1IEasbHP
         J6YnwRLituZwDxqAskp68H+jeWPu6OCWhsSc7YPI=
Date:   Sun, 11 Sep 2022 17:37:15 -0700
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        hughd@google.com, david@redhat.com, apopple@nvidia.com,
        syoshida@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix.patch removed from -mm tree
Message-Id: <20220912003715.B7CC0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup.c: Fix return value for __gup_longterm_locked()
has been removed from the -mm tree.  Its filename was
     mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix.patch

This patch was dropped because it was folded into mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch

------------------------------------------------------
From: Shigeru Yoshida <syoshida@redhat.com>
Subject: mm/gup.c: Fix return value for __gup_longterm_locked()
Date: Mon, 22 Aug 2022 03:35:47 +0900

__get_user_pages_locked() may return the number of pages less than
nr_pages.  So __gup_longterm_locked() have to return the number of pages
__get_user_pages_locked() returns if it succeeded, not nr_pages requested.

Link: https://lkml.kernel.org/r/20220821183547.950370-1-syoshida@redhat.com
Fixes: 61c63c2076d9 (mm/gup.c: simplify and fix check_and_migrate_movable_pages() return codes)
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reported-by: syzbot+616ff0452fec30f4dcfd@syzkaller.appspotmail.com
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/gup.c~mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix
+++ a/mm/gup.c
@@ -2080,22 +2080,22 @@ static long __gup_longterm_locked(struct
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

mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch

