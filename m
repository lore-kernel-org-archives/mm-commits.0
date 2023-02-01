Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB87C38142
	for <mm-commits@archiver.kernel.org>; Wed,  1 Feb 2023 00:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbjBAAhs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 19:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbjBAAhp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 19:37:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB642BF39
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 16:37:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EA4FB81FBB
        for <mm-commits@vger.kernel.org>; Wed,  1 Feb 2023 00:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6ED2C433EF;
        Wed,  1 Feb 2023 00:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675211862;
        bh=r8Uz7ABPw6x4dfWJMligoO+7yQ+rUtFL2GAywcx2LxY=;
        h=Date:To:From:Subject:From;
        b=q5TuLM060GABBDbLo7yYLwiYpw0JT6xpsKav0ApCn+I1O8hJkxRuqoqPhxKCE8jRp
         J4URAXlNEDNPvkaKZRVHHBcJBXjFDSIoUH2ymCIyFTWIwRapXR8vuUF8A3ZI7BSA9I
         aKZuCf86RyM3PV4/kEc2Vho5uTKzs1wuCfkUz4fw=
Date:   Tue, 31 Jan 2023 16:37:41 -0800
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        nphamcs@gmail.com, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zsmalloc-fix-a-race-with-deferred_handles-storing-fix.patch removed from -mm tree
Message-Id: <20230201003741.E6ED2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: avoid unused-function warning
has been removed from the -mm tree.  Its filename was
     zsmalloc-fix-a-race-with-deferred_handles-storing-fix.patch

This patch was dropped because it was folded into zsmalloc-fix-a-race-with-deferred_handles-storing.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: zsmalloc: avoid unused-function warning
Date: Tue, 17 Jan 2023 18:04:59 +0100

obj_allocated() can be called from two places that are each inside of an
#ifdef.  When both are disabled, the compiler warns:

mm/zsmalloc.c:900:13: error: 'obj_allocated' defined but not used [-Werror=unused-function]

Rather than trying to figure out the correct #ifdef, mark the trivial
function as 'inline', which implies __maybe_unused and shuts up the
warning.

Link: https://lkml.kernel.org/r/20230117170507.2651972-1-arnd@kernel.org
Fixes: 796c71ac728e ("zsmalloc: fix a race with deferred_handles storing")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/zsmalloc.c~zsmalloc-fix-a-race-with-deferred_handles-storing-fix
+++ a/mm/zsmalloc.c
@@ -937,7 +937,7 @@ static bool obj_tagged(struct page *page
 	return true;
 }
 
-static bool obj_allocated(struct page *page, void *obj, unsigned long *phandle)
+static inline bool obj_allocated(struct page *page, void *obj, unsigned long *phandle)
 {
 	return obj_tagged(page, obj, phandle, OBJ_ALLOCATED_TAG);
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

zsmalloc-fix-a-race-with-deferred_handles-storing.patch
mm-extend-max-struct-page-size-for-kmsan.patch
mm-hugetlb-convert-get_hwpoison_huge_page-to-folios-fix.patch

