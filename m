Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D45E7C4F5
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbjJDURv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243883AbjJDURv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C4BD7
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D6EC433C8;
        Wed,  4 Oct 2023 20:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450667;
        bh=X3N5bejdASkWDXGBC239VAI77nVPIp5/UeFD6vale40=;
        h=Date:To:From:Subject:From;
        b=uCBv+hVUWmsg+KooYF4aHYsyX3ZHI0MCfPWmluaqoKgcRkuFAiVB8Rcuv7cIOBkO8
         K/5Fh1q6sPYUDtPiqGbOIDZUzbcWHudTClhkbd5w/aM8eYSJD4adfPt9r3lX0L2LJr
         kN65hifMBG+nLc+t+9QVGiMi2mfRpphSKP335CCI=
Date:   Wed, 04 Oct 2023 13:17:45 -0700
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        david@redhat.com, vernhao@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-use-folio_migratetype-instead-of-get_pageblock_migratetype.patch removed from -mm tree
Message-Id: <20231004201747.35D6EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: use folio_migratetype() instead of get_pageblock_migratetype()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-use-folio_migratetype-instead-of-get_pageblock_migratetype.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2271,7 +2271,7 @@ static bool skip_cma(struct folio *folio
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


