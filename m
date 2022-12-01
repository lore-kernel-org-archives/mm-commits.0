Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F50C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 22:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbiLAWmf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Dec 2022 17:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbiLAWmP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2022 17:42:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EC38B3B1
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 14:41:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EFE76217C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 22:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BD9C433C1;
        Thu,  1 Dec 2022 22:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669934494;
        bh=sxQcAbzlu4sVvuNjmAtchHSsVCCNkb3G9EHN6+R15HU=;
        h=Date:To:From:Subject:From;
        b=aF1wROVzoVXcjTUau1oGI+7Epif/I4i1fzcjHz7mMrzs83X41JLt+u3Dy3QqNg27h
         enHJG1kYFZe/BbjknS883bWnZYnPvRRyMy/bY55pkGoFtFk8retdV5SZRevy4y6lyV
         079iAfVBfT4WPMv0k3fytmQz/ZiYMgwCgp2vn1Fk=
Date:   Thu, 01 Dec 2022 14:41:33 -0800
To:     mm-commits@vger.kernel.org, wonder_rock@126.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-update-comments-in-__free_pages_ok.patch added to mm-unstable branch
Message-Id: <20221201224134.A7BD9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: update comments in __free_pages_ok()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-update-comments-in-__free_pages_ok.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-update-comments-in-__free_pages_ok.patch

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
From: Deyan Wang <wonder_rock@126.com>
Subject: mm/page_alloc: update comments in __free_pages_ok()
Date: Thu, 1 Dec 2022 21:50:45 +0800

Add a comment to explain why we call get_pfnblock_migratetype() twice in
__free_pages_ok().

Link: https://lkml.kernel.org/r/20221201135045.31663-1-wonder_rock@126.com
Signed-off-by: Deyan Wang <wonder_rock@126.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-update-comments-in-__free_pages_ok
+++ a/mm/page_alloc.c
@@ -1702,6 +1702,11 @@ static void __free_pages_ok(struct page
 	if (!free_pages_prepare(page, order, true, fpi_flags))
 		return;
 
+	/*
+	 * Calling get_pfnblock_migratetype() without spin_lock_irqsave() here
+	 * is used to avoid calling get_pfnblock_migratetype() under the lock.
+	 * This will reduce the lock holding time.
+	 */
 	migratetype = get_pfnblock_migratetype(page, pfn);
 
 	spin_lock_irqsave(&zone->lock, flags);
_

Patches currently in -mm which might be from wonder_rock@126.com are

mm-page_alloc-update-comments-in-__free_pages_ok.patch

