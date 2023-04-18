Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E8AC77B72
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 01:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjDRBic (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Apr 2023 21:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjDRBib (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Apr 2023 21:38:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748BC59F2
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 18:38:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12B4862BC6
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 01:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5957EC433D2;
        Tue, 18 Apr 2023 01:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681781909;
        bh=GF1vP6v4kbRvkZoiiJLDbBiUCidnuFeHOtTS3PzSz34=;
        h=Date:To:From:Subject:From;
        b=pGN65mx60saZo2Ul29v/HRnyIyKNu+tivMep08AbbznMg1OG3LVNbNu7yq2YN5kzk
         Jd38T0y24R+jBRw6bCwn/OqRr+1toICuOipFsCZ9FpwTkS5tZY7xUiBFnL7QoxTIDV
         Zc6A/LHjZl9F/QuwjNA3zO970THA/rhdK12MOrFM=
Date:   Mon, 17 Apr 2023 18:38:28 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, sj@kernel.org,
        rppt@kernel.org, oliver.sang@intel.com, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-arch_has_descending_max_zone_pfns-static-v2.patch added to mm-unstable branch
Message-Id: <20230418013829.5957EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: [v2] mm: make arch_has_descending_max_zone_pfns() static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-arch_has_descending_max_zone_pfns-static-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-arch_has_descending_max_zone_pfns-static-v2.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: [v2] mm: make arch_has_descending_max_zone_pfns() static
Date: Sat, 15 Apr 2023 10:18:20 +0200

fix logic bug

Link: https://lkml.kernel.org/r/20230415081904.969049-1-arnd@kernel.org
Fixes: 9420f89db2dd ("mm: move most of core MM initialization to mm/mm_init.c")
Reported-by: kernel test robot <oliver.sang@intel.com>
  https://lore.kernel.org/oe-lkp/202304151422.5e4d380b-oliver.sang@intel.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-make-arch_has_descending_max_zone_pfns-static-v2
+++ a/mm/mm_init.c
@@ -1754,7 +1754,7 @@ static void __init free_area_init_memory
  */
 static bool arch_has_descending_max_zone_pfns(void)
 {
-	return !IS_ENABLED(CONFIG_ARC_HAS_PAE40);
+	return IS_ENABLED(CONFIG_ARC) && !IS_ENABLED(CONFIG_ARC_HAS_PAE40);
 }
 
 /**
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-make-arch_has_descending_max_zone_pfns-static.patch
mm-make-arch_has_descending_max_zone_pfns-static-v2.patch

