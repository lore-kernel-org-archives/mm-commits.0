Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0D0C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 18:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391410AbiDUSsU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 14:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389434AbiDUSsT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 14:48:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF7F42ED0
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 11:45:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DF229CE25F4
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 18:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE993C385A1;
        Thu, 21 Apr 2022 18:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650566726;
        bh=HuguBjtOvQ575ectOAI78p0PmPg4VlpQhKh9ILdHSnM=;
        h=Date:To:From:Subject:From;
        b=jVEY/ohBBeabl2yoauDw7stcWGISENpPShzTY4V++oAVyL/Ms0RE15UYOnXOevjqp
         BZ7o8n9rejj/f7WoADfPPgMLugOtKxpKY3PXsCrqov71UWKUEbo3wj10YtZX2cZQvw
         mK3J9pm6e1f43FsTy0Jd1MwXUHHJ9S3U7tD+lomY=
Date:   Thu, 21 Apr 2022 11:45:25 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, liqiong@nfschina.com,
        yuzhe@nfschina.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-remove-unnecessary-type-castings.patch added to -mm tree
Message-Id: <20220421184525.EE993C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove unnecessary type castings
has been added to the -mm tree.  Its filename is
     mm-damon-remove-unnecessary-type-castings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-remove-unnecessary-type-castings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-remove-unnecessary-type-castings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhe <yuzhe@nfschina.com>
Subject: mm/damon: remove unnecessary type castings

Remove unnecessary void* type castings.

Link: https://lkml.kernel.org/r/20220421153056.8474-1-yuzhe@nfschina.com
Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: liqiong <liqiong@nfschina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-remove-unnecessary-type-castings
+++ a/mm/damon/core.c
@@ -1042,7 +1042,7 @@ static int kdamond_wait_activation(struc
  */
 static int kdamond_fn(void *data)
 {
-	struct damon_ctx *ctx = (struct damon_ctx *)data;
+	struct damon_ctx *ctx = data;
 	struct damon_target *t;
 	struct damon_region *r, *next;
 	unsigned int max_nr_accesses = 0;
_

Patches currently in -mm which might be from yuzhe@nfschina.com are

mm-damon-remove-unnecessary-type-castings.patch

