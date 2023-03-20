Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F47C6FD1D
	for <mm-commits@archiver.kernel.org>; Mon, 20 Mar 2023 21:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjCTVXS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Mar 2023 17:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjCTVXQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Mar 2023 17:23:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCF02ED48
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 14:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA39A61812
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 21:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D699C433EF;
        Mon, 20 Mar 2023 21:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679347388;
        bh=5JchjvQep8VLeTduTBshn4tvBgrLtPSk0cgNdy41qXo=;
        h=Date:To:From:Subject:From;
        b=xVDTF/PyRkggT5XlisWOMJfgw1+Nh5yPrh40fdAGlPcK5oBetYRhAKqmFcrHwhn7m
         3fmMCLcHChy5D9x1nmyXbleLTCqSYIcpyd1UeTyUziMTXMivSzUJeCXuZP/JrAqF29
         rrpU63jSnIUPeo+daX6PDHYmgaEi991hERHWoOlM=
Date:   Mon, 20 Mar 2023 14:23:07 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        konishi.ryusuke@gmail.com, hch@lst.de, agruenba@redhat.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-shmem_get_partial_folio-use-filemap_get_entry.patch added to mm-unstable branch
Message-Id: <20230320212308.2D699C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: shmem_get_partial_folio use filemap_get_entry
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-shmem_get_partial_folio-use-filemap_get_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-shmem_get_partial_folio-use-filemap_get_entry.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: shmem: shmem_get_partial_folio use filemap_get_entry
Date: Sun, 19 Mar 2023 22:19:21 -0700 (PDT)

To avoid use of the FGP_ENTRY flag, adapt shmem_get_partial_folio() to use
filemap_get_entry() and folio_lock() instead of __filemap_get_folio(). 
Update "page" in the comments there to "folio".

Link: https://lkml.kernel.org/r/9d1aaa4-1337-fb81-6f37-74ebc96f9ef@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/shmem.c~shmem-shmem_get_partial_folio-use-filemap_get_entry
+++ a/mm/shmem.c
@@ -886,14 +886,21 @@ static struct folio *shmem_get_partial_f
 
 	/*
 	 * At first avoid shmem_get_folio(,,,SGP_READ): that fails
-	 * beyond i_size, and reports fallocated pages as holes.
+	 * beyond i_size, and reports fallocated folios as holes.
 	 */
-	folio = __filemap_get_folio(inode->i_mapping, index,
-					FGP_ENTRY | FGP_LOCK, 0);
-	if (!xa_is_value(folio))
+	folio = filemap_get_entry(inode->i_mapping, index);
+	if (!folio)
 		return folio;
+	if (!xa_is_value(folio)) {
+		folio_lock(folio);
+		if (folio->mapping == inode->i_mapping)
+			return folio;
+		/* The folio has been swapped out */
+		folio_unlock(folio);
+		folio_put(folio);
+	}
 	/*
-	 * But read a page back from swap if any of it is within i_size
+	 * But read a folio back from swap if any of it is within i_size
 	 * (although in some cases this is just a waste of time).
 	 */
 	folio = NULL;
_

Patches currently in -mm which might be from hughd@google.com are

shmem-shmem_get_partial_folio-use-filemap_get_entry.patch
shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp-fix.patch

