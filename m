Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA2EC77B7F
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 21:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjEEVmG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 17:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbjEEVlj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 17:41:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B7055B9
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 14:40:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E635640D8
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 21:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9B6C4339E;
        Fri,  5 May 2023 21:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683322853;
        bh=o4NBaxfsrhIeP5V8leFHDnmKUVwj6AXhJsbty7x6wHc=;
        h=Date:To:From:Subject:From;
        b=hwkzK1Y9gVjwpWK10zhn5x3ta0oPoKh36QUjShZJedAlkYrqPgn3Vyvd7gA87C0Es
         8w4c45xV4n4+OuyLWnyv2pkorY7UfFAU9CVyvq4w/omfnccmfMyPoYgaM3osG2Fz1O
         brWvb68vqDTJUqbDQgB3+3eMTYgsxR9cZTn3TtF0=
Date:   Fri, 05 May 2023 14:40:52 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cachestat-implement-cachestat-syscall-fix.patch added to mm-unstable branch
Message-Id: <20230505214052.DD9B6C4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cachestat: implement cachestat syscall (fix)
has been added to the -mm mm-unstable branch.  Its filename is
     cachestat-implement-cachestat-syscall-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cachestat-implement-cachestat-syscall-fix.patch

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: cachestat: implement cachestat syscall (fix)
Date: Wed, 3 May 2023 19:20:44 -0700

This fixlet replaces rounddown logic with the existing helper.

Link: https://lkml.kernel.org/r/20230504022044.3675469-1-nphamcs@gmail.com
Fixes: 5c289a59b1d0 ("cachestat: implement cachestat syscall")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/filemap.c~cachestat-implement-cachestat-syscall-fix
+++ a/mm/filemap.c
@@ -4157,8 +4157,7 @@ static void filemap_cachestat(struct add
 			int order = xa_get_order(xas.xa, xas.xa_index);
 
 			nr_pages = 1 << order;
-			/* rounds down to the nearest multiple of 2^order */
-			folio_first_index = xas.xa_index >> order << order;
+			folio_first_index = round_down(xas.xa_index, 1 << order);
 			folio_last_index = folio_first_index + nr_pages - 1;
 
 			/* Folios might straddle the range boundaries, only count covered pages */
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zsmalloc-move-lru-update-from-zs_map_object-to-zs_malloc.patch
workingset-refactor-lru-refault-to-expose-refault-recency-check.patch
cachestat-implement-cachestat-syscall.patch
cachestat-implement-cachestat-syscall-fix.patch
selftests-add-selftests-for-cachestat.patch

