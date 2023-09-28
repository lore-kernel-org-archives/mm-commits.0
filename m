Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59488E732E7
	for <mm-commits@archiver.kernel.org>; Thu, 28 Sep 2023 16:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjI1Q3l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjI1Q3l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2023 12:29:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE55FBF
        for <mm-commits@vger.kernel.org>; Thu, 28 Sep 2023 09:29:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574F0C433C9;
        Thu, 28 Sep 2023 16:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695918579;
        bh=m+NSxaPfPi9euruuteSh2spFpiVa8idiLeJdW7bvdoE=;
        h=Date:To:From:Subject:From;
        b=ytm14eTIaOTvveuC1NaoEtqcWf1eRl3tJIJJYKw+zmLTTK+Iaa2m8C6VxnzB2DjQa
         tibLWdeBlTf1qfV6pVrGh12J8n4OgLsTYy8xs6XbSCcyqjDEqcseFODNU1C9ZZ9vOZ
         QeMZXYb1S/lyqbG+E9dDKZFTu7wutI+rPotUMk1Q=
Date:   Thu, 28 Sep 2023 09:29:38 -0700
To:     mm-commits@vger.kernel.org, sidhartha.kumar@oracle.com,
        dan.carpenter@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-remove-hugetlb-special-casing-in-filemapc-fix.patch added to mm-unstable branch
Message-Id: <20230928162939.574F0C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: fix an NULL vs IS_ERR() bug
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-remove-hugetlb-special-casing-in-filemapc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-remove-hugetlb-special-casing-in-filemapc-fix.patch

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
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: hugetlbfs: fix an NULL vs IS_ERR() bug
Date: Thu, 28 Sep 2023 08:17:36 +0300

This code was converted from using find_lock_page() which returns NULL,
to calling filemap_lock_hugetlb_folio() which returns -ENOENT.  The
check needs to be updated to match.  Also IS_ERR() has an unlikely()
built in so we can remove that.

Link: https://lkml.kernel.org/r/1772c296-1417-486f-8eef-171af2192681@moroto.mountain
Fixes: 4649d8d5bb81 ("mm/filemap: remove hugetlb special casing in filemap.c")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~mm-filemap-remove-hugetlb-special-casing-in-filemapc-fix
+++ a/fs/hugetlbfs/inode.c
@@ -354,7 +354,7 @@ static ssize_t hugetlbfs_read_iter(struc
 
 		/* Find the folio */
 		folio = filemap_lock_hugetlb_folio(h, mapping, index);
-		if (unlikely(folio == NULL)) {
+		if (IS_ERR(folio)) {
 			/*
 			 * We have a HOLE, zero out the user-buffer for the
 			 * length of the hole or request.
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

mm-filemap-remove-hugetlb-special-casing-in-filemapc-fix.patch

