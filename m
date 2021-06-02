Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF09C4708F
	for <mm-commits@archiver.kernel.org>; Wed,  2 Jun 2021 22:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7C81613BF
	for <mm-commits@archiver.kernel.org>; Wed,  2 Jun 2021 22:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhFBW3O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:29:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhFBW3O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Jun 2021 18:29:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AED0613BF;
        Wed,  2 Jun 2021 22:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622672838;
        bh=oO5FOd06d+sL5T5lM++7nYJa4YUrkkI+vWTx56TZeUg=;
        h=Date:From:To:Subject:From;
        b=Rk1cLtgN8n7dPf8WWWcE38nP7F5hSWUXaAH2wLB60jz7/2MhOacgPxl8IFm3Xnd11
         8iS0xf1PytUMhoeWOgM4vKx2gHy/YyvUn3ufxA/8Vq4MP6UwTs3ZY/nQIAKVl3H8Tv
         vliAlYAa/X/phJ25nKwk40nJpxkFOcZEO9sTeonw=
Date:   Wed, 02 Jun 2021 15:27:18 -0700
From:   akpm@linux-foundation.org
To:     jrdr.linux@gmail.com, lkp@intel.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  + h8300-remove-unused-variable.patch added to -mm tree
Message-ID: <20210602222718.8H6Rf2vqT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: h8300: remove unused variable
has been added to the -mm tree.  Its filename is
     h8300-remove-unused-variable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/h8300-remove-unused-variable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/h8300-remove-unused-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: h8300: remove unused variable

Kernel test robot throws below warning ->

>> arch/h8300/kernel/setup.c:72:26:
warning: Unused variable: region [unusedVariable]
    struct memblock_region *region;

Fixed it by removing unused variable.

Link: https://lkml.kernel.org/r/20210602185431.11416-1-jrdr.linux@gmail.com
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/setup.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/h8300/kernel/setup.c~h8300-remove-unused-variable
+++ a/arch/h8300/kernel/setup.c
@@ -69,8 +69,6 @@ void __init h8300_fdt_init(void *fdt, ch
 
 static void __init bootmem_init(void)
 {
-	struct memblock_region *region;
-
 	memory_end = memory_start = 0;
 
 	/* Find main memory where is the kernel */
_

Patches currently in -mm which might be from jrdr.linux@gmail.com are

h8300-remove-unused-variable.patch

