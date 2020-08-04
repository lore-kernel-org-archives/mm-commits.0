Return-Path: <SRS0=09mD=BO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71CEFC433E0
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 777F9206DA
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596511298;
	bh=Y9D9jx3IOVv65GZ1hKIqRPgyMjaP6l6cwgkjZ+DyPXU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=FxOE1aewTBFFsdnHbtPsOhHgsA5cx1GVKPvuY24PgL0sTXuEvVBfYlSmOy10zzBOi
	 9LO6DTe0Tz7d5N1FUqfOmWFBXG3tb3OSt4Nbl9m1UrA+4bxhg+jsygZsnDkm9SxtLi
	 tKbM2I4tBQ8BeKwq82tZvtQ954ZPItawV8c5Q5oE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbgHDDVi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Aug 2020 23:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbgHDDVh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Aug 2020 23:21:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BC692068F;
        Tue,  4 Aug 2020 03:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596511297;
        bh=Y9D9jx3IOVv65GZ1hKIqRPgyMjaP6l6cwgkjZ+DyPXU=;
        h=Date:From:To:Subject:From;
        b=1AlZvgCYQQDoCGqs8Z3++aHT9hEg5ZIZEYX+GuS/BHheN9KMeqzLsT1b3SkkU8zq+
         e/S+7wAE5F/ps831vKaaepZ3VggktMyAu4Jl/6sn60kvNdQt8XBP/U1NjRvAQ5RVIS
         VZ38YGcAPXUtcCymwz5x6lUPxCpJ6i4fXN83ssWE=
Date:   Mon, 03 Aug 2020 20:21:36 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  + mm-page_allocc-delete-or-fix-duplicated-words.patch
 added to -mm tree
Message-ID: <20200804032136.Tt-Jpotnu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: delete or fix duplicated words
has been added to the -mm tree.  Its filename is
     mm-page_allocc-delete-or-fix-duplicated-words.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-delete-or-fix-duplicated-words.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-delete-or-fix-duplicated-words.patch

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
Subject: mm/page_alloc.c: delete or fix duplicated words

Drop the repeated word "them" and "that".
Change "the the" to "to the".

Link: http://lkml.kernel.org/r/20200801173822.14973-10-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-delete-or-fix-duplicated-words
+++ a/mm/page_alloc.c
@@ -4285,7 +4285,7 @@ retry:
 	/*
 	 * If an allocation failed after direct reclaim, it could be because
 	 * pages are pinned on the per-cpu lists or in high alloc reserves.
-	 * Shrink them them and try again
+	 * Shrink them and try again
 	 */
 	if (!page && !drained) {
 		unreserve_highatomic_pageblock(ac, false);
@@ -6195,7 +6195,7 @@ static int zone_batchsize(struct zone *z
  * locking.
  *
  * Any new users of pcp->batch and pcp->high should ensure they can cope with
- * those fields changing asynchronously (acording the the above rule).
+ * those fields changing asynchronously (acording to the above rule).
  *
  * mutex_is_locked(&pcp_batch_high_lock) required when calling this function
  * outside of boot time (or some other assurance that no concurrent updaters
@@ -8206,7 +8206,7 @@ void *__init alloc_large_system_hash(con
  * race condition. So you can't expect this function should be exact.
  *
  * Returns a page without holding a reference. If the caller wants to
- * dereference that page (e.g., dumping), it has to make sure that that it
+ * dereference that page (e.g., dumping), it has to make sure that it
  * cannot get removed (e.g., via memory unplug) concurrently.
  *
  */
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

