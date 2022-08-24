Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBCD0C00140
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 17:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240057AbiHXRgY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 13:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiHXRgV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 13:36:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04AC6BD4F
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 10:36:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FA2561297
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 17:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E037C433D6;
        Wed, 24 Aug 2022 17:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661362579;
        bh=IHygKEbAJ7Lq1NFheE4N2Dp9a7W2RbLR6lyx1fGWa20=;
        h=Date:To:From:Subject:From;
        b=B+61IzrluOfQ5Tpw+GxUwTnHAc35fcTW7B4fp4FebmAqHSgArYQGU8aiiUCtvZRGU
         2SSf1RUXyOk4Ba0RA2T72ZERr8cPWOQcWu9BX0bTJkb1YY8oeHc+mnfinEblOIFZ/Z
         Hr4GXQ9Q0aAfMGvWO3WTX/vo3m1bvRHk9JKC+fR4=
Date:   Wed, 24 Aug 2022 10:36:18 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, lkft@linaro.org,
        dan.carpenter@oracle.com, eb@emlix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-make-error-checks-more-obvious-fix-2.patch added to mm-unstable branch
Message-Id: <20220824173619.8E037C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagewalk: add back missing variable initializations
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pagewalk-make-error-checks-more-obvious-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-make-error-checks-more-obvious-fix-2.patch

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

--- a/mm/pagewalk.c~mm-pagewalk-make-error-checks-more-obvious-fix-2
+++ a/mm/pagewalk.c
@@ -264,7 +264,7 @@ static int walk_pgd_range(unsigned long
 	else
 		pgd = pgd_offset(walk->mm, addr);
 	do {
-		int err;
+		int err = 0;
 
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd)) {
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

