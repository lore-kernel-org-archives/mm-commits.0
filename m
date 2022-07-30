Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95269C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239572AbiG3BI7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239618AbiG3BIk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5051863F2
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6399BB82922
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38ACC433D6;
        Sat, 30 Jul 2022 01:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143311;
        bh=YYI5SAbxJHXEd4bnZ0EO5Enxwl+BbBMkJZ2jhJh1uPo=;
        h=Date:To:From:Subject:From;
        b=KiIhcpm+wcXDflb+F7Mrd3slOf7iSesqByIPffTIoIx+O7NRFLmIDVUXNu/56qJSB
         T9FYrVPOa7rS55csh4skA9N0HxarkLQDfvd4WX3W5Je7cFrJ4t6X5N0OpS756T8A3D
         /qORcPQZAI8/oxen5IBwtvlPnNCyv5A/e5ZiM8OE=
Date:   Fri, 29 Jul 2022 18:08:30 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-remove-unneeded-out-label.patch removed from -mm tree
Message-Id: <20220730010830.F38ACC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: remove unneeded out label
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-remove-unneeded-out-label.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mempolicy: remove unneeded out label
Date: Tue, 19 Jul 2022 19:52:33 +0800

We can use unlock label to unlock ptl and return ret directly to remove
the unneeded out label and reduce the size of mempolicy.o.  No functional
change intended.

[Before]
   text	   data	    bss	    dec	    hex	filename
  26702	   3972	   6168	  36842	   8fea	mm/mempolicy.o

[After]
   text	   data	    bss	    dec	    hex	filename
  26662	   3972	   6168	  36802	   8fc2	mm/mempolicy.o

Link: https://lkml.kernel.org/r/20220719115233.6706-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-remove-unneeded-out-label
+++ a/mm/mempolicy.c
@@ -465,9 +465,8 @@ static int queue_pages_pmd(pmd_t *pmd, s
 	}
 	page = pmd_page(*pmd);
 	if (is_huge_zero_page(page)) {
-		spin_unlock(ptl);
 		walk->action = ACTION_CONTINUE;
-		goto out;
+		goto unlock;
 	}
 	if (!queue_pages_required(page, qp))
 		goto unlock;
@@ -484,7 +483,6 @@ static int queue_pages_pmd(pmd_t *pmd, s
 		ret = -EIO;
 unlock:
 	spin_unlock(ptl);
-out:
 	return ret;
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

