Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F9DECAAD1
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 23:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbiH0XRB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 19:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiH0XRA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 19:17:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7CC210
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 16:16:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 481C560EAA
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 23:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA88C433C1;
        Sat, 27 Aug 2022 23:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661642218;
        bh=jQnuXDjvnzJ80K3LdpevLiHWejGav2j4omkEcNE44iI=;
        h=Date:To:From:Subject:From;
        b=Cd0PDUeKSJ3cZp6IXwFaWg0lpNp4GnyDBCgmyl+LY6632P00LlPJiSU02Lv9hN19y
         2Hkq8Iiuu7XnUmH0BmBWB1BQPpp2NYg8qwytoiO0fShYQroyPRGxrVqAka4ZmoTyyG
         wiDpw3TGIWRzGtzb2N4OBm3ZRysROG2/hlMefqX4=
Date:   Sat, 27 Aug 2022 16:16:57 -0700
To:     mm-commits@vger.kernel.org, dan.carpenter@oracle.com,
        apopple@nvidia.com, yshigeru@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix-fix.patch added to mm-unstable branch
Message-Id: <20220827231658.9DA88C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: Fix uninitialized return value on __gup_longterm_locked()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix-fix.patch

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
@@ -2078,8 +2078,10 @@ static long __gup_longterm_locked(struct
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

mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix-fix.patch

