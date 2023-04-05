Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14AA8C7619A
	for <mm-commits@archiver.kernel.org>; Wed,  5 Apr 2023 19:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbjDETuv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 15:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbjDETuf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 15:50:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B22183CA
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 12:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2E5B6408D
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35993C433D2;
        Wed,  5 Apr 2023 19:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680724202;
        bh=RO6PDYyygsD7ZSgCs6XkzpOvpVFJGTaooW8reHBC8Fs=;
        h=Date:To:From:Subject:From;
        b=2wR0Gdm40yugnURYeHkQ9X0eaF0YOmSP5jP4z7v+aHO/RblAaB06eJk00RGAlmQEh
         EQjMuPImzYXOZNRKymoG6PZhhCmk08CwsfCQ/E1H//nX2BZV73P1w7iylwm3Vs7+Hk
         4ooRoOtYpeZlR/+8udviWNGT5WNw8mdZhCH4B08o=
Date:   Wed, 05 Apr 2023 12:50:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        mgorman@suse.de, lstoakes@gmail.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mlock-use-folios_put-in-mlock_folio_batch.patch added to mm-unstable branch
Message-Id: <20230405195002.35993C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mlock: use folios_put() in mlock_folio_batch()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mlock-use-folios_put-in-mlock_folio_batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mlock-use-folios_put-in-mlock_folio_batch.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: mlock: use folios_put() in mlock_folio_batch()
Date: Thu, 6 Apr 2023 00:18:54 +0800

Since we have updated mlock to use folios, it's better to call
folios_put() instead of calling release_pages() directly.

Link: https://lkml.kernel.org/r/20230405161854.6931-2-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mlock.c~mm-mlock-use-folios_put-in-mlock_folio_batch
+++ a/mm/mlock.c
@@ -206,7 +206,7 @@ static void mlock_folio_batch(struct fol
 
 	if (lruvec)
 		unlock_page_lruvec_irq(lruvec);
-	release_pages(fbatch->folios, fbatch->nr);
+	folios_put(fbatch->folios, folio_batch_count(fbatch));
 	folio_batch_reinit(fbatch);
 }
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-swap-fix-performance-regression-on-sparsetruncate-tiny.patch
mm-mlock-use-folios_put-in-mlock_folio_batch.patch

