Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF1AE7848A
	for <mm-commits@archiver.kernel.org>; Sun,  1 Oct 2023 19:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbjJATsu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Oct 2023 15:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235309AbjJATsu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 1 Oct 2023 15:48:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9556C4
        for <mm-commits@vger.kernel.org>; Sun,  1 Oct 2023 12:48:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6191DC433C8;
        Sun,  1 Oct 2023 19:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696189727;
        bh=wY6KJjhwPCBRF/sTM5wKg/Ep+EX20Qz8beb4NmswIKE=;
        h=Date:To:From:Subject:From;
        b=1CI+kTl4qPVLpd4IGZGGaab9joJ2NAZjheFyA1NYG6MYEkTl+oX4G6rgDzww87u/R
         eTn9G0LLFb83hfTmpvdBF7BHFgJMIVD6fU+MxW9qRZ2NBFlElOLuMWEYvbMRK6zlut
         BpsTRDdlT8DjWaz3RNRrmV9bn0Igk6+NGo5OxYsw=
Date:   Sun, 01 Oct 2023 12:48:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, jack@suse.cz,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch added to mm-unstable branch
Message-Id: <20231001194847.6191DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: clarify filemap_fault() comments for not uptodate case
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/filemap: clarify filemap_fault() comments for not uptodate case
Date: Sun, 1 Oct 2023 00:10:29 +0100

The existing comments in filemap_fault() suggest that, after either a
minor fault has occurred and filemap_get_folio() found a folio in the page
cache, or a major fault arose and __filemap_get_folio(FGP_CREATE...) did
the job (having relied on do_sync_mmap_readahead() or filemap_read_folio()
to read in the folio), the only possible reason it could not be uptodate
is because of an error.

This is not so, as if, for instance, the fault occurred within a VMA which
had the VM_RAND_READ flag set (via madvise() with the MADV_RANDOM flag
specified), this would cause even synchronous readahead to fail to read in
the folio.

I confirmed this by dropping page caches and faulting in memory
madvise()'d this way, observing that this code path was reached on each
occasion.

Clarify the comments to include this case, and additionally update the
comment recently added around the invalidate lock logic to make it clear
the comment explicitly refers to the minor fault case.

In addition, while we're here, refer to folios rather than pages.

Link: https://lkml.kernel.org/r/20230930231029.88196-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/mm/filemap.c~mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case
+++ a/mm/filemap.c
@@ -3308,21 +3308,28 @@ retry_find:
 	VM_BUG_ON_FOLIO(!folio_contains(folio, index), folio);
 
 	/*
-	 * We have a locked page in the page cache, now we need to check
-	 * that it's up-to-date. If not, it is going to be due to an error.
+	 * We have a locked folio in the page cache, now we need to check
+	 * that it's up-to-date. If not, it is going to be due to an error,
+	 * or because readahead was otherwise unable to retrieve it.
 	 */
 	if (unlikely(!folio_test_uptodate(folio))) {
 		/*
-		 * The page was in cache and uptodate and now it is not.
-		 * Strange but possible since we didn't hold the page lock all
-		 * the time. Let's drop everything get the invalidate lock and
-		 * try again.
+		 * If the invalidate lock is not held, the folio was in cache and
+		 * uptodate and now it is not. Strange but possible since we
+		 * didn't hold the page lock all the time. Let's drop everything,
+		 * get the invalidate lock and try again.
 		 */
 		if (!mapping_locked) {
 			folio_unlock(folio);
 			folio_put(folio);
 			goto retry_find;
 		}
+
+		/*
+		 * OK, the folio is really not uptodate. This can be because the
+		 * VMA has the VM_RAND_READ flag set, or because an error
+		 * arose. Let's read it in directly.
+		 */
 		goto page_not_uptodate;
 	}
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-refactor-si_mem_available.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch

