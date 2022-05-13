Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A981C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 22:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbiEMWgF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 18:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbiEMWgB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 18:36:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C832B35841
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 15:35:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B4835CE3353
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 22:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A01C34100;
        Fri, 13 May 2022 22:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652481342;
        bh=d7yyPfVA0JKOTwlVf6IUeG+NlYZnnru5Xdkq5WVQN8w=;
        h=Date:To:From:Subject:From;
        b=VYVycX7jjWNZOLd/T682E4TovySX9MfkpgsCpW5UDpL087lf8rqyzJcGArb/NdtSU
         gRIFWPx+oQEWkkXid8kWIWxdrJPlugoBz9X6TKveq7HqfuPyVuQhC/zuiYF0Si2t2n
         skc5obsPI9vlzJnQQsUe7A02InfoL/U+JjjHxog4=
Date:   Fri, 13 May 2022 15:35:41 -0700
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com,
        minchan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-is_pinnable_page-against-on-cma-page-v5-fix.patch removed from -mm tree
Message-Id: <20220513223542.12A01C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-fix-is_pinnable_page-against-on-cma-page-v5-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-is_pinnable_page-against-on-cma-page-v5-fix.patch

This patch was dropped because it was folded into mm-fix-is_pinnable_page-against-on-cma-page.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm-fix-is_pinnable_page-against-on-cma-page-v5-fix

fat finger

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mm.h~mm-fix-is_pinnable_page-against-on-cma-page-v5-fix
+++ a/include/linux/mm.h
@@ -1632,6 +1632,7 @@ static inline bool is_pinnable_page(stru
 	 * this routine races with set_pageblock_migratetype(), and we want to
 	 * avoid reading zero, when actually one or the other flags was set.
 	 */
+	int __mt = get_pageblock_migratetype(page);
 	int mt = __READ_ONCE(__mt);
 
 	if (mt & (MIGRATE_CMA | MIGRATE_ISOLATE))
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-fix-is_pinnable_page-against-on-cma-page.patch
mm-dont-be-stuck-to-rmap-lock-on-reclaim-path.patch

