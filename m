Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C0DC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 30 May 2022 20:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240972AbiE3UIi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 May 2022 16:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbiE3UIh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 May 2022 16:08:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9322D51E69
        for <mm-commits@vger.kernel.org>; Mon, 30 May 2022 13:08:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D53360F16
        for <mm-commits@vger.kernel.org>; Mon, 30 May 2022 20:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA2AC34119;
        Mon, 30 May 2022 20:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653941315;
        bh=Im5PGmk7WD+Y0cWTIkiqxWByVoqoAN3DUU9amOcYyw8=;
        h=Date:To:From:Subject:From;
        b=XrnH7SiAGZYzx5GdELH9Ho4MOYIuh2n2P/H6qo6nim9OpZ9XeXvnC4/skaa9lISBA
         SapDtw1ZRGYZwUExh07/4WyZDQIG16T0KoWNJEP+HJ02Axb+c/tFP1Jq80VdWLCixy
         vMkBkzubwAqNpU1R84V/luIhkDmQxGwF/WVZpojE=
Date:   Mon, 30 May 2022 13:08:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, hughd@google.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch added to mm-unstable branch
Message-Id: <20220530200835.7EA2AC34119@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem.c: clean up comment of shmem_swapin_folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch

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
Subject: mm/shmem.c: clean up comment of shmem_swapin_folio
Date: Mon, 30 May 2022 19:58:41 +0800

shmem_swapin_folio has changed to use folio but comment still mentions
page.  Update the relevant comment accordingly as suggested by Naoya.

Link: https://lkml.kernel.org/r/20220530115841.4348-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/shmem.c~mm-shmemc-clean-up-comment-of-shmem_swapin_folio
+++ a/mm/shmem.c
@@ -1706,10 +1706,10 @@ static void shmem_set_folio_swapin_error
 }
 
 /*
- * Swap in the page pointed to by *pagep.
- * Caller has to make sure that *pagep contains a valid swapped page.
- * Returns 0 and the page in pagep if success. On failure, returns the
- * error code and NULL in *pagep.
+ * Swap in the folio pointed to by *foliop.
+ * Caller has to make sure that *foliop contains a valid swapped folio.
+ * Returns 0 and the folio in foliop if success. On failure, returns the
+ * error code and NULL in *foliop.
  */
 static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			     struct folio **foliop, enum sgp_type sgp,
@@ -1749,7 +1749,7 @@ static int shmem_swapin_folio(struct ino
 	}
 	folio = page_folio(page);
 
-	/* We have to do this with page locked to prevent races */
+	/* We have to do this with folio locked to prevent races */
 	folio_lock(folio);
 	if (!folio_test_swapcache(folio) ||
 	    folio_swap_entry(folio).val != swap.val ||
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch

