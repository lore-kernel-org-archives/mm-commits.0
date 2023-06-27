Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91A5EB64D9
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jun 2023 19:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjF0Tb3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jun 2023 15:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbjF0TbZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jun 2023 15:31:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1503D19A9
        for <mm-commits@vger.kernel.org>; Tue, 27 Jun 2023 12:31:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9256961214
        for <mm-commits@vger.kernel.org>; Tue, 27 Jun 2023 19:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E080CC433C0;
        Tue, 27 Jun 2023 19:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687894283;
        bh=NHcIzcTlnqWJXIHkDNFWkQFx1qbKz4kMbxudc021PrY=;
        h=Date:To:From:Subject:From;
        b=EjAHLJNXqr0iJvROf/Y2JnpTjWLdACaJHV585OT40Fb+u2TKg+NMkugb3pwMR31vA
         VxjGWDYehSgqG+WdI3TakOkQVL5LqVg6rr/sGsbagZQaY88StAkhhUf14G7gzGaiP7
         g6xMcqJ6/naCzAT+fNx6tUvKjro4wkob97GIaTUQ=
Date:   Tue, 27 Jun 2023 12:31:21 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch added to mm-unstable branch
Message-Id: <20230627193122.E080CC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: fix unexpected return value in soft_offline_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: fix unexpected return value in soft_offline_page()
Date: Tue, 27 Jun 2023 19:28:08 +0800

When page_handle_poison() fails to handle the hugepage or free page in
retry path, soft_offline_page() will return 0 while -EBUSY is expected in
this case.

Link: https://lkml.kernel.org/r/20230627112808.1275241-1-linmiaohe@huawei.com
Fixes: b94e02822deb ("mm,hwpoison: try to narrow window race for free pages")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page
+++ a/mm/memory-failure.c
@@ -2737,10 +2737,13 @@ retry:
 	if (ret > 0) {
 		ret = soft_offline_in_use_page(page);
 	} else if (ret == 0) {
-		if (!page_handle_poison(page, true, false) && try_again) {
-			try_again = false;
-			flags &= ~MF_COUNT_INCREASED;
-			goto retry;
+		if (!page_handle_poison(page, true, false)) {
+			if (try_again) {
+				try_again = false;
+				flags &= ~MF_COUNT_INCREASED;
+				goto retry;
+			}
+			ret = -EBUSY;
 		}
 	}
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch
mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch

