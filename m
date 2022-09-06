Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11BA4C38145
	for <mm-commits@archiver.kernel.org>; Tue,  6 Sep 2022 19:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiIFTg3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Sep 2022 15:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiIFTg1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2022 15:36:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79DB95AC0
        for <mm-commits@vger.kernel.org>; Tue,  6 Sep 2022 12:36:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CFF5B81A02
        for <mm-commits@vger.kernel.org>; Tue,  6 Sep 2022 19:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53DCC433D6;
        Tue,  6 Sep 2022 19:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662492978;
        bh=ycMEUhxNK3r/jCwFdQ2uB6xkBLc6UwLCAJl/R2L5CF0=;
        h=Date:To:From:Subject:From;
        b=vwjlqeIw7hrJOTGh9JlYkLmB8KzTBmvkJwqMjMqtSa0LmWA0o7Up1yGVRoRqe/Nm0
         zWWA2HhBIxpaLwMtT5e0N9O0iElVKBKRZI7ODLE29t6ePC/9CL5cmzXw9VGY6jngwB
         QZm/4iHmrDIQAPzO5ItTUDIqxTuhKl0dU31na0Ew=
Date:   Tue, 06 Sep 2022 12:36:18 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, lkft@linaro.org,
        dan.carpenter@oracle.com, eb@emlix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-pagewalk-make-error-checks-more-obvious-fix-2.patch removed from -mm tree
Message-Id: <20220906193618.C53DCC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: pagewalk: add back missing variable initializations
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-make-error-checks-more-obvious-fix-2.patch

This patch was dropped because it was folded into mm-pagewalk-make-error-checks-more-obvious.patch

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
mm-pagewalk-dont-check-vma-in-walk_page_range_novma.patch
mm-pagewalk-fix-documentation-of-pte-hole-handling.patch
mm-pagewalk-add-api-documentation-for-walk_page_range_novma.patch
mm-pagewalk-allow-walk_page_range_novma-without-mm.patch
mm-pagewalk-move-variables-to-more-local-scope-tweak-loops.patch
mm-pagewalk-move-variables-to-more-local-scope-tweak-loops-fix.patch

