Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F301FC25B0E
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 00:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbiHQAxg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Aug 2022 20:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiHQAxe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Aug 2022 20:53:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB2970E7C
        for <mm-commits@vger.kernel.org>; Tue, 16 Aug 2022 17:53:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 745CBB81B8E
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 00:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A59AC433C1;
        Wed, 17 Aug 2022 00:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660697605;
        bh=JgTx91W1DIR6rlxHCceodnc+1RW7SOsmSWSGZLmKc2s=;
        h=Date:To:From:Subject:From;
        b=wV5H7NZrevOACfSNxBna34cXaW5+IdfwcuSNkpolaWxVVlaxf0mBZ2Yq40+fS8QaI
         hCwKgrAj5gcZznGUaFLKUek95+WF1+sxVbMDZwtdolLWZ/nzQkRPCikUXM7ZX35UsT
         uZTaFdF7BIiZJ1jHj+cNCdS4erRc5KkYkpMN9D0s=
Date:   Tue, 16 Aug 2022 17:53:24 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-do-not-attempt-to-free-is_err-handle.patch added to mm-hotfixes-unstable branch
Message-Id: <20220817005325.1A59AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: do not attempt to free IS_ERR handle
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zsmalloc-do-not-attempt-to-free-is_err-handle.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-do-not-attempt-to-free-is_err-handle.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: mm/zsmalloc: do not attempt to free IS_ERR handle
Date: Tue, 16 Aug 2022 14:09:06 +0900

zsmalloc() now returns ERR_PTR values as handles, which zram accidentally
can pass to zs_free().  Another bad scenario is when zcomp_compress()
fails - handle has default -ENOMEM value, and zs_free() will try to free
that "pointer value".

Add the missing check and make sure that zs_free() bails out when
ERR_PTR() is passed to it.

Link: https://lkml.kernel.org/r/20220816050906.2583956-1-senozhatsky@chromium.org
Fixes: c7e6f17b52e9 ("zsmalloc: zs_malloc: return ERR_PTR on failure")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>,
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-do-not-attempt-to-free-is_err-handle
+++ a/mm/zsmalloc.c
@@ -1487,7 +1487,7 @@ void zs_free(struct zs_pool *pool, unsig
 	struct size_class *class;
 	enum fullness_group fullness;
 
-	if (unlikely(!handle))
+	if (IS_ERR_OR_NULL((void *)handle))
 		return;
 
 	/*
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

mm-zsmalloc-do-not-attempt-to-free-is_err-handle.patch

