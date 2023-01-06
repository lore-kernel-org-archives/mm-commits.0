Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E83AC54EBD
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 23:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjAFXyw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Jan 2023 18:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjAFXyu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2023 18:54:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5170543E73
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 15:54:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D90F861F99
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 23:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3921FC433EF;
        Fri,  6 Jan 2023 23:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673049288;
        bh=3MDfEm7uFC2UKlGSmnLQGT/2ATuQWN4aItecHpUSYig=;
        h=Date:To:From:Subject:From;
        b=frjppHMg50+Lg2g+dkIXxWoaJV300lAbV9zB8iwgPEOPA7F4+Ycx+Dh65zaNkUo72
         2taJgTOhJCLng3MrQr9boNblI0SH5ybv/V32oLhp8I4rlrZIQGTClSrRkG1SuY85P6
         +ksEm/++gLsCoyR92wU4KA6XeyYllMV1q6G7AIOM=
Date:   Fri, 06 Jan 2023 15:54:47 -0800
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        linux@weissschuh.net, hannes@cmpxchg.org, corbet@lwn.net,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-zswap-remove-zsmallocs-lack-of-writeback-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20230106235448.3921FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/zswap: remove zsmalloc's lack of writeback warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     docs-admin-guide-mm-zswap-remove-zsmallocs-lack-of-writeback-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-zswap-remove-zsmallocs-lack-of-writeback-warning.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Nhat Pham <nphamcs@gmail.com>
Subject: Docs/admin-guide/mm/zswap: remove zsmalloc's lack of writeback warning
Date: Fri, 6 Jan 2023 14:00:16 -0800

Writeback has been implemented for zsmalloc, so this warning no longer
holds.

Link: https://lkml.kernel.org/r/20230106220016.172303-1-nphamcs@gmail.com
Fixes: 9997bc017549a ("zsmalloc: implement writeback mechanism for zsmalloc")
Suggested-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
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

docs-admin-guide-mm-zswap-remove-zsmallocs-lack-of-writeback-warning.patch

