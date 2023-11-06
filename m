Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24817C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 19:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbjKFTpg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 14:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbjKFTpg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 14:45:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B50D7C
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 11:45:33 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D27BC433C8;
        Mon,  6 Nov 2023 19:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699299933;
        bh=ng8ydQ/QdsgtQHj8fhUTEN6UBrt3LqHtNncpkH03xZk=;
        h=Date:To:From:Subject:From;
        b=awglEFhtem1AjgTGbBlDImjQ27/PuFeFWk5IJSd55k2TJ3bkEnT9y+/flHgCxwMpX
         D3Ppx26S2DbeW2TYWSktQeiWNs2Xf3qudXkR/H2657CKFtwvVcLmPE70CSkSksw4wO
         htNYaD4B4OkCXJcwiUWbzOHpoLxNPrYV3JdJPppc=
Date:   Mon, 06 Nov 2023 11:45:32 -0800
To:     mm-commits@vger.kernel.org, shr@devkernel.io, riel@surriel.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-for-negative-counter-nr_file_hugepages-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20231106194533.5D27BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-for-negative-counter-nr_file_hugepages-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-for-negative-counter-nr_file_hugepages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-for-negative-counter-nr_file_hugepages-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-for-negative-counter-nr_file_hugepages-fix
Date: Mon Nov  6 11:44:47 AM PST 2023

whitespace fix

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/huge_memory.c~mm-fix-for-negative-counter-nr_file_hugepages-fix
+++ a/mm/huge_memory.c
@@ -2773,7 +2773,6 @@ int split_huge_page_to_list(struct page
 				__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS,
 							-nr);
 			} else if (folio_test_pmd_mappable(folio)) {
-
 				__lruvec_stat_mod_folio(folio, NR_FILE_THPS,
 							-nr);
 				filemap_nr_thps_dec(mapping);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-for-negative-counter-nr_file_hugepages-fix.patch
mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch

