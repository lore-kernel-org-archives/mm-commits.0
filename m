Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FECC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 22 May 2022 13:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345999AbiEVNeI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 May 2022 09:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234645AbiEVNeI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 22 May 2022 09:34:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869F39FF3
        for <mm-commits@vger.kernel.org>; Sun, 22 May 2022 06:34:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BED5B80BE9
        for <mm-commits@vger.kernel.org>; Sun, 22 May 2022 13:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDECC385AA;
        Sun, 22 May 2022 13:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653226444;
        bh=DX4aKihsebkMvdbywLYO5CZEWzFN8+aBpSRhoFbsNjo=;
        h=Date:To:From:Subject:From;
        b=XzOB9Rgdg8deqPaLvV7EC13nJDDc9YhDkyrRX8W0bpfPo0xQ912ffy4pcEiLAI9a1
         Vmtm+bIbMiKSGqlxb8OSmSIAsCU+t/NViMuDByGfJpi0Yzg+R2nPwWqEI4bylkwXec
         8cbJxtedAbEaQMO9emhob4RJ2XF/vTI8806OoxH0=
Date:   Sun, 22 May 2022 06:34:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, hch@lst.de,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-shmem-folio-swapoff-hang.patch added to mm-stable branch
Message-Id: <20220522133404.AFDECC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: fix shmem folio swapoff hang
has been added to the -mm mm-stable branch.  Its filename is
     mm-shmem-fix-shmem-folio-swapoff-hang.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-shmem-folio-swapoff-hang.patch

This patch will later appear in the mm-stable branch at
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
From: Hugh Dickins <hughd@google.com>
Subject: mm/shmem: fix shmem folio swapoff hang
Date: Sat, 21 May 2022 19:53:04 -0700 (PDT)

Shmem swapoff makes no progress: the index to indices is not incremented. 
But "ret" is no longer a return value, so use folio_batch_count() instead.

Link: https://lkml.kernel.org/r/c32bee8a-f0aa-245-f94e-24dd271924fa@google.com
Fixes: da08e9b79323 ("mm/shmem: convert shmem_swapin_page() to shmem_swapin_folio()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-shmem-folio-swapoff-hang
+++ a/mm/shmem.c
@@ -1165,7 +1165,6 @@ static int shmem_find_swap_entries(struc
 	XA_STATE(xas, &mapping->i_pages, start);
 	struct folio *folio;
 	swp_entry_t entry;
-	unsigned int ret = 0;
 
 	rcu_read_lock();
 	xas_for_each(&xas, folio, ULONG_MAX) {
@@ -1179,7 +1178,7 @@ static int shmem_find_swap_entries(struc
 		if (swp_type(entry) != type)
 			continue;
 
-		indices[ret] = xas.xa_index;
+		indices[folio_batch_count(fbatch)] = xas.xa_index;
 		if (!folio_batch_add(fbatch, folio))
 			break;
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-shmem-fix-shmem-folio-swapoff-hang.patch

