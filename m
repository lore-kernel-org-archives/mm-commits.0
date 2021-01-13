Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB0DC4332E
	for <mm-commits@archiver.kernel.org>; Thu, 14 Jan 2021 01:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA0052343E
	for <mm-commits@archiver.kernel.org>; Thu, 14 Jan 2021 01:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbhANB4E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jan 2021 20:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729442AbhAMXrK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Jan 2021 18:47:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E293022248;
        Wed, 13 Jan 2021 23:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610581554;
        bh=YihJ4M0m9Om4e6t02bnFjNYIZXb236xrG+o/o137Ar4=;
        h=Date:From:To:Subject:From;
        b=U0T1FKMw+E7Rel45+iKt+RKS5DCzsYAdOuGBzpU7qoGN5gr7yOjBuB1w3Iqssi9UB
         O1tyXZSxluWh1DutV5Os2zBDDusiXmcwG73Sgk2kbIFAoi0MwOPpB7L0QRUSSpZvUB
         I4j/zHlay/9Gpp0F1gDwp04Xq2Oxe4cWX3uziSzU=
Date:   Wed, 13 Jan 2021 15:45:53 -0800
From:   akpm@linux-foundation.org
To:     daniel.vetter@ffwll.ch, daniel.vetter@intel.com,
        mm-commits@vger.kernel.org
Subject:  + bdi-use-might_alloc.patch added to -mm tree
Message-ID: <20210113234553.Gon__bRUi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/backing-dev.c: use might_alloc()
has been added to the -mm tree.  Its filename is
     bdi-use-might_alloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/bdi-use-might_alloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/bdi-use-might_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: mm/backing-dev.c: use might_alloc()

Now that my little helper has landed, use it more.  On top of the existing
check this also uses lockdep through the fs_reclaim annotations.

Link: https://lkml.kernel.org/r/20210113135009.3606813-2-daniel.vetter@ffwll.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/backing-dev.c~bdi-use-might_alloc
+++ a/mm/backing-dev.c
@@ -580,7 +580,7 @@ struct bdi_writeback *wb_get_create(stru
 {
 	struct bdi_writeback *wb;
 
-	might_sleep_if(gfpflags_allow_blocking(gfp));
+	might_alloc(gfp);
 
 	if (!memcg_css->parent)
 		return &bdi->wb;
_

Patches currently in -mm which might be from daniel.vetter@ffwll.ch are

mm-dmapool-use-might_alloc.patch
bdi-use-might_alloc.patch

