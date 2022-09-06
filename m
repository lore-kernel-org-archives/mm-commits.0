Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FED2C38145
	for <mm-commits@archiver.kernel.org>; Tue,  6 Sep 2022 19:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiIFTiY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Sep 2022 15:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiIFTiX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2022 15:38:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF8B9A9DA
        for <mm-commits@vger.kernel.org>; Tue,  6 Sep 2022 12:38:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9F2561655
        for <mm-commits@vger.kernel.org>; Tue,  6 Sep 2022 19:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2287DC433D6;
        Tue,  6 Sep 2022 19:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662493101;
        bh=7WH74TlT+yUVG/7/B4xLeygbxilsPcXe+pKGb92Ibsg=;
        h=Date:To:From:Subject:From;
        b=Ggyyjjmkj/iVgl1/NcHhYIdBVRt9JUL9sN+FUKoe9UL+ieujimCUAGsUOlc1MMxd3
         V1Z4mHNPcwS2I7ZenbIby/69KtgG7CDrBsYxykBIjJlLf/PIXACtGFkUUJ/4Bc+cVQ
         ZgB9i1Jd/KouvUZcWffOHzbnDlGMBrsQhLXShgDU=
Date:   Tue, 06 Sep 2022 12:38:20 -0700
To:     mm-commits@vger.kernel.org, eb@emlix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-pagewalk-dont-check-vma-in-walk_page_range_novma.patch removed from -mm tree
Message-Id: <20220906193821.2287DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: pagewalk: don't check vma in walk_page_range_novma()
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-dont-check-vma-in-walk_page_range_novma.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rolf Eike Beer <eb@emlix.com>
Subject: mm: pagewalk: don't check vma in walk_page_range_novma()
Date: Mon, 22 Aug 2022 15:00:47 +0200

Directly call walk_pgd_range() as that is everything that will actually
happen in __walk_page_range() besides checking if the vma is set.

Link: https://lkml.kernel.org/r/21585888.EfDdHjke4D@devpool047
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/pagewalk.c~mm-pagewalk-dont-check-vma-in-walk_page_range_novma
+++ a/mm/pagewalk.c
@@ -517,7 +517,7 @@ int walk_page_range_novma(struct mm_stru
 
 	mmap_assert_locked(walk.mm);
 
-	return __walk_page_range(start, end, &walk);
+	return walk_pgd_range(start, end, &walk);
 }
 
 int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
_

Patches currently in -mm which might be from eb@emlix.com are

mm-pagewalk-fix-documentation-of-pte-hole-handling.patch
mm-pagewalk-add-api-documentation-for-walk_page_range_novma.patch
mm-pagewalk-allow-walk_page_range_novma-without-mm.patch
mm-pagewalk-move-variables-to-more-local-scope-tweak-loops.patch

