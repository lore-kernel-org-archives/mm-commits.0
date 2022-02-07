Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AED1C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 21:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbiBGVEm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiBGVEm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 16:04:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1F2C06109E
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 13:04:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B85D6156C
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 21:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A2AC004E1;
        Mon,  7 Feb 2022 21:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644267880;
        bh=b1VNKE3LgG2bYOA2m67wBmGDYoy0F5n3MWRCLxYl3g0=;
        h=Date:To:From:Subject:From;
        b=E66Nv8rxFnH3bf53lbhnoOX0YqAhG4V3nJnU/FzEnN5f5bd+rAAZa4NaTwMhmpylX
         2nql2w30fvoVvTj8tK5rPz8KXO77zaIyTzb+DMObBKFZfbHzZhpKNLnSIyM44bKt+C
         euuGD4o/vDLOoAa26m4f1zgk9jrhRcC28NaFbVP0=
Date:   Mon, 07 Feb 2022 13:04:40 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-unexport-page_init_poison.patch added to -mm tree
Message-Id: <20220207210440.96A2AC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unexport page_init_poison
has been added to the -mm tree.  Its filename is
     mm-unexport-page_init_poison.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-unexport-page_init_poison.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-unexport-page_init_poison.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: unexport page_init_poison

page_init_poison is only used in core MM code, so unexport it.

Link: https://lkml.kernel.org/r/20220207063446.1833404-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/debug.c~mm-unexport-page_init_poison
+++ a/mm/debug.c
@@ -265,5 +265,4 @@ void page_init_poison(struct page *page,
 	if (page_init_poisoning)
 		memset(page, PAGE_POISON_PATTERN, size);
 }
-EXPORT_SYMBOL_GPL(page_init_poison);
 #endif		/* CONFIG_DEBUG_VM */
_

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-page_init_poison.patch

