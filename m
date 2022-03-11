Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A1E2C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Mar 2022 22:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiCKWrK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Mar 2022 17:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiCKWq5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Mar 2022 17:46:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4E31F63D
        for <mm-commits@vger.kernel.org>; Fri, 11 Mar 2022 14:22:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5289A61DEE
        for <mm-commits@vger.kernel.org>; Fri, 11 Mar 2022 22:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBA1C340E9;
        Fri, 11 Mar 2022 22:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647036847;
        bh=VJu01Oh9epa5gbTepotIDCrQCbEGsxcellZgmLNQBDU=;
        h=Date:To:From:Subject:From;
        b=TOz0OMCxw5M5qJySv7hyzD9w/9c2B9zn9D1u9/9cqQcHfW6uZcuFCU4qBgOb6GUx4
         NWsX5tEcUZG1QqFmC07J/x/9WF7Q1ad0Wv/pjEERFxQakTFlciSTef1ArdpA5GF76J
         3BJDMg8pjdl0u2eoDi7ac5DDcvSZkAfmbZA+ZXq0=
Date:   Fri, 11 Mar 2022 14:14:06 -0800
To:     mm-commits@vger.kernel.org, libang.linuxer@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-confusing-comment-in-folio_mark_accessed.patch added to -mm tree
Message-Id: <20220311221407.8FBA1C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: fix confusing comment in folio_mark_accessed
has been added to the -mm tree.  Its filename is
     mm-swap-fix-confusing-comment-in-folio_mark_accessed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-confusing-comment-in-folio_mark_accessed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-fix-confusing-comment-in-folio_mark_accessed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bang Li <libang.linuxer@gmail.com>
Subject: mm/swap: fix confusing comment in folio_mark_accessed

For unevictable pages, we don't need mark them.

Link: https://lkml.kernel.org/r/20220311141519.59948-1-libang.linuxer@gmail.com
Signed-off-by: Bang Li <libang.linuxer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-swap-fix-confusing-comment-in-folio_mark_accessed
+++ a/mm/swap.c
@@ -425,7 +425,7 @@ void folio_mark_accessed(struct folio *f
 		/*
 		 * Unevictable pages are on the "LRU_UNEVICTABLE" list. But,
 		 * this list is never rotated or maintained, so marking an
-		 * evictable page accessed has no effect.
+		 * unevictable page accessed has no effect.
 		 */
 	} else if (!folio_test_active(folio)) {
 		/*
_

Patches currently in -mm which might be from libang.linuxer@gmail.com are

mm-swap-fix-confusing-comment-in-folio_mark_accessed.patch
mm-vmalloc-fix-comments-about-vmap_area-struct.patch

