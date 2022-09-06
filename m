Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D060CECAAA1
	for <mm-commits@archiver.kernel.org>; Tue,  6 Sep 2022 19:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiIFTgW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Sep 2022 15:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiIFTgW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2022 15:36:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E19792F60
        for <mm-commits@vger.kernel.org>; Tue,  6 Sep 2022 12:36:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C6366164E
        for <mm-commits@vger.kernel.org>; Tue,  6 Sep 2022 19:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68334C433C1;
        Tue,  6 Sep 2022 19:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662492977;
        bh=pZknl7NwqdHflTkWFLrC3ccjiSzLN810mDLz4nCuHsg=;
        h=Date:To:From:Subject:From;
        b=yCtBtabdSXB5dYhObscLUsTpTo1KOd5qbNNMMn2k/JeDrP4F/TnklppOGq1UIgKjX
         g+8jrOipbjnsmYvF/axpa6YwLTjHKfHv7FrX8MISTC7rnYrI0ZxCo1xyKc83qHEsEi
         xzuBY7GXGcFrmPDa4K60VMdaESvemsN/DWLvQdH8=
Date:   Tue, 06 Sep 2022 12:36:16 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, lkft@linaro.org,
        dan.carpenter@oracle.com, eb@emlix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-pagewalk-make-error-checks-more-obvious-fix.patch removed from -mm tree
Message-Id: <20220906193617.68334C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: pagewalk: add back missing variable initializations
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-make-error-checks-more-obvious-fix.patch

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

--- a/mm/pagewalk.c~mm-pagewalk-make-error-checks-more-obvious-fix
+++ a/mm/pagewalk.c
@@ -225,7 +225,7 @@ static int walk_p4d_range(pgd_t *pgd, un
 
 	p4d = p4d_offset(pgd, addr);
 	do {
-		int err;
+		int err = 0;
 
 		next = p4d_addr_end(addr, end);
 		if (p4d_none_or_clear_bad(p4d)) {
_

Patches currently in -mm which might be from eb@emlix.com are

mm-pagewalk-make-error-checks-more-obvious.patch
mm-pagewalk-make-error-checks-more-obvious-fix-2.patch
mm-pagewalk-dont-check-vma-in-walk_page_range_novma.patch
mm-pagewalk-fix-documentation-of-pte-hole-handling.patch
mm-pagewalk-add-api-documentation-for-walk_page_range_novma.patch
mm-pagewalk-allow-walk_page_range_novma-without-mm.patch
mm-pagewalk-move-variables-to-more-local-scope-tweak-loops.patch
mm-pagewalk-move-variables-to-more-local-scope-tweak-loops-fix.patch

