Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52DAE784BE
	for <mm-commits@archiver.kernel.org>; Mon,  2 Oct 2023 15:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238206AbjJBPpU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238196AbjJBPpU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2023 11:45:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCA3B3
        for <mm-commits@vger.kernel.org>; Mon,  2 Oct 2023 08:45:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0B4C433C9;
        Mon,  2 Oct 2023 15:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696261515;
        bh=FJt/gzJtEQyKsDRlwIU+FiiaJih2Wcg140EVVgqwVno=;
        h=Date:To:From:Subject:From;
        b=A+IMUL2/P2S22MrZ7vT14biebsaaokhhrAfvuievnNGB69tKEDZxlwXCTJqUt1tGG
         9XCWtaOyTyNGwLQ1fGXHERNvUyUEAhAWCnog51CtRcItEgP8N+zfDTjocAIX31nBVN
         NginAekbBVkMln5cnCTsee18IBVuRREIgCKsucN0=
Date:   Mon, 02 Oct 2023 08:45:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, jack@suse.cz,
        hch@lst.de, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch added to mm-unstable branch
Message-Id: <20231002154515.BE0B4C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Date: Mon, 2 Oct 2023 07:37:24 +0100
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch

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
Date: Mon, 2 Oct 2023 07:37:24 +0100
Subject: mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix

correct identation as per Christopher's feedback

Link: https://lkml.kernel.org/r/2c7014c0-6343-4e76-8697-3f84f54350bd@lucifer.local
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/filemap.c~mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix
+++ a/mm/filemap.c
@@ -3314,10 +3314,10 @@ retry_find:
 	 */
 	if (unlikely(!folio_test_uptodate(folio))) {
 		/*
-		 * If the invalidate lock is not held, the folio was in cache and
-		 * uptodate and now it is not. Strange but possible since we
-		 * didn't hold the page lock all the time. Let's drop everything,
-		 * get the invalidate lock and try again.
+		 * If the invalidate lock is not held, the folio was in cache
+		 * and uptodate and now it is not. Strange but possible since we
+		 * didn't hold the page lock all the time. Let's drop
+		 * everything, get the invalidate lock and try again.
 		 */
 		if (!mapping_locked) {
 			folio_unlock(folio);
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-refactor-si_mem_available.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch

