Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4416C00140
	for <mm-commits@archiver.kernel.org>; Wed,  3 Aug 2022 00:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbiHCArX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Aug 2022 20:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiHCArW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2022 20:47:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E5F3C8DF
        for <mm-commits@vger.kernel.org>; Tue,  2 Aug 2022 17:47:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21F9A61057
        for <mm-commits@vger.kernel.org>; Wed,  3 Aug 2022 00:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E7FC433D6;
        Wed,  3 Aug 2022 00:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659487640;
        bh=Ky1zzW9uOhXwTuKWBFUFidyBe0osTQ9TbnKHixYK6jY=;
        h=Date:To:From:Subject:From;
        b=J1VrlCL4fOU/lW3MIlJ4A+fcpN0jNIATa2/wczKW58xhbzSuTVVirWNEd2rPDXZhz
         0OoETSuCtBkdW2EqxMJL/Fgy2smyF59YH8msUv8fSAIO0gysxpSayijBH2Cez2vJtD
         JaAwQ5nP2o68evHBIiTezgnHcygYMxnHKUsuAtSg=
Date:   Tue, 02 Aug 2022 17:47:19 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-update-folio-if-shmem_replace_page-updates-the-page.patch added to mm-hotfixes-unstable branch
Message-Id: <20220803004720.67E7FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: update folio if shmem_replace_page() updates the page
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     shmem-update-folio-if-shmem_replace_page-updates-the-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-update-folio-if-shmem_replace_page-updates-the-page.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: update folio if shmem_replace_page() updates the page
Date: Sat, 30 Jul 2022 05:25:18 +0100

If we allocate a new page, we need to make sure that our folio matches
that new page.  This will be solved by changing shmem_replace_page() to
shmem_replace_folio(), but this is the minimal fix.

Link: https://lkml.kernel.org/r/20220730042518.1264767-1-willy@infradead.org
Fixes: da08e9b79323 ("mm/shmem: convert shmem_swapin_page() to shmem_swapin_folio()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/shmem.c~shmem-update-folio-if-shmem_replace_page-updates-the-page
+++ a/mm/shmem.c
@@ -1771,6 +1771,7 @@ static int shmem_swapin_folio(struct ino
 
 	if (shmem_should_replace_folio(folio, gfp)) {
 		error = shmem_replace_page(&page, gfp, info, index);
+		folio = page_folio(page);
 		if (error)
 			goto failed;
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

shmem-update-folio-if-shmem_replace_page-updates-the-page.patch

