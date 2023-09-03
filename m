Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33413C83F2C
	for <mm-commits@archiver.kernel.org>; Sun,  3 Sep 2023 23:58:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241294AbjICX6V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Sep 2023 19:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237477AbjICX6U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Sep 2023 19:58:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F36C4
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 16:58:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 69D8ECE0AC0
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 23:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD58C433C8;
        Sun,  3 Sep 2023 23:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693785493;
        bh=MiIXHQiHawhZS4z3CNOUPlwyKhokoYlBLR7TFbY+ud0=;
        h=Date:To:From:Subject:From;
        b=c/Cyt3aIfyO1GojeuL3kF1kWR7uIwzQAK7ME1a+5ITtWuV5ztf2DocHeJN1+JBS7f
         +YboTU9PM3O9gtmCtpx6yIj5SxN7oFfXm6/8+GwCIb0hgFWhJVH0dlCPbmQ3LmE+Nz
         9q4USmARfC677GpCb1WA8GWbfCW4xpVOKn/JWs0Y=
Date:   Sun, 03 Sep 2023 16:58:11 -0700
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        david@redhat.com, vernhao@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-use-folio_migratetype-instead-of-get_pageblock_migratetype.patch added to mm-unstable branch
Message-Id: <20230903235813.6DD58C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: use folio_migratetype() instead of get_pageblock_migratetype()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-use-folio_migratetype-instead-of-get_pageblock_migratetype.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-use-folio_migratetype-instead-of-get_pageblock_migratetype.patch

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
From: Vern Hao <vernhao@tencent.com>
Subject: mm/vmscan: use folio_migratetype() instead of get_pageblock_migratetype()
Date: Fri, 25 Aug 2023 15:57:34 +0800

In skip_cma(), we can use folio_migratetype() to replace
get_pageblock_migratetype().

Link: https://lkml.kernel.org/r/20230825075735.52436-1-user@VERNHAO-MC1
Signed-off-by: Vern Hao <vernhao@tencent.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-use-folio_migratetype-instead-of-get_pageblock_migratetype
+++ a/mm/vmscan.c
@@ -2284,7 +2284,7 @@ static bool skip_cma(struct folio *folio
 {
 	return !current_is_kswapd() &&
 			gfp_migratetype(sc->gfp_mask) != MIGRATE_MOVABLE &&
-			get_pageblock_migratetype(&folio->page) == MIGRATE_CMA;
+			folio_migratetype(folio) == MIGRATE_CMA;
 }
 #else
 static bool skip_cma(struct folio *folio, struct scan_control *sc)
_

Patches currently in -mm which might be from vernhao@tencent.com are

mm-vmscan-use-folio_migratetype-instead-of-get_pageblock_migratetype.patch

