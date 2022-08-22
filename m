Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2901C28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 20:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiHVU7J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 16:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237335AbiHVU7H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 16:59:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B75F4CA12
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 13:59:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA740612B5
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 20:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC3EC433D6;
        Mon, 22 Aug 2022 20:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661201946;
        bh=RaCBEk+BNHN/8WuE4OT50mWv1sxxxoRxDj/IbBeMRiI=;
        h=Date:To:From:Subject:From;
        b=ypnLWyRDIOvm2TFDotfTQAIKoMz1ey2PqF5IUC4mkJ0KXxpqSWBPq9cXDEa+LOpfI
         5SKt0V5TsXBu4hXuVGtW2hfpucW+P+xeBIodmm7wKTVVYYqO055E+wGf/GaBLBHVUv
         qqsbZf0IUmQLQlfKMu34Shscj9qENi42veaya/I8=
Date:   Mon, 22 Aug 2022 13:59:05 -0700
To:     mm-commits@vger.kernel.org, eb@emlix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-dont-check-vma-in-walk_page_range_novma.patch added to mm-unstable branch
Message-Id: <20220822205906.1EC3EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagewalk: don't check vma in walk_page_range_novma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pagewalk-dont-check-vma-in-walk_page_range_novma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-dont-check-vma-in-walk_page_range_novma.patch

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

mm-pagewalk-make-error-checks-more-obvious.patch
mm-pagewalk-dont-check-vma-in-walk_page_range_novma.patch
mm-pagewalk-fix-documentation-of-pte-hole-handling.patch
mm-pagewalk-add-api-documentation-for-walk_page_range_novma.patch
mm-pagewalk-allow-walk_page_range_novma-without-mm.patch
mm-pagewalk-move-variables-to-more-local-scope-tweak-loops.patch

