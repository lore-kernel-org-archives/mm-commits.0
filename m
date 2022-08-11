Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17ADC19F2A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 22:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiHKWF2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 18:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiHKWF1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 18:05:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1ED175AE
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 15:05:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 799F5B822A7
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 22:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FFEC433C1;
        Thu, 11 Aug 2022 22:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660255524;
        bh=rixPr28D1CW48/symXchIUC7X59wx97XmPqVXC0MIrQ=;
        h=Date:To:From:Subject:From;
        b=caHNwa3tCHcyfvxyWLKPb0FqgA+Bd/zTF95BAft1XvtJm/dxAESwiJp+JqjOPbmrm
         FfNLDGvwnLgaUB3W7uR67CbttBZyO6oyHWD0MHQAO6Z3jY5j4DxyPOmLGWCzHMvfnI
         4uzGjVgwioCSypUKx2/HnCwJF3oJItwGZ13QdgQ8=
Date:   Thu, 11 Aug 2022 15:05:22 -0700
To:     mm-commits@vger.kernel.org, kunyu@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + page_alloc-remove-inactive-initialization.patch added to mm-unstable branch
Message-Id: <20220811220524.33FFEC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: page_alloc: remove inactive initialization
has been added to the -mm mm-unstable branch.  Its filename is
     page_alloc-remove-inactive-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/page_alloc-remove-inactive-initialization.patch

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
From: Li kunyu <kunyu@nfschina.com>
Subject: page_alloc: remove inactive initialization
Date: Wed, 3 Aug 2022 14:41:18 +0800

The allocation address of the table pointer variable is first performed in
the function, no initialization assignment is required, and no invalid
pointer will appear.

Link: https://lkml.kernel.org/r/20220803064118.3664-1-kunyu@nfschina.com
Signed-off-by: Li kunyu <kunyu@nfschina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~page_alloc-remove-inactive-initialization
+++ a/mm/page_alloc.c
@@ -8983,7 +8983,7 @@ void *__init alloc_large_system_hash(con
 {
 	unsigned long long max = high_limit;
 	unsigned long log2qty, size;
-	void *table = NULL;
+	void *table;
 	gfp_t gfp_flags;
 	bool virt;
 	bool huge;
_

Patches currently in -mm which might be from kunyu@nfschina.com are

page_alloc-remove-inactive-initialization.patch

