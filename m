Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A29ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 00:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiILAhW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 20:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiILAhV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 20:37:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E30E2558B
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 17:37:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D855C61148
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 00:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A73C433D7;
        Mon, 12 Sep 2022 00:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662943039;
        bh=GIBwyb+4uhLOkBcTPum32/ClvqtcLkqXCG2qnbWgWhE=;
        h=Date:To:From:Subject:From;
        b=pgEnFnPFdTSA8/QIkozqgdI9lowU8wUXCZJv780ToC6maPGOwGJILSQYufqa4tu1t
         UvPyBj1ChyuIEnxxBZXHeN6FhoFld2+hkl1NU+1satOLD3mGR1lXZe5bmZha7P8dfT
         REheSxxU78zT6EaZrOV9NnkBnNBNdEOSY3ZwL7J8=
Date:   Sun, 11 Sep 2022 17:37:18 -0700
To:     mm-commits@vger.kernel.org, dan.carpenter@oracle.com,
        apopple@nvidia.com, yshigeru@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix-fix.patch removed from -mm tree
Message-Id: <20220912003719.37A73C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup.c: Fix uninitialized return value on __gup_longterm_locked()
has been removed from the -mm tree.  Its filename was
     mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix-fix.patch

This patch was dropped because it was folded into mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch

------------------------------------------------------
From: Shigeru Yoshida <yshigeru@gmail.com>
Subject: mm/gup.c: Fix uninitialized return value on __gup_longterm_locked()
Date: Sun, 28 Aug 2022 08:00:37 +0900

In __gup_longterm_locked(), it returns uninitialized value if
__get_user_pages_locked() fails on the first iteration of the loop since
rc is not initialized.

This patch fixes this issue by properly returning error code if
__get_user_pages_locked() fails.

Link: https://lkml.kernel.org/r/20220827230037.78876-1-syoshida@redhat.com
Fixes: 11147539df44 ("mm/gup.c: Fix return value for __gup_longterm_locked()")
Signed-off-by: Shigeru Yoshida <yshigeru@gmail.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix-fix
+++ a/mm/gup.c
@@ -2090,8 +2090,10 @@ static long __gup_longterm_locked(struct
 		nr_pinned_pages = __get_user_pages_locked(mm, start, nr_pages,
 							  pages, vmas, NULL,
 							  gup_flags);
-		if (nr_pinned_pages <= 0)
+		if (nr_pinned_pages <= 0) {
+			rc = nr_pinned_pages;
 			break;
+		}
 		rc = check_and_migrate_movable_pages(nr_pinned_pages, pages,
 						     gup_flags);
 	} while (rc == -EAGAIN);
_

Patches currently in -mm which might be from yshigeru@gmail.com are

mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch

