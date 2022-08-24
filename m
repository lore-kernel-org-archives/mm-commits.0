Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4873CC32796
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 17:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239989AbiHXRg0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 13:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiHXRgY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 13:36:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374116BD4F
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 10:36:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CADEA61297
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 17:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0A9C433C1;
        Wed, 24 Aug 2022 17:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661362583;
        bh=exC+8jkZ+8dUQ1mamUowUUHKdtFUyAF5KP6TFbKPuvQ=;
        h=Date:To:From:Subject:From;
        b=iO1cb3Scx6aHLJKGrLVecPpyyXWqNmcflzNZuBYN1gDnrrl5VeWE6+H8aMMKk+psn
         PutVMnRFUtJ5LAcgKHQcP8zUAjENP33F5kLiS2vfwHfXnyKe/WwAYZTcBoOztRxHbw
         u8IGmxI2wtGHUz4p97gfkgrH/tB9lr0DbCdlOIdE=
Date:   Wed, 24 Aug 2022 10:36:22 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, lkft@linaro.org,
        dan.carpenter@oracle.com, eb@emlix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-move-variables-to-more-local-scope-tweak-loops-fix.patch added to mm-unstable branch
Message-Id: <20220824173623.2A0A9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagewalk: add back missing variable initializations
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pagewalk-move-variables-to-more-local-scope-tweak-loops-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-move-variables-to-more-local-scope-tweak-loops-fix.patch

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
Subject: mm: pagewalk: add back missing variable initializations
Date: Wed, 24 Aug 2022 13:00:11 +0200

These initializations accidentially got lost during refactoring.

The first one can't actually be used without initialization, because
walk_p4d_range() is only called when one of the 4 callbacks is set, but relying
on this seems fragile.

Link: https://lkml.kernel.org/r/2123960.ggj6I0NvhH@mobilepool36.emlix.com
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/pagewalk.c~mm-pagewalk-move-variables-to-more-local-scope-tweak-loops-fix
+++ a/mm/pagewalk.c
@@ -308,7 +308,7 @@ static int walk_hugetlb_range(unsigned l
 	const struct mm_walk_ops *ops = walk->ops;
 
 	for (; addr < end; addr = next) {
-		int err;
+		int err = 0;
 		pte_t *pte = huge_pte_offset(walk->mm, addr & hmask, sz);
 
 		next = hugetlb_entry_end(h, addr, end);
_

Patches currently in -mm which might be from eb@emlix.com are

mm-pagewalk-make-error-checks-more-obvious.patch
mm-pagewalk-make-error-checks-more-obvious-fix.patch
mm-pagewalk-make-error-checks-more-obvious-fix-2.patch
mm-pagewalk-dont-check-vma-in-walk_page_range_novma.patch
mm-pagewalk-fix-documentation-of-pte-hole-handling.patch
mm-pagewalk-add-api-documentation-for-walk_page_range_novma.patch
mm-pagewalk-allow-walk_page_range_novma-without-mm.patch
mm-pagewalk-move-variables-to-more-local-scope-tweak-loops.patch
mm-pagewalk-move-variables-to-more-local-scope-tweak-loops-fix.patch
mm-pagewalk-add-back-missing-variable-initializations.patch

