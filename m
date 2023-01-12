Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D8AC67871
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 00:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbjALAPc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 19:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbjALAPR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 19:15:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CA615F12
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 16:15:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3A6461EFC
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 00:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC207C433D2;
        Thu, 12 Jan 2023 00:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482515;
        bh=634jlK4qqpFlfhOmrSdWDS16o4B1jSIHTgU+o5CJ+fc=;
        h=Date:To:From:Subject:From;
        b=PimaHzZtfu3nsheWJzSGrU/HrwUxoV/2zn+SLsQ8EsBML+WDIsb/7Y14sdFWj3y5z
         7o/rzW8pY2k/VuQyfF6P7dU251Ol2n5AS3s2XxPK5pYOIizP9tQa6idO6/0NT3s+KT
         c+nIgHObgtmCu99xNuHDgmBbTt/LfTB+XTTtIUG4=
Date:   Wed, 11 Jan 2023 16:15:13 -0800
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        linux@weissschuh.net, hannes@cmpxchg.org, corbet@lwn.net,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] docs-admin-guide-mm-zswap-remove-zsmallocs-lack-of-writeback-warning.patch removed from -mm tree
Message-Id: <20230112001514.EC207C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/zswap: remove zsmalloc's lack of writeback warning
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-zswap-remove-zsmallocs-lack-of-writeback-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: Docs/admin-guide/mm/zswap: remove zsmalloc's lack of writeback warning
Date: Fri, 6 Jan 2023 14:00:16 -0800

Writeback has been implemented for zsmalloc, so this warning no longer
holds.

Link: https://lkml.kernel.org/r/20230106220016.172303-1-nphamcs@gmail.com
Fixes: 9997bc017549a ("zsmalloc: implement writeback mechanism for zsmalloc")
Suggested-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/zswap.rst |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/zswap.rst~docs-admin-guide-mm-zswap-remove-zsmallocs-lack-of-writeback-warning
+++ a/Documentation/admin-guide/mm/zswap.rst
@@ -70,9 +70,7 @@ e.g. ``zswap.zpool=zbud``. It can also b
 The zbud type zpool allocates exactly 1 page to store 2 compressed pages, which
 means the compression ratio will always be 2:1 or worse (because of half-full
 zbud pages).  The zsmalloc type zpool has a more complex compressed page
-storage method, and it can achieve greater storage densities.  However,
-zsmalloc does not implement compressed page eviction, so once zswap fills it
-cannot evict the oldest page, it can only reject new pages.
+storage method, and it can achieve greater storage densities.
 
 When a swap page is passed from frontswap to zswap, zswap maintains a mapping
 of the swap entry, a combination of the swap type and swap offset, to the zpool
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zsmalloc-fix-a-race-with-deferred_handles-storing.patch

