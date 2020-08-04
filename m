Return-Path: <SRS0=09mD=BO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A178C433DF
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BC932068F
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596511284;
	bh=COEEulLpyjd/bwrZifqAGtNuegeTKEfkcwoNjydiAVU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=MpO6R38UYF+dPTVKWb6riELuHkyYiTWLDNLZGVjHjgT9LiYfH4vVhlxZnbYp0YYxD
	 Hf6Q07+70ecFodgS9Tdb911Q2QxMdP4NWg1pjtYcNyOuCSbOfLT0n8lThQhYQHGhpJ
	 ICC4w13twy/TYAnOj0V1e7ZGiSa5U9c2v0Xl2T2s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgHDDVX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Aug 2020 23:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbgHDDVX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Aug 2020 23:21:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE9C7206DA;
        Tue,  4 Aug 2020 03:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596511283;
        bh=COEEulLpyjd/bwrZifqAGtNuegeTKEfkcwoNjydiAVU=;
        h=Date:From:To:Subject:From;
        b=aNkZqrKi8TWZ2WDkmuhTV6qhUi1qVQ0Ra2qMRgvM12hY6xhFuClpnT//R/yg8gRQ8
         lVip+Azf5fQhxjhiO8DrqM9gyydrCUAUP3oYTnN9cW7TxrMjjdy1EJrWU6LrA4mEEU
         hLz6xmV1Kywe77JIv691a+mCCiA5xxVhv/V7D+jU=
Date:   Mon, 03 Aug 2020 20:21:22 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  + mm-filemapc-delete-duplicated-word.patch added to -mm
 tree
Message-ID: <20200804032122.4Znr4FXta%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap.c: delete duplicated word
has been added to the -mm tree.  Its filename is
     mm-filemapc-delete-duplicated-word.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-filemapc-delete-duplicated-word.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-filemapc-delete-duplicated-word.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/filemap.c: delete duplicated word

Drop the repeated word "the".

Link: http://lkml.kernel.org/r/20200801173822.14973-3-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemapc-delete-duplicated-word
+++ a/mm/filemap.c
@@ -2885,7 +2885,7 @@ filler:
 	 * Case a, the page will be up to date when the page is unlocked.
 	 *    There is no need to serialise on the page lock here as the page
 	 *    is pinned so the lock gives no additional protection. Even if the
-	 *    the page is truncated, the data is still valid if PageUptodate as
+	 *    page is truncated, the data is still valid if PageUptodate as
 	 *    it's a race vs truncate race.
 	 * Case b, the page will not be up to date
 	 * Case c, the page may be truncated but in itself, the data may still
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ocfs2-suballoch-delete-a-duplicated-word.patch
mm-drop-duplicated-words-in-linux-pgtableh.patch
mm-drop-duplicated-words-in-linux-mmh.patch
highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch
frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment.patch
memcontrol-drop-duplicate-word-and-fix-spello-in-linux-memcontrolh.patch
mm-compactionc-delete-duplicated-word.patch
mm-filemapc-delete-duplicated-word.patch
mm-hmmc-delete-duplicated-word.patch
mm-hugetlbc-delete-duplicated-words.patch
mm-memcontrolc-delete-duplicated-words.patch
mm-memoryc-delete-duplicated-words.patch
mm-migratec-delete-duplicated-word.patch
mm-nommuc-delete-duplicated-words.patch
mm-page_allocc-delete-or-fix-duplicated-words.patch
mm-shmemc-delete-duplicated-word.patch
mm-slab_commonc-delete-duplicated-word.patch
mm-usercopyc-delete-duplicated-word.patch
mm-vmscanc-delete-or-fix-duplicated-words.patch
mm-zpoolc-delete-duplicated-word-and-fix-grammar.patch
mm-zsmallocc-fix-duplicated-words.patch
clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch
linux-exportfsh-drop-duplicated-word-in-a-comment.patch
linux-async_txh-drop-duplicated-word-in-a-comment.patch
xz-drop-duplicated-word-in-linux-xzh.patch
autofs-fix-doubled-word.patch

